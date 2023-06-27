function [par_avg, std_avg, Par_no, par_std_rel] = print_par_std(method, Nx, NparSys, Ndata, NparID, parFlag, NavgPt,...
                                                   sx, sxstd)

% Compute average parameter values and standard deviations over NavgPt points
% and print the same.
%
% Chapter 7: Recursive Parameter Estimation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
% Modifications by Mona Strauss (monastrauss@gmx.net)
%
% Inputs:
%    method        recursive parameter estimation method
%    Nx            number of state variables
%    NparSys       Number of system parameters
%    Ndata         number of data points
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    NavgPt        number of points for averaging
%    sx            estimated augmented states, i.e. (system states + parameters), (Ndata,Nxp)
%    sxstd         standard deviations of estimated states, (Ndata,Nxp)
%
% Outputs:
%    par_avg       estimated parameters (average over last NavgPt points)
%    std_avg       standard deviations (average over last NavgPt points)

global optimizing

% parameter values and their standard deviations: average over last NavgPt points
par_avg = mean(sx(Ndata-NavgPt+1:Ndata,Nx+1:end))';
std_avg = mean(sxstd(Ndata-NavgPt+1:Ndata,Nx+1:end))';

par_prnt = sprintf('Estimated Parameters with %s: Average of last %d points',method,NavgPt);
if ~optimizing
    disp(par_prnt)
    disp(' No.   Parameter                   Std. deviation     Relative Std. Dev (%)')
end
iPar = 0;

Params = {'Cl0'; 'Clbeta'; 'Clp'; 'Clr'; 'Clxi'; 'Clzeta';...
    'Cm0'; 'Cmalpha'; 'Cmq'; 'Cmeta';...
    'Cn0'; 'Cnbeta'; 'Cnp'; 'Cnr'; 'Cnxi'; 'Cnzeta';...
    'CD0'; 'CDq' ; 'CDeta'; 'CDalpha'; 'CDalpha2'; 'CDbeta2';...
    'CY0'; 'CYbeta'; 'CYp'; 'CYr'; 'CYzeta';...
    'CL0'; 'CLalpha';'CLq'; 'CLbeta2'; 'CLeta'};

% For plotting purposes
Params_tex = {'C_{l0}'; 'C_{l\beta}'; 'C_{lp}'; 'C_{lr}'; 'C_{l\xi}'; 'C_{l\zeta}';...
   'C_{m0}'; 'C_{m\alpha}'; 'C_{mq}'; 'C_{m\eta}';...
   'C_{n0}'; 'C_{n\beta}'; 'C_{np}'; 'C_{nr}'; 'C_{n\xi}'; 'C_{n\zeta}';...
   'C_{D0}'; 'C_{Dq}' ; 'C_{D\eta}'; 'C_{D\alpha}'; 'C_{D\alpha^2}'; 'C_{D\beta^2}';...
   'C_{Y0}'; 'C_{Y\beta}'; 'C_{Yp}'; 'C_{Yr}'; 'C_{Y\zeta}';...
   'C_{L0}'; 'C_{L\alpha}';'C_{Lq}'; 'C_{L\beta^2}'; 'C_{L\eta}'};

Par_no = cell(NparID,4);

for ip=1:NparSys
    if  parFlag(ip) > 0
        iPar = iPar + 1;
        par_std_rel(iPar) = Inf;
        currentParam = char(Params(ip,1));
        currentParam_tex = char(Params_tex(ip,1));
        if par_avg(iPar) ~= 0
            par_std_rel(iPar) = 100*std_avg(iPar)/abs(par_avg(iPar));
        end
        par_prnt = sprintf('%3i   %8s   %13.5e     %10.4e      %8.2f',...
                              iPar, currentParam, par_avg(iPar), std_avg(iPar), par_std_rel(iPar));
        if ~optimizing
            disp(par_prnt)
        end

        % For plotting purposes 
        Par_no{iPar,1} = iPar;
        Par_no{iPar,2} = currentParam;
        Par_no{iPar,3} = currentParam_tex;
        if strcmp(currentParam(1:2),'Cl') 
            Par_no{iPar,4} = 1;
        elseif strcmp(currentParam(1:2),'Cm')
            Par_no{iPar,4} = 2;
        elseif strcmp(currentParam(1:2),'Cn') 
            Par_no{iPar,4} = 3;
        elseif strcmp(currentParam(1:2),'CD')
            Par_no{iPar,4} = 4; 
        elseif strcmp(currentParam(1:2),'CY')
            Par_no{iPar,4} = 5; 
        elseif strcmp(currentParam(1:2),'CL')
            Par_no{iPar,4} = 6; 
        end
    end
end
    
