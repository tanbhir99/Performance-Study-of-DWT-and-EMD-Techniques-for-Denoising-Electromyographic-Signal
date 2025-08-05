close all;
clear variables;
clc;
A_noise = 0.05;

% Parameters
fs = 1000;          % Sampling frequency (samples per second)
t = 0:1/fs:10;       % Time vector (1 second duration)
f = 5;             % Frequency of the sinusoidal signal

% Generate the sinusoidal signal
signal = 0.6 * sin(2 * pi * f * t);

% Set a portion of the signal to zero
start_flat = 4;   % Start time of flat portion (in seconds)
end_flat = 6;     % End time of flat portion (in seconds)
signal(t >= start_flat & t <= end_flat) = 0;

% Plot the signal
figure
subplot(311)
plot(t, signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sinusoidal Signal with Flat Portion');
grid on;

noise = A_noise * randn(size(signal));

signal_f = signal + noise;
subplot(312)
plot(signal_f)

%% EMD:
[imfs,res] = emd(signal_f);

% Plot the original signal and the IMFs
num_imfs = size(imfs, 2);

figure;
subplot(num_imfs+2, 1, 1);
plot(t,signal_f);
title('Original EMG Signal');

for i = 1:num_imfs
    subplot(num_imfs+2, 1, i+1);
    plot(imfs(:, i));
    title(['IMF ' num2str(i)]);
    xlabel('Time');
ylabel('Amplitude');
end

subplot(num_imfs+2,1,num_imfs+2)
plot(res);
title("Residual")

%% Soft thresholding:
r = 4000:6000;

% num_imfs = size(imfs, 2);

% For soft thresholding of IMFs:

[num_imfs, IMF_length] = size(imfs);
tIMF = zeros(num_imfs, IMF_length);
tnoise = zeros(num_imfs, IMF_length);

for i = 1:IMF_length
    noise_segment = imfs(r,i);
    t = std(noise_segment);
    a = sign(imfs(:,i));
    b = (abs(imfs(:,i)) - t);
    b(b < 0) = 0;
    tIMF(:,i) = a .* b;
    tnoise(:,i) = imfs(:,i) - tIMF(:,i);
end

figure;
subplot(IMF_length+2, 1, 1);
plot(signal_f);
title('Original EMG Signal');

for i = 1:IMF_length
    subplot(IMF_length+2, 1, i+1);
    plot(tIMF(:, i));
    title(['IMF ' num2str(i) ' After thresholding']);
    xlabel('Time');
ylabel('Amplitude');
end

subplot(IMF_length+2,1,IMF_length+2)
plot(res);
title("Residual")
%% Signal reconstruction:

denoised_signal = sum(tIMF, 2);
% residue = signal_f - denoised_signal;
noise_signal = sum(tnoise,2);

figure;
subplot(4, 1, 1);
plot(signal_f);
title('Original Signal with noise');

subplot(412)
plot(signal);
title('Original Signal without noise');

subplot(4, 1, 3);
plot(denoised_signal);
title('Denoised Signal with noise');

subplot(4, 1, 4);
plot(noise_signal);
title('Noise Signal');

snr_b = snr(signal_f, noise);
disp("SNR before EMD: ");
disp(snr_b);

snr_v = snr(denoised_signal, noise);
disp("SNR after EMD: ");
disp(snr_v);

%% Obtained from GitHub:

function EMDdenoised = EMDdenoise_onlyIMFs(IMFs, threstype, T_mult)
    % EMDdenoised  : denoised signal
    % IMFs         : Intrinsic Mode Functions (IMFs) from EMD
    % threstype    : Thresholding method ('hard', 'soft', 'softSCAD')
    % T_mult       : Multiplication factor of the universal threshold

    n = size(IMFs, 1); % Length of the signal
    nofIMFs = size(IMFs, 2); % Number of IMFs

    % Estimate noise energy for thresholding
    estimenergy_F = (median(abs(IMFs(:, 1))) / 0.6745) ^ 2;
    for k = 2:nofIMFs + 3
        estimenergy_F(k) = estimenergy_F(1) / 0.719 * 2.01 ^ (-k);
    end
    T_mult = T_mult * sqrt(2 * log(n));

    % Apply thresholding
    for k = 1:nofIMFs
        T = T_mult * sqrt(estimenergy_F(k));
        switch threstype
            case 'hard'
                IMFs(abs(IMFs(k, :)) < T, k) = 0;
            case 'soft'
                IMFs(:, k) = sign(IMFs(:, k)) .* max(abs(IMFs(:, k)) - T, 0);
            case 'softSCAD'
                % Implement SCAD thresholding here
                % Add your SCAD logic
        end
    end

    % Sum the thresholded IMFs to reconstruct the denoised signal
    EMDdenoised = sum(IMFs, 2);
end


EMDdenoised = EMDdenoise_onlyIMFs(imfs, 'soft', 0.5);

figure;
subplot(5, 1, 1);
plot(signal_f);
title('Original Signal with noise');

subplot(512)
plot(signal);
title('Original Signal without noise');

subplot(5, 1, 3);
plot(EMDdenoised);
title('Denoised Signal');

subplot(5, 1, 4);
plot(noise_signal);
title('Noise Signal');
ylim([-1 1]);

subplot(5, 1, 5);
plot(noise);
title('Original Noise Signal');
ylim([-1 1]);

% Load your .mat file
data = signal;

% Extract the matrix you want to save (replace 'yourMatrix' with the actual matrix name)
% yourMatrix = data.yourMatrix;

% Save the matrix to a .csv file
writematrix(data, 'yourfile.csv');
