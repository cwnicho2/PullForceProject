% Colt Nichols 10/30/23 - Revised on 6/6/2024 for ACI submission
% Adapted on 8/20/2024 for dual force
close all
clc
clear

%DataNames = ['050224.csv'];
%DataName = DataNames(4);
%DataPath = 'C:\Users\Colt\Documents\Matlab2021b\PF_2_08162024\';
DataPath = 'C:\Users\nicho\OneDrive\Documents\Matlab2024b\prepeddata\';
stats = ["fmax" "favg" "std" "var" "session length"]
fchai = []
tchai = []


%fileList = dir(fullfile('C:\Users\nicho\OneDrive\Documents\Matlab2024b\prepeddata\', '*.csv'));     % find all .csv files
%fileList = ls('C:\Users\nicho\OneDrive\Documents\Matlab2024b\prepeddata\');     % find all .csv files

%exps = vertcat(fileList.name);
%MyMatrix=cell2mat(struct2cell(fileList));

%%exps = ["PF_0_1","PF_0_2","PF_0_3","PF_0_4","PF_0_5","PF_0_6","PF_0_7"];
%exps = ["PF_2_1","PF_2_3","PF_2_4","PF_2_5"];
%exps = ["250310"];
exps = ["2025_03_31"];
%exps = ["100324","050224","0502241","060224"];

for j = 1:length(exps)
    clear M
    filename = strcat(DataPath + exps(j),".csv");   % create path for file to read
    
    %All array indexes were decreased by on as a temporary fix bc we
    %removed a column in data collection in regards to the previous version
    Array=readmatrix(filename); % read all the proper columns
    tmillis = Array(2:end, 7);
    t = tmillis/1000
    flb = Array(2:end, 2);
    f2lb = Array(2:end, 4);
    x = Array(2:end, 9);
    y = Array(2:end, 10);
    z = Array(2:end, 11);
    gyx = Array(2:end, 12);
    gyy = Array(2:end, 13);
    gyz = Array(2:end, 14);


    if j>3     
        fchai = [fchai;flb * 0.453592];
        try
            tsofar = tchai(end)
        catch
            tsofar = 0
        end
        tchai = [tchai ; t + tsofar];
    end

    flb = flb - mean(flb(1:100));   % Left and Right force normalizing to zero
    f2lb = f2lb - mean(f2lb(1:100));


    f = flb * 0.453592; % force in kilogram
    f2 = f2lb * 0.453592;
    %%fprime = diff(f); this doesn't account for time yet

    statline = [max(f) mean(f) std(f) var(f) t(end)];   % calculate stats for the session
    stats = [stats;statline]
  
    
    % PLOTTING
    figure
    hold on
    sgtitle(exps(j), 'Interpreter', 'none')
    grid on;

    % LEFT RIGHT Force
    subplot(3,1,1)
    plot(t,f,t,f2)
    title('L/R Force')
    axis([min(t) max(t) min(f) max(f2)])
    legend({'Left','Right'})
    xlabel('Time (s)'); ylabel('Kilograms (kg)');

    % IMU
    subplot(3,1,2)
    plot(t,x,t,y,t,z)
    title('IMU x y z')
    legend({'x','y','z'})
    axis([min(t) max(t) min(cat(1,x,y,z)) max(cat(1,x,y,z))])    % set axis bounds to the min and max of the 3 dimensions
    xlabel('Time (s)'); ylabel('Accleration (m/s^2)');

    % GYRO
    subplot(3,1,3)
    plot(t,gyx,t,gyy,t,gyz)
    title('Gyroscope x y z')
    legend({'x gyro','y gyro','z gyro'})
    axis([min(t) max(t) min(cat(1,gyx,gyy,gyz)) max(cat(1,gyx,gyy,gyz))])    % set axis bounds to the min and max of the 3 dimensions
    xlabel('Time (s)'); ylabel('(Rad./sec^s)');

    
    set(findobj(gcf,'type','axes'),'FontName','Calibri','FontSize',14,'FontWeight','Bold', 'LineWidth', 1,'layer','top');

    %set(gca,'FontSize',14,'FontWeight','bold','box','off');
    set(gcf,'color','w','Position',  [100, 100, 2000, 800])

    t1 = [];
    t2 = [];
end    

%%statlinechai = [max(fchai) mean(fchai) std(fchai) var(fchai) tchai(end)]




