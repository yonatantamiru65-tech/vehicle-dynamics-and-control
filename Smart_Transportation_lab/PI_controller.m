% open loop
% 1. Define Vehicle Parameters
global m; % Mass of Renault Megane [kg]

% 2. Define the Plant Transfer Function G(s)
s = tf('s');
G = 1 / (m * s);

% 3. Open the SISO Design Tool
sisotool(G)