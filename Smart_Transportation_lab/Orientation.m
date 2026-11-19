function [y] = Orientation(vx,beta,psi)

    vy = vx*tan(beta);

    x_dot = vx*cos(psi)-vy*sin(psi);
    y_dot = vx*sin(psi)+vy*cos(psi);
    y = [x_dot;y_dot];
end