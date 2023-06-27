function [ytSave, xhSave, xhstdD, szmsy] = ukf(Z, Uinp, Ndata, dt,...
                                        Nx, Ny, Nu,  NparID, Nxp, param, parFlag,...
                                        xhat, pp, qq, rr, kappa, alpha, beta)

% Unscented Kalman filter for state and parameter estimation
% General case of state augmentation through process and measurement noise.
%
% Chapter 7: Recursive Parameter Estimation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    state_eq      function coding the state equations
%    obser_eq      function coding the observation equations
%    Z             measured outputs (Ndata,Ny)
%    Uinp          measured inputs (Ndata,Nu) 
%    Ndata         number of data points
%    dt            sampling time
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    Nxp           number of augmented state (=Nx+NparID)
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    xhat          Starting values for the augmented state vector (Nx+NparID)
%    pp            Initial state propagation error covariance, (Nxp): only diagonal terms
%    qq            Process noise covariance matrix, (Nxp) - only diagonal terms
%    rr            Measurement noise covariance matrix, (Ny): only diagonal terms
%    kappa         secondary scaling parameter    
%    alpha         costant defining the spread of Sigma points around estimated x
%    beta          scaling parameter (to include prior knowledge of the distribution)
%
% Outputs:
%    ytSave        estimated model ouptuts, (Ndata,Ny)
%    xhSave        estimated augmented states, i.e. (system states + parameters), (Ndata,Nxp)
%    xhstdD        standard deviations of estimated states, (Ndata,Nxp)


%--------------------------------------------------------------------------
% Number of augmented states and sigma points
Na  = Nxp + Nx + Ny;                        % Basic states + Paramaters + NwNoise + NvNoise
Nsp = 2*Na + 1;

% Scaling Parameters 
lamda = alpha^2*(Na+kappa) - Na;
gamma = sqrt(Na + lamda);

% Compute weights for 2Na+1 sigma points (wm: for mean and wc for covariance)
wm(1,1)     = lamda/(Na+lamda);
wm(2:Nsp,1) = ones(2*Na,1)/(2*(Na+lamda));
wc(1,1)     = wm(1,1) + 1 - alpha^2 + beta;
wc(2:Nsp,1) = wm(2:Nsp,1);

% State propagation error covariance matrix - pcov: (Nxp X Nxp)
pcov = diag(pp);
% Process noise covariance matrix - Qnoise: (Nx x Nx)
Qnoise = diag(qq(1:Nx));
% Measurement noise covariance matrix - Rnoise: (Ny x Ny)
Rnoise = diag(rr);

% Augmented Covariance matrix and augmented state vector
Pa = [pcov            zeros(Nxp,Na-Nxp);...
      zeros(Nx,Nxp)   Qnoise  zeros(Nx,Ny);...
      zeros(Ny,Na-Ny)         Rnoise];
xa(:,1) = [xhat; zeros(Nx,1); zeros(Ny,1)];

% Generate (2Na+1) sigma points:
Psqrtm = gamma*real(sqrtm(Pa))';                 % Psqrtm = gamma*chol(Pa)';
Xsp    = [zeros(Na,1) -Psqrtm Psqrtm] + repmat(xa,1,Nsp);
xtSigPt(1:Nxp,:) = Xsp(1:Nxp,:);                 % for the first data point

%--------------------------------------------------------------------------
% Recursive UKF filtering starts here (loop for the data points)
for k=1:Ndata
    u = Uinp(k,1:Nu)';                          % Exogenous control inputs
    % Augmented Covariance matrix and augmented state vector
    Pa = [pcov            zeros(Nxp,Na-Nxp);...
          zeros(Nx,Nxp)   Qnoise  zeros(Nx,Ny);...
          zeros(Ny,Na-Ny)         Rnoise];
    xa(:,1) = [xhat; zeros(Nx,1); zeros(Ny,1)];

    % Generate (2Na+1) sigma points:
    Psqrtm  = gamma*real(sqrtm(Pa))';            % Psqrtm = gamma*chol(Pa)';
    Xsp     = [zeros(Na,1) -Psqrtm Psqrtm] + repmat(xa,1,Nsp);
    
    %----------------------------------------------------------------------
    % Prediction step (Time update): Propagate sigma points through state functions
    if k > 1
        for ip=1:Nsp
           param(find(parFlag~=0)) = Xsp(Nx+1:Nx+NparID,ip); 
           xNoise(1:Nx,1)          = Xsp(Nxp+1:Nxp+Nx,ip);
           xSP = ruku4(Xsp(1:Nxp,ip), xNoise, dt, u, param, Nx); 
           xtSigPt(:,ip) = xSP;       
        end
    end
    
    %----------------------------------------------------------------------
    % System states as weighted sum
    xtilde = xtSigPt*wm; 

    % Compute covariances of predicted states:
    xtSPdiff = xtSigPt - kron(xtilde,ones(1,Nsp));
    Pxx      = zeros(Nxp,Nxp);
    for ip=1:Nsp
        Pxx = Pxx + wc(ip) * (xtSPdiff(:,ip)*xtSPdiff(:,ip)');
    end
    
    %----------------------------------------------------------------------
    % Correction step (Measurement update):
    
    % Compute model outputs; 
    for ip=1:Nsp
        param(find(parFlag~=0)) = xtSigPt(Nx+1:Nx+NparID,ip);
        yNoise(1:Ny,1) = Xsp(Nxp+Nx+1:Na,ip);
        ySP = obs(xtSigPt(1:Nxp,ip), u, param, yNoise);
        ytSigPt(:,ip)  = ySP;  
    end

    % Model output as weighted sum 
    ytilde = ytSigPt*wm;
    
    % Compute covariances and cross correlations, Pyy and Pxy;
    ytSPdiff = ytSigPt - kron(ytilde,ones(1,Nsp));
    Pxy = zeros(Nxp,Ny);
    Pyy = zeros(Ny,Ny);
    for ip=1:Nsp
        Pyy = Pyy + wc(ip) * ytSPdiff(:,ip) * ytSPdiff(:,ip)'; 
        Pxy = Pxy + wc(ip) * xtSPdiff(:,ip) * ytSPdiff(:,ip)';
    end
         
    % Kalman gain matrix Kgain
    Kgain = Pxy*inv(Pyy);  

    % Corrected states
    z    = Z(k,1:Ny)';                           % Measured outputs
    res  = z - ytilde;                           % Output Residual
    xhat = xtilde + Kgain*res;                   % State Update

    % Covariance update P(k) = P(k-) - KPyy*K';
    pcov = Pxx - Kgain * Pyy * Kgain';
   
    % Save estimated states and standard deviation for plotting purposes only.
    ytSave(k,1:Ny)  = ytilde';               
    xhSave(k,1:Nxp) = xhat';
    xhstdD(k,1:Nxp) = sqrt(diag(pcov))';
    szmsy(k,:) = Z(k,1:Ny) - ytSave(k,1:Ny);

end    % end of UKF (i.e., of recursive filtering)

return
