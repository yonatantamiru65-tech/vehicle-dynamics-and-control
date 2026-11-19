function [A, B] = LateralMatrixAB(vx)

global C_af C_ar lf lr m Iz

% Prevent division by zero
vx = max(vx, 0.1);

A = zeros(2,2);
B = zeros(2,1);

A(1,1) = -(C_af + C_ar) / (m * vx);
A(1,2) = -1 + (C_ar*lr - C_af*lf) / (m * vx^2);

A(2,1) = (C_ar*lr - C_af*lf) / Iz;
A(2,2) = -(C_af*lf^2 + C_ar*lr^2) / (Iz * vx);

B(1) = C_af / (m * vx);
B(2) = (C_af * lf) / Iz;

end