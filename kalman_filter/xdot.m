function xdot = xdot(x, u, param, xNoise)

    % Function to compute the state derivatives 
    % variables:       states  - p, q, r, Phi, Theta, Psi, ukb, vkb, wkb, H                 
    %                  inputs  - dt, xi, eta, zeta
     
    global estimonlyparam
    
    % if only estimating parameters -> states vector empty
    if estimonlyparam
        xdot = [];
    else
        p       = x(1);
        q       = x(2);
        r       = x(3);
        Phi     = x(4);
        Theta   = x(5);
        Psi     = x(6); 
        ukb     = x(7);
        vkb     = x(8);
        wkb     = x(9);
        H       = x(10);
        
        dt      = u(1);
        xi      = u(2);
        eta     = u(3);
        zeta    = u(4);
        
        Cl0     = param(1);
        Clbeta  = param(2);
        Clp     = param(3);
        Clr     = param(4);
        Clxi    = param(5);
        Clzeta  = param(6);
        
        Cm0     = param(7);
        Cmalpha = param(8);
        Cmq     = param(9);
        Cmeta   = param(10);
        
        Cn0     = param(11);
        Cnbeta  = param(12);
        Cnp     = param(13);
        Cnr     = param(14);
        Cnxi    = param(15);
        Cnzeta  = param(16);
        
        CD0     = param(17);
        CDq     = param(18);
        CDeta   = param(19);
        CDalpha = param(20);
        CDalpha2= param(21);
        CDbeta2 = param(22);
        
        CY0     = param(23);
        CYbeta  = param(24);
        CYp     = param(25);
        CYr     = param(26);
        CYzeta  = param(27); 
        
        CL0     = param(28);
        CLalpha = param(29);
        CLq     = param(30); 
        CLbeta2 = param(31);
        CLeta   = param(32);
        
        omegab      = [p,q,r]';
        Vkb         = [ukb, vkb, wkb]';

        % Vitesse dimensions
        I       = diag([0.9006;0.2487;1.1469]);     % from model (UT) (Vitesse Parameter)
        S       = 0.61681;                          % aeroDB
        b       = 2.9690;                           % aeroDB
        lmu     = 0.16725;                          % aeroDB --> aerodynamic chordlength -> p.238 
        m       = 3.1;                              % from model UT
        xCGAC   = [0;0;0];                          % from aeroDB
        Vwb     = [0;0;0];                          % assuming no wind 
        
        % Environment            
        T           = 288.15 - 0.0065*H;                                 
        g           = 9.80665; 
        theta       = T/288.15;
        R           = 287.0531;
        L           = 0.0065;
        rho0        = 1.225;
        rho         = rho0*theta^((g/(L*R))-1.0); % in troposphere
        
        % Aerodynamics
        Vab     = (cross(omegab,xCGAC) + Vkb) - Vwb;
        Va      = norm(Vab);
        
        pdyn    = rho/2 * Va^2;
        alpha   = atan(Vab(3)/Vab(1));
        beta    = asin(Vab(2)/Va);
        
        % transformation aerodyn. to bodyfixed
        Tba =  [cos(alpha)*cos(beta) -cos(alpha)*sin(beta) -sin(alpha);
                sin(beta) cos(beta) 0;
                sin(alpha)*cos(beta) -sin(alpha)*sin(beta) cos(alpha)];
        
        % tranformation earth to body
        Tbe =  [cos(Theta)*cos(Psi) cos(Theta)*sin(Psi) -sin(Theta);
            ((sin(Phi)*sin(Theta))-(cos(Phi)*sin(Psi))) ((sin(Phi)*sin(Theta))+(cos(Phi)*cos(Psi))) (sin(Phi)*cos(Theta));
            (cos(Phi)*sin(Theta)*cos(Psi))+(sin(Phi)*sin(Psi)) (cos(Phi)*sin(Theta)*sin(Psi))-(sin(Phi)*cos(Psi)) (cos(Phi)*cos(Theta))];
        Teb = Tbe';
        
        % transformation omega to euler angle derivatives. 
        Tphithe = [ 1 sin(Phi)*tan(Theta) cos(Phi)*tan(Theta);
                    0 cos(Phi) -sin(Phi);
                    0 sin(Phi)/cos(Theta) cos(Phi)/cos(Theta)];
        
        
        % normalized angular rates
        pstar = p*b/Va;
        qstar = q*lmu/Va;
        rstar = r*b/Va;
        
        % Parameter: aerodynamic coefficients (7.93)
        Cl = Cl0 + Clbeta * beta + Clp * pstar + Clr * rstar + Clxi * xi + Clzeta * zeta;
        Cm = Cm0 + Cmalpha * alpha + Cmq * qstar + Cmeta * eta;
        Cn = Cn0 + Cnbeta * beta + Cnp * pstar + Cnr * rstar + Cnxi * xi + Cnzeta * zeta;
        CD = CD0 + CDq * qstar + CDeta * eta + CDalpha * alpha + CDalpha2 * alpha^2 + CDbeta2 * beta^2 ;
        CY = CY0 + CYbeta * beta + CYp * pstar + CYr * rstar + CYzeta * zeta; 
        CL = CL0 + CLalpha * alpha + CLq * qstar + CLbeta2 * beta^2 + CLeta *eta;
         
        % resulting aerondynamic force and moment
        Raa =  [-CD*pdyn*S;
                CY*pdyn*S;
                -CL*pdyn*S];
        Maac = [Cl*pdyn*S*b*1/2;
                Cm*pdyn*S*lmu;
                Cn*pdyn*S*b*1/2];
        
        % Weight force 
        Wb = Tbe * [0,0,m*g]';
        
        % Engine 
        Tb = [dt,0,0]';
        
        Rab= Tba*Raa;
        Vke = Teb*Vkb;
        
        % Sum of Forces & Sum of Moments
        Fsum = Rab + Tb + Wb;
        Msum = Maac + cross(xCGAC,Rab);   
        
        % state derivatives
        omegabdot = (I)\(Msum + (cross(-omegab,I*omegab)));
        attitudedot = Tphithe * omegab;
        Vkbdot = Fsum/m + cross(-omegab,Vkb);
        Hdot = Vke(3);
           
        xdot = [omegabdot; attitudedot; Vkbdot; Hdot] + xNoise; 

    end
    
return
