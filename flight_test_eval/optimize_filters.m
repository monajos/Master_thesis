clear all;
close all; 


%% select optimization mode

% 1 -> trying all Maneuvers in flight 3 
%       for each filter for 
%       qq from qq_val to qq_val_max --> finding suitable Maneuver and Q 
% 2 -> trying only Maneuver 10 in flight 3 
%       for each filter, with qq = 0.1
%       for pa0 from 1.0e-2 to 1.0e2 --> finding suitable Pa0
% 3 -> optimize qq, rr and alpha 
%       using all filters
%       and optimizer patternsearch 

optimization_mode = 3; 

% add path to filter scripts
addpath("..\kalman_filter\")

global ManeuverNo qq_val pa0_val methodNo optimizing initdata Man
optimizing = true;

% use flight logs 
initdata = 'log';


%% mode 1 ------------------------------------------------------------
if optimization_mode == 1
    running = true;
    pa0_val = 10;
    ManeuverNo = 0; 
    qq_val = 1.0e-2;
    qq_val_max = 1.0e-1;
    rr_val = [0.001 ;0.0005 ;0.0005 ;0.0838 ;0.349 ;0.0408 ;0.0018; ...
         0.0018 ;0.0018 ;0.004 ;0.004 ;0.004 ;0.11; 9.3];
    alpha = 0.5;
    Man = '3211';
    methodNo = 1; 
    Results = zeros(15, 3,2);
    qNo =  1;

    while running
        try
            % iterate through maneuvers 
            ManeuverNo = ManeuverNo + 1; 
            if methodNo == 3 && ManeuverNo >16
                % iterate through qq
                qq_val = qq_val*10;
                qNo = qNo+1;
                methodNo = 1;
                ManeuverNo = 1;
                if qq_val == qq_val_max*10 
                    running = false;
                end
            elseif ManeuverNo >16
                % iterate through methods (filter types)
                ManeuverNo = 1;
                methodNo = methodNo + 1; 
            end   

            % Run script
            warning('off', 'all');  % Disable all warnings
            main;                   % main script calls filters
            warning('on', 'all');   % Re-enable warnings
            
            % If Results = 1 --> simulation succesful
            Results(ManeuverNo, methodNo,qNo) = 1;  
            if isnan(stdAvg(1))
                Results(ManeuverNo, methodNo,qNo) = 0;
            end

            % saving different quality criteria for each simulation
            quality_criterion.std(:, methodNo, qNo,ManeuverNo) = stdAvg;
            quality_criterion.sign(:, methodNo, qNo,ManeuverNo) = same_sign;
            quality_criterion.diff(:, methodNo, qNo,ManeuverNo) = par_diff;  
    
        catch exception
            % Check for warnings within the catch block
            [~, lastWarning] = lastwarn();
            if ~isempty(lastWarning)
                % Handle warnings here
                disp('Warning occurred!');                               
                % Clear warning state
                lastwarn('');
            end
            % Handle errors
            disp('Error occurred!');
           
        end
    end
end

%% mode 2 --------------------------------------------------------------
if optimization_mode == 2
    running = true;
    pa0_val = 1.0e-2;
    pa0_val_max = 1e2;
    Man = '3211';
    ManeuverNo = 10; 
    qq_val = 0.1;
        rr_val = [0.001 ;0.0005 ;0.0005 ;0.0838 ;0.349 ;0.0408 ;0.0018; ...
         0.0018 ;0.0018 ;0.004 ;0.004 ;0.004 ;0.11; 9.3];
    alpha = 0.5;
    methodNo = 1; 
    pa0No =  0;
    Results = zeros(4,3);

    pa0_val = pa0_val/10;

    while running
        try            
            % iterate through inital cov Pa0
            pa0_val = pa0_val*10;
            pa0No = pa0No+1;
            if pa0_val == pa0_val_max*10 && methodNo == 3
                running = false;
            elseif pa0_val == pa0_val_max*10
                % iterate through all filter types (method)
                methodNo = methodNo+1;
                pa0No = 1; 
                pa0_val = 1.0e-2;
            end     
    
            % Run script
            warning('off', 'all');  % Disable all warnings
            main;                   % main script calls filters
            warning('on', 'all');   % Re-enable warnings
            
            % quality criterion here
            Results(pa0No, methodNo) = 1;    % simulation worked 
            if isnan(stdAvg(1))
                Results(pa0No, methodNo) = 0;
            end
            % saving different quality criteria for each simulation
            quality_criterion.std(:,pa0No, methodNo) = stdAvg;
            quality_criterion.sign(:,pa0No, methodNo) = same_sign;
            quality_criterion.diff(:,pa0No, methodNo) = par_diff;

        catch exception
            % Check for warnings within the catch block
            [~, lastWarning] = lastwarn();
            if ~isempty(lastWarning)
                % Handle warnings here
                disp('Warning occurred!');

                % Clear warning state
                lastwarn('');
            end
    
            % Handle errors
            disp('Error occurred!');
           
        end
    end
end


%% mode 3 -------------------------------------------------------------
if optimization_mode == 3
    global count opt_log cost_log
    pa0_val = 1.0e-2;
    ManeuverNo = 13; 
    methodNo = 4; 
    count = 1;
    Man = '3211';

    % Define the objective function
    cost = @(x) cost_function(x);
    
    % Set up the optimization problem
    load("optimal_x.mat");
    load("R_var.mat");

    % set initial values for Q (qq), alpha and R (rr)
    x0 = x(1:25,1);     % x0(1:10) is qq, x0(11) is alpha, x0(12:25) is rr
%     x0(12:25,1) = rr;  % variance from measured outputs 

    % Lower bounds for the variables
    lb = ones(length(x0), 1)*1.0e-7;  
    lb(11) = 0.1; 
    lb(12:25) = rr*0.1;

    % Upper bounds for the variables
    ub = ones(length(x0), 1)*1;   
    ub(12:25) = rr*10;

    % number of variable to optimize (for particle swarm) 
    nvars = length(x0);

    % Set optimization options, change cost to matrix for lsqnonlin, to
    % scalar for fmincon, particleswarm and patternsearch
%     options = optimoptions('fmincon', 'Display', 'iter','StepTolerance',1.0e-20);  % Optional: Set display options
    options = optimset('Display','iter-detailed','MaxFunEvals',50000,'MaxIter',100,'TolFun',1e-20,'TolX',1e-23);
%     options = optimoptions('particleswarm', 'Display', 'iter', 'PlotFcn', @pswplotbestf);    
%     options = optimoptions('patternsearch', 'Display', 'iter', 'PlotFcn', @psplotbestf);
    tic; % Start the timer

    try
        % Set optimizer, 
        x = lsqnonlin(cost, x0, lb, ub, options);
%         [x, fval] = fmincon(cost, x0, [], [], [], [], lb, ub,[] , options);
%         [x, fval] = patternsearch(cost, x0, [], [], [], [], lb, ub,[] , options);
%         [x, fval] = particleswarm(cost, nvars, lb, ub, options);
        elapsedTime = toc;  % Get the elapsed time
        qq_opt = x(1:10,1);
        alpha_opt = x(11);
        rr_opt = x(12:25,1); 
            
        disp(['Optimization time: ' num2str(elapsedTime) ' seconds']);

        % change file to not overwrite last result
        save('optimal_x.mat','x');
    catch error
        disp('Error occurred during optimization. Optimization terminated prematurely.');
        elapsedTime = toc;  % Get the elapsed time
        disp(['Optimization time: ' num2str(elapsedTime) ' seconds']);
    end
end

% quality criteria 
function cost_total = cost_function(x)
    global count opt_log cost_log
    qq_val(:,1) = x(1:10);
    alpha = x(11);
    rr_val(:,1) = x(12:25);
    opt_log(:,count) = x;
    
    main;

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

    cost(1:Ny,1) = NMSE_ekf;
    cost(1:Ny,2) = NMSE_ukf;
    cost(1:Ny,3) = NMSE_ukfaug;

    % parameter standard deviation over last 100 points
    cost(Ny+1:Ny+NparID,1) = par_std_rel_ekf;
    cost(Ny+1:Ny+NparID,2) = par_std_rel_ukf;
    cost(Ny+1:Ny+NparID,3) = par_std_rel_ukfaug;

    cost_log(:,:,count)= double(cost);
    cost_total = double(cost); 
%     cost_total = double(sum(sum(cost))); 
    count=count+1;
end







