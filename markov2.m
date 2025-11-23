clear; clc;

% --------------------------------------------
% Initial state: all ancestry in females
% --------------------------------------------
x0 = [1; 0; 0]; % 100% of paths start as females

% --------------------------------------------
% Simulation parameters
% --------------------------------------------
n_steps = 10;
w1_values = [0.1, 0.25, 0.45]; % w1 < 0.25, w1 = 0.25, w1 > 0.25

% --------------------------------------------
% Create a figure with custom manual positions
% --------------------------------------------
figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);

positions = [
    0.1 0.55 0.35 0.4;  % Top-left
    0.55 0.55 0.35 0.4; % Top-right
    0.325 0.05 0.35 0.4 % Bottom-center
];

for idx = 1:3
    w1 = w1_values(idx);

    % Corrected transition matrix in terms of w1
    P = [
        0.5          , 0.5         , 0;
        w1           , 0.5 - w1    , 1;
        0.5 - w1     , w1          , 0
    ];

    % Simulate evolution over generations
    x_history = zeros(3, n_steps+1);
    x_history(:,1) = x0;

    for k = 1:n_steps
        x_history(:,k+1) = P * x_history(:,k);
    end

    % Create axes manually
    axes('Position', positions(idx,:));
    hold on;
    plot(0:n_steps, x_history(1,:), 'r-', 'LineWidth', 2);
    plot(0:n_steps, x_history(2,:), 'g--', 'LineWidth', 2);
    plot(0:n_steps, x_history(3,:), 'b:', 'LineWidth', 2);
    hold off;

    xlabel('Generation (k)', 'FontSize', 10);
    ylabel('Proportion', 'FontSize', 10);
    title(sprintf('w_1 = %.2f', w1), 'FontSize', 12);
    legend('Female age-1 (f)', 'Male age-1 (m_1)', 'Male age-2 (m_2)', 'Location', 'southoutside');
    grid on;
    ylim([0 1]);
end

