% Define s as a transfer function variable
s = tf('s');

% Define K values
K1 = 12;
K2 = 8.129123;

% Open-loop transfer functions for both K values
G1 = K1 / (s * (s^2 + 4*s + 8));
G2 = K2 / (s * (s^2 + 4*s + 8));

% Closed-loop transfer functions
T1 = feedback(G1, 1);
T2 = feedback(G2, 1);

% Time vector for step response (optional, for consistent scaling)
t = 0:0.01:10;

% Plot step response
figure;
step(T1, t);
hold on;
step(T2, t);
title('Step Response of Closed-Loop System for Different K Values');
ylabel('Output');
xlabel('Time (seconds)');
legend('K = 12', 'K = 8.129123');
grid on;
