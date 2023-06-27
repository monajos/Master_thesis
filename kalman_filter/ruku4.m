function xa = ruku4(xa, xNoise, dt, u, param, Nx)
    
    x = xa(1:Nx);
    
    % k1
    rk.k1  =   xdot(x,u,param,xNoise);

    % k2
    rk.x2  =   x + 1/2 * dt * rk.k1;
    rk.k2  =   xdot(rk.x2,u,param,xNoise);

    % k3
    rk.x3  =   x + 1/2 * dt * rk.k2;
    rk.k3  =   xdot(rk.x3,u,param,xNoise);

    % k4
    rk.x4  =   x + dt * rk.k3;
    rk.k4  =   xdot(rk.x4,u,param,xNoise);

    % Integration
    xa(1:Nx)   =   xa(1:Nx) + dt * (1/6*rk.k1 + 1/3*rk.k2 + 1/3*rk.k3 + 1/6*rk.k4);
    
   