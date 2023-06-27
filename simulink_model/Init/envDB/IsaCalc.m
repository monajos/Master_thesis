function [H,T,P,rho]=IsaCalc()

%definition of ISA temperature profile
H=[0; 11e3; 20e3; 32e3; 47e3; 52e3; 61e3; 79e3; 88e3];
T=[288.15; 216.65; 216.65; 228.65; 270.65; 270.65; 252.65; 180.65; 180.65];

%physical constants
R=287.05287;
g0=9.81;

%initialisation
P=zeros(size(H));
rho=zeros(size(H));
P(1)=101325;           %ISA standard pressure at sea level
rho(1)=P(1)/(T(1)*R);   %density from ideal gas law

for n=1:length(H)-1
    if abs(T(n+1)-T(n))>eps     %constant gradient
        k=(T(n+1)-T(n))/(H(n+1)-H(n));
        P(n+1)=P(n)*(T(n+1)/T(n))^(-g0/(k*R));
    else                        %constant temperature
        P(n+1)=P(n)*exp(-g0/(R*T(n))*(H(n+1)-H(n)));
    end
    rho(n+1)=P(n+1)/(T(n+1)*R); %density from ideal gas law

end
end


%doppelaxe
%logplots
%size
%laden speichern
