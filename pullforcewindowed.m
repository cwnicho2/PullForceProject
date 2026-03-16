% Colt Nichols 10/30/23 - Revised on 6/6/2024 for ACI submission
% Adapted on 8/20/2024 for dual force
close all
clc
clear

projectRoot = fileparts(mfilename('fullpath'));
cd(projectRoot)

LBS_TO_KG = 0.453592;

%-----------------------------------------------------------
doyouwantstatsonly  = 0; % 1 for yes, 0 for no. Basically option to choose to skip graphing them
analyzeGEB          = 1; % 1 for GEB, 0 for VET
%-----------------------------------------------------------

% Start and Stops for the pulling windows on each dog
timeWindowsMap = {
    '2025_02_05.csv',               [289, 379; 424, 514; 561, 651];		
    '2025_02_05_1.csv',             [67, 157; 210, 300; 366, 456];
    '2025_02_06.csv',               [103, 167; 252, 335; 437, 529];
    % '2025_02_28_2.csv',
    % '2025_02_28_3.csv',
    % '2025_03_10.csv',             % not food motivated, used open door
    % '2025_03_19.csv',
    % '2025_03_28_1.csv',
    % '2025_03_28_2.csv',
    '2025_03_31.csv',               [461, 542; 765, 858; 1050, 1140];
    '2025_04_01.csv',               [310, 394; 464, 554; 622, 710];			
    '2025_04_02.csv',               [361, 451; 555, 643; 735, 823];
    '2025_04_03.csv',               [190, 280; 351, 438; 511, 601];
    '2025_04_22_11_45_Tiger.csv',   [224, 314; 397, 487; 558, 648];
    '2025_04_24_10_50_Evie.csv',    [80, 170; 248, 340; 407, 502];
    '2025_05_01_Emmy.csv',          [209, 299; 365, 459; 530, 618];
    '2025_05_05_Taro.csv',          [297, 385; 451, 541; 629, 719];
    '2025_05_07_Maya.csv',          [143, 233; 341, 431; 501, 588];
    '2025_05_07_Rosie.csv',         [335, 425; 493, 583; 656, 746];
    '2025_05_08_Flossie.csv',       [216, 306; 514, 604; 666, 756];
    '2025_05_08_Pirate.csv',        [300, 390; 450, 540; 606, 696];
    '2025_05_12_Wiz.csv',           [356, 446; 539, 629; 688, 778]; %double check once more with footage
    '2025_05_14_Lily.csv'           [108, 198; 264, 353; 416, 507];
    '2025_05_14_Moose.csv'          [242, 338; 415, 505; 568, 658];
    % Daisy??
    '2025_05_14_Zoey.csv'           [286, 377; 469, 555; 650, 740]; %Nearly slipped out of harness
    '2025_05_21_Lobster.csv'        [400, 490; 583, 677; 751, 843];
    '2025_05_22_Eloise.csv'         [196, 283; 358, 448; 514, 604];
    '2025_05_23_Russ.csv'           [138, 218; 292, 383; 462, 553];			
    '2025_05_23_Zoey.csv'           [95, 185; 259, 349; 439, 529];
    '2025_05_27_Freckles.csv'       [374, 439; 506, 596; 672, 764];
    '2025_05_27_Lina.csv'           [201, 291; 362, 453; 531, 594];	% L sensor appears to zero in the first round	
    % '2025_05_27_Niko.csv'           []    % No food motivation
    % '2025_05_28_Riley.csv'          []    % data issue
    '2025_06_03_Jabbo.csv'          [95, 185; 253, 343; 419, 509];
    % '2025_06_03_Ragnar.csv'         [263, 436; 506, 582; 713, 803]; %some issues backing out of the harness or disinterest
    % '2025_06_10_GOOSE.csv'          []    % no footage found
    '2025_06_10_Peanut.csv'         [313, 402; 502, 592; 685, 778];	% camera may have died during experiment end		
    '2025_06_11_Zephyra.csv'        [258, 348; 426, 514; 603, 694];   % dog was not well motivated
    '2025_06_12_Blondie.csv'        [71, 191; 233, 323; 420, 512];			
    '2025_06_12_Raven.csv'          [71, 191; 240, 330; 415, 504];			
    '2025_06_12_Shiloh.csv'         [61, 150; 219, 309; 375, 464];
    % 6/16 Garth could not focus on task
    '2025_06_17_Banjo.csv'          [140, 229; 298, 386; 464, 553];
    '2025_06_18_Oakley.csv'         [152, 242; 339, 428; 554, 644];			
    '2025_06_19_Coconut.csv'        [185, 330; 421, 511; 626, 714];			
    % '2025_06_20_Annie.csv'          []; data loss
    '2025_06_20_Teddy.csv'          [204, 293; 366, 456; 553, 644];
    '2025_06_23_Grizzy.csv'         [95, 182; 284, 373; 433, 535];
    % '2025_06_24_Alma.csv'           []  [not pull motivated, some bursts];
    '2025_06_24_GooseRepeat.csv'    [95, 184; 260, 350; 442, 532];			
    '2025_06_24_Lucy(Curtis).csv'   [123, 213; 428, 518; 593, 683];			
    '2025_06_24_PeanutRepeat.csv'   [91, 179; 248, 338; 417, 507];		
    '2025_06_24_Tahoe.csv'          [85, 171; 266, 354; 436, 526];			
    '2025_06_25_Chai.csv'           [126, 216; 303, 394; 473, 561];			
    '2025_06_25_Kenzie.csv'         [90, 179; 255, 345; 455, 545];			
    '2025_06_25_Muppet.csv'         [245, 333; 402, 487; 575, 663]; %some lower food motivation
    '2025_06_25_Sam.csv'            [100, 190; 355, 442; 574, 661];			
			
    '2025_06_26_Astro.csv'          [103, 192; 264, 354; 569, 657]; %lost motivation shortly after beginning
    '2025_06_26_Barry.csv'          [155, 242; 364, 454; 573, 663];			
    '2025_06_26_Leo.csv'            [100, 190; 270, 360; 434, 522];			
    '2025_06_27_Atlo.csv'           [100, 189; 265, 355; 450, 540]; %great consistency
    '2025_06_27_Bucky.csv'          [166, 255; 351, 439; 514, 604]; %motivation a little low, but succesful exp
    '2025_06_27_Dude.csv'           [160, 250; 323, 413; 498, 588];	%great consistency		
    '2025_06_27_Peaches.csv'        [105, 195; 343, 434; 560, 650];
    '2025_06_30_Mushu.csv'          [154, 242; 307, 397; 468, 556];			
    '2025_06_30_Ruby.csv'           [96, 186; 257, 347; 430, 520];	
    % '2025_06_30_Tiberius.csv'       []; %not food motivated
    '2025_07_01_Cheddar.csv'        [103, 193; 365, 455; 556, 646];			
			
    '2025_07_01_Groot.csv'          [125, 157; 241, 331; 528, 617]; %intermittently interested. Huge dog, also needed a poop break during
    '2025_07_01_GrootP2.csv'        [89, 179; 286, 372; 373, 373];	% Use the first two here, interest far more consistent					
    '2025_07_02_Zuzu.csv'           [113, 198; 298, 388; 467, 554];	% good consistency
    '2025_07_03_BarryRepeat.csv'    [112, 201; 299, 389; 485, 574];	% good consistency
    '2025_07_03_Kaptain.csv'        [135, 225; 388, 476; 649, 739];	% procedure not consistent		
    '2025_07_03_Kinder.csv'         [92, 181; 256, 346; 443, 530];				
    % '2025_07_03_KinderORSam.csv'         []; % This was the first part of Sam
    % '2025_07_03_SamRepeat.csv'         []; need to concat with the previous
    '2025_07_03_Sydney.csv'         [151, 241; 324, 414; 511, 600];	%big dog no problems	
    '2025_07_03_TeddyRepeat.csv'    [80, 170; 246, 336; 411, 503]; % very consistent	
    '2025_07_04_DudeRepeat.csv'     [88, 178; 266, 356; 445, 535];	
    % '2025_07_04_GrizzyRepeat.csv'         []; % data file issues, looks like shorting pin
    '2025_07_04_Oscar.csv'          [147, 236; 343, 433; 595, 685];
    '2025_07_04_Penelope.csv'       [114, 198; 272, 362; 434, 524];	
    '2025_07_04_Pirate.csv'         [40, 130; 194, 284; 360, 450];		
    '2025_07_04_TahoeRepeat.csv'    [93, 183; 293, 383; 489, 579]; % very strong and consistent
    '2025_07_04_Whiskey.csv'        [110, 195; 252, 337; 404, 494];			
    '2025_07_04_Willow.csv'         [129, 279; 401, 491; 596, 686]; % harness too big, problematic
    % '2025_07_07_Emilio.csv'         []; % not interested in the task
    % '2025_07_07_Lily.csv'           []; % data file too small
    '2025_07_07_PrincessPeaches.csv'         [65, 155; 230, 316; 380, 467];
    % '2025_07_07_ZZTop.csv'         []; % not interested in the task 
    '2025_07_24_Emmy.csv'         [100, 190; 269, 360; 438, 528];			
		
};


% Analzying VET data vs GEB data
if analyzeGEB == 0
    % VET Code to execute if the condition is true (i.e., analyzeGEB is 0)
    disp('Analyzing pulling_data');
    datasubfolder = 'pulling_data';
    fileout = 'VETstats.csv';
    
    exps = {dir(fullfile(datasubfolder, '*.csv')).name};    %identify all .csv files in folder
    exps = exps(~cellfun('isempty', regexp(exps, '^\d{4}_'))); %removes any files from this list that dont start like YYYY_
    
    % Use the below to look at only one file
    %exps = ["2025_07_07_ZZTop.csv"];

elseif analyzeGEB == 1
    % GEB Code to execute if the condition is false
    disp('Analyzing pulling_data\GEB');
    datasubfolder = 'pulling_data\GEB';
    fileout = 'GEBstats.csv';

    exps = {dir(fullfile(datasubfolder, '*.csv')).name};    %identify all .csv files in folder
    exps = exps(~cellfun('isempty', regexp(exps, '^\d{4}_'))); %removes any files from this list that dont start like YYYY_
    exps = ["2026_02_19_Bono.csv","2026_02_19_Rhiana.csv","2026_02_19_Zeppelin.csv","2026_02_19_Camden.csv"];

else
    disp('Error finding data files, check folder structure'); 
end

%If the number of experiments is large, prevent plotting all on accident
if length(exps) > 15
    doyouwantstatsonly = 1;
    disp(['Large number of experiments detected, plotting prevented, you can change the tolerance here']);
end



%Set up the stats table based on how many files were found
numFiles = length(exps);
stats = table( ...
    strings(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), zeros(numFiles, 1), ...
    'VariableNames', {'File','fLmax','fLavg','fRmax','fRavg','fmax','favg','std','var','SessionLength'});

% Boxplot Initialize a cell array to hold force data for each trial
fcomb_all = cell(numFiles, 1); 

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

    % Handle Special Cases/Corrections -----------------------------------
    % special case for 2/06
    if strcmp(exps, "2025_02_06.csv")
        disp("special case adjusting force 2/06")
        f = f + 0.724;
        f2 = f2 + 0.724;
    end
    % special case for Camden
    if strcmp(exps{j}, "2025_11_05_Camden_cleaned.csv")
        disp("special case adjusting force 2/06")
        f = f + 0.65;
    end   
    % special case for Atticus
    if strcmp(exps{j}, "2025_04_15_1.csv")
        disp("special case adjusting force on Atticus 04_15_1")
        f2 = f2 - (-1.177/(t(end)-t(1)))*t;
    end   
    % -------------------------------------------------------------------

    fcomb   = f + f2;

    % Find if this file has defined time windows
    matchIdx = find(strcmp(timeWindowsMap(:,1), exps{j}));
    if ~isempty(matchIdx)
        windows = timeWindowsMap{matchIdx, 2};
    
        % Create a mask to filter data within any of the specified windows
        windowMask = false(size(t));
        for w = 1:size(windows, 1)
            windowMask = windowMask | (t >= windows(w,1) & t <= windows(w,2));
        end
    
        % Apply the mask to trim data
        t = t(windowMask);
        f = f(windowMask);
        f2 = f2(windowMask);
        fcomb = f + f2;
    else
        warning('No time window defined for file: %s. Using full session.', exps{j});
    end

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
    stats.SessionLength(j) = t(end)-t(1);

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
    fcomb_all{j} = fcomb; % Store combined pulling force for this dog/trial
end 
writetable(stats, fullfile(datasubfolder, fileout));
disp(['Data saved to: ', fileout]);

if analyzeGEB == 1
    DOWNSAMPLE = 1;     % 40Hz → 2Hz
    USE_AVG = true;

    validIdx = ~cellfun(@isempty, fcomb_all);
    trials = fcomb_all(validIdx);
    labels = exps(validIdx);

    % Downsample each trial and record max length
    downsampled = cell(1, numel(trials));
    maxLen = 0;

    for i = 1:numel(trials)
        f = trials{i};
        if USE_AVG
            w = DOWNSAMPLE;
            N = floor(length(f)/w);
            f = arrayfun(@(k) mean(f((k-1)*w + 1 : k*w)), 1:N)';
        else
            f = f(1:DOWNSAMPLE:end);
        end
        downsampled{i} = f;
        maxLen = max(maxLen, length(f));
    end

    % Pad with NaNs to build a matrix
    dataMatrix = NaN(maxLen, numel(trials));
    for i = 1:numel(trials)
        len = length(downsampled{i});
        dataMatrix(1:len, i) = downsampled{i};
    end

    % Number of trials
    numTrials = numel(trials);
    
    % Create labels as letters A, B, C, ...
    dogLabels = arrayfun(@(x) char('A' + x - 1), 1:numTrials, 'UniformOutput', false);
    numDogs = size(stats.favg, 1); % or length(trials) if that matches dogs
    % Plot
    figure;
    violinplot(dataMatrix);
    % xticklabels(regexprep(labels, '^\d{4}_\d{2}_\d{2}_?', ''));
    % xtickangle(45);
    ylabel('Combined Pulling Force (kg)');

    set(gca, 'FontName', 'Calibri', 'FontSize', 12, 'FontWeight', 'Normal');
    set(gcf, 'Color', 'w');
    title('Combined Pulling Force Distributions','FontSize', 18,'FontWeight','normal');
    grid on;                 % Turn on grid lines
    ylim([-3 15]);            % Set y-axis limits from 0 to 15 kg
   
    % After violinplot call, set the tick labels
    xticklabels(dogLabels);
    xtickangle(0);
    xlabel('Dog Identifier (Anonymized)');
    
    hold on
    % Add marker for each dog's average combined pull force
    for i = 1:numDogs
        avgVal = stats.favg(i); % assuming one avg per dog in the i-th row
        plot(i, avgVal, 'r*', 'MarkerSize', 10, 'LineWidth', 1.5);
    end
    % Create dummy handles for legend
    h_violin = plot(nan, nan, 'b');       % dummy for violin plots (blue color)
    h_avg = plot(nan, nan, 'r*', 'MarkerSize', 10, 'LineWidth', 1.5);  % dummy for average markers

    hold off
    legend([h_avg], { 'Average Value'}, 'Location', 'northwest');
end

function setFigureStyle()
    set(findobj(gcf, 'type', 'axes'), 'FontName', 'Calibri', 'FontSize', 16, ...
        'FontWeight', 'Normal', 'LineWidth', 1, 'Layer', 'top');
    set(gcf, 'Color', 'w');  % Set figure background color to white
    set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);  % Fullscreen
end


