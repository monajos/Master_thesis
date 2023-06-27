function Amat = sysmatA(Nxp, Nx, NparID, x, delx, u, param, parFlag)

% Linearized state matrix Amat by central difference approximation
% 
% Chapter 7: Recursive Parameter Estimation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    state_eq      function coding the state equations
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
%    Amat          Linearized system matrix (Nxp,Nxp)


xin  = x;
xdt3 = zeros(Nxp,1);
xdt4 = zeros(Nxp,1);
xNoise = zeros(Nx,1);

for ix=1:Nxp
    zip1 = xin(ix);
    del2 = 2*delx(ix);
   
    xin(ix) = zip1 + delx(ix);
    param(find(parFlag~=0)) = xin(Nx+1:Nx+NparID);
    xdt3(1:Nx) = xdot(xin, u, param, xNoise); %feval(state_eq, ts, xin, u, param);
    

    xin(ix) = zip1 - delx(ix);
    param(find(parFlag~=0)) = xin(Nx+1:Nx+NparID);
    xdt4(1:Nx) = xdot(xin, u, param, xNoise); %feval(state_eq, ts, xin, u, param);
   
    Amat(:,ix) = (xdt3 - xdt4) / del2;

    xin(ix) = zip1;
end

return
% end of subroutine
