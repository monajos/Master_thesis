clear all;
close all;

%% Load flight data    
% total               = ulogreader('..\logs\Logs_Testflight_20220413\log_35_2022-4-13-06-04-10.ulg');
total               = ulogreader('logs\2023-05-26\09_59_31.ulg'); % flight 2 Short period 

sensor_combined     = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='sensor_combined'));
actuator_outputs    = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='actuator_outputs'));
vehicle_attitude    = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='vehicle_attitude'));
differential_p      = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='differential_pressure'));
gps_position        = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='vehicle_gps_position'));


%% p_dyn 

p_dyn(:,1) = differential_p{1,1}.differential_pressure_filtered_pa;
t_pdyn     = differential_p{1,1}.timestamp;

% plot quantity to choose suitable time period for finding the standard dev
% and variance
% figure 
% plot(t_pdyn,p_dyn);
% title('p_{dyn}')
% grid on 

% save data for selected time period
j = 0;
for i = 1:length(t_pdyn)
    if t_pdyn(i) > duration(0,11,15,0) && t_pdyn(i) < duration(0,11,30,0) %duration(0,1,35,0) && t_pdyn(i) < duration(0,2,33,0)
        j =j+1;
        t_p_neu(:,j) = t_pdyn(i);
        p_dyn_neu(:,j) = p_dyn(i);
    end
end

% standard deviation, variance and noise power
p_dyn_std = std(p_dyn_neu);
p_dyn_var = p_dyn_std^2;
p_dyn_NP  = p_dyn_var* seconds(mean(diff(t_p_neu)));



%% p,q,r & ukbd,vkbd,wkb 
p(:,1) = sensor_combined{1, 1}.gyro_rad(:,1); 
q(:,1) = sensor_combined{1, 1}.gyro_rad(:,2); 
r(:,1) = sensor_combined{1, 1}.gyro_rad(:,3); 
ukbd(:,1) = sensor_combined{1, 1}.accelerometer_m_s2(:,1); 
vkbd(:,1) = sensor_combined{1, 1}.accelerometer_m_s2(:,2); 
wkbd(:,1) = sensor_combined{1, 1}.accelerometer_m_s2(:,3); 
t_imu     = sensor_combined{1, 1}.timestamp; 

% plot quantities to choose suitable time period for finding the standard dev
% and variance
% figure
% plot(t_imu,p,t_imu,q,t_imu,r)
% legend('p','q','r')
% grid on 
% figure
% plot(t_imu,ukbd,t_imu,vkbd,t_imu,wkbd)
% legend('ukbd','vkbd','wkbd')
% grid on 

% save data for selected time period
j = 0;
for i = 1:length(t_imu)
    if t_imu(i) > duration(0,11,33,0) && t_imu(i) < duration(0,11,43,0) 
        j =j+1;
        t_imu_neu(:,j) = t_imu(i);
        p_neu(:,j) = p(i);
        q_neu(:,j) = q(i);
        r_neu(:,j) = r(i);
        
        ukbd_neu(:,j) = ukbd(i);
        vkbd_neu(:,j) = vkbd(i);
        wkbd_neu(:,j) = wkbd(i);
    end
end

% standard deviations and variances
p_std = std(p_neu);
q_std = std(q_neu);
r_std = std(r_neu);

p_var = std(p_neu)^2;
q_var = std(q_neu)^2;
r_var = std(r_neu)^2;

ud_var = std(ukbd_neu)^2;
vd_var = std(vkbd_neu)^2;
wd_var = std(wkbd_neu)^2;


%% Euler angles
% convert quatern to euler 
q0(:,1) = vehicle_attitude{1, 1}.q(:,1);
q1(:,1) = vehicle_attitude{1, 1}.q(:,2);
q2(:,1) = vehicle_attitude{1, 1}.q(:,3);
q3(:,1) = vehicle_attitude{1, 1}.q(:,4);
t       = vehicle_attitude{1, 1}.timestamp;

% compute Euler angles from quaternions
for i= 1:length(q0)
            Phi(i,1)     = atan2((2*(q0(i)*q1(i)+q2(i)*q3(i))),(1-2*(q1(i)^2+q2(i)^2)));
            Theta(i,1)   = asin(-2*q1(i)*q3(i) + 2*q0(i)*q2(i));
            Psi(i,1)     = atan2((2*(q0(i)*q3(i)+q1(i)*q2(i))),(1-2*(q2(i)^2+q3(i)^2)));
end

% plot quantities to choose suitable time period for finding the standard dev
% and variance
% figure 
% plot(t,Phi*180/pi,t,Theta*180/pi,t,Psi*180/pi)
% legend('Phi','Theta','Psi')
% grid on 


% Cut interesting sequences
j = 0;
for i = 1:length(t)
    if t(i) > duration(0,11,0,0) && t(i) < duration(0,11,15,0) 
        j =j+1;
        t_neu(:,j) = t(i);
        Theta_neu(:,j) = Theta(i);
        Phi_neu(:,j) = Phi(i);
    end
end
j= 0;
for i = 1:length(t)
    if t(i) > duration(0,11,30,0) && t(i) < duration(0,11,40,0)
        j =j+1;
        t_neu_psi(:,j) = t(i);
        Psi_neu(:,j) = Psi(i);
    end
end

% find std dev and var
Theta_std   = std(Theta_neu);
Theta_Var   = Theta_std^2;

Phi_std     = std(Phi_neu);
Phi_Var     = Phi_std^2;

Psi_std     = std(Psi_neu);
Psi_Var     = Psi_std^2;

Euler_Var    = ((Psi_std + Theta_std + Phi_std)/3)^2;
Euler_NP     = Euler_Var * seconds(mean(diff(t_neu)));


%% Vke & H 
uke(:,1) = gps_position{1,1}.vel_n_m_s(:);                    % North
vke(:,1) = gps_position{1,1}.vel_e_m_s(:);                    % East
wke(:,1) = gps_position{1,1}.vel_d_m_s(:);                    % Down
H(:,1)   = double(gps_position{1,1}.alt(:))/1000;
t_vke    = gps_position{1,1}.timestamp;

% Plot Vke & H
% figure 
% plot(t_vke,uke,t_vke,vke,t_vke,wke)
% legend('u_{k_e}','v_{k_e}','w_{k_e}')
% title('V_{k_e}')
% grid on 
% figure 
% plot(t_vke,H)
% title('height')
% grid on

% interesting sequence
j = 0;
for i = 1:length(t_vke)
    if t_vke(i) > duration(0,11,0,0) && t_vke(i) < duration(0,11,15,0) 
        j =j+1;
        t_vke_neu(:,j) = t_vke(i);
        uke_neu(:,j) = uke(i);
        vke_neu(:,j) = vke(i);
        wke_neu(:,j) = wke(i);    
        H_neu(:,j) = H(i);
    end
end

% find std dev, var
uke_std = std(uke_neu);
uke_var = var(uke_neu);
vke_std = std(vke_neu);
vke_var = var(vke_neu);
wke_std = std(wke_neu);
wke_var = var(wke_neu);
Vke_var = ((uke_std+vke_std+wke_std)/3)^2;

Vke_NP  = Vke_var * seconds(mean(diff(t_vke_neu)));

H_std   = std(H_neu);
H_var   = H_std^2;
H_NP    = H_var * seconds(mean(diff(t_vke_neu)));

% save variance for initial guess of measurement noise covariance R (rr)
rr = [p_var,q_var,r_var,ud_var,vd_var,wd_var,Phi_Var,Theta_Var,Psi_Var,uke_var,vke_var,wke_var,H_var,p_dyn_var]';
save('R_var.mat','rr');








