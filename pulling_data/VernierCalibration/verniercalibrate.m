close all
clc

% plot_force_data.m
% This script reads two CSV files and plots force vs time from each on the same graph

LBS_TO_KG = 0.453592;
N_TO_KG = 1/9.81;

L_Offset = 12537;
L_Scale = 40250 / 1.07;

R_Offset = 2725;
R_Scale = 38670 / 1.07;

t_Offset = (50751 - 1040) / 1000;

% File names (you can change these to your actual file paths)
filePF = '06_09_2025_Vernier_3Bias.csv';
fileVernier  = '1kg3bias.csv';

% Read the CSV files
% Assumes the first row contains headers
data1 = readmatrix(fileVernier);
data2 = readmatrix(filePF);

% Extract time and force columns
time1 = data1(2:end, 1);
force1 = data1(2:end, 2);
force1 = force1 * N_TO_KG;

time2 = data2(2:end, 7) / 1000;
force2 = data2(2:end, 1);
force3 = data2(2:end, 3);

force2 = -(force2 + L_Offset) / L_Scale  ;   % Left and Right force normalizing to zero
force3 = -(force3 + R_Offset) / R_Scale  ;   % Left and Right force normalizing to zero


% Plotting
figure;
subplot(2,1,1);
plot(time2, force2, 'r', 'LineWidth', 1.5); hold on;
plot(time2, force3, 'b', 'LineWidth', 1.5);
xlim([t_Offset t_Offset+50.08])
% Labels and title
xlabel('Time (s)');
ylabel('Force (kg)');
title('Force vs Time - Custom System');
legend('Left Force', 'Right Force');
grid on;

% Save figure (optional)
% saveas(gcf, 'force_comparison_plot.png');

subplot(2,1,2); 
plot(time1, force1, 'black', 'LineWidth', 1.5); hold on;
xlabel('Time (s)');
ylabel('Force (kg)');
title('Force vs Time - Vernier GDX-FOR');
legend('Force');

forcenet = force2 + force3;
forcenet = forcenet();




