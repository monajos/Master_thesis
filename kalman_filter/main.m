% Recursive Parameter Estimation
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
% Extended Kalman Filter (EKF), 
% Unscented Kalman Filter (UKF) -- simplified version
% Unscented Kalman Filter (UKFaugmented) - General case

global ManeuverNo pa0_val optimizing methodNo onlylongitudinal onlylateral...
    repeatdata estimonlyparam Man initdata 

  
%% ------------------------------------------------------------------------
% Specify Filter Configuration 

% Estimate only parameters? 
estimonlyparam      = 0; 

% Running filters for optimizing purposes?
optimizing          = 1; 

% Estimate only longitudinal parameters?
onlylongitudinal    = 1; 

% Or only lateral parameters?
onlylateral         = 0; 

% Filter data multiple times?
repeatdata          = 0; 

% If not optimizing 
if ~optimizing

    % Filter simulink or flight test data 
    % initdata = 'log';
    initdata = 'simulink';       

    % select Maneuver and Maneuver number 
    if strcmp(initdata,'log')
%         Man = '3211';             % --> ManeuverNo 13
%         Man = 'banktobank';       % --> ManeuverNo 6
%         Man = 'rudderdoublet';    % --> ManeuverNo 13
        Man = 'openloopflight';

        ManeuverNo = 6;
    end
        
    % select Filter type
    %  1 = Extended Kalman filter    
    %  2 = Unscented Kalman Filter - Simplified version, no noise augmentation
    %  3 = Unscented Kalman Filter - General case, augmentation though noise 
    %  4 = all filters 
    methodNo = 4;

    % load optimized  system noise cov Q, scaling param alpha and
    % measurement noise cov R
    load("..\flight_test_eval\optimal_x.mat");
    qq_val = x(1:10,1);
    alpha = x(11);
    rr_opt = x(12:25,1); 
    rr_val = rr_opt; 
    
    % set initial covariance Pa0
    pa0_val = 0.01;

    % R needs to modified for exclusive parameter estimation bc the defined
    % outputs are different
    if estimonlyparam
        rr_val = [rr_opt([4,5,6]);7;5;1;rr_opt([10,11,12,14])];
    end

    close all
end

        
%% ------------------------------------------------------------------------
% Simulation setup 
[Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, Uinp, param, parFlag, xa0, delxa, rr, qq, pa0] = mDef(initdata,qq_val,rr_val);

% Verify dimensions 
iError = mDef_check(Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, ...
                                            param, parFlag, xa0, delxa, rr, qq, pa0);
                                    

%% ------------------------------------------------------------------------
% State and parameter estimation

% EKF 
if methodNo == 1  || methodNo == 4
    tekfIni = cputime;
    [sy, szmsyekf, sx, sxstd] = ekf( Z, Uinp, Ndata, Ny, NparID, Nxp, Nu,...
                                                 Nx, dt, rr, qq, pa0, param, parFlag,...
                                                 xa0, delxa);
    time_ekf = cputime - tekfIni;
    syekf = sy;
    sxekf = sx;
    sxstdekf = sxstd;    
    if ~optimizing
        disp(['Computational time for EKF: time_ekf= ' num2str(time_ekf) ' seconds']);
    end 
    % parameter values: average over last 100 points
    [parAvg, stdAvg, Par_no, par_std_rel_ekf] = print_par_std('EKF', Nx, NparSys, Ndata, NparID, parFlag, 100,...
                                                 sx, sxstd);
end

% UKF
if methodNo == 2  || methodNo == 4
    tukfIni = cputime;
    beta  = 2;
    kappa = 3 - Nxp;
    [sy, sx, sxstd, szmsyukf] = ukf_mod( Z, Uinp, Ndata, dt,...
                                       Nx, Ny, Nu, NparID, Nxp, param, parFlag,...
                                       xa0, pa0, qq, rr, kappa, alpha, beta);
    time_ukf = cputime - tukfIni;
    syukf = sy;
    sxukf = sx;
    sxstdukf = sxstd;
    if ~optimizing
        disp(['Computational time for UKF: time_ukf= ' num2str(time_ukf) ' seconds']);
    end
    % parameter values: average over last 100 points
    [parAvg, stdAvg, Par_no, par_std_rel_ukf] = print_par_std('UKF', Nx, NparSys, Ndata, NparID, parFlag, 100,...
                                                 sx, sxstd);
end

% UKF_aug 
if  methodNo == 3  || methodNo == 4
    tukfIni = cputime;
    beta  = 2;
    Na    = Nxp + Nx + Ny;        % Basic states + Paramaters + NwNoise + NvNoise
    kappa = 3 - Na;
    [sy, sx, sxstd, szmsyukfaug] = ukf( Z, Uinp, Ndata, dt,...
                                            Nx, Ny, Nu, NparID, Nxp, param, parFlag,...
                                            xa0, pa0, qq, rr, kappa, alpha, beta);
    time_ukf = cputime - tukfIni;
    syukfaug = sy;
    sxukfaug = sx;
    sxstdukfaug = sxstd;
    if ~optimizing
        disp(['Computational time for UKFaugmented: time_ukfAug = ' num2str(time_ukf) ' seconds']);
    end
    % parameter values: average over last 100 points
    [parAvg, stdAvg, Par_no, par_std_rel_ukfaug] = print_par_std('UKFaug', Nx, NparSys, Ndata, NparID, parFlag, 100,...
                                                    sx, sxstd);

end


%% ------------------------------------------------------------------------
% quality indicator
% check if same sign as initial value 
% check difference in magnitude 

initial_params = param;
initial_params(find(parFlag==0))=[];

for i= 1:length(initial_params)
    sign_parAvg(i)=parAvg(i) / abs(parAvg(i));
    if initial_params(i) == 0
        sign_of_param(i) = 0;
    else
        sign_of_param(i)=initial_params(i)/abs(initial_params(i));       
    end
    same_sign(i) = (sign_of_param(i)==sign_parAvg(i));
    par_diff(i) = abs(parAvg(i) - initial_params(i));
end


%% ------------------------------------------------------------------------
% Plot results and print NMSE

% Plot Params for all filters and print NMSE
if ~optimizing && methodNo == 4
    plot_params(Par_no,t,sxekf,sxukf,sxukfaug,Nx);
    print_NMSE(Z,szmsyekf,szmsyukf,szmsyukfaug,Ndata);
end

% plot all estimated parameters
if ~optimizing && methodNo ~= 4
    figure
    plot(t,sx(:,11:Nxp))
    title('all estimated parameters')
    grid on
end

% plot measurements and filteroutcome
if ~optimizing && ~estimonlyparam
    plot_states_outputs(t,Z,sxekf,sxukf,sxukfaug,syekf,syukf,syukfaug,onlylongitudinal,onlylateral)
end




