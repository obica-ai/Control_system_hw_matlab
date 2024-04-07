function K = findKForPM(targetPM)
    % Initial guess for K
    K_initial = 1;
    
    % Optimization routine to find K
    options = optimset('TolX',1e-6,'Display','iter');
    K = fminsearch(@(K) objectiveFunction(K, targetPM), K_initial, options);
end

function error = objectiveFunction(K, targetPM)
    s = tf('s');
    G = K / (s * (s^2 + 4*s + 8));
    
    [~, phaseMargin] = margin(G);
    
    % Calculate the error between current and target PM
    error = abs(phaseMargin - targetPM);
end

% Gvien Phase Margin
givenPM = 60;

% Find K
K_optimal = findKForPM(givenPM);
fprintf('Optimal K for PM = 60 degrees: %f\n', K_optimal);