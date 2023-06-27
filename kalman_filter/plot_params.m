function [] = plot_params(Par_no,t,sxekf,sxukf,sxukfaug,Nx)

% Function to plot resulting estimated parameters 

    for i = 1:6    % l, m, n, D, Y, L 
        k = 1;  
        clear currentParam       
        for j = 1:length(Par_no)
            if Par_no{j,4}==i
                currentParam(k,:) = Par_no(j,:);
                k = k+1;
            end
        end
        if exist('currentParam')
            count = height(currentParam);        
            figure(i)
            for j = 1:count
                subplot(ceil(count/2),2,j)
                plot(t, sxekf(:,currentParam{j,1}+Nx), 'Color', [0 0.7 0], 'LineWidth', 1);
                hold on;
                plot(t, sxukf(:,currentParam{j,1}+Nx), 'Color', [0.2 0.2 0.9], 'LineWidth', 1);
                plot(t, sxukfaug(:,currentParam{j,1}+Nx), 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
                hold off;
                if j ==1
                    legend({'EKF','UKF','UKF$_{aug}$'}, 'Interpreter', 'latex');
                end
                set(gca, 'FontName', 'Times New Roman');
                title(['$',currentParam{j,3},'$'],'Interpreter', 'latex')
                xlabel('in s', 'Interpreter', 'latex')
                grid on
            end
        end
    end
end

