function iError = mDef_check(Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, ...
                                     param, parFlag, xah, delx, rr, qq, p0)

% Check model defined in mDef
%
% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    test_case     test case number
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    NparSys       number of system parameters
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    Nxp           number of augmented state (=Nx+NparID)
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    xah           Starting values for the augmented state vector (system states + parameters)
%    delx          Perturbations to compute approximations of system matrices
%    rr            Measurement noise covariance matrix, (Ny): only diagonal terms
%    qq            Process noise covariance matrix, (Nxp) - only diagonal terms
%    pp            Initial state propagation error covariance, (Nxp): only diagonal terms
%
% Outputs:
%    iError        Error flag

%----------------------------------------------------------------------------------------
iError = 0;

if Nparam < NparSys,
    disp('Wrong specification of Nparam or NparSys: Nparam less than NparSys?')
    iError = 1;
end

if size(param,1) ~= Nparam,
    disp('The number of parameter values (i.e size of param) and Nparam do not match.')
    iError = 1;
end

if size(param,1) ~= size(parFlag,1),
    disp('The number of parameter values (param) and parameter flags (parFlag) do not match.')
    iError = 1;
end

if size(rr,1) ~= Ny,
    disp('The number of diagonal elements of measurement noise covariance matrix rr is not Ny.')
    iError = 1;
end

if size(qq,1) ~= Nxp,
    disp('The number of diagonal elements of process noise covariance matrix rr is not Nxp.')
    iError = 1;
end

if size(p0,1) ~= Nxp,
    disp('The number of values for initial state prediction error p0 is not Nxp.')
    iError = 1;
end

if size(xah,1) ~= Nxp,
    disp('The number of intial values for the augmented state xah is not Nxp.')
    iError = 1;
end

if size(delx,1) ~= Nxp,
    disp('The number of perturbartions delx is not Nxp.')
    iError = 1;
end

if iError ~= 0,
    disp('Error termination')
end

return
% end of function
