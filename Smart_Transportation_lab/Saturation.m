function [y] = Saturation(Fx,RoadCond)

if RoadCond == 0
    Fx_new = min(Fx, 6880.65); % Limit Fx for dry conditions
elseif RoadCond == 1
    Fx_new = min(Fx, 4346.55); % Limit Fx for wet conditions
elseif RoadCond == 2
    Fx_new = min(Fx, 1274.11); % Limit Fx for ice conditions
else
    Fx_new = Fx;
end

y = Fx_new;
end