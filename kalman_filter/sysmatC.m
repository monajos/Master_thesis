function Cmat = sysmatC( Ny, Nxp, Nx, NparID, x, delx, u, param, parFlag)


% Measurement matrix C by linearization by central difference approximation
% 
% Chapter 7: Recursive Parameter Estimation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    obser_eq      function coding the observation equations
%    Ny            number of output variables
%    Nxp           number of augmented states
%    Nx            number of state variables
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    x             aumented state vector (Nxp)
%    delx          Perturbations to compute approximations of system matrices
%    u             input vector (Nu)
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    ts            time vector
%
% Outputs:
%    Cmat          Linearized observation matrix


yNoise = zeros(length(Ny),1);

for ix=1:Nxp 
    zip1 = x(ix);
    del2 = 2*delx(ix);
   
    x(ix) = zip1 + delx(ix);
    param(find(parFlag~=0)) = x(Nx+1:Nx+NparID);
    y3   = obs(x, u, param, yNoise); %feval(obser_eq, ts, x, u, param);
    
    x(ix) = zip1 - delx(ix);
    param(find(parFlag~=0)) = x(Nx+1:Nx+NparID);
    y4   = obs(x, u, param, yNoise); %feval(obser_eq,ts, x, u, param);
   
    Cmat(:,ix) = (y3 - y4) / del2;

    x(ix) = zip1;
end

return
% end of subroutine
