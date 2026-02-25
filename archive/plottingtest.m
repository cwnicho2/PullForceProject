% Load data (manually or from file)
file = {
    '2025_01_14_1', '2025_01_14_7', '2025_01_14_8', '2025_01_15', '2025_01_15_1', ...
    '2025_01_15_2', '2025_01_27', '2025_02_03_2', '2025_02_03_4', '2025_02_05', ...
    '2025_02_05_1', '2025_02_06', '2025_02_28_2', '2025_02_28_3', '2025_03_04', ...
    '2025_03_10', '2025_03_19', '2025_03_28_1', '2025_03_28_2', '2025_03_31', ...
    '2025_04_01', '2025_04_02', '2025_04_03', '2025_04_10_Anhedonia'
};

% Example data arrays: replace these with data loading code if reading from CSV
fLavg = [0.064248, 0.068059, 0.74336, -2.8449, -1.0642, -3.2887, 0.46271, -0.00034447, ...
         0.42593, 0.315, 0.10356, 0.27407, 0.21393, 0.49185, 0.37368, 2.3685, 0.34526, ...
         1.3912, 0.27366, 0.66986, 0.9267, 0.98972, 1.0838, 0.91537];

fRavg = [-6.04E-16, 0.09702, 0.79504, 0.22761, -0.37301, 0.57412, 0.50337, -0.0045751, ...
         0.26297, 0.28021, 0.21388, 0.37589, 6.4459e-15, 6.4459e-15, 0.31948, 1.457, ...
         0.4439, 1.2557, 0.32571, 0.76534, 0.793, 0.96904, 0.74764, 0.903];

favg = [0.064248, 0.16508, 1.5384, -2.6173, -1.4372, -2.7146, 0.96608, -0.0049195, ...
        0.6889, 0.59521, 0.31744, 0.64996, 0.21393, 0.49185, 0.69316, 3.8255, ...
        0.78916, 2.6468, 0.59937, 1.4352, 1.7197, 1.9588, 1.8314, 1.8184];

% Dates and favg values from your earlier dataset

% New data: measurement date, weight (kg), age (years)
datesBW = {
    'February 5, 2025',   5.5, 12;
    'February 5, 2025',   9.9, 16;
    'February 6, 2025',   18.9, 14;
    'February 12, 2025',  22.4, 11;
    'February 12, 2025',  24.9, 14;
    'February 13, 2025',  33.4, 12;
    'February 14, 2025',  10.4, 14;
    'February 17, 2025',  25.9, 12;
    'February 27, 2025',  21.6, 14;
    'February 28, 2025',  27.7, 1;
    'February 28, 2025',  40,   6;
    'February 28, 2025',  5.7,  13;
    'March 10, 2025',     40.3, 13;
    'March 19, 2025',     13.6, 13;
    'March 19, 2025',     20.1, 15;
    'March 31, 2025',     20.4, 15;
    'April 1, 2025',      26.7, 11;
    'April 2, 2025',      17.2, 13;
    'April 3, 2025',      18.4, 11;
    'April 22, 2025',     31.4, 12.1;
    'April 24, 2025',     22.8, 14;
    'May 1, 2025',        17.8, 15;
    'May 1, 2025',        24.4, 11
};

% Convert date strings to datetime
dateBW_dt = datetime(datesBW(:,1), 'InputFormat', 'MMMM d, yyyy');
weights = cell2mat(datesBW(:,2));
ages = cell2mat(datesBW(:,3));

% Extract dates from session names
sessionDates = cellfun(@(s) datetime(extractBefore(s, 11), 'InputFormat', 'yyyy_MM_dd'), file);

% Initialize output arrays
normForces = [];
agesUsed = [];

for i = 1:length(file)
    % Find all matching weight/age records for this session date
    matches = find(sessionDates(i) == dateBW_dt);
    
    if isempty(matches)
        continue;  % skip if no weight/age for that session
    end

    % If multiple matches, use the average weight and age
    avgWeight = mean(weights(matches));
    avgAge = mean(ages(matches));
    
    % Normalize force by weight
    normForce = favg(i) / avgWeight;

    % Store results
    normForces(end+1) = normForce;
    agesUsed(end+1) = avgAge;
end

figure('Color', 'w');
scatter(agesUsed, normForces, 80, 'filled');
xlabel('Age (years)', 'FontSize', 12);
ylabel('Normalized Force (N/kg)', 'FontSize', 12);
title('Normalized Force vs. Age', 'FontSize', 14);
grid on;
set(gca, 'FontSize', 10);

% Optional: Add trendline
hold on;
p = polyfit(agesUsed, normForces, 1);
xFit = linspace(min(agesUsed), max(agesUsed), 100);
yFit = polyval(p, xFit);
plot(xFit, yFit, '--k', 'LineWidth', 1.5);
legend('Data', sprintf('Trend: y = %.2fx + %.2f', p(1), p(2)), 'Location', 'best');
