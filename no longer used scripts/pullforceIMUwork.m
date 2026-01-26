close all
clc
clear

datasubfolder = 'pulling_data\GEB';
exps = {dir(fullfile(datasubfolder, '*.csv')).name};    %identify all .csv files in folder

% === USER SETTINGS ===
filename = 'pulling_data\GEB\2025_05_23_OwenGaitLab.csv';   % Replace with your actual file
sampleRate = 25;            % Hz — set to your actual IMU sampling rate
dt = 1 / sampleRate;
gravityVec = [0 8 4];     % Gravity vector in world frame

% === LOAD DATA ===
imuData = readmatrix(filename);

% Adjust columns based on your format
accel = imuData(:, 9:11);    % [ax ay az]
gyro  = imuData(:, 12:14);   % [gx gy gz]

numSamples = size(accel, 1);
time = (0:numSamples-1) * dt;  % time in seconds

% === 1. Load and preprocess data ===
imuData = readmatrix(filename);
accel = imuData(:, 9:11);
gyro = imuData(:, 12:14);
numSamples = size(accel,1);

% === 2. Initial orientation from accel ===
acc0 = mean(accel(1:100,:));
pitch = atan2(-acc0(1), sqrt(acc0(2)^2 + acc0(3)^2));
roll = atan2(acc0(2), acc0(3));
yaw = 0;
q0 = quaternion([yaw, pitch, roll], 'euler', 'zyx', 'frame');

% === 3. Bias estimation ===
accel_bias = mean(accel(1:100, :), 1);
gyro_bias = mean(gyro(1:100, :), 1);
gravity_sensor = rotateframe(conj(q0), [0 0 9.81]);
accel_offset = accel_bias - gravity_sensor;

% Subtract biases
accel = accel - accel_offset;
gyro = gyro - gyro_bias;

% === 4. Integrate gyro to get orientations ===
dt = 1 / sampleRate;
orientations = quaternion.zeros(numSamples,1);
orientations(1) = q0;
q = q0;
for i=2:numSamples
    omega = gyro(i-1,:);
    dq = quaternion(omega * dt, 'rotvec');
    q = q * dq;
    orientations(i) = normalize(q);
end

% === 5. Rotate acceleration into world frame ===
accel_world = rotateframe(orientations, accel);

% === 6. Subtract gravity ===
gravityVec = [0 0 9.81];
accel_corrected = accel_world - gravityVec;

% === 7. Integrate acceleration to velocity and position ===
vel = cumtrapz((1:numSamples)*dt, accel_corrected);
pos = cumtrapz((1:numSamples)*dt, vel);

% === 8. Plot position ===
figure;
plot3(pos(:,1), pos(:,2), pos(:,3), 'b', 'LineWidth', 2);
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
title('Estimated 3D Position from IMU');
grid on; axis equal;

figure;
plot(time, vel(:,1), 'r', 'DisplayName', 'Velocity X');
hold on;
plot(time, vel(:,2), 'g', 'DisplayName', 'Velocity Y');
plot(time, vel(:,3), 'b', 'DisplayName', 'Velocity Z');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity Components over Time');
legend;
grid on;