close all;

% %x over time
% plot(out.x.time,out.x.data(:,:))
% 
% %trajectory
% plot(out.x.data(:,:),out.y.data(:,:))

% % 3. vx for linear and non-linear
% figure(Name="Q3: vx, Fx for linear and non-linear");
% subplot(2,1,1);
% plot(out.vx_out.time,out.vx_out.data(:,:));
% hold on;
% plot(out.vx_out_nonLin.time,out.vx_out_nonLin.data(:,:));
% xlabel("time (s)");
% ylabel("longitudinal velocity (m/s)");
% legend('linear','non-linear');
% title("vx over time");
% 
% % Fx for linear and non-linear
% subplot(2,1,2);
% plot(out.Fx.time,out.Fx.data(:,:));
% hold on;
% plot(out.Fx_nonLin.time,out.Fx_nonLin.data(:,:));
% ylabel("traction force (N)");
% xlabel("time (s)");
% legend('linear','non-linear');
% title("Fx over time");
% 
% % Q4 vehicle trajectories
% figure(Name="Q4: vehicle trajectories");
% subplot(2,1,1);
% plot(out.x.data(:,:),out.y.data(:,:));
% ylabel("y (m)");
% xlabel("x (m)");
% title("vehicle trajectory linear");
% subplot(2,1,2);
% plot(out.x_nonLin.data(:,:),out.y_nonLin.data(:,:));
% ylabel("y (m)");
% xlabel("x (m)");
% title("vehicle trajectory non-linear");
% 
% % Q4 yaw, side-slip, lateral force
% figure(Name="Q4: yaw, side-slip, lateral force");
% % psi_dot
% subplot(4,1,1);
% plot(out.psi_dot.time,out.psi_dot.data(:,:));
% hold on;
% plot(out.psi_dot_nonLin.time,out.psi_dot_nonLin.data(:,:));
% xlabel("time (s)");
% ylabel("yaw rate (rad/s)");
% legend('linear','non-linear');
% title("yaw rate over time");
% % beta
% subplot(4,1,2);
% plot(out.beta.time,out.beta.data(:,:));
% hold on;
% plot(out.beta_nonLin.time,out.beta_nonLin.data(:,:));
% xlabel("time (s)");
% ylabel("side-slip angle (rad)");
% legend('linear','non-linear');
% title("side-slip angle over time");
% % Fyf
% subplot(4,1,3);
% plot(out.Fyf.time,out.Fyf.data(:,:));
% hold on;
% plot(out.Fyf_nonLin.time,out.Fyf_nonLin.data(:,:));
% xlabel("time (s)");
% ylabel("lateral force (N)");
% legend('linear','non-linear');
% title("lateral force of front wheels over time");
% % Fyr
% subplot(4,1,4);
% plot(out.Fyr.time,out.Fyr.data(:,:));
% hold on;
% plot(out.Fyr_nonLin.time,out.Fyr_nonLin.data(:,:));
% xlabel("time (s)");
% ylabel("lateral force (N)");
% legend('linear','non-linear');
% title("lateral force of rear wheels over time");

% % Q5
% figure(Name="Q5: non-linear vehicle trajectory for different road conditions");
% hold on;
% labels = ["Dry", "Wet", "Ice"];
% for i = 1:length(results)
% 
%     x = squeeze(results(i).x.Data);
%     y = squeeze(results(i).y.Data);
% 
%     plot(x, y, 'LineWidth', 1.5, 'DisplayName', labels(i));
% 
% end
% xlabel("x (m)");
% ylabel("y (m)");
% title(sprintf("Vehicle Trajectory for Different Road Conditions, θ = %d°", theta));
% legend;
% grid on;
% lgd = legend;
% lgd.ItemHitFcn = @(src,event) toggleVisibility(event);
% function toggleVisibility(event)
%     % Toggle line visibility when clicking legend
%     if strcmp(event.Peer.Visible,'on')
%         event.Peer.Visible = 'off';
%     else
%         event.Peer.Visible = 'on';
%     end
% end


% % Vehicle controller
% figure(Name="Q1: vx, Fx for linear and non-linear");
% % subplot(2,1,1);
% plot(out.vref.time,out.vref.data(:,:));
% hold on;
% plot(out.vx_out.time,out.vx_out.data(:,:));
% hold on;
% plot(out.vx_out_nonLin.time,out.vx_out_nonLin.data(:,:));
% xlabel("time (s)");
% ylabel("longitudinal velocity (m/s)");
% legend('vref','linear','non-linear');
% title("vx over time");

% % Non linear only
% labels = {'dry', 'wet', 'ice'};
% 
% figure(Name="Q4: add saturation block");
% hold on;
% 
% for i = 1:length(results)
%     x = squeeze(results(i).vx_time);
%     y = squeeze(results(i).vx);
% 
%     plot(x, y, 'LineWidth', 1.5, 'DisplayName', labels{i});
% end
% 
% xlabel("time (s)");
% ylabel("longitudinal velocity (m/s)");
% title("vx, non-linear model, for different road conditions");
% legend show;


% labels = {'without ff', 'with ff'};
% 
% figure(Name="Q5: Feed forward");
% hold on;
% 
% for i = 1:length(results)
%     x = squeeze(results(i).vx_time);
%     y = squeeze(results(i).vx);
% 
%     plot(x, y, 'LineWidth', 1.5, 'DisplayName', labels{i});
% end
% 
% xlabel("time (s)");
% ylabel("longitudinal velocity (m/s)");
% title("vx, non-linear model, with and without feed forward");
% legend;
% grid on;
% lgd = legend;
% lgd.ItemHitFcn = @(src,event) toggleVisibility(event);
% function toggleVisibility(event)
%     % Toggle line visibility when clicking legend
%     if strcmp(event.Peer.Visible,'on')
%         event.Peer.Visible = 'off';
%     else
%         event.Peer.Visible = 'on';
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Steering control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(Name="Vehicle trajectories");
plot(out.x_nonLin.data(:,:),out.y_nonLin.data(:,:));
ylabel("y (m)");
xlabel("x (m)");
title("vehicle trajectory");

figure(Name="yaw rate error and steering angle");
subplot(2,1,1);
plot(out.psi_dot_nonLin.time,out.psi_dot_nonLin.data(:,:));
hold on;
plot(out.psi_dot_ref.time,out.psi_dot_ref.data(:,:));
ylabel("yaw rate (rad/s)");
xlabel("time (s)");
title("steering angle over time");
legend('psi dot', 'psi dot ref');

subplot(2,1,2);
plot(out.yaw_error.time,out.yaw_error.data(:,:));
ylabel("yaw rate error (rad)");
xlabel("time (s)");
title("yaw rate error");

% figure(Name="Track");
% plot(Track.X, Track.Y, '--');
% hold on;
% plot(Xgl, Ygl);
% axis equal;
% legend('Reference path','Vehicle trajectory');