clear all;
close all;

%% ------------------------------------------------------------------------------------
% plot all 3-2-1-1 Maneuvers of Flight 3
% short period -> q, Theta, u, w, ud, wd
r2d = 180/pi;
d2r = pi/180; 

for i = 1:16
    figure(i)
    filename = ['testflight_maneuver_log_data\Flight_3_Maneuver_',num2str(i),'_Elevator_3211_p1s.mat'];
    load(filename);
    subplot(2,2,1)
    plot(Maneuver.t,Maneuver.q*r2d,Maneuver.t,  Maneuver.eta*r2d,'LineWidth',1); grid on;
    % set(gca, 'FontName', 'Times New Roman');
    legend({'$q$', '$\eta$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex')
    ylabel('in $^\circ$ and $^\circ/s$', 'Interpreter', 'latex');
    
    subplot(2,2,2)
    plot(Maneuver.t,Maneuver.Theta*r2d,Maneuver.t, Maneuver.eta*r2d,'LineWidth',1); grid on;
    legend('\Theta','\eta');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ$', 'Interpreter', 'latex');
    
    subplot(2,2,3)
    plot(Maneuver.t,Maneuver.u_d,Maneuver.t, Maneuver.eta*r2d,'LineWidth',1); grid on;
    legend({'$\dot{u}_{kb}$', '$\eta$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $m/s^2$ and $^\circ$', 'Interpreter', 'latex');
    
    subplot(2,2,4)
    plot(Maneuver.t,Maneuver.w_d,Maneuver.t, Maneuver.eta*r2d,'LineWidth',1); grid on;
    legend({'$\dot{w}_{kb}$', '$\eta$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $m/s^2$ and $^\circ$', 'Interpreter', 'latex');
end

%% -------------------------------------------------------------------------------
% plot all bank to bank maneuvers 
% roll mode, bank to bank -> p, r, Phi, Psi, vd 

r2d = 180/pi;
d2r = pi/180; 
for i = 1:12
    filename = ['testflight_maneuver_log_data\Flight_4_Maneuver_',num2str(i),'_Bank_to_bank_p1s.mat'];
    load(filename);

    figure(i+16)
    subplot(2,2,1)
    plot(Maneuver.t,Maneuver.p*r2d,Maneuver.t,  Maneuver.xi*r2d,'LineWidth',1); grid on;
    legend({'$p$', '$\xi$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex')
    ylabel('in $^\circ$ and $^\circ/s$', 'Interpreter', 'latex');
    
    subplot(2,2,2)
    plot(Maneuver.t,Maneuver.Phi*r2d,Maneuver.t, Maneuver.xi*r2d,'LineWidth',1); grid on;
    legend('\Phi','\xi');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ$', 'Interpreter', 'latex');
    
    subplot(2,2,3)
    plot(Maneuver.t,Maneuver.r*r2d,Maneuver.t, Maneuver.xi*r2d,'LineWidth',1); grid on;
    legend({'$r$', '$\xi$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ/s$ and $^\circ$', 'Interpreter', 'latex');
    
    subplot(2,2,4)
    plot(Maneuver.t,Maneuver.Psi*r2d-Maneuver.Psi(1)*r2d,Maneuver.t, Maneuver.xi*r2d,'LineWidth',1); grid on;
    legend({'$\Psi$', '$\xi$'}, 'Interpreter', 'latex'); %$\dot{w}_{kb}$
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ$', 'Interpreter', 'latex');

end

%% ------------------------------------------------------------------------------------
% plot rudder doublet maneuvers
% rudder doublet -> p, r, Phi, Psi, vd 

r2d = 180/pi;
d2r = pi/180; 
for i = 13:15
    filename = ['testflight_maneuver_log_data\Flight_4_Maneuver_',num2str(i),'_Rudder_doublet_p1s.mat'];
    load(filename);

    figure(i+28)
    subplot(2,2,1)
    plot(Maneuver.t,Maneuver.p*r2d,Maneuver.t,  Maneuver.zeta*r2d,'LineWidth',1); grid on;
    legend({'$p$', '$\zeta$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex')
    ylabel('in $^\circ$ and $^\circ/s$', 'Interpreter', 'latex');
    
    subplot(2,2,2)
    plot(Maneuver.t,Maneuver.Phi*r2d,Maneuver.t, Maneuver.zeta*r2d,'LineWidth',1); grid on;
    legend('\Phi','\zeta');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ$', 'Interpreter', 'latex');
    
    subplot(2,2,3)
    plot(Maneuver.t,Maneuver.r*r2d,Maneuver.t, Maneuver.zeta*r2d,'LineWidth',1); grid on;
    legend({'$r$', '$\zeta$'}, 'Interpreter', 'latex');
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ/s$ and $^\circ$', 'Interpreter', 'latex');
    
    subplot(2,2,4)
    plot(Maneuver.t,Maneuver.Psi*r2d-Maneuver.Psi(1)*r2d,Maneuver.t, Maneuver.zeta*r2d,'LineWidth',1); grid on;
    legend({'$\Psi$', '$\zeta$'}, 'Interpreter', 'latex'); %$\dot{w}_{kb}$
    set(gca, 'FontName', 'Times New Roman');
    xlabel('in $s$', 'Interpreter', 'latex');
    ylabel('in $^\circ$', 'Interpreter', 'latex');

end

%% ------------------------------------------------------------------------
%plot open loop flight

load("testflight_maneuver_log_data\Flight_1_openloop.mat");

r2d = 180/pi;
d2r = pi/180; 

figure(100)
subplot(3,2,1)
plot(Maneuver.t,Maneuver.p*r2d,Maneuver.t, Maneuver.xi*r2d); grid on;
legend('p','\xi')

subplot(3,2,3)
plot(Maneuver.t,Maneuver.q*r2d,Maneuver.t, Maneuver.eta*r2d); grid on;
legend('q','\eta')

subplot(3,2,5)
plot(Maneuver.t,Maneuver.r*r2d,Maneuver.t, Maneuver.zeta*r2d); grid on;
legend('r','\zeta')

subplot(3,2,4)
plot(Maneuver.t,Maneuver.Theta*r2d,Maneuver.t, Maneuver.eta*r2d); grid on;
legend('\Theta','\eta')

subplot(3,2,2)
plot(Maneuver.t,Maneuver.Phi*r2d); grid on;
legend('\Phi')

subplot(3,2,6)
plot(Maneuver.t,Maneuver.Psi*r2d); grid on;
legend('\Psi')


figure(101)
subplot(3,2,1)
plot(Maneuver.t,Maneuver.Vkb(:,1)); grid on;
legend('u')

subplot(3,2,3)
plot(Maneuver.t,Maneuver.Vkb(:,2)); grid on;
legend('v')

subplot(3,2,5)
plot(Maneuver.t,Maneuver.Vkb(:,3)); grid on;
legend('w')

subplot(3,2,2)
plot(Maneuver.t,Maneuver.u_d); grid on;
legend('u_d')

subplot(3,2,4)
plot(Maneuver.t,Maneuver.v_d); grid on;
legend('v_d')

subplot(3,2,6)
plot(Maneuver.t,Maneuver.w_d); grid on;
legend('w_d')


