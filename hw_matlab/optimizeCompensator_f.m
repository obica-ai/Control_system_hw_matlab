function [K_c_opt, tau_z_opt, tau_p_opt] = optimizeCompensator(initialGuess, PM_target, omega_cp_target, num, den)
    % Objective function to minimize
    objectiveFunction = @(x) compensatorObjective(x, PM_target, omega_cp_target, num, den);
    
    % Bounds for K_c, tau_z, and tau_p
    % Assuming no explicit bounds for tau_z and tau_p, you might choose reasonable values based on your system
    lb = [2, 0, 0]; % Lower bounds, K_c >= 2, tau_z and tau_p > 0
    ub = [4, Inf, Inf]; % Upper bounds, K_c <= 4
    
    % Options for fmincon
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    
    % Optimize compensator parameters using fmincon
    optimizedParams = fmincon(objectiveFunction, initialGuess, [], [], [], [], lb, ub, [], options);
    
    % Extract optimized parameters
    K_c_opt = optimizedParams(1);
    tau_z_opt = optimizedParams(2);
    tau_p_opt = optimizedParams(3);
end

function error = compensatorObjective(x, PM_target, omega_cp_target, num, den)
    % Extract parameters from x
    K_c = x(1);
    tau_z = x(2);
    tau_p = x(3);
    
    % Motor transfer function (G(s))
    G_s = tf(num, den); % num is already defined as 3069.16, den should contain [s^2, s] coefficients
    
    % Lead compensator transfer function (G_c(s))
    G_c = tf([K_c*tau_z K_c], [tau_p 1]);
    
    % Combined open-loop transfer function (G_c(s)G(s))
    G_ol = series(G_c, G_s);
    
    % Get the phase margin (PM) and crossover frequency (omega_cp) of the open-loop transfer function
    [~, PM_actual, ~, omega_cp_actual] = margin(G_ol);
    
    % Calculate the deviations from target PM and omega_cp
    PM_error = abs(PM_actual - PM_target);
    omega_cp_error = abs(omega_cp_actual - omega_cp_target);
    
    % Combine the errors. You could also weigh these errors differently if desired.
    error = PM_error + omega_cp_error;
end


% Example usage
num = 3069.16;
den = [1 57.27 0];
PM_target = 53.16;
omega_cp_target = 42.89;
initialGuess = [3, 0.01, 0.1]; % Initial guess for [K_c, tau_z, tau_p]

[K_c_opt, tau_z_opt, tau_p_opt] = optimizeCompensator(initialGuess, PM_target, omega_cp_target, num, den);

fprintf('Optimized K_c: %f, tau_z: %f, tau_p: %f\n', K_c_opt, tau_z_opt, tau_p_opt);

