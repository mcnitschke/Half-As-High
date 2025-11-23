% Load fertility data
load('Fertility.mat');

% ------------------ Prepare Hadza Fertility ------------------
female_raw = Fertility.Hadza_Women_ASF(:,6);
male_raw   = Fertility.Hadza_Men_ASF(:,6);

age_female = (1:length(female_raw))';
age_male   = (1:length(male_raw))';

% Smooth with moving average
windowSize = 3;
female_smooth = movmean(female_raw, windowSize);
male_smooth   = movmean(male_raw, windowSize);

% Female fertility ends at age 45
female_smooth(age_female > 45) = 0;

% Scale male fertility so that peak = 0.5 * female peak
target_peak = max(female_smooth) / 2;
male_scaled = male_smooth * (target_peak / max(male_smooth));

% ------------------ Set Up Figure ------------------
figure;

hf = gcf
set(hf, 'Units', 'inches');
set(hf, 'Position', [0 0 12 3.7]);
set(groot, 'defaulttextInterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesFontSize',12)
% ------------------ Subplot 1: Survival ------------------
subplot(1,2,1);

ages = 0:90;
female_survival = exp(-0.03 * ages);
male_survival   = exp(-0.045 * ages);

plot(ages, female_survival, 'r-', 'LineWidth', 2); hold on;
plot(ages, male_survival, 'b-', 'LineWidth', 2);

xlabel('Age (years)');
ylabel('Survival Probability');
title('Sex-Specific Survival (Synthetic)');
legend('Females', 'Males', 'Location', 'northeast');
grid on;
ylim([0 1.05]);

% ------------------ Subplot 2: Fertility ------------------
subplot(1,2,2);

plot(age_female, female_smooth, 'r-', 'LineWidth', 2); hold on;
plot(age_male, male_scaled, 'b-', 'LineWidth', 2);

xlabel('Age (years)');
ylabel('Smoothed Fertility');
title('Adjusted Hadza Fertility');
legend('Females', 'Males', 'Location', 'northeast');
xlim([10 75]);
ylim([0 0.35]);
grid on;

% set(gcf, 'Units', 'inches', 'Position', [0 0 12 5]);
% exportgraphics(gcf, 'Figure_Survival_Fertility.pdf', 'ContentType', 'vector');
% export_fig('Figure_1_HalfasHigh.pdf','-painters','-m3','-q101','-transparent');
