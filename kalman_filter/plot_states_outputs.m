function [] = plot_states_outputs(t,Z,sxekf,sxukf,sxukfaug,syekf,syukf,syukfaug,onlylongitudinal,onlylateral)

% function to plot measurements and filteroutcome

    % plot pitch rate, longitudinal horizontal and vertical acceleration for
    % longitudinal estimation
    r2d = 180/pi;
    if onlylongitudinal
        figure
    
        subplot(3,1,1)
        plot(t, sxekf(:,2)*r2d, 'Color', [0 0.7 0], 'LineWidth', 0.8);
        hold on;
        plot(t, sxukf(:,2)*r2d, 'Color', [0.2 0.2 0.9], 'LineWidth', 0.8);
        plot(t, sxukfaug(:,2)*r2d, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.8);
        plot(t, Z(:,2)*r2d, 'r', 'LineWidth', 0.8);
        hold off;
        
        title('q', 'Interpreter', 'latex');
        set(gca, 'FontName', 'Times New Roman');
        legend({'EKF', 'UKF', 'UKF$_{aug}$', 'measured'}, 'Interpreter', 'latex');
        xlabel('in s', 'Interpreter', 'latex');
        ylabel('in $^\circ$/s', 'Interpreter', 'latex');
        grid on;
        
    
        subplot(3,1,2)
        plot(t, syekf(:,4), 'Color', [0 0.7 0], 'LineWidth', 0.8);
        hold on;
        plot(t, syukf(:,4), 'Color', [0.2 0.2 0.9], 'LineWidth', 0.8);
        plot(t, syukfaug(:,4), 'Color', [0.5 0.5 0.5], 'LineWidth', 0.8);
        plot(t, Z(:,4), 'r', 'LineWidth', 0.8);
        hold off;
        
        title('$\dot{u}_{kb}$', 'Interpreter', 'latex');
        set(gca, 'FontName', 'Times New Roman');
        xlabel('in s', 'Interpreter', 'latex');
        ylabel('in m/$s^2$', 'Interpreter', 'latex');
        grid on;
        
        
        subplot(3,1,3)
        plot(t, syekf(:,6), 'Color', [0 0.7 0], 'LineWidth', 0.8);
        hold on;
        plot(t, syukf(:,6), 'Color', [0.2 0.2 0.9], 'LineWidth', 0.8);
        plot(t, syukfaug(:,6), 'Color', [0.5 0.5 0.5], 'LineWidth', 0.8);
        plot(t, Z(:,6), 'r', 'LineWidth', 0.8);
        hold off;
        
        title('$\dot{w}_{kb}$', 'Interpreter', 'latex');
        set(gca, 'FontName', 'Times New Roman');
        xlabel('in s', 'Interpreter', 'latex');
        ylabel('in m/$s^2$', 'Interpreter', 'latex');
        grid on;
    
    % plot roll rate, yaw rate and lateral acceleration for
    % lateral estimation
    elseif onlylateral
        figure
        
        subplot(3,1,1)
        plot(t, sxekf(:,1)*r2d, 'Color', [0 0.7 0], 'LineWidth', 1);
        hold on;
        plot(t, sxukf(:,1)*r2d, 'Color', [0.2 0.2 0.9], 'LineWidth', 1);
        plot(t, sxukfaug(:,1)*r2d, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
        plot(t, Z(:,1)*r2d, 'r', 'LineWidth', 1);
        hold off;
        
        title('p', 'Interpreter', 'latex');
        set(gca, 'FontName', 'Times New Roman');
        legend({'EKF', 'UKF', 'UKF$_{aug}$', 'measured'}, 'Interpreter', 'latex');
        xlabel('in s', 'Interpreter', 'latex');
        ylabel('in $^\circ$/s', 'Interpreter', 'latex');
        grid on;
        
        
        subplot(3,1,2)
        plot(t, sxekf(:,3)*r2d, 'Color', [0 0.7 0], 'LineWidth', 1);
        hold on;
        plot(t, sxukf(:,3)*r2d, 'Color', [0.2 0.2 0.9], 'LineWidth', 1);
        plot(t, sxukfaug(:,3)*r2d, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
        plot(t, Z(:,3)*r2d, 'r', 'LineWidth', 1);
        hold off;
        
        title('r', 'Interpreter', 'latex');
        set(gca, 'FontName', 'Times New Roman');
        xlabel('in s', 'Interpreter', 'latex');
        ylabel('in $^\circ$/s', 'Interpreter', 'latex');
        grid on;
        
        
        subplot(3,1,3)
        plot(t, syekf(:,5), 'Color', [0 0.7 0], 'LineWidth', 1);
        hold on;
        plot(t, syukf(:,5), 'Color', [0.2 0.2 0.9], 'LineWidth', 1);
        plot(t, syukfaug(:,5), 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
        plot(t, Z(:,5), 'r', 'LineWidth', 1);
        hold off;
        
        title('$\dot{v}_{kb}$', 'Interpreter', 'latex');
        set(gca, 'FontName', 'Times New Roman');
        xlabel('in s', 'Interpreter', 'latex');
        ylabel('in m/$s^2$', 'Interpreter', 'latex');
        grid on;
    end

return 
