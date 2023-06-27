function [ytSave, xhSave, xhstdD, szmsy] = ukf_mod(Z, Uinp, Ndata, dt,...
                                     Nx, Ny, Nu,  NparID, Nxp, param, parFlag,...
                                     xhat, pp, qq, rr, kappa, alpha, beta) 

% Unscented Kalman filter for state and parameter estimation
% Simplified case of additive noise
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
%    param         parameter vector (Nparam) (initial)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    xhat          Starting values for the augmented state vector (system states + parameters)
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
% State propagation error covariance matrix - pcov: (Nxp X Nxp)
pcov = diag(pp);
% Process noise covariance matrix - Qnoise: (Nxp x Nxp)
Qnoise = diag(qq);
% Measurement noise covariance matrix - Rnoise: (Ny x Ny)
Rnoise = diag(rr);

% Number of sigma points
Nsp   = 2*Nxp + 1;
lamda = alpha^2*(Nxp+kappa) - Nxp;
gamma = sqrt(Nxp + lamda);

% Compute weights for 2Nxp+1 sigma points (wm: for mean and wc for covariance)
wm(1,1)     = lamda/(Nxp+lamda);
wm(2:Nsp,1) = ones(2*Nxp,1)/(2*(Nxp+lamda));
wc(1,1)     = wm(1,1) + 1 - alpha^2 + beta;
wc(2:Nsp,1) = wm(2:Nsp,1);                                                  % Eq. (7.62)

% Generate (2Na+1) sigma points:
Psqrtm  = gamma*real(sqrtm(pcov))';           % Psqrtm = gamma*chol(pcov)';
Xsp     = [zeros(Nxp,1) -Psqrtm Psqrtm] + repmat(xhat,1,Nsp);               % Eq. (7.68)
xtSigPt = Xsp;                                % for the first data point

%--------------------------------------------------------------------------
% Recursive UKF filtering starts here (loop for the data points)
for k=1:Ndata
    u1c = Uinp(k,1:Nu)';                    % Exogenous control inputs             

    % Generate (2Na+1) sigma points:
    Psqrtm = gamma*real(sqrtm(pcov))';           % Psqrtm = gamma*chol(pcov)';
    Xsp    = [zeros(Nxp,1) -Psqrtm Psqrtm] + repmat(xhat,1,Nsp);            % Eq. (7.68)
    
    %----------------------------------------------------------------------
    % Prediction step (Time update): Propagate sigma points through state functions
    xNoise = zeros(Nx,1);
    if k > 1
        u1p = Uinp(k-1,1:Nu)';
        for ip=1:Nsp 
            xt  = Xsp(1:Nxp,ip);
            param(find(parFlag~=0)) = xt(Nx+1:Nx+NparID);
            xSP = ruku4(xt, xNoise, dt, u1c, param, Nx); %ruku4_aug(state_eq, dt, xt, dt, u1p, u1c, param, Nx, Nxp, Nparam);
            xtSigPt(:,ip) = xSP;                                            % Eq. (7.84)
        end
    end

    %----------------------------------------------------------------------
    % System states as weighted sum
    % xtilde = xtSigPt*wm; 
    xtilde = zeros(Nxp,1);
    for ip=1:Nsp
        xtilde = xtilde + wm(ip)*xtSigPt(:,ip);                             % Eq. (7.70) 
    end
    
    yNoise = zeros(Ny,1);
    % Compute model outputs; 
    for ip=1:Nsp
        xt  = xtSigPt(:,ip);
        param(find(parFlag~=0)) = xt(Nx+1:Nx+NparID);
        ySP = obs(xtSigPt(1:Nxp,ip), u1c, param, yNoise); %feval(obser_eq, dt, xt, u1c, param); % Call observation equation
        ytSigPt(:,ip) = ySP;                                                % Eq. (7.72)
    end

    % Model output as weighted sum 
    ytilde = ytSigPt*wm;
    
    %----------------------------------------------------------------------
    % Compute covariances of predicted states:
    %xtSPdiff = xtSigPt - kron(xtilde,ones(1,Nsp));
    Pxx = zeros(Nxp,Nxp) + Qnoise;
    for ip=1:Nsp
        Pxx = Pxx + wc(ip)*(xtSigPt(:,ip)-xtilde)*(xtSigPt(:,ip)-xtilde)';    %Eq. (7.82)
    end

    % Compute covariances and  cross correlations, Pyy and Pxy;
    %ytSPdiff = ytSigPt - kron(ytilde,ones(1,Nsp));
    Pxy = zeros(Nxp,Ny);
    Pyy = zeros(Ny,Ny) + Rnoise;
    for ip=1:Nsp
        Pyy = Pyy + wc(ip)* (ytSigPt(:,ip)-ytilde)*(ytSigPt(:,ip)-ytilde)'; % Eq. (7.83)
        Pxy = Pxy + wc(ip)* (xtSigPt(:,ip)-xtilde)*(ytSigPt(:,ip)-ytilde)'; % Eq. (7.75)
    end
         
    % Kalman gain matrix Kgain
    Kgain = Pxy*inv(Pyy);                                                   % Eq. (7.76)

    % Corrected states: 
    z    = Z(k,1:Ny)';                      % Measured outputs
    res  = z - ytilde;                      % Output Residual
    xhat = xtilde + Kgain*res;              % State Update                  % Eq. (7.77)

    % Covariance update P(k) = P(k-) - KPyy*K';
    pcov = Pxx - Kgain*Pyy*Kgain';
   
    %----------------------------------------------------------------------
    % Save estimated states and standard deviations for plotting purposes only.
    ytSave(k,1:Ny)  = ytilde';               
    xhSave(k,1:Nxp) = xhat';
    xhstdD(k,1:Nxp) = sqrt(diag(pcov))';    
    szmsy(k,:) = Z(k,1:Ny) - ytSave(k,1:Ny);
    
end    % end of UKF (i.e., of recursive filtering)

return
% end of the function
