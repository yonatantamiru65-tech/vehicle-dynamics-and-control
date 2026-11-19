function w = Fx_w_map(Fx_cmd, vx)
    % Define Parameters
    global R;          % Wheel radius [m]
    global C_lambda;   % Longitudinal stiffness [N]

    % Safety to avoid division by zero if car is stopped
    v_safe = max(abs(vx), 0.01);

    % LINEAR MAPPING LOGIC
    % Fx = C_lambda * lambda

    if Fx_cmd >= 0
        % ACCELERATION:
        % lambda = (R*w - v) / (R*w)
        % w = v / (R * (1 - Fx/C))

        Fx_lin = min(Fx_cmd, 0.99 * C_lambda);        
        omega_ref = v_safe / (R * (1 - Fx_lin / C_lambda));

    else
        % BRAKING:
        % lambda = (R*w - v) / v
        % w = (v/R) * (1 + Fx/C)

        Fx_lin = max(Fx_cmd, -0.99 * C_lambda);
        omega_ref = (v_safe / R) * (1 + Fx_lin / C_lambda);
    end

    w = omega_ref;
end