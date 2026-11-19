yalmip('clear');

global controller

%% Dimensions
nx = 2;     % [psi_dot; beta]
nu = 1;     % steering
ny = 1;     % yaw rate

C = [0 1];  % select psi_dot

%% MPC parameters
N = 15;     % prediction horizon
Q = 100;     % yaw-rate tracking weight
R = 1;      % steering effort weight

u_min = deg2rad(-25);
u_max = deg2rad(25);

%% YALMIP variables
x = sdpvar(repmat(nx,1,N+1), repmat(1,1,N+1));
u = sdpvar(repmat(nu,1,N),   repmat(1,1,N));

x0_mpc    = sdpvar(nx,1);   % x(1)
psi_r = sdpvar(1,1);    % ψ̇_ref

Ad = sdpvar(nx,nx,'full');
Bd = sdpvar(nx,nu,'full');

%% Build MPC problem
constraints = [x{1} == x0_mpc];
objective = 0;

for k = 1:N
    objective = objective ...
        + (C*x{k} - psi_r)'*Q*(C*x{k} - psi_r) ...
        + u{k}'*R*u{k};

    constraints = [constraints, ...
        x{k+1} == Ad*x{k} + Bd*u{k}, ...
        u_min <= u{k} <= u_max];
end

%% Create optimizer
controller = optimizer( ...
    constraints, objective, ...
    sdpsettings('solver','quadprog','verbose',0), ...
    {x0_mpc, psi_r, Ad, Bd}, ...
    u{1});

disp('✓ MPC created');