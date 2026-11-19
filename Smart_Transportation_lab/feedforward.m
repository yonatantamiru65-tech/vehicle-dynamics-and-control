function u_FF = feedforward(t, vx, theta, ff)

    % Define Parameters (Global or local)
    global  m Cd S Cr rho g
   
    % 1. Define the True Slope (10% grade)
    % 10% grade means tan(theta) = 0.1, so theta = atan(0.1) approx 5.71 degrees
    theta_true = deg2rad(theta); 

    % 2. Calculate Estimated Slope with Noise (Equation 28)
    % The problem adds a sinusoidal estimation error
    theta_hat = theta_true + ( (5*theta_true)/100 ) * sin(2*pi*0.15*t);

    % 3. Calculate Feed-Forward Force (Equation 27)
    % u_FF = Aerodynamic Drag + Rolling Resistance + Gravity Slope Component
    
    F_aero = 0.5 * rho * Cd * S * vx^2;
    F_roll = Cr * m * g * cos(theta_hat);
    F_gravity = m * g * sin(theta_hat);
    
    u_FF_temp = F_aero + F_roll + F_gravity;

    if ff == 1
        u_FF = u_FF_temp; 
    else
        u_FF = 0; 
    end
end