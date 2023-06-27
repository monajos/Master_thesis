function [] = print_NMSE(Z,szmsyekf,szmsyukf,szmsyukfaug,Ndata)
    
% function to print normalized mean squared error for all filters 

    % squared residuals and average of squared residuals
    res_square_ekf = szmsyekf(21:end,:).^2;
    res_square_avg_ekf = sum(res_square_ekf)./(Ndata-20);
    
    res_square_ukf = szmsyukf(21:end,:).^2;
    res_square_avg_ukf = sum(res_square_ukf)./(Ndata-20);
    
    res_square_ukfaug = szmsyukfaug(21:end,:).^2;
    res_square_avg_ukfaug = sum(res_square_ukfaug)./(Ndata-20);
    
    Var_Z = var(Z(21:end,:));
    
    % if variance is very small decrease influence on cost function by
    % by setting a limit
    for i = 1:length(Var_Z)
        if Var_Z(i) < 1.0e-3
            Var_Z(i) = 1.0e-3;
        end
    end
    
    % Normalized mean squared error
    NMSE_ekf = res_square_avg_ekf./Var_Z;
    NMSE_ukf = res_square_avg_ukf./Var_Z;
    NMSE_ukfaug = res_square_avg_ukfaug./Var_Z;

    output = {'p'; 'q'; 'r'; 'u_d'; 'v_d'; 'w_d'; 'Phi'; 'Theta'; 'Psi'; 'ue'; 've'; 'we'; 'H'; 'pdyn'};
    output_latex = {'$p$'; '$q$'; '$r$'; '$\Dot{u_{k_b}}$'; '$\Dot{v_{k_b}}$'; '$\Dot{w_{k_b}}$'; '$\Phi$'; '$\Theta$'; '$\Psi$'; '$u_e$'; '$v_e$'; '$w_e$'; '$H$'; '$p_{dyn}$'};

    disp(' Output       NMSE_EKF          NMSE_UKF        NMSE_UKFaug')
    for i=1:length(NMSE_ekf)    
        fprintf('%8s        %5.2f           %5.2f           %5.2f \n',...
                              char(output(i,1)), NMSE_ekf(i), NMSE_ukf(i), NMSE_ukfaug(i));
    end
    fprintf('\n \n');
    
    % To print table for LateX
%     for i=1:length(NMSE_ekf)
% 
%         fprintf('%8s & $%20s$ & $ %10s $ &  $ %10s $ \\\\ \n',...
%                               char(output_latex(i,1)), formatNumber(NMSE_ekf(i)), formatNumber(NMSE_ukf(i)), formatNumber(NMSE_ukfaug(i)));
%     end
end