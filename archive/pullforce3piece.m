% Colt Nichols 10/30/23 - Revised on 6/6/2024 for ACI submission
% Adapted on 8/20/2024 for dual force
close all
clc
clear

LBS_TO_KG = 0.453592;

%-----------------------------------------------------------
doyouwantstatsonly  = 0; % 1 for yes, 0 for no. Basically option to choose to skip graphing them
analyzeGEB          = 0; % 1 for GEB, 0 for VET
%-----------------------------------------------------------

% Analzying VET data vs GEB data
if analyzeGEB == 0
    % VET Code to execute if the condition is true (i.e., analyzeGEB is 0)
    disp('Analyzing pulling_data');
    datasubfolder = 'pulling_data';
    fileout = 'VETstats.csv';
    
    exps = {dir(fullfile(datasubfolder, '*.csv')).name};    %identify all .csv files in folder
    exps = exps(~cellfun('isempty', regexp(exps, '^\d{4}_'))); %removes any files from this list that dont start like YYYY_
    % Use the below to look at only one file
    exps = ["2025_05_14_Moose.csv","2025_05_14_Lily.csv","2025_05_14_Daisy.csv"];

elseif analyzeGEB == 1
    % GEB Code to execute if the condition is false
    disp('Analyzing pulling_data\GEB');
    datasubfolder = 'pulling_data\GEB';
    fileout = 'GEBstats.csv';

    exps = {dir(fullfile(datasubfolder, '*.csv')).name};    %identify all .csv files in folder
    exps = exps(~cellfun('isempty', regexp(exps, '^\d{4}_'))); %removes any files from this list that dont start like YYYY_
else
    disp('Error finding data files, check folder structure'); 
end

%Set up the stats table based on how many files were found
numFiles = length(exps);
stats = table( ...
    strings(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), ...
    'VariableNames', {'File','fLmax','fLavg','fRmax','fRavg','fmax','favg','std','var','SessionLength'});

for j = 1:length(exps)

    % Build the path to the pulling_data folder and specific data file
    filename = fullfile(fileparts(mfilename('fullpath')), datasubfolder, exps{j});
    
    % Check if the file exists
    if exist(filename, 'file')
        disp(['Data file found: ', filename]);
    else
        error('Data file does not exist: %s', filename);
    end
    
    Array=readmatrix(filename); % read all the proper columns
    tmillis = Array(2:end, 7);
    t    = tmillis/1000;
    flb  = Array(2:end, 2);
    f2lb = Array(2:end, 4);

    if size(Array, 2) >= 14
        x   = Array(2:end, 9);  % Safe access
        y   = Array(2:end, 10);
        z   = Array(2:end, 11);
        gyx = Array(2:end, 12);
        gyy = Array(2:end, 13);
        gyz = Array(2:end, 14);
    else
        warning('IMU or GYRO data not present for %s', exps{j});
    end

    flb     = flb - mean(flb(1:100));   % Left and Right force normalizing to zero
    f2lb    = f2lb - mean(f2lb(1:100));

    f       = flb * LBS_TO_KG; % convert lb to kilogram
    f2      = f2lb * LBS_TO_KG;
    fcomb   = f + f2;

    % Write dog's stats to table
    stats.File(j)          = string(exps(j));
    stats.fLmax(j)         = max(f);
    stats.fLavg(j)         = mean(f);
    stats.fRmax(j)         = max(f2);
    stats.fRavg(j)         = mean(f2);
    stats.fmax(j)          = max(fcomb);
    stats.favg(j)          = mean(fcomb);
    stats.std(j)           = std(fcomb);
    stats.var(j)           = var(fcomb);
    stats.SessionLength(j) = t(end);

    if doyouwantstatsonly ~= 1
        % PLOTTING
        figure
        hold on
        sgtitle(exps(j), 'Interpreter', 'none')
        grid on;
        
        % LEFT RIGHT Force
        subplot(3,1,1)
        plot(t, f, t, f2)
        title('L/R Force')
        legend({'Left', 'Right'})
        xlabel('Time (s)')
        ylabel('Kilograms (kg)')
        axis tight
        ylim padded
        
        % IMU
        subplot(3,1,2)
        try
            plot(t, x, t, y, t, z)
            title('IMU x y z')
            legend({'x', 'y', 'z'})
            axis tight
            ylim padded
            xlabel('Time (s)')
            ylabel('Acceleration (m/s^2)')
        end
        
        % GYRO
        subplot(3,1,3)
        try
            plot(t, gyx, t, gyy, t, gyz)
            title('Gyroscope x y z')
            legend({'x gyro', 'y gyro', 'z gyro'})
            axis tight
            ylim padded
            xlabel('Time (s)')
            ylabel('(Rad./sec^2)')
        end
        
        % Call the styling function
        setFigureStyle();

    end
end 
writetable(stats, fullfile(datasubfolder, fileout));
disp(['Data saved to: ', fileout]);



function setFigureStyle()
    set(findobj(gcf, 'type', 'axes'), 'FontName', 'Calibri', 'FontSize', 14, ...
        'FontWeight', 'Bold', 'LineWidth', 1, 'Layer', 'top');
    set(gcf, 'Color', 'w');  % Set figure background color to white
    set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);  % Fullscreen
end


