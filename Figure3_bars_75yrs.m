% Updated two-sex Leslie model: realistic age structure to 75

hf = gcf;
set(hf, 'Units', 'inches');
set(hf, 'Position', [0 0 16 5]);

set(groot, 'defaulttextInterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesFontSize',12)

% Parameters
omega = 76; % Age 0 to 75
t_final = 2000;

% Fertility schedules
f = zeros(1, omega);
f(16:46) = 0.2;  % Female fertility: age 15–45

f_m_vec = linspace(0.15, 0.01, 61); % Declining male fertility from 15–75
f_m = zeros(1, omega);
f_m(16:76) = .1;

% Survival schedules
sf = 0.98* ones(1, omega-1);         % Female survival
sf(51:end) = 0.98;%0.99;                    % Female survival drops after 50

sm = 0.98* ones(1, omega-1);         % Male survival
sm(51:end) = 0.98;%0.99;                    % Male survival drops more after 50

% Male survivorship vector (for f_m normalization)
lm = ones(1, omega);
for i = 2:omega
    lm(i) = lm(i-1) * sm(i-1);
end
rho = sum(lm);
f_m = f_m / rho;  % Normalize male fertility to total = 1

% Build Leslie matrix
L = zeros(2*omega);
L(1, 1:omega) = 0.5 * f;
L(1, omega+1:end) = 0.5 * f_m;
L(omega+1, 1:omega) = 0.5 * f;
L(omega+1, omega+1:end) = 0.5 * f_m;

for i = 2:omega
    L(i, i-1) = sf(i-1);
end
for i = omega+2:2*omega
    L(i, i-1) = sm(i - omega - 1);
end

% Initial populations
Pf = zeros(2*omega,1); Pf(1) = 1;
Pm = zeros(2*omega,1); Pm(omega+1) = 1;

% Evolve
for t = 1:t_final
    Pf = L * Pf;
    Pm = L * Pm;
end

% Normalize
Pf = Pf / sum(Pf);
Pm = Pm / sum(Pm);

% Extract
female_from_female = Pf(1:omega);
male_from_female   = Pf(omega+1:end);
female_from_male   = Pm(1:omega);
male_from_male     = Pm(omega+1:end);

% Age axis
X = 0:omega-1;
Y_femaleFounder = [female_from_female'; male_from_female'];
Y_maleFounder   = [female_from_male';   male_from_male'];

% Plot
subplot(1,2,1);
bar(X, Y_femaleFounder', 'stacked');
xlabel('Age Class'); ylabel('Proportion');
title('Founder: Female');
ylim([0, max(sum(Y_femaleFounder,1)) * 1.1]);
grid on;

subplot(1,2,2);
bar(X, Y_maleFounder', 'stacked');
xlabel('Age Class');
title('Founder: Male');
legend({'Female', 'Male'}, 'Location', 'northeast');
ylim([0, max(sum(Y_maleFounder,1)) * 1.1]);
grid on;

% Export
% export_fig('Figure_3.pdf','-painters','-m3','-q101','-transparent');
