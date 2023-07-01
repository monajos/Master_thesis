clear all;
close all;

%% load logfile ------------------------------------------------------------
% select flight
% 1 = warm up
% 2 = short period 
% 3 = short period
% 4 = roll and dutch roll 

testflight = 1;         

if testflight == 1
    total  = ulogreader('..\logs\2023-05-26\09_15_46.ulg');
elseif testflight == 2
    total  = ulogreader('..\logs\2023-05-26\09_59_31.ulg');
elseif testflight == 3
    total  = ulogreader('..\logs\2023-05-26\10_34_08.ulg');
elseif testflight == 4
    total  = ulogreader('..\logs\2023-05-26\11_06_06.ulg');
end


%% read relevant topics ----------------------------------------------------

sensor_combined     = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='sensor_combined'));
actuator_outputs    = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='actuator_outputs'));
vehicle_attitude    = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='vehicle_attitude'));
differential_p      = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='differential_pressure'));
gps_position        = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='vehicle_gps_position'));
testflight_params   = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='testflight_ident_control_params'));
vehicle_control_mode= total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='vehicle_control_mode'));
sensor_gyro         = total.readTopicMsgs.TopicMessages(find(total.AvailableTopics.TopicNames=='sensor_gyro'));


%% prep for KF sim ---------------------------------------------------------

% Generate new time axis
t0 = seconds(sensor_combined{1, 1}.timestamp(1));   % from beginning
dt = 0.01; 
tend = seconds(sensor_combined{1, 1}.timestamp(end));                                     
t = [t0:dt:tend]';
Ndata = length(t);

% interpolate data 
p = interp1(seconds(sensor_combined{1, 1}.timestamp),sensor_combined{1, 1}.gyro_rad(:,1),t,'spline');
q = interp1(seconds(sensor_combined{1, 1}.timestamp),sensor_combined{1, 1}.gyro_rad(:,2),t,'spline');
r = interp1(seconds(sensor_combined{1, 1}.timestamp),sensor_combined{1, 1}.gyro_rad(:,3),t,'spline');

u_d = interp1(seconds(sensor_combined{1, 1}.timestamp),sensor_combined{1, 1}.accelerometer_m_s2(:,1),t,'spline');
v_d = interp1(seconds(sensor_combined{1, 1}.timestamp),sensor_combined{1, 1}.accelerometer_m_s2(:,2),t,'spline');
w_d = interp1(seconds(sensor_combined{1, 1}.timestamp),sensor_combined{1, 1}.accelerometer_m_s2(:,3),t,'spline');

ue(:,1) = interp1(seconds(gps_position{1,1}.timestamp),gps_position{1,1}.vel_n_m_s(:),t,'spline');                   % North
ve(:,1) = interp1(seconds(gps_position{1,1}.timestamp),gps_position{1,1}.vel_e_m_s(:),t,'spline');                   % East
we(:,1) = interp1(seconds(gps_position{1,1}.timestamp),gps_position{1,1}.vel_d_m_s(:),t,'spline');                   % Down
H(:,1)  = interp1(seconds(gps_position{1,1}.timestamp),double(gps_position{1,1}.alt(:)),t,'spline')./1000;           % height in milimeter 

pdyn(:,1)=  interp1(seconds(differential_p{1,1}.timestamp),differential_p{1,1}.differential_pressure_filtered_pa(:),t,'spline');

q0(:,1) = interp1(seconds(vehicle_attitude{1, 1}.timestamp),vehicle_attitude{1, 1}.q(:,1),t,'spline'); 
q1(:,1) = interp1(seconds(vehicle_attitude{1, 1}.timestamp),vehicle_attitude{1, 1}.q(:,2),t,'spline');
q2(:,1) = interp1(seconds(vehicle_attitude{1, 1}.timestamp),vehicle_attitude{1, 1}.q(:,3),t,'spline');
q3(:,1) = interp1(seconds(vehicle_attitude{1, 1}.timestamp),vehicle_attitude{1, 1}.q(:,4),t,'spline');

% convert quaternions to euler angles
Psi_accumulated = 0;
for i= 1:length(q0)
    Phi(i,1)     = atan2((2*(q0(i)*q1(i)+q2(i)*q3(i))),(1-2*(q1(i)^2+q2(i)^2)));
    Theta(i,1)   = asin(-2*q1(i)*q3(i) + 2*q0(i)*q2(i));
    Psi(i,1)     = atan2((2*(q0(i)*q3(i)+q1(i)*q2(i))),(1-2*(q2(i)^2+q3(i)^2)));
    
    if i > 2
        % Perform angle unwrapping for Psi
        diff = Psi(i-1) - Psi(i);
        factor = round(diff / (2*pi));
        Psi(i) = Psi(i) + factor * 2 * pi;
    end 

    % tranformation body to earth
    Tbe(:,:,i) =  [cos(Theta(i))*cos(Psi(i)) cos(Theta(i))*sin(Psi(i)) -sin(Theta(i));
        ((sin(Phi(i))*sin(Theta(i)))-(cos(Phi(i))*sin(Psi(i)))) ((sin(Phi(i))*sin(Theta(i)))+(cos(Phi(i))*cos(Psi(i)))) (sin(Phi(i))*cos(Theta(i)));
        (cos(Phi(i))*sin(Theta(i))*cos(Psi(i)))+(sin(Phi(i))*sin(Psi(i))) (cos(Phi(i))*sin(Theta(i))*sin(Psi(i)))-(sin(Phi(i))*cos(Psi(i))) (cos(Phi(i))*cos(Theta(i)))];
    Teb(:,:,i) = Tbe(:,:,i)';
    
    Vkb(:,i) = Tbe(:,:,i)*[ue(i);ve(i);we(i)];
end

Z = [p q r u_d v_d w_d Phi Theta Psi ue ve we H pdyn];

% convert pwm signals to inputs zeta, eta, xi, thrust
% angle conversion based on measurements
% thrust based on maximum thrust
output_zeta     = (3-((actuator_outputs{1, 1}.output(:,4)-1500)/500).*3.0/0.1)./180*pi;   
output_eta      = (-((actuator_outputs{1, 1}.output(:,3)-1500)/500)*12.5./0.6)./180*pi;  
output_xi       = (-((actuator_outputs{1, 1}.output(:,1)-1500)/500)*17.5./0.6)./180*pi;  
output_thrust   = ((actuator_outputs{1, 1}.output(:,5)-1000)/1000)*10;                   

zeta    = interp1(seconds(actuator_outputs{1, 1}.timestamp),output_zeta,t,'linear');
eta     = interp1(seconds(actuator_outputs{1, 1}.timestamp),output_eta,t,'linear');
xi      = interp1(seconds(actuator_outputs{1, 1}.timestamp),output_xi,t,'linear');
thrust  = interp1(seconds(actuator_outputs{1, 1}.timestamp),output_thrust,t,'linear');

Uinp = [thrust xi eta zeta];

% read flags: aux1-> maneuver activated, attitude-> attitude mode,

% man_sel-> selected maneuver
% 1   -> elevator doublet
% 2   -> elevator multistep
% 3   -> elevator pulse
% 4,5 -> bank to bank 30 and 60°
% 6   -> rudder doublet
% 7   -> thrust variation
% 8   -> rudder pulses 

aux1                = interp1(seconds(testflight_params{1,1}.timestamp),double(testflight_params{1,1}.aux1_activated(:,1)),t);
attitude            = interp1(seconds(vehicle_control_mode{1,1}.timestamp),double(vehicle_control_mode{1,1}.flag_control_attitude_enabled(:,1)),t);
man_sel             = interp1(seconds(testflight_params{1,1}.timestamp),double(testflight_params{1,1}.man_ident_sel(:,1)),t); 


%% Algorithm to save maneuver data seperately ------------------------------ 

% adjustments bc data was interpolated 
for i=1:length(aux1) 
    if aux1(i)<1
        aux1(i)=0;
    end
end

% manipulating aux1 to save second before maneuver
for i=1:(length(aux1)-100) 
    if aux1(i+100)>0 && aux1(i+200)>0
        aux1(i)=1;
    end
end

j   = 1; 
man = 1; 
helper = 0; 
folderName = 'testflight_maneuver_log_data'; 
currentPath = pwd;
folderPath = fullfile(currentPath, folderName);

for i=1:length(aux1)    
    if aux1(i)==1 && attitude(i) == 1
        helper = 1; 

        % write maneuver data into struct
        Maneuver.zeta(j)    = zeta(i);
        Maneuver.eta(j)     = eta(i);
        Maneuver.xi(j)      = xi(i);
        Maneuver.thrust(j)  = thrust(i);

        Maneuver.p(j)       = p(i);    
        Maneuver.q(j)       = q(i);    
        Maneuver.r(j)       = r(i);  
        
        Maneuver.u_d(j)     = u_d(i);  
        Maneuver.v_d(j)     = v_d(i);  
        Maneuver.w_d(j)     = w_d(i);  
         
        Maneuver.ue(j)      = ue(i);
        Maneuver.ve(j)      = ve(i);
        Maneuver.we(j)      = we(i);
        Maneuver.H(j)       = H(i);
        Maneuver.pdyn(j)    = pdyn(i);
 
        Maneuver.Phi(j)     = Phi(i);
        Maneuver.Theta(j)   = Theta(i);
        Maneuver.Psi(j)     = Psi(i);
        Maneuver.Vkb(j,:)   = Vkb(:,i);
        Maneuver.t_total(j) = t(i);
        Maneuver.t(j)       = t(i)-Maneuver.t_total(1);

        % secify maneuver for name of saved data
        if man_sel(i) == 1
            name = '_Elevator_doublet';
        elseif man_sel(i) == 2
            name = '_Elevator_3211';
        elseif man_sel(i) == 3
            name = '_Elevator_pulse';
        elseif man_sel(i) == 4
            name = '_Bank_to_bank';
        elseif man_sel(i) == 5
            name = '_Bank_to_bank';
        elseif man_sel(i) == 6
            name = '_Rudder_doublet';
        end

        j   = j+1;

    elseif aux1(i) == 0 && helper == 1

        % name and save file
%         filename = ['Flight_',num2str(testflight),'_Maneuver_',num2str(man),name, '.mat'];
        filename = ['Flight_',num2str(testflight),'_Maneuver_',num2str(man),name, '_p1s.mat'];
        save(fullfile(folderPath, filename),"Maneuver")
        helper = 0;
        man = man+1;
        j = 1;
        clear Maneuver
    end
end
man = 1; 


%% save open-loop part of flight 1 ------------------------------------------

j=1;
folderName = 'testflight_maneuver_log_data'; 
currentPath = pwd;
folderPath = fullfile(currentPath, folderName);

if testflight == 1
    for i=1:length(t)    
        % time interval was selected based on attitude flag 
        if t(i)> 2555 && t(i)< 2754 
            Maneuver.zeta(j)    = zeta(i);
            Maneuver.eta(j)     = eta(i);
            Maneuver.xi(j)      = xi(i);
            Maneuver.thrust(j)  = thrust(i);
    
            Maneuver.p(j)       = p(i);    
            Maneuver.q(j)       = q(i);    
            Maneuver.r(j)       = r(i);    
            
            Maneuver.u_d(j)     = u_d(i);  
            Maneuver.v_d(j)     = v_d(i);  
            Maneuver.w_d(j)     = w_d(i);  
             
            Maneuver.ue(j)      = ue(i);
            Maneuver.ve(j)      = ve(i);
            Maneuver.we(j)      = we(i);
            Maneuver.H(j)       = H(i);
            Maneuver.pdyn(j)    = pdyn(i);
     
            Maneuver.Phi(j)     = Phi(i);
            Maneuver.Theta(j)   = Theta(i);
            Maneuver.Psi(j)     = Psi(i);
            Maneuver.Vkb(j,:)   = Vkb(:,i);
            Maneuver.t_total(j) = t(i);
            Maneuver.t(j)       = t(i)-Maneuver.t_total(1);   
            j = j+1;
        end
    end

    % save derivatives of angular rates for estimation of only parameters
    Maneuver.pd = gradient(Maneuver.p,0.01);
    Maneuver.qd = gradient(Maneuver.q,0.01);
    Maneuver.rd = gradient(Maneuver.r,0.01);

    filename = ['Flight_',num2str(testflight),'_openloop.mat'];
    save(fullfile(folderPath, filename),"Maneuver")
end


