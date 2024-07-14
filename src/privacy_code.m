clc; close all; clear;
%% The name of the data file and folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = 'trial17.txt';  
input_folder = 'C:\Users\dirky\Desktop\OculusNew\Oculus\VrSamples\VrCubeWorld_NativeActivity\Projects\Android\WINLAB\motion_data\raw_oculus_data\arm\side_raise\';
output_folder = 'C:\Users\dirky\Desktop\OculusNew\Oculus\VrSamples\VrCubeWorld_NativeActivity\Projects\Android\WINLAB\motion_data\csv_oculus_data\prac\arm\';
Fs = 1000;
Fc = 30; % Cutoff frequency for lowpass filter 
format longG

start_index = 1;
end_index = 6205;

%% Extract motion sensor data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = [input_folder file];  
fid=fopen(filename);
tline = fgetl(fid);

% Array to store accelerometer and gyroscope data
time_acc = [];
time_gyro = [];
time_0contr_acc = [];
time_0contr_gyro = [];
time_1contr_acc = [];
time_1contr_gyro = [];

x_acc = [];
y_acc = [];
z_acc = [];
x_gyro = [];
y_gyro = [];
z_gyro = [];

x_0contr_acc = [];
y_0contr_acc = [];
z_0contr_acc = [];
x_0contr_gyro = [];
y_0contr_gyro = [];
z_0contr_gyro = [];

x_1contr_acc = [];
y_1contr_acc = [];
z_1contr_acc = [];
x_1contr_gyro = [];
y_1contr_gyro = [];
z_1contr_gyro = [];

while ischar(tline) 
    %disp(tline);
    tline = fgetl(fid);
    if tline == -1
        break
    end

    strings = strsplit(tline,' ');
    if size(strings,2)<5
        continue
    end
    
    if strcmp(char(strings(1, end-4)), 'HMDAcceleration:') == 1
        time_acc = [time_acc; str2num(char(strings(1, end-3)))];
        x_acc = [x_acc; str2num(char(strings(1, end-2)))];
        y_acc = [y_acc; str2num(char(strings(1, end-1)))];
        z_acc = [z_acc; str2num(char(strings(1, end)))];     
    elseif  strcmp(char(strings(1, end-4)), 'HMDGyroscope:') == 1
        time_gyro = [time_gyro; str2num(char(strings(1, end-3)))];
        x_gyro = [x_gyro; str2num(char(strings(1, end-2)))];
        y_gyro = [y_gyro; str2num(char(strings(1, end-1)))];
        z_gyro = [z_gyro; str2num(char(strings(1, end)))];
    elseif  strcmp(char(strings(1, end-4)), 'Controller0Acceleration:') == 1
        time_0contr_acc = [time_0contr_acc; str2num(char(strings(1, end-3)))];
        x_0contr_acc = [x_0contr_acc; str2num(char(strings(1, end-2)))];
        y_0contr_acc = [y_0contr_acc; str2num(char(strings(1, end-1)))];
        z_0contr_acc = [z_0contr_acc; str2num(char(strings(1, end)))];
    elseif  strcmp(char(strings(1, end-4)), 'Controller0Gyroscope:') == 1
        time_0contr_gyro = [time_0contr_gyro; str2num(char(strings(1, end-3)))];
        x_0contr_gyro = [x_0contr_gyro; str2num(char(strings(1, end-2)))];
        y_0contr_gyro = [y_0contr_gyro; str2num(char(strings(1, end-1)))];
        z_0contr_gyro = [z_0contr_gyro; str2num(char(strings(1, end)))];
    elseif  strcmp(char(strings(1, end-4)), 'Controller1Acceleration:') == 1
        time_1contr_acc = [time_1contr_acc; str2num(char(strings(1, end-3)))];
        x_1contr_acc = [x_1contr_acc; str2num(char(strings(1, end-2)))];
        y_1contr_acc = [y_1contr_acc; str2num(char(strings(1, end-1)))];
        z_1contr_acc = [z_1contr_acc; str2num(char(strings(1, end)))];
    elseif  strcmp(char(strings(1, end-4)), 'Controller1Gyroscope:') == 1
        time_1contr_gyro = [time_1contr_gyro; str2num(char(strings(1, end-3)))];
        x_1contr_gyro = [x_1contr_gyro; str2num(char(strings(1, end-2)))];
        y_1contr_gyro = [y_1contr_gyro; str2num(char(strings(1, end-1)))];
        z_1contr_gyro = [z_1contr_gyro; str2num(char(strings(1, end)))];
    end
end

% gets all rows and columns of array
% headset 
x_acc = x_acc(:,:);
y_acc = y_acc(:,:);
z_acc = z_acc(:,:);
x_gyro = x_gyro(:,:);
y_gyro = y_gyro(:,:);
z_gyro = z_gyro(:,:);

% left controller
x_0contr_acc = x_0contr_acc(:,:);
y_0contr_acc = y_0contr_acc(:,:);
z_0contr_acc = z_0contr_acc(:,:);
x_0contr_gyro = x_0contr_gyro(:,:);
y_0contr_gyro = y_0contr_gyro(:,:);
z_0contr_gyro = z_0contr_gyro(:,:);

% right controller
x_1contr_acc = x_1contr_acc(:,:);
y_1contr_acc = y_1contr_acc(:,:);
z_1contr_acc = z_1contr_acc(:,:);
x_1contr_gyro = x_1contr_gyro(:,:);
y_1contr_gyro = y_1contr_gyro(:,:);
z_1contr_gyro = z_1contr_gyro(:,:);

max_time = size(x_acc,1) / Fs; 
max_time_0contr = size(x_0contr_acc,1) / Fs;
max_time_1contr = size(x_1contr_acc,1) / Fs;

offset = min(time_acc(1,1), time_gyro(1,1));
offset_0contr = min(time_0contr_acc(1,1), time_0contr_gyro(1,1));
offset_1contr = min(time_1contr_acc(1,1), time_1contr_gyro(1,1));

time_acc = time_acc - offset;
time_gyro = time_gyro - offset;
time_0contr_acc = time_0contr_acc - offset_0contr;
time_0contr_gyro = time_0contr_gyro - offset_0contr;
time_1contr_acc = time_1contr_acc - offset_1contr;
time_1contr_gyro = time_1contr_gyro - offset_1contr;

num_data_pts_acc = length(time_acc);
num_data_pts_gyro = length(time_gyro);
num_data_pts_0contr_acc = length(time_0contr_acc);
num_data_pts_0contr_gyro = length(time_0contr_gyro);
num_data_pts_1contr_acc = length(time_1contr_acc);
num_data_pts_1contr_gyro = length(time_1contr_gyro);

%% Noise removing Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% smooth function 
x_acc_smooth = smooth(x_acc); % headset 
y_acc_smooth = smooth(y_acc);
z_acc_smooth = smooth(z_acc);
x_gyro_smooth = smooth(x_gyro);
y_gyro_smooth = smooth(y_gyro);
z_gyro_smooth = smooth(z_gyro);

x_0contr_acc_smooth = smooth(x_0contr_acc); % left controller 
y_0contr_acc_smooth = smooth(y_0contr_acc);
z_0contr_acc_smooth = smooth(z_0contr_acc);
x_0contr_gyro_smooth = smooth(x_0contr_gyro);
y_0contr_gyro_smooth = smooth(y_0contr_gyro);
z_0contr_gyro_smooth = smooth(z_0contr_gyro);

x_1contr_acc_smooth = smooth(x_1contr_acc); % right controller 
y_1contr_acc_smooth = smooth(y_1contr_acc);
z_1contr_acc_smooth = smooth(z_1contr_acc);
x_1contr_gyro_smooth = smooth(x_1contr_gyro);
y_1contr_gyro_smooth = smooth(y_1contr_gyro);
z_1contr_gyro_smooth = smooth(z_1contr_gyro);

% lowpass filter on smooth function graph 
x_acc_lowpass = lowpass(x_acc_smooth, Fc, Fs); % headset 
y_acc_lowpass = lowpass(y_acc_smooth, Fc, Fs);
z_acc_lowpass = lowpass(z_acc_smooth, Fc, Fs);
x_gyro_lowpass = lowpass(x_gyro, Fc, Fs);
y_gyro_lowpass = lowpass(y_gyro, Fc, Fs);
z_gyro_lowpass = lowpass(z_gyro, Fc, Fs);

x_0contr_acc_lowpass = lowpass(x_0contr_acc_smooth, Fc, Fs); % left controller 
y_0contr_acc_lowpass = lowpass(y_0contr_acc_smooth, Fc, Fs);
z_0contr_acc_lowpass = lowpass(z_0contr_acc_smooth, Fc, Fs);
x_0contr_gyro_lowpass = lowpass(x_0contr_gyro_smooth, Fc, Fs);
y_0contr_gyro_lowpass = lowpass(y_0contr_gyro_smooth, Fc, Fs);
z_0contr_gyro_lowpass = lowpass(z_0contr_gyro_smooth, Fc, Fs);

x_1contr_acc_lowpass = lowpass(x_1contr_acc_smooth, Fc, Fs); % right controller 
y_1contr_acc_lowpass = lowpass(y_1contr_acc_smooth, Fc, Fs);
z_1contr_acc_lowpass = lowpass(z_1contr_acc_smooth, Fc, Fs);
x_1contr_gyro_lowpass = lowpass(x_1contr_gyro_smooth, Fc, Fs);
y_1contr_gyro_lowpass = lowpass(y_1contr_gyro_smooth, Fc, Fs);
z_1contr_gyro_lowpass = lowpass(z_1contr_gyro_smooth, Fc, Fs);


% finding peaks on smooth graph 
[x_acc_peak_values, x_acc_peak_locs] = findpeaks(x_acc_smooth);
[y_acc_peak_values, y_acc_peak_locs] = findpeaks(y_acc_smooth);
[z_acc_peak_values, z_acc_peak_locs] = findpeaks(z_acc_smooth);

[x_gyro_peak_values, x_gyro_peak_locs] = findpeaks(x_gyro_smooth);
[y_gyro_peak_values, y_gyro_peak_locs] = findpeaks(y_gyro_smooth);
[z_gyro_peak_values, z_gyro_peak_locs] = findpeaks(z_gyro_smooth);


% finding peaks on lowpass filter graph and their times 
[x_acc_peak_values_wlowpass, x_acc_peak_locs_wlowpass] = findpeaks(x_acc_lowpass); % headset acc
x_acc_peak_time_locs_wlowpass = time_acc(x_acc_peak_locs_wlowpass);
[y_acc_peak_values_wlowpass, y_acc_peak_locs_wlowpass] = findpeaks(y_acc_lowpass);
y_acc_peak_time_locs_wlowpass = time_acc(y_acc_peak_locs_wlowpass);
[z_acc_peak_values_wlowpass, z_acc_peak_locs_wlowpass] = findpeaks(z_acc_lowpass);
z_acc_peak_time_locs_wlowpass = time_acc(z_acc_peak_locs_wlowpass);
[x_gyro_peak_values_wlowpass, x_gyro_peak_locs_wlowpass] = findpeaks(x_gyro_lowpass); % headset gyro
x_gyro_peak_time_locs_wlowpass = time_gyro(x_gyro_peak_locs_wlowpass);
[y_gyro_peak_values_wlowpass, y_gyro_peak_locs_wlowpass] = findpeaks(y_gyro_lowpass);
y_gyro_peak_time_locs_wlowpass = time_gyro(y_gyro_peak_locs_wlowpass);
[z_gyro_peak_values_wlowpass, z_gyro_peak_locs_wlowpass] = findpeaks(z_gyro_lowpass);
z_gyro_peak_time_locs_wlowpass = time_gyro(z_gyro_peak_locs_wlowpass);

[x_0contr_acc_peak_values_wlowpass, x_0contr_acc_peak_locs_wlowpass] = findpeaks(x_0contr_acc_lowpass); % left contr acc
x_0contr_acc_peak_time_locs_wlowpass = time_0contr_acc(x_0contr_acc_peak_locs_wlowpass);
[y_0contr_acc_peak_values_wlowpass, y_0contr_acc_peak_locs_wlowpass] = findpeaks(y_0contr_acc_lowpass);
y_0contr_acc_peak_time_locs_wlowpass = time_0contr_acc(y_0contr_acc_peak_locs_wlowpass);
[z_0contr_acc_peak_values_wlowpass, z_0contr_acc_peak_locs_wlowpass] = findpeaks(z_0contr_acc_lowpass);
z_0contr_acc_peak_time_locs_wlowpass = time_0contr_acc(z_0contr_acc_peak_locs_wlowpass);
[x_0contr_gyro_peak_values_wlowpass, x_0contr_gyro_peak_locs_wlowpass] = findpeaks(x_0contr_gyro_lowpass); % left contr gyro
x_0contr_gyro_peak_time_locs_wlowpass = time_0contr_gyro(x_0contr_gyro_peak_locs_wlowpass);
[y_0contr_gyro_peak_values_wlowpass, y_0contr_gyro_peak_locs_wlowpass] = findpeaks(y_0contr_gyro_lowpass);
y_0contr_gyro_peak_time_locs_wlowpass = time_0contr_gyro(y_0contr_gyro_peak_locs_wlowpass);
[z_0contr_gyro_peak_values_wlowpass, z_0contr_gyro_peak_locs_wlowpass] = findpeaks(z_0contr_gyro_lowpass);
z_0contr_gyro_peak_time_locs_wlowpass = time_0contr_gyro(z_0contr_gyro_peak_locs_wlowpass);

[x_1contr_acc_peak_values_wlowpass, x_1contr_acc_peak_locs_wlowpass] = findpeaks(x_1contr_acc_lowpass); % right contr acc
x_1contr_acc_peak_time_locs_wlowpass = time_1contr_acc(x_1contr_acc_peak_locs_wlowpass);
[y_1contr_acc_peak_values_wlowpass, y_1contr_acc_peak_locs_wlowpass] = findpeaks(y_1contr_acc_lowpass);
y_1contr_acc_peak_time_locs_wlowpass = time_1contr_acc(y_1contr_acc_peak_locs_wlowpass);
[z_1contr_acc_peak_values_wlowpass, z_1contr_acc_peak_locs_wlowpass] = findpeaks(z_1contr_acc_lowpass);
z_1contr_acc_peak_time_locs_wlowpass = time_1contr_acc(z_1contr_acc_peak_locs_wlowpass);
[x_1contr_gyro_peak_values_wlowpass, x_1contr_gyro_peak_locs_wlowpass] = findpeaks(x_1contr_gyro_lowpass); % right contr gyro
x_1contr_gyro_peak_time_locs_wlowpass = time_1contr_gyro(x_1contr_gyro_peak_locs_wlowpass);
[y_1contr_gyro_peak_values_wlowpass, y_1contr_gyro_peak_locs_wlowpass] = findpeaks(y_1contr_gyro_lowpass);
y_1contr_gyro_peak_time_locs_wlowpass = time_1contr_gyro(y_1contr_gyro_peak_locs_wlowpass);
[z_1contr_gyro_peak_values_wlowpass, z_1contr_gyro_peak_locs_wlowpass] = findpeaks(z_1contr_gyro_lowpass);
z_1contr_gyro_peak_time_locs_wlowpass = time_1contr_gyro(z_1contr_gyro_peak_locs_wlowpass);
%{
%% Graphs using 'smooth', 'lowpass', and 'findpeaks' functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
% X-axis accelerometer
subplot(3,1,1);
plot(x_acc_peak_time_locs_wlowpass, x_acc_peak_values_wlowpass);
title({'Headset Graphs Using "smooth", "lowpass", and "findpeaks" Functions'; 'X-Axis Accelerometer'});
xlim([0, 20]);
hold on;
% Y-axis accelerometer
subplot(3,1,2);
plot(y_acc_peak_time_locs_wlowpass, y_acc_peak_values_wlowpass);
ylabel('\bf{Acc (m/s^2)}');
title('Y-Axis Accelerometer');
xlim([0, 20]);
hold on;
% Z-axis accelerometer
subplot(3,1,3);
plot(z_acc_peak_time_locs_wlowpass, z_acc_peak_values_wlowpass);
title('Z-Axis Accelerometer');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure; 
% X-axis gyroscope
subplot(3,1,1);
plot(x_gyro_peak_time_locs_wlowpass, x_gyro_peak_values_wlowpass);
title({'Headset Graphs Using "smooth", "lowpass", and "findpeaks" Functions';'X-Axis Gyroscope'});
xlim([0, 20]);
hold on;
% Y-axis gyroscope
subplot(3,1,2);
plot(y_gyro_peak_time_locs_wlowpass, y_gyro_peak_values_wlowpass);
ylabel('\bf{Ang (deg/s)}');
title('Y-Axis Gyroscope');
xlim([0, 20]);
hold on;
% Z-axis gyroscope
subplot(3,1,3);
plot(z_gyro_peak_time_locs_wlowpass, z_gyro_peak_values_wlowpass);
title('Z-Axis Gyroscope');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure; 
% X-axis accelerometer
subplot(3,1,1);
plot(x_0contr_acc_peak_time_locs_wlowpass, x_0contr_acc_peak_values_wlowpass);
title({'Left Controller Graphs Using "smooth", "lowpass", and "findpeaks" Functions'; 'X-Axis Accelerometer'});
xlim([0, 20]);
hold on;
% Y-axis accelerometer
subplot(3,1,2);
plot(y_0contr_acc_peak_time_locs_wlowpass, y_0contr_acc_peak_values_wlowpass);
ylabel('\bf{Acc (m/s^2)}');
title('Y-Axis Accelerometer');
xlim([0, 20]);
hold on;
% Z-axis accelerometer
subplot(3,1,3);
plot(z_0contr_acc_peak_time_locs_wlowpass, z_0contr_acc_peak_values_wlowpass);
title('Z-Axis Accelerometer');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure; 
% X-axis gyroscope
subplot(3,1,1);
plot(x_0contr_gyro_peak_time_locs_wlowpass, x_0contr_gyro_peak_values_wlowpass);
title({'Left Controller Graphs Using "smooth", "lowpass", and "findpeaks" Functions'; 'X-Axis Gyroscope'});
xlim([0, 20]);
hold on;
% Y-axis gyroscope
subplot(3,1,2);
plot(y_0contr_gyro_peak_time_locs_wlowpass, y_0contr_gyro_peak_values_wlowpass);
ylabel('\bf{Ang (deg/s)}');
title('Y-Axis Gyroscope');
xlim([0, 20]);
hold on;
% Z-axis gyroscope
subplot(3,1,3);
plot(z_0contr_gyro_peak_time_locs_wlowpass, z_0contr_gyro_peak_values_wlowpass);
title('Z-Axis Gyroscope');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure; 
% X-axis accelerometer
subplot(3,1,1);
plot(x_1contr_acc_peak_time_locs_wlowpass, x_1contr_acc_peak_values_wlowpass);
title({'Right controller Graphs Using "smooth", "lowpass", and "findpeaks" Functions'; 'X-Axis Accelerometer'});
xlim([0, 20]);
hold on;
% Y-axis accelerometer
subplot(3,1,2);
plot(y_1contr_acc_peak_time_locs_wlowpass, y_1contr_acc_peak_values_wlowpass);
ylabel('\bf{Acc (m/s^2)}');
title('Y-Axis Accelerometer');
xlim([0, 20]);
hold on;
% Z-axis accelerometer
subplot(3,1,3);
plot(z_1contr_acc_peak_time_locs_wlowpass, z_1contr_acc_peak_values_wlowpass);
title('Z-Axis Accelerometer');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure; 
% X-axis gyroscope
subplot(3,1,1);
plot(x_1contr_gyro_peak_time_locs_wlowpass, x_1contr_gyro_peak_values_wlowpass);
title({'Right Controller Graphs Using "smooth", "lowpass", and "findpeaks" Functions'; 'X-Axis Gyroscope'});
xlim([0, 20]);
hold on;
% Y-axis gyroscope
subplot(3,1,2);
plot(y_1contr_gyro_peak_time_locs_wlowpass, y_1contr_gyro_peak_values_wlowpass);
ylabel('\bf{Ang (deg/s)}');
title('Y-Axis Gyroscope');
xlim([0, 20]);
hold on;
% Z-axis gyroscope
subplot(3,1,3);
plot(z_1contr_gyro_peak_time_locs_wlowpass, z_1contr_gyro_peak_values_wlowpass);
title('Z-Axis Gyroscope');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');
%}
%{
%% 3D Acceleration Visualization 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New Part: Integrate Acceleration Data to Get Orientation
dt = 1 / Fs;
position = zeros(length(time_acc), 3); % head
position_contr = zeros(length(time_0contr_acc), 3); % left
position_contr_other = zeros(length(time_1contr_acc), 3); % right

for i = 2:length(time_acc) % head 
    position(i, 1) = position(i-1, 1) + x_acc(i) * dt * dt / 2;
    position(i, 2) = position(i-1, 2) + y_acc(i) * dt * dt / 2;
    position(i, 3) = position(i-1, 3) + z_acc(i) * dt * dt / 2;
end

for j = 2:length(time_0contr_acc) % left 
    position_contr(j, 1) = position_contr(j-1, 1) + x_0contr_acc(j) * dt * dt / 2;
    position_contr(j, 2) = position_contr(j-1, 2) + y_0contr_acc(j) * dt * dt / 2;
    position_contr(j, 3) = position_contr(j-1, 3) + z_0contr_acc(j) * dt * dt / 2;
end

for k = 2:length(time_1contr_acc) % right
    position_contr_other(k, 1) = position_contr_other(k-1, 1) + x_1contr_acc(k) * dt * dt / 2;
    position_contr_other(k, 2) = position_contr_other(k-1, 2) + y_1contr_acc(k) * dt * dt / 2;
    position_contr_other(k, 3) = position_contr_other(k-1, 3) + z_1contr_acc(k) * dt * dt / 2;
end

% Define the index range
%start_index = 1;
%end_index = 8896;
selected_indices = start_index:end_index;

% Filter data using the selected indices
filtered_position = position(selected_indices, :); % head
filtered_position_contr = position_contr(selected_indices, :); % left 
filtered_position_contr_other = position_contr_other(selected_indices, :); % right
filtered_time_acc = time_acc(selected_indices);

% Plot the 3D trajectory with a color gradient representing time
figure;
scatter3(filtered_position(:, 1), filtered_position(:, 2), filtered_position(:, 3), 3, filtered_time_acc, 'filled');
title('HMD 3D Visual From Accelerometer Data');
xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
cb = colorbar('eastoutside');
colormap(jet);
cb.Label.String = 'Time (seconds)';

% Plot the 3D trajectory with a color gradient representing time
figure;
scatter3(filtered_position_contr(:, 1), filtered_position_contr(:, 2), filtered_position_contr(:, 3), 3, filtered_time_acc, 'filled');
title('Left Controller 3D Visual From Accelerometer Data');
xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
cb = colorbar('eastoutside');
colormap(jet);
cb.Label.String = 'Time (seconds)';

% Plot the 3D trajectory with a color gradient representing time
figure;
scatter3(filtered_position_contr_other(:, 1), filtered_position_contr_other(:, 2), filtered_position_contr_other(:, 3), 3, filtered_time_acc, 'filled');
title('Right Controller 3D Visual From Accelerometer Data');
xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
cb = colorbar('eastoutside');
colormap(jet); 
cb.Label.String = 'Time (seconds)';
%}
%% MATLAB data to CSV for Python
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure all arrays have the same length by trimming the longest arrays
acc_min_length = min([length(x_acc_peak_time_locs_wlowpass), length(y_acc_peak_time_locs_wlowpass), length(z_acc_peak_time_locs_wlowpass)]);
x_acc_peak_time_locs_wlowpass = x_acc_peak_time_locs_wlowpass(1:acc_min_length);
y_acc_peak_time_locs_wlowpass = y_acc_peak_time_locs_wlowpass(1:acc_min_length);
z_acc_peak_time_locs_wlowpass = z_acc_peak_time_locs_wlowpass(1:acc_min_length);
x_acc_peak_values_wlowpass = x_acc_peak_values_wlowpass(1:acc_min_length);
y_acc_peak_values_wlowpass = y_acc_peak_values_wlowpass(1:acc_min_length);
z_acc_peak_values_wlowpass = z_acc_peak_values_wlowpass(1:acc_min_length);

gyro_min_length = min([length(x_gyro_peak_time_locs_wlowpass), length(y_gyro_peak_time_locs_wlowpass), length(z_gyro_peak_time_locs_wlowpass)]);
x_gyro_peak_time_locs_wlowpass = x_gyro_peak_time_locs_wlowpass(1:gyro_min_length);
y_gyro_peak_time_locs_wlowpass = y_gyro_peak_time_locs_wlowpass(1:gyro_min_length);
z_gyro_peak_time_locs_wlowpass = z_gyro_peak_time_locs_wlowpass(1:gyro_min_length);
x_gyro_peak_values_wlowpass = x_gyro_peak_values_wlowpass(1:gyro_min_length);
y_gyro_peak_values_wlowpass = y_gyro_peak_values_wlowpass(1:gyro_min_length);
z_gyro_peak_values_wlowpass = z_gyro_peak_values_wlowpass(1:gyro_min_length);

left_contr_acc_min_length = min([length(x_0contr_acc_peak_time_locs_wlowpass), length(y_0contr_acc_peak_time_locs_wlowpass), length(z_0contr_acc_peak_time_locs_wlowpass)]);
x_0contr_acc_peak_time_locs_wlowpass = x_0contr_acc_peak_time_locs_wlowpass(1:left_contr_acc_min_length);
y_0contr_acc_peak_time_locs_wlowpass = y_0contr_acc_peak_time_locs_wlowpass(1:left_contr_acc_min_length);
z_0contr_acc_peak_time_locs_wlowpass = z_0contr_acc_peak_time_locs_wlowpass(1:left_contr_acc_min_length);
x_0contr_acc_peak_values_wlowpass = x_0contr_acc_peak_values_wlowpass(1:left_contr_acc_min_length);
y_0contr_acc_peak_values_wlowpass = y_0contr_acc_peak_values_wlowpass(1:left_contr_acc_min_length);
z_0contr_acc_peak_values_wlowpass = z_0contr_acc_peak_values_wlowpass(1:left_contr_acc_min_length);

left_contr_gyro_min_length = min([length(x_0contr_gyro_peak_time_locs_wlowpass), length(y_0contr_gyro_peak_time_locs_wlowpass), length(z_0contr_gyro_peak_time_locs_wlowpass)]);
x_0contr_gyro_peak_time_locs_wlowpass = x_0contr_gyro_peak_time_locs_wlowpass(1:left_contr_gyro_min_length);
y_0contr_gyro_peak_time_locs_wlowpass = y_0contr_gyro_peak_time_locs_wlowpass(1:left_contr_gyro_min_length);
z_0contr_gyro_peak_time_locs_wlowpass = z_0contr_gyro_peak_time_locs_wlowpass(1:left_contr_gyro_min_length);
x_0contr_gyro_peak_values_wlowpass = x_0contr_gyro_peak_values_wlowpass(1:left_contr_gyro_min_length);
y_0contr_gyro_peak_values_wlowpass = y_0contr_gyro_peak_values_wlowpass(1:left_contr_gyro_min_length);
z_0contr_gyro_peak_values_wlowpass = z_0contr_gyro_peak_values_wlowpass(1:left_contr_gyro_min_length);

right_contr_acc_min_length = min([length(x_1contr_acc_peak_time_locs_wlowpass), length(y_1contr_acc_peak_time_locs_wlowpass), length(z_1contr_acc_peak_time_locs_wlowpass)]);
x_1contr_acc_peak_time_locs_wlowpass = x_1contr_acc_peak_time_locs_wlowpass(1:right_contr_acc_min_length);
y_1contr_acc_peak_time_locs_wlowpass = y_1contr_acc_peak_time_locs_wlowpass(1:right_contr_acc_min_length);
z_1contr_acc_peak_time_locs_wlowpass = z_1contr_acc_peak_time_locs_wlowpass(1:right_contr_acc_min_length);
x_1contr_acc_peak_values_wlowpass = x_1contr_acc_peak_values_wlowpass(1:right_contr_acc_min_length);
y_1contr_acc_peak_values_wlowpass = y_1contr_acc_peak_values_wlowpass(1:right_contr_acc_min_length);
z_1contr_acc_peak_values_wlowpass = z_1contr_acc_peak_values_wlowpass(1:right_contr_acc_min_length);

right_contr_gyro_min_length = min([length(x_1contr_gyro_peak_time_locs_wlowpass), length(y_1contr_gyro_peak_time_locs_wlowpass), length(z_1contr_gyro_peak_time_locs_wlowpass)]);
x_1contr_gyro_peak_time_locs_wlowpass = x_1contr_gyro_peak_time_locs_wlowpass(1:right_contr_gyro_min_length);
y_1contr_gyro_peak_time_locs_wlowpass = y_1contr_gyro_peak_time_locs_wlowpass(1:right_contr_gyro_min_length);
z_1contr_gyro_peak_time_locs_wlowpass = z_1contr_gyro_peak_time_locs_wlowpass(1:right_contr_gyro_min_length);
x_1contr_gyro_peak_values_wlowpass = x_1contr_gyro_peak_values_wlowpass(1:right_contr_gyro_min_length);
y_1contr_gyro_peak_values_wlowpass = y_1contr_gyro_peak_values_wlowpass(1:right_contr_gyro_min_length);
z_1contr_gyro_peak_values_wlowpass = z_1contr_gyro_peak_values_wlowpass(1:right_contr_gyro_min_length);

% Combine the time and peak values into a single matrix
acc_peak_data_matrix = [x_acc_peak_time_locs_wlowpass, x_acc_peak_values_wlowpass, y_acc_peak_values_wlowpass, z_acc_peak_values_wlowpass];
gyro_peak_data_matrix = [x_gyro_peak_time_locs_wlowpass, x_gyro_peak_values_wlowpass, y_gyro_peak_values_wlowpass, z_gyro_peak_values_wlowpass];
left_contr_acc_peak_data_matrix = [x_0contr_acc_peak_time_locs_wlowpass, x_0contr_acc_peak_values_wlowpass, y_0contr_acc_peak_values_wlowpass, z_0contr_acc_peak_values_wlowpass];
left_contr_gyro_peak_data_matrix = [x_0contr_gyro_peak_time_locs_wlowpass, x_0contr_gyro_peak_values_wlowpass, y_0contr_gyro_peak_values_wlowpass, z_0contr_gyro_peak_values_wlowpass];
right_contr_acc_peak_data_matrix = [x_1contr_acc_peak_time_locs_wlowpass, x_1contr_acc_peak_values_wlowpass, y_1contr_acc_peak_values_wlowpass, z_1contr_acc_peak_values_wlowpass];
right_contr_gyro_peak_data_matrix = [x_1contr_gyro_peak_time_locs_wlowpass, x_1contr_gyro_peak_values_wlowpass, y_1contr_gyro_peak_values_wlowpass, z_1contr_gyro_peak_values_wlowpass];

% Write the matrix to a CSV file
csvwrite([output_folder 'headset_acceleration_new_peak_data.csv'], acc_peak_data_matrix);
csvwrite([output_folder 'headset_gyroscope_new_peak_data.csv'], gyro_peak_data_matrix);
csvwrite([output_folder 'left_contr_acceleration_new_peak_data.csv'], left_contr_acc_peak_data_matrix);
csvwrite([output_folder 'left_contr_gyroscope_new_peak_data.csv'], left_contr_gyro_peak_data_matrix);
csvwrite([output_folder 'right_contr_acceleration_new_peak_data.csv'], right_contr_acc_peak_data_matrix);
csvwrite([output_folder 'right_contr_gyroscope_new_peak_data.csv'], right_contr_gyro_peak_data_matrix);
%%









%{
%% Graphs using 'smooth' and 'lowpass' functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% X-axis accelerometer
subplot(3,1,1);
plot(time_acc(1:num_data_pts_acc), x_acc_lowpass);
title({'Graphs Using "smooth" and "lowpass" Functions';'X-Axis Accelerometer'});
xlim([0, 20]);
hold on;
% Y-axis accelerometer
subplot(3,1,2);
plot(time_acc(1:num_data_pts_acc), y_acc_lowpass);
ylabel('\bf{Acc (m/s^2)}');
title('Y-Axis Accelerometer');
xlim([0, 20]);
hold on;
% Z-axis accelerometer
subplot(3,1,3);
plot(time_acc(1:num_data_pts_acc), z_acc_lowpass);
title('Z-Axis Accelerometer');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure;
% X-axis gyroscope
subplot(3,1,1);
plot(time_gyro(1:num_data_pts_gyro), x_gyro_lowpass);
title({'Graphs Using "smooth" and "lowpass" Functions';'X-Axis Gyroscope'});
xlim([0, 20]);
hold on;
% Y-axis gyroscope
subplot(3,1,2);
plot(time_gyro(1:num_data_pts_gyro), y_gyro_lowpass);
ylabel('\bf{Ang (deg/s)}');
title('Y-Axis Gyroscope');
xlim([0, 20]);
hold on;
% Z-axis gyroscope
subplot(3,1,3);
plot(time_gyro(1:num_data_pts_gyro), z_gyro_lowpass);
title('Z-Axis Gyroscope');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');
%%
%}










%{
%% Graphs using 'smooth' function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% X-axis accelerometer
subplot(3,1,1);
plot(time_acc(1:num_data_pts_acc), x_acc_smooth(1:num_data_pts_acc));
title({'Graphs Using "smooth" Function';'X-Axis Accelerometer'});
xlim([0, 20]);
hold on;
% Y-axis accelerometer
subplot(3,1,2);
plot(time_acc(1:num_data_pts_acc), y_acc_smooth(1:num_data_pts_acc));
ylabel('\bf{Acc (m/s^2)}');
title('Y-Axis Accelerometer');
xlim([0, 20]);
hold on;
% Z-axis accelerometer
subplot(3,1,3);
plot(time_acc(1:num_data_pts_acc), z_acc_smooth(1:num_data_pts_acc));
title('Z-Axis Accelerometer');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure;
% X-axis gyroscope
subplot(3,1,1);
plot(time_gyro(1:num_data_pts_gyro), x_gyro_smooth(1:num_data_pts_gyro));
title({'Graphs Using "smooth" Function';'X-Axis Gyroscope'});
xlim([0, 20]);
hold on;
% Y-axis gyroscope
subplot(3,1,2);
practice = plot(time_gyro(1:num_data_pts_gyro), y_gyro_smooth(1:num_data_pts_gyro));
ylabel('\bf{Ang (deg/s)}')
title('Y-Axis Gyroscope');
xlim([0, 20]);
hold on;
% Z-axis gyroscope
subplot(3,1,3);
plot(time_gyro(1:num_data_pts_gyro), z_gyro_smooth(1:num_data_pts_gyro));
title('Z-Axis Gyroscope');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');
%}









%{
%% Graphs using no functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % For accelerometer
% X-axis accelerometer 
subplot(3,1,1);
plot(time_acc(1:num_data_pts_acc), x_acc(1:num_data_pts_acc));
title({"Graphs Using No Functions";'X-Axis Accelerometer'});
xlim([0, 20]);
hold on;
% Y-axis accelerometer
subplot(3,1,2);
plot(time_acc(1:num_data_pts_acc), y_acc(1:num_data_pts_acc));
ylabel('\bf{Acc (m/s^2)}');
title('Y-Axis Accelerometer');
xlim([0, 20]);
hold on;
% Z-axis accelerometer
subplot(3,1,3);
plot(time_acc(1:num_data_pts_acc), z_acc(1:num_data_pts_acc));
title('Z-Axis Accelerometer');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');

figure;
% X-axis gyroscope
subplot(3,1,1);
plot(time_gyro(1:num_data_pts_gyro), x_gyro(1:num_data_pts_gyro));
title({"Graphs Using No functions";'X-Axis Gyroscope'});
xlim([0, 20]);
hold on;
% Y-axis gyroscope
subplot(3,1,2);
plot(time_gyro(1:num_data_pts_gyro), y_gyro(1:num_data_pts_gyro));
ylabel('\bf{Ang (deg/s)}')
title('Y-Axis Gyroscope');
xlim([0, 20]);
hold on;
% Z-axis gyroscope
subplot(3,1,3);
plot(time_gyro(1:num_data_pts_gyro), z_gyro(1:num_data_pts_gyro));
title('Z-Axis Gyroscope');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');
%%
%}









%{
%% How to plot two plots in one 
figure
plot(time_gyro(1:num_data_pts_gyro), x_gyro(1:num_data_pts_gyro));
hold on
plot(time_gyro(1:num_data_pts_gyro), x_gyro_smooth(1:num_data_pts_gyro));
legend('original','clean')
title('Gyroscope in X-axis');
xlim([0, 20]);
xlabel('\bf{Time (seconds)}');
%}
