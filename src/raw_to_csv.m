clc; close all; clear;
%% Setup
input_folder = 'C:\Users\dirky\Desktop\OculusNew\Oculus\VrSamples\VrCubeWorld_NativeActivity\Projects\Android\WINLAB\motion_data\raw_oculus_data\head\head_right\';
output_folder_base = 'C:\Users\dirky\Desktop\OculusNew\Oculus\VrSamples\VrCubeWorld_NativeActivity\Projects\Android\WINLAB\motion_data\csv_oculus_data\head\head_right\';
Fs = 1000;
Fc = 30; % Cutoff frequency for lowpass filter 
format longG

for trial = 1:250
    %% File Paths
    file = sprintf('trial%d.txt', trial);
    output_folder = fullfile(output_folder_base, sprintf('trial%d', trial));
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    
    filename = fullfile(input_folder, file);
    
    %% Read Data
    fid = fopen(filename);
    tline = fgetl(fid);

    % Initialize arrays to store accelerometer and gyroscope data
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
        tline = fgetl(fid);
        if tline == -1
            break
        end

        strings = strsplit(tline,' ');
        if size(strings,2) < 5
            continue
        end

        if strcmp(char(strings(1, end-4)), 'HMDAcceleration:') == 1
            time_acc = [time_acc; str2double(char(strings(1, end-3)))];
            x_acc = [x_acc; str2double(char(strings(1, end-2)))];
            y_acc = [y_acc; str2double(char(strings(1, end-1)))];
            z_acc = [z_acc; str2double(char(strings(1, end)))];     
        elseif strcmp(char(strings(1, end-4)), 'HMDGyroscope:') == 1
            time_gyro = [time_gyro; str2double(char(strings(1, end-3)))];
            x_gyro = [x_gyro; str2double(char(strings(1, end-2)))];
            y_gyro = [y_gyro; str2double(char(strings(1, end-1)))];
            z_gyro = [z_gyro; str2double(char(strings(1, end)))];
        elseif strcmp(char(strings(1, end-4)), 'Controller0Acceleration:') == 1
            time_0contr_acc = [time_0contr_acc; str2double(char(strings(1, end-3)))];
            x_0contr_acc = [x_0contr_acc; str2double(char(strings(1, end-2)))];
            y_0contr_acc = [y_0contr_acc; str2double(char(strings(1, end-1)))];
            z_0contr_acc = [z_0contr_acc; str2double(char(strings(1, end)))];
        elseif strcmp(char(strings(1, end-4)), 'Controller0Gyroscope:') == 1
            time_0contr_gyro = [time_0contr_gyro; str2double(char(strings(1, end-3)))];
            x_0contr_gyro = [x_0contr_gyro; str2double(char(strings(1, end-2)))];
            y_0contr_gyro = [y_0contr_gyro; str2double(char(strings(1, end-1)))];
            z_0contr_gyro = [z_0contr_gyro; str2double(char(strings(1, end)))];
        elseif strcmp(char(strings(1, end-4)), 'Controller1Acceleration:') == 1
            time_1contr_acc = [time_1contr_acc; str2double(char(strings(1, end-3)))];
            x_1contr_acc = [x_1contr_acc; str2double(char(strings(1, end-2)))];
            y_1contr_acc = [y_1contr_acc; str2double(char(strings(1, end-1)))];
            z_1contr_acc = [z_1contr_acc; str2double(char(strings(1, end)))];
        elseif strcmp(char(strings(1, end-4)), 'Controller1Gyroscope:') == 1
            time_1contr_gyro = [time_1contr_gyro; str2double(char(strings(1, end-3)))];
            x_1contr_gyro = [x_1contr_gyro; str2double(char(strings(1, end-2)))];
            y_1contr_gyro = [y_1contr_gyro; str2double(char(strings(1, end-1)))];
            z_1contr_gyro = [z_1contr_gyro; str2double(char(strings(1, end)))];
        end
    end
    fclose(fid);
    
    %% Data Processing
    % Offset Calculation
    offset = min(time_acc(1), time_gyro(1));
    offset_0contr = min(time_0contr_acc(1), time_0contr_gyro(1));
    offset_1contr = min(time_1contr_acc(1), time_1contr_gyro(1));

    time_acc = time_acc - offset;
    time_gyro = time_gyro - offset;
    time_0contr_acc = time_0contr_acc - offset_0contr;
    time_0contr_gyro = time_0contr_gyro - offset_0contr;
    time_1contr_acc = time_1contr_acc - offset_1contr;
    time_1contr_gyro = time_1contr_gyro - offset_1contr;

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

    %% Data Export
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
    csvwrite(fullfile(output_folder, 'headset_acceleration.csv'), acc_peak_data_matrix);
    csvwrite(fullfile(output_folder, 'headset_gyroscope.csv'), gyro_peak_data_matrix);
    csvwrite(fullfile(output_folder, 'left_contr_acceleration.csv'), left_contr_acc_peak_data_matrix);
    csvwrite(fullfile(output_folder, 'left_contr_gyroscope.csv'), left_contr_gyro_peak_data_matrix);
    csvwrite(fullfile(output_folder, 'right_contr_acceleration.csv'), right_contr_acc_peak_data_matrix);
    csvwrite(fullfile(output_folder, 'right_contr_gyroscope.csv'), right_contr_gyro_peak_data_matrix);
end
