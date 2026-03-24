clc
% --- Data Entry ---
% Replace these with your actual data arrays
% SensorData: Numerical pulling force from your wearable (e.g., in Newtons or Volts)
% SchoolRank: Qualitative ranking mapped to 1-5
sensorData = [2.625, 3.286, 1.551, 0.315, 1.410, 0.687, 2.313, 2.242, 1.155, 0.764, 2.893, 0.715];
schoolRank = [4, 5, 3, 1, 3, 1, 5, 5, 3, 1, 5, 2];

% --- 1. Calculate Spearman Correlation ---
% 'rows','complete' handles any NaN (missing) data points automatically
[rho, pValue] = corr(sensorData', schoolRank', 'type', 'Spearman');

fprintf('Spearman Rho (Correlation): %.4f\n', rho);
fprintf('P-value: %.4f\n', pValue);

% --- 1.B Calculate Confidence Interval ---
data = [schoolRank', sensorData'];
bootstat = bootstrp(1000, @(x) corr(x(:,1), x(:,2), 'type', 'Spearman'), data);
CI = prctile(bootstat, [2.5, 97.5]);

fprintf('95%% Confidence Interval for Rho: [%.4f, %.4f]\n', CI(1), CI(2));

% --- 2. Visualization ---
figure('Color', 'w');

% Subplot 1: Scatter with Rank
subplot(1, 2, 1);
scatter(schoolRank, sensorData, 80, 'filled', 'MarkerFaceColor', [0 .4 .7]);
hold on;
grid on;
title('Scatter Plot (Sensor vs. Rank)');
xlabel('School Rank (1=Light, 5=Firm)');
ylabel('Sensor Pulling Force (Numerical)');
xticks(1:5);
xticklabels({'Light','L/M','Med','M/F','Firm'});

% Subplot 2: Boxplot (The "PhD Standard" for this data)
subplot(1, 2, 2);
boxplot(sensorData, schoolRank);
title('Sensor Data Distribution by Category');
xlabel('School Rank');
ylabel('Sensor Pulling Force');
xticklabels({'Light','L/M','Med','M/F','Firm'});

% Add a professional touch
sgtitle('Guide Dog Sensor Validation Analysis');