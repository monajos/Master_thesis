function [Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
          t, Z, Uinp, param, parFlag, xa0, delxa, rr, qq, pa0] = mDef(initdata,qq_val,rr_val)

    % Definition of model, flight data, initial values etc. 
    %
    % Basic structure of this script from
    % Chapter 7: Recursive Parameter Estimation
    % "Flight Vehicle System Identification - A Time Domain Methodology"
    % Second Edition
    % by Ravindra V. Jategaonkar
    % published by AIAA, Reston, VA 20191, USA
    % Modifications by Mona Strauss (monastrauss@gmx.net)
    %
    %
    % Inputs
    %    initdata     input,output data and initial states from logs or simulink
    %    qq_val       values for process noise covariance matrix
    %    rr_val       values for measurement noise covariance matrix
    %
    % Outputs
    %    Nx           number of states 
    %    Ny           number of observation variables
    %    Nu           number of input (control) variables
    %    NparSys      number of system parameters
    %    Nparam       total number of system and bias parameters
    %    NparID       total number of parameters to be estimated (free parameters)
    %    Nxp          total number of states (=system states + parameters, i.e. Nx + NparID)
    %    dt           sampling time
    %    Ndata        total number of data points for Nzi time segments
    %    t            time vector
    %    Z            observation variables: Data array of measured outputs (Ndata,Ny)
    %    Uinp         input variables: Data array of measured input (Ndata,Nu)
    %    param        initial starting values for unknown parameters (aerodynamic derivatives) 
    %    parFlag      flags for free and fixed parameters
    %    xa0          starting values for the augmented state vector (system states + parameters)
    %    delxa        perturbations to compute approximations of system matrices 
    %    rr           measurement noise covariance matrix - R0(Ny): only diagonal terms
    %    qq           process noise covariance matrix - diagonal qq(Nxp).
    %    pa0          initial state propagation error covariance matrix - diagonal pcov(Nxp): 
    %    parOEM       estimates obtained from OEM method (only for plot purposes)

    %% ----------------------------------------------------------------------------------------
    % Model definition

    global om_f VK_fdot VK_f Usim XT attitude Vke Coord Pdyn ManeuverNo Maneuver ...
        pa0_val onlylongitudinal onlylateral repeatdata estimonlyparam Man

    Nx       = 10;         % Number of states 
    Ny       = 14;         % Number of observation variables (will be overwritten if only param est.) 
    Nu       = 4;          % Number of input (control) variables
    NparSys  = 32;         % Number of system parameters
    Nparam   = NparSys;    % Total number of parameters to be estimated

    
    %% ----------------------------------------------------------------------------------------
    % setup for filtering flight test log data 

    if (strcmp(initdata,'log')) 

        % Load flight data;            
        if strcmp(Man,'3211')
            filename = ['..\flight_test_eval\testflight_maneuver_log_data\Flight_3_Maneuver_',...
                num2str(ManeuverNo),'_Elevator_3211_p1s.mat'];
        elseif strcmp(Man,'banktobank')
            filename = ['..\flight_test_eval\testflight_maneuver_log_data\Flight_4_Maneuver_',...
                num2str(ManeuverNo),'_Bank_to_bank_p1s.mat'];
        elseif strcmp(Man,'rudderdoublet')
            filename = ['..\flight_test_eval\testflight_maneuver_log_data\Flight_4_Maneuver_',...
                num2str(ManeuverNo),'_Rudder_doublet_p1s.mat'];     
        elseif strcmp(Man,'openloopflight')
            filename = '..\flight_test_eval\testflight_maneuver_log_data\Flight_1_openloop.mat';
        end
        load(filename);

        % Number of data points
        Ndata = length(Maneuver.t);

        % time vector
        t = Maneuver.t;

        % sampling interval
        dt = t(2)-t(1); 

        % parameters and states are estimated 
        if ~estimonlyparam

            % measured outputs
            Z = [Maneuver.p; Maneuver.q; Maneuver.r; Maneuver.u_d; Maneuver.v_d;...
                Maneuver.w_d; Maneuver.Phi; Maneuver.Theta; Maneuver.Psi; ...
                Maneuver.ue; Maneuver.ve; Maneuver.we; Maneuver.H; Maneuver.pdyn]';
            
            % input variables (already transfered from PWM signal) 
            Uinp = [Maneuver.thrust; Maneuver.xi; Maneuver.eta; Maneuver.zeta]';
    
            % initial states vector
            x0  = [Maneuver.p(1), Maneuver.q(1), Maneuver.r(1), Maneuver.Phi(1),...
                Maneuver.Theta(1), Maneuver.Psi(1), Maneuver.Vkb(1),...
                Maneuver.Vkb(2), Maneuver.Vkb(3), Maneuver.H(1)]';
 
        % only parameters are estimated, states are treated like inputs 
        elseif estimonlyparam
            
            % adjusting dimensions
            Nx = 0;
            Nu = 14;
            Ny = 10;

            % augmented output vector with angular accelerations
            Z = [Maneuver.u_d; Maneuver.v_d; Maneuver.w_d; Maneuver.pd; Maneuver.qd;...
                Maneuver.rd; Maneuver.ue; Maneuver.ve; Maneuver.we; Maneuver.pdyn]';
            Uinp = [Maneuver.p; Maneuver.q; Maneuver.r; Maneuver.Phi; Maneuver.Theta;...
                Maneuver.Psi; Maneuver.Vkb(:,1)';Maneuver.Vkb(:,2)'; Maneuver.Vkb(:,3)';...
                Maneuver.H; Maneuver.thrust; Maneuver.xi; Maneuver.eta; Maneuver.zeta]';

            % empty initial states
            x0  = [];
        end
        
        % if data is filtered multiple times 
        if repeatdata
            Z = [Z;Z;Z;Z];
            t = 0:0.01:(length(Z)-1)*0.01; 
            Uinp = [Uinp; Uinp; Uinp; Uinp];
            Ndata = length(t);
        end
    end


    %% ----------------------------------------------------------------------------------------
    % setup for filtering simulink data 

    if (strcmp(initdata,'simulink'))  

        % Generate new time axis
        dt   = attitude.Time(2)-attitude.Time(1);
        t = attitude.Time;
        % Number of data points
        Ndata = length(t);

        % Measured outputs p, q, r, ukbd, vkbd, wkbd, Phi, Theta, Psi, uke, vke, wke, H;  
        clear q ukbd vkbd wkbd
        p(:,1) = om_f.Data(:,1);
        q(:,1) = om_f.Data(:,2);
        r(:,1) = om_f.Data(:,3);

        ukbd(:,1) = VK_fdot.Data(:,1);
        vkbd(:,1) = VK_fdot.Data(:,2);
        wkbd(:,1) = VK_fdot.Data(:,3);
       
        Phi(:,1) = attitude.Data(1,1,:);
        Theta(:,1) = attitude.Data(2,1,:);
        Psi(:,1) = attitude.Data(3,1,:);
        
        uke(:,1) = Vke.Data(1,1,:);
        vke(:,1) = Vke.Data(2,1,:);
        wke(:,1) = Vke.Data(3,1,:);
        
        H(:,1) = Coord.Data(3,1,:);

        pdyn(:,1) = Pdyn.Data(1,1,:);

        Z = [p q r ukbd vkbd wkbd Phi Theta Psi uke vke wke H pdyn]; 

        %  Measured inputs zeta, eta, xi, thrust
        clear thrust xi eta zeta
        thrust  = Usim.r8thro.Data;     %ones(length(t),1)*1.925;
        xi      = Usim.r8xi.Data;       %zeros(length(t),1);
        eta     = Usim.r8et.Data;       %ones(length(t),1)*0.0663;
        zeta    = Usim.r8ze.Data;       %zeros(length(t),1);

        Uinp = [thrust xi eta zeta];

        % Initial conditions   
        Vkb(1)  = VK_f.Data(1,1,1);
        Vkb(2)  = VK_f.Data(2,1,1);
        Vkb(3)  = VK_f.Data(3,1,1);
        Phi     = XT(4);
        Theta   = XT(5); 
        Psi     = XT(6); 
        H       = -XT(12);

        x0  = [p(1), q(1), r(1), Phi, Theta, Psi, Vkb(1), Vkb(2), Vkb(3), H]';
    end

    %% ----------------------------------------------------------------------------------------   
    % Setting intitial values, what parameters to estimate, Q, R, Pa0,... 
    
    % Initial values for parameters (aerodynamic derivatives)   
    % from aeroDB Excel with addition from ac sys. identification
    param = [0; -0.0955; -1.1145; 0.2079; -0.425; -0.0099   % l: Cl0, Clbeta, Clp, Clr, Clxi, Clzeta
        -0.0197; -1.3036; -13.603; -1.0687;                 % m: Cm0, Cmalpha, Cmq, Cmeta
        0; 0.1024; 0; -0.1139; 0.0501; -0.0778;             % n: Cn0, Cnbeta, Cnp, Cnr, Cnxi, Cnzeta
        0.0358; 0; 0; 0.2326; 0.6972; 0.2369                % D: CD0, CDq, CDeta, CDalpha, CDalpha2, CDbeta2
        0; -0.375; 0; 0.1259; 0.1349;                       % Y: CY0, CYbeta, CYp, CYr, CYzeta
        0.5324; 5.7721; 0; -0.2357; 0.2007];                % L: CL0, CLapha, CLq, CLbeta2, CLeta 

    % Flag for free and fixed parameters
    parFlag = ones(NparSys,1); 
    if onlylongitudinal
        parFlag(1) = 0;     % Cl0
        parFlag(2) = 0;     % Clbeta
        parFlag(3) = 0;     % Clp
        parFlag(4) = 0;     % Clr
        parFlag(5) = 0;     % Clxi
        parFlag(6) = 0;     % Clzeta
    
        parFlag(11) = 0;    % Cn0
        parFlag(12) = 0;    % Cnbeta
        parFlag(13) = 0;    % Cnp
        parFlag(14) = 0;    % Cnr
        parFlag(15) = 0;    % Cnxi
        parFlag(16) = 0;    % Cnzeta
    
        parFlag(23) = 0;    % CY0
        parFlag(24) = 0;    % CYbeta
        parFlag(25) = 0;    % CYp
        parFlag(26) = 0;    % CYr
        parFlag(27) = 0;    % Cyzeta
    elseif onlylateral 
        parFlag(7) = 0;     % Cm0
        parFlag(8) = 0;     % Cmalpha
        parFlag(9) = 0;     % Cmq
        parFlag(10) = 0;    % Cmeta
    
        parFlag(17) = 0;     % CD0
        parFlag(18) = 0;     % CDq
        parFlag(19) = 0;     % CDeta
        parFlag(20) = 0;     % CDalpha
        parFlag(21) = 0;     % CDalpha2
        parFlag(22) = 0;    % CDbeta2
       
        parFlag(28) = 0;    % CL0
        parFlag(29) = 0;    % CLalpha    
        parFlag(30) = 0;    % CLq
        parFlag(32) = 0;    % CLeta
        parFlag(31) = 0;    % CLbeta2
    end
    parFlag(30) = 0;    % CLq

    % not estimating aileron derivs for rudderdoublet and 3211
    if strcmp(Man,'rudderdoublet') || strcmp(Man,'3211')
        parFlag(5) = 0;     % Clxi
        parFlag(15) = 0;    % Cnxi        
    end

    % not estimating rudder derivs, unless filtering rudder doublet
    if strcmp(Man,'banktobank') || strcmp(Man,'3211') || strcmp(Man,'openloopflight')
        parFlag(16) = 0;    % Cnzeta
        parFlag(27) = 0;    % Cyzeta
        parFlag(6) = 0;     % Clzeta
    end 

    % Number of free parameters (to be estimated)
    NparID = size(find(parFlag~=0),1);

    % Total number of states (system states +  free parameters)
    Nxp    = Nx + NparID;

    % Augmented state vector:
    xa0  = [x0; param(find(parFlag~=0))];

    % Perturbations for numerical approximations of system matrices
    delxa = zeros(Nxp,1)+1.0e-06; 

    % Measurement noise covariance matrix - R0(Ny): only diagonal terms
    rr = 5.0e-8*ones(Ny,1);
    rr = rr_val; 

    % Process noise covariance matrix (diagonal terms only)
    if ~estimonlyparam
        qq(1:Nx,1)     = qq_val; 
    end
    qq(Nx+1:Nxp,1) = [zeros(NparID,1)];    % for system parameters

    % Initial state propagation error covariance matrix - pcov(Nxp): only diagonal terms
    if ~estimonlyparam
        pa0(1:Nx,1)     = pa0_val; %1.0e+1;     % p0 for system states
    end
    pa0(Nx+1:Nxp,1) = pa0_val; %1.0e+1;     % p0 for parameters
    

return



