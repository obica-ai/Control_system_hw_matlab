% Placeholder initial values for compensator parameters
k_c = 0.4; % This will need adjustment
tau_z = 1/2.3; % Adjust this based on desired PM and omega_cp
tau_p = 1/92; % Adjust this based on desired PM and omega_cp

% Transfer function for G(s)
G_s = tf([3069.16], [1 57.27 0]);

% Initial lead compensator G_c(s)
G_c = tf(k_c * [tau_z 1], [tau_p 1]);

% Open-loop transfer function G_c(s)G(s)
G_ol = series(G_c, G_s);

% Plot the Bode plot and obtain the margin
[GM, PM, Wcg, Wcp] = margin(G_ol);
fprintf('Original Crossover Frequency: %f rad/s\n', Wcp);
fprintf('Original Phase Margin: %f degrees\n', PM);

% Use this to iteratively adjust k_c, tau_z, and tau_p
G_cl = feedback(G_ol, 1);

% Plot the step response
figure;
step(G_cl);
title('Closed-Loop Step Response');
grid on;

% Check time-domain specifications and adjust design if necessary
% Document choices made for each iteration

% Root Locus Plot
figure;
rlocus(G_ol);
title('Root Locus with Varying K_c');
grid on;

% Mark the closed-loop pole locations for the optimized design
hold on;
[p] = pole(G_cl); % Extract closed-loop poles
plot(real(p), imag(p), 'rx', 'MarkerSize', 12); % Mark poles on the root locus
hold off;