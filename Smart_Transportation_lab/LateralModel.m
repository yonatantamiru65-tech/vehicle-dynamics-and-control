function [A, B, C] = LateralModel(vx)
    global C_af C_ar lf lr m Iz

    % Predeclare sizes for Simulink
    A = zeros(2,2);
    B = zeros(2,1);
    C = zeros(1,2);

    % A matrix terms
    A11 = -(C_af + C_ar) / (m * vx);
    A12 = -1 + (C_ar * lr - C_af * lf) / (m * vx^2);
    
    A21 = (C_ar * lr - C_af * lf) / Iz;
    A22 = -(C_af * lf^2 + C_ar * lr^2) / (Iz * vx);

    A = [A11  A12;
         A21  A22];

    % B matrix terms
    B1 = C_af / (m * vx);
    B2 = (C_af * lf) / Iz;

    B = [B1;
         B2];

    % Output matrix
    C = [0 1];

end