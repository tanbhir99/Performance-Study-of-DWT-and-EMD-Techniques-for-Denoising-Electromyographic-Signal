close all
clear variables
clc
%% Signal loading:

datapath = "RifatEEE2-L01.mat";

[noise_signal, signal, noise] = signaGeneration(datapath, -2);

%% EMD technique:

[denoise_emd,tIMF,IMF] = EMDdenoiseWithWThresh(noise_signal, 0.5);

%% DWT technique:

[denoise_db3, cb1] = softThreshDWT(noise_signal,'db3', 8, 0.5);

[denoise_db4, cb] = softThreshDWT(noise_signal,'db4', 8, 0.5);

%% Parameter Comparison:

[snrs, mse] = paraComp(signal, noise_signal);
[snrs_emd, mse_emd] = paraComp(signal, denoise_emd);
[snrs_db3, mse_db3] = paraComp(signal, denoise_db3);
[snrs_db4, mse_db4] = paraComp(signal, denoise_db4);

disp("SNR before denoising: ");
fprintf('%.3f\n\n', snrs);
disp("SNR after EMD: ");
fprintf('%.3f\n\n', snrs_emd);
disp("SNR after DWT 'db3': ");
fprintf('%.3f\n\n', snrs_db3);
disp("SNR after DWT 'db4': ");
fprintf('%.3f\n\n', snrs_db4);

disp("MSE before denoising: ");
fprintf('%.4f\n\n', mse);
disp("MSE after EMD: ");
fprintf('%.4f\n\n', mse_emd);
disp("MSE after DWT 'db3': ");
fprintf('%.4f\n\n', mse_db3);
disp("MSE after DWT 'db4': ");
fprintf('%.4f\n\n', mse_db4);

%% t-Test:

% test = ttest2(snrs_db3,snrs_db4);

%% Figures:

t = 1:1:length(noise_signal);
t = t / 1000;

figure
subplot(511)
plot(t,signal, 'LineWidth', 1,'Color','k');
title("2 dB Noise Level", 'FontName', 'Times New Roman','FontSize',28);
% xlim([min(t), max(t)]);
% ylim([min(db2), max(db2)]);
text(max(t)*1.01, 0, 'Exp. Signal', 'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight','bold');
set(gca, 'XTick', [], 'YTick', []);
xlim([min(t), max(t)])
box off;
% Get current axes handle 
ax = gca; 
% Adjust the position of the axes 
% Format: [left, bottom, width, height] 
current_position = ax.Position; 
ax.Position = [0.05, current_position(2), current_position(3), current_position(4)]; % Adjust only the 'left' position

subplot(512)
plot(t,noise_signal, 'LineWidth', 1,'Color','k');
% title("Experimental Signal",'FontSize',10);
text(max(t)*1.01, 0, 'Signal with noise', 'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight','bold');
set(gca, 'XTick', [], 'YTick', []);
xlim([min(t), max(t)])
box off;
% Get current axes handle 
ax = gca; 
% Adjust the position of the axes 
% Format: [left, bottom, width, height] 
current_position = ax.Position; 
ax.Position = [0.05, current_position(2), current_position(3), current_position(4)]; % Adjust only the 'left' position

subplot(513)
plot(t,denoise_emd, 'LineWidth', 1,'Color','k');
% title("EMD denoising",'FontSize',8);
text(max(t)*1.01, 0, 'EMD', 'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight','bold');
set(gca, 'XTick', [], 'YTick', []);
xlim([min(t), max(t)])
box off;
% Get current axes handle 
ax = gca; 
% Adjust the position of the axes 
% Format: [left, bottom, width, height] 
current_position = ax.Position; 
ax.Position = [0.05, current_position(2), current_position(3), current_position(4)]; % Adjust only the 'left' position

subplot(514)
plot(t,denoise_db3, 'LineWidth', 1,'Color','k');
% title("DWT with 'db3' denoising",'FontSize',8);
text(max(t)*1.01, 0, "DWT with 'db3'", 'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight','bold');
set(gca, 'XTick', [], 'YTick', []);
xlim([min(t), max(t)])
box off;
% Get current axes handle 
ax = gca; 
% Adjust the position of the axes 
% Format: [left, bottom, width, height] 
current_position = ax.Position; 
ax.Position = [0.05, current_position(2), current_position(3), current_position(4)]; % Adjust only the 'left' position

subplot(515)
plot(t,denoise_db4, 'LineWidth', 1,'Color','k');
% title("DWT with 'db4' denoising",'FontSize',8);
text(max(t)*1.01, 0, "DWT with 'db4'", 'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight','bold');
box off;
ylim([-1, 1]);
xlim([min(t), max(t)])
xlabel("Time (sec)","FontWeight","bold", 'FontName', 'Times New Roman',"FontSize",18)
% set(gca, 'Box', 'off', 'LineWidth', 2, 'XColor', 'red', 'YColor', 'red');
% Get current axes handle 
ax = gca; 
% Adjust the position of the axes 
% Format: [left, bottom, width, height] 
current_position = ax.Position; 
ax.Position = [0.05, current_position(2), current_position(3), current_position(4)]; % Adjust only the 'left' position