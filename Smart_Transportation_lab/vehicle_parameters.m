%% Vehicle Parameters (Renault Mégane)
% Define all parameters as global for access across multiple functions

clear all;
global m Iz lf lr Cd S Cr rho R C_lambda C_af C_ar g

% Vehicle parameters
m       = 1400;          % Mass (kg)
Iz      = 1960;          % Yaw moment of inertia (kg·m²)
lf      = 1.177;         % Distance from CG to front axle (m)
lr      = 1.358;         % Distance from CG to rear axle (m)
Cd      = 0.35;          % Aerodynamic drag coefficient
S       = 2.14;          % Frontal area (m²)
Cr      = 0.015;         % Rolling resistance coefficient
rho     = 1.225;         % Air density (kg/m³)
R       = 0.3;           % Wheel radius (m)
C_lambda = 66100;        % Longitudinal stiffness (N)
C_af     = 84085;        % Front cornering stiffness (N/rad)
C_ar     = 87342;        % Rear cornering stiffness (N/rad)

g        = 9.8; % Gravity (m/s)

% initial conditions
vx0 = 0.1;
beta0 = 0;
psi_dot0 = 0;
psi0 = 0;
x0 = 0;
y0 = 0;

disp('Global vehicle parameters have been initialized.');

% model run parameters
% w = 50; % w=50 when vx=15m/s; w=66.667 when vx=20m/s
% theta = 5.7; % 3.43
% RoadCond = 0; % RoadCond: 0 - dry; 1 - wet; 2 - ice
% drag = 1;
% ff = 1;

% % Road condition values
% roadList = [0 1 2];      % 0 = dry, 1 = wet, 2 = ice
% 
% results = struct();
% 
% for i = 1:length(roadList)
% 
%     % ---- Set parameters for this run ----
%     RoadCond = roadList(i); 
%     w = 50;       % or 50 depending on vx
%     theta = 0;        % degrees
%     drag = 1;
% 
%     % ---- Run the Simulink model ----
%     simOut = sim("VehicleDynamics.slx");
% 
%     % ---- Extract trajectory from To Workspace outputs ----
%     % These variables now exist in simOut
%     results(i).RoadCond = RoadCond;
%     results(i).x = simOut.x_nonLin;   % direct variable access
%     results(i).y = simOut.y_nonLin;
% end
% 
% disp('Sim done.');

% Road condition values
% roadList = [0 1 2];      % 0 = dry, 1 = wet, 2 = ice
% 
% results = struct();
% 
% for i = 1:length(roadList)
% 
%     % ---- Set parameters for this run ----
%     RoadCond = roadList(i); 
%     w = 50;          % or 50 depending on vx
%     theta = 0;       % degrees
%     drag = 1;
% 
%     % ---- Run the Simulink model ----
%     simOut = sim("VehicleDynamics.slx");
% 
%     % ---- Extract outputs ----
%     results(i).RoadCond = RoadCond;
% 
%     % trajectory (unchanged)
%     results(i).x = simOut.x_nonLin;
%     results(i).y = simOut.y_nonLin;
% 
%     % ---- Extract vx_nonLin time + data ----
%     results(i).vx_time = simOut.vx_out_nonLin.time;
%     results(i).vx = simOut.vx_out_nonLin.data;
% 
% end
% 
% disp('Sim done.');

% feed forward enable/disable values
% ff_list = [0 1];      % 0 = off, 1 = on
% results = struct();
% 
% for i = 1:length(ff_list)
% 
%     % ---- Set parameters for this run ----
%     ff = ff_list(i); 
%     theta = 5.7;       % degrees
%     drag = 1;
%     Fmax = 6880.65;
% 
%     % ---- Run the Simulink model ----
%     simOut = sim("VehicleDynamics.slx");
% 
%     % ---- Extract vx_nonLin time + data ----
%     results(i).vx_time = simOut.vx_out_nonLin.time;
%     results(i).vx = simOut.vx_out_nonLin.data;
% 
% end
% 
% disp('Sim done.');



% Steering Control
% Q_weight = diag([10, 10]);   % penalize beta more than yaw rate
% R_weight = 1;             % small but not tiny penalty on steering
vx_constant = 10;
% [A,B,C] = LateralModel(vx_constant);
% K = lqr(A,B,Q_weight,R_weight);
% N = -inv(C*inv(A-B*K)*B);

RoadCond = 0;
theta = 0;
drag = 0;
ff = 0;
if RoadCond == 0
    Fmax = 6880.65; % Limit Fx for dry conditions
elseif RoadCond == 1
    Fmax = 4346.55; % Limit Fx for wet conditions
elseif RoadCond == 2
    Fmax = 1274.11; % Limit Fx for ice conditions
end