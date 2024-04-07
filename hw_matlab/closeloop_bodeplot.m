% Define the plant G(s) and controller KD(s)
s = tf('s');
G = 10 / ((s/0.2 + 1) * (s/0.5 + 1));
KD = 3.6 * ((s/0.8 + 1)/(s/5 + 1)) * ((s + 0.07)/(s + 0.02));

% Combined system
Gc = G * KD;

% Calculate phase margin, bandwidth, and gain crossover frequency
[GM, PM, wcg, wcp] = margin(Gc);
BW = bandwidth(Gc);

% Steady-state tracking error for constant references
Kp = dcgain(Gc);
ess = 1 / (1 + Kp);
bode(Gc)
grid on % Enhances visibility of the plot
% Display the results
fprintf('(PM): %f degrees\n', PM);
fprintf('(BW): %f rad/s\n', BW);
fprintf('Steady-State Tracking Error : %f\n', ess);
% Closed-loop transfer function T(s)
T = feedback(G * KD, 1);

% Plot the Bode plot
figure;
bode(T);
grid on;
title('Closed-Loop Bode Plot');

% Calculate the bandwidth
BW = bandwidth(T);

% Display the bandwidth
fprintf('Closed-Loop Bandwidth (BW): %f rad/s\n', BW);