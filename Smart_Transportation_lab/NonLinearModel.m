function [y] = NonLinearModel(w,delta,vx,beta,psi_dot,theta,roadCond,drag)
    global m;
    global Iz;
    global lf;
    global lr;
    global R;
    
    % delta = deg2rad(delta);
    theta = deg2rad(theta);

    % Prevent division by zero for vx
    vx_safe = max(vx, 0.1);

    % ---- Longitudinal slip lambda ----
    if R*w >= vx_safe  % ACCELERATION slip
        denom = max(R*w, 0.1);
        lambda = (R*w - vx_safe) / denom;
    else                % BRAKING slip
        denom = vx_safe;
        lambda = (R*w - vx_safe) / denom;
    end

    % ---- Slip angles ----
    alphaf = atan((vx_safe*beta + lf*psi_dot) / vx_safe) - delta;
    alphar = atan((vx_safe*beta - lr*psi_dot) / vx_safe);

    % ---- Tire forces ----
    Fx = computeFx(lambda, roadCond);

    % Drag force
    if drag == 0
        Fd = 0;
    elseif drag == 1
        Fd = computeFd(theta, vx_safe);
    else
        Fd = 0;    % default safe fallback
    end

    % Lateral forces
    Fyf = 2 * computeFy(alphaf, lambda, roadCond);
    Fyr = 2 * computeFy(alphar, 0, roadCond);

    % ---- Dynamics ----
    vx_dot   = (1/m) * (Fx - Fd) + beta * vx_safe * psi_dot;
    beta_dot = (1/(m * vx_safe)) * (Fyf + Fyr) - psi_dot;
    psi_ddot = (1/Iz) * (Fyf * lf - Fyr * lr);

    % Output must ALWAYS be a finite double vector for Simulink
    y = double([vx_dot; beta_dot; psi_ddot; Fx; Fyf; Fyr]);
end

function Fx = computeFx(lambda,roadCond)
    global m;
    global g;

    Fn = m*g/2;
    mu_dry = [1.11,23.99,0.52];
    mu_wet = [0.687,33.822,0.347];
    mu_ice = [0.19,94.13,0.06];

    if(roadCond==0)
        mu = mu_dry;
    elseif(roadCond==1)
        mu = mu_wet;
    elseif(roadCond==2)
        mu = mu_ice;
    end

    mu_lambda = sign(lambda)*(mu(1)*(1-exp(-abs(lambda)*mu(2)))-abs(lambda*mu(3)));

    Fx = mu_lambda*Fn;
end

function Fy = computeFy(alpha,lambda,roadCond)
    v_dry = 1;
    v_wet = 0.5;
    v_ice = 0.1;

    if(roadCond==0)
        v = v_dry;
    elseif(roadCond==1)
        v = v_wet;
    elseif(roadCond==2)
        v = v_ice;
    end

    By = 2*(2-v)*8.3278;
    Cy = (5/4*-v/4)*1.1009;
    Dy = v*2268;
    Ey = -1.1661;
    
    Fy = Dy*sin(Cy*atan(By*(1-Ey)*alpha + Ey*atan(By*alpha)))*exp(-6*abs(lambda)^5);
end

function Fd = computeFd(theta,vx)
    global rho;
    global Cd;
    global Cr;
    global S;
    global m;
    global g;

    Fd = (1/2)*rho*Cd*S*vx^2+Cr*m*g*cos(theta)+m*g*sin(theta);
end