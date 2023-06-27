---------------------------------------------------------------------------------
STRUCTURE OF FOLDERS AND FILES 
---------------------------------------------------------------------------------


simulink_model 
	- testEnvironment.slx 
		* Test environment including model of the Vitesse and added sensors 
		(Meyer-Brügel, Modifications by me)
	- init_testEnvironment.m
		* initializes and opens test environment
	- Init 
		* contains scripts and data for initialization 
		(Meyer-Brügel)


kalman_filter
	- main.m		
		* runs filters 
		!!! Set desired config first -> Specify what and how to filter
		(basic structure by Jategaonkar, Modifications by me)
	- xdot.m
		* Equations of motion of the Vitesse
	- obs.m
		* Output Equation 
	- ruku4.m
 		* numerical integration method, Runge-Kutta 4
	- ekf.m
		* algorithm of the EKF
		(Jategaonkar)
	- ukf.m
		* algorithm of the UKF with noise estimation
		(Jategaonkar)
	- ukf_mod.m
		* algorithm of the UKF with additive zero-mean noise
		(Jategaonkar)	
	- sysmatA.m
		* linearizes state matrix (for EKF)
		(Jategaonkar)
	- sysmatC.m
		* linearizes output matrix (for EKF)
		(Jategaonkar)
	- print_par_std.m
		* prints average estimated parameter, standard deviation and
		relative standard deviation 
		(Jategaonkar, Modifications by me)
	- plot_params.m
		* plot results of parameter estimation
	- plot_states_outputs.m
		* plot results of state estimation\ output prediction
		together with measurements
	- mDef_check.m
		* checks if dimensions are set correctly
		(Jategaonkar)
	- mDef.m
		* Definition of model, flight data, initial values etc. 
		(Jategaonkar, Modifications by me)


flight_test_eval
	- read_logs.m
		* saves maneuver data for selected flight
    	- plot_maneuvers.m
    		* plots all maneuver data
    	- find_std_dev_log.m
    		* computes standard deviations and variances of measured output
    	  	to use as inital value for optimization of rr 
    	  	and for sensor models in simulink 
    	- optimize_filters.m
     		* inlcudes optimization modes to find suitable maneuvers, 
    	 	system noise covariance Q,
    	  	scaling parameter alpha and 
    	  	measurement noise cov. R
    	- logs 
    		* contains log files 
    	- testflight_maneuver_log_data 
    		* contains generated maneuver data from read_logs.m




