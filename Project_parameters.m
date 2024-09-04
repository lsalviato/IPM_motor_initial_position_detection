%{
SALVIATO LUCA
INDUSTRIAL ELECTRIC DRIVES PROJECT:
Implementation of a system for recognizing the initial position of the
rotor of an IPM, through the application of voltage pulses.

To perform a complete simulation:

1. Set burst = 0 and theta0 (initial position)
   Press RUN on this script
2. Run Simulink
3. Run the script Project_fitting without changing anything; an initial estimate of the position will be provided
4. Set burst = 1
5. Run Simulink
6. Run the script Project_fitting without changing anything; an improved estimate of the position with the burst will be provided
%}

%% PARAMETERS TO SET BEFORE THE SIMULATION
theta0 = 28 * pi/180; % [mechanical radians] with respect to an alpha phase (INITIAL POSITION)
burst = 0;  % boolean variable to select the analysis mode:
            % 0 = pulses over 360 electrical degrees
            % 1 = pulses over the range limited to the burst
            
%% motor parameters
In = 3.78; %[A]
Wm_n = 3000; %[RPM]
p = 2; %number of pole pairs
Wme_n = 628.31; %[rad.el/s]
Lambda_mg = 0.252; %[Vs]
Tn = 4.5; %[Nm]
Ld = 0.021; %[H]
Lq = 0.128; %[H]
R = 2.73; %[R]

%% friction
J = 1e-4*1000000; %[Kg*m^2]
Jload = 4*J; %[Kg*m^2] % load inertia
B = 0.05*Tn/Wm_n; %[N*s] 
maxTau_sf = Tn/100; %[Nm] max static friction (not connected)

%% simulation parameters
q = 4*In/2^10; %current sensor noise amplitude

if burst
    n_pulse = 30; % number of burst pulses 
    range_rad = 5*pi/180; % half-width of the angular interval for the burst [electrical radians]
    Ts = 1; % sampling period time [s]
    range = 2*range_rad; % angular segment of analysis [electrical radians]
    ramp = range/n_pulse/Ts; % ramp slope [electrical radians/s]
    T_pulse = 1e-3; %  pulse duration over the period [s]
    duty = T_pulse/Ts*100; % duty cycle of the pulse train [percentage of Ts]
    U_pulse = 10;
    phase0 = theta_stimato*pi/180 - range_rad; % [electrical radians]
else
    n_pulse = 40;
    range = 2*pi;  % angular segment of analysis  [electrical radians]
    Ts = 1;
    ramp = range/n_pulse/Ts;% ramp slope [electrical radians/s] 
    %IMPORTANT: if testing with the method to prevent rotor drift, replace the previous line with:
    %ramp = range/n_pulse/Ts + pi;
    T_pulse = 1e-3;
    duty = T_pulse/Ts*100; % [percentage of Ts]
    U_pulse = 10; 
    phase0 = 0; % starting angle for the burst estimation
end

Tsimulation = (n_pulse+1)*Ts;
