function [y] = LinearModel(w,delta,vx,beta,psi_dot,theta,drag)
    global m Iz lf lr;
    
    % delta = deg2rad(delta);
    theta = deg2rad(theta);

    vx_safe = max(vx,0.1);   % prevent division by zero

    Fx = computeFx(w,vx_safe);

    if drag == 0
        Fd = 0;
    elseif drag == 1
        Fd = computeFd(theta,vx_safe);
    else
        Fd = 0;
    end

    Fyf = computeFyf(delta,vx_safe,beta,psi_dot);
    Fyr = computeFyr(vx_safe,beta,psi_dot);

    vx_dot    = (1/m)*(Fx - Fd) + beta * vx_safe * psi_dot;
    beta_dot  = (1/(m*vx_safe))*(Fyf + Fyr) - psi_dot;
    psi_ddot  = (1/Iz)*(Fyf*lf - Fyr*lr);

    y = double([vx_dot; beta_dot; psi_ddot; Fx; Fyf; Fyr]);  % ensure double
end

function Fx = computeFx(w,vx)
    global C_lambda;
    global R;

    if R*w >= vx         % ACCELERATION slip
        denom = max(R*w, 0.1);        % avoid division by zero
        lambda = (R*w - vx) / denom;
    else                  % BRAKING slip
        denom = max(vx, 0.1);
        lambda = (R*w - vx) / denom;
    end

    Fx = C_lambda*lambda;
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

function Fyf = computeFyf(delta,vx,beta,psi_dot)
    global C_af;
    global lf;

    alphaf = delta - atan((vx*beta+lf*psi_dot)/vx); % Calculate front slip angle
    Fy = C_af * alphaf; % Calculate lateral force at the front

    Fyf = 2*Fy;
end

function Fyr = computeFyr(vx,beta,psi_dot)
    global C_ar;
    global lr;

    alphar = -atan((vx*beta-lr*psi_dot)/vx); % Calculate front slip angle
    Fy = C_ar * alphar; % Calculate lateral force at the front

    Fyr = 2*Fy;
end