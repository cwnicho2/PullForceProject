clc
clear all

% 1 - Data
filename = 'Experiment Notes Pull Force - VET Analysis.csv';
opts = detectImportOptions(filename);
opts.VariableNamesLine = 2; 
opts.DataLines = [3, Inf]; 
opts.VariableNamingRule = 'preserve'; 

% Read the table
data = readtable(filename, opts);

% Display names so you can verify they match your CSV
disp('Detected Columns:');
disp(data.Properties.VariableNames);

% 2. Define your Variables
% Change these strings to match the EXACT column headers in your CSV
yName = 'Star FAvg'; 
% xFactors = {'Age [yrs]', 'Weight [kg]'}; % Add all factors you want to test
% xName = 'Weight [kg]';
xName = 'Age [yrs]';

% Extract data (removing any NaN/missing values)
    cleanData = data(~isnan(data.(xName)) & ~isnan(data.(yName)), :);
    x = cleanData.(xName);
    y = cleanData.(yName);

% 2. Create the Linear Model
mdl = fitlm(x, y);

% 3. Extract the p-value
% The p-value for the slope (the relationship) is in the Coefficients table
pVal = mdl.Coefficients.pValue(2); 

% 4. Plot
figure;
plot(mdl); % This automatically plots data points, fit line, and CI
xlabel('Dependent Factor (X)');
ylabel('Average Force (Y)');
title(['Dog Performance: Force vs Factor (p = ', num2str(pVal, '%.3f'), ')']);

% Add a text marker for the p-value specifically on the plot
text(min(x), max(y), ['p-value: ' num2str(pVal, '%.4f')], 'FontSize', 12, 'Color', 'r');