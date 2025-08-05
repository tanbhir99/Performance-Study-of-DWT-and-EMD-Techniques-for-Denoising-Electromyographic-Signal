close all
clear variables
clc
%% Signal loading:

datapath = "RifatEEE2-L01.mat";
noise_level_snr = 0;
N = 25;
snr = zeros(N,3);
mse = zeros(N,3);
ext = zeros(N,3);

for i = 1:N
[noise_signal, signal, noise] = signaGeneration(datapath, noise_level_snr);

%% EMD technique:
tic
[denoise_emd,tIMF,IMF] = EMDdenoiseWithWThresh(noise_signal, 0.5);
ext(i,1) = toc * 1000;
%% DWT technique:
tic
[denoise_db3, cb1] = softThreshDWT(noise_signal,'db3', 8, 0.5);
ext(i,2) = toc * 1000;

tic
[denoise_db4, cb] = softThreshDWT(noise_signal,'db4', 8, 0.5);
ext(i,3) = toc * 1000;
%% Parameter Comparison:

[snrs, mses] = paraComp(signal, noise_signal);
[snrs_emd, mse_emd] = paraComp(signal, denoise_emd);
[snrs_db3, mse_db3] = paraComp(signal, denoise_db3);
[snrs_db4, mse_db4] = paraComp(signal, denoise_db4);

snr(i,1) = snrs_emd;
snr(i,2) = snrs_db3;
snr(i,3) = snrs_db4;

mse(i,1) = mse_emd;
mse(i,2) = mse_db3;
mse(i,3) = mse_db4;

end
%% t-Test:

% SNR comparison:
[h_e_d3,p_e_d3] = ttest2(snr(:,1), snr(:,2));
[h_e_d4,p_e_d4] = ttest2(snr(:,1), snr(:,3));
[h_d4_d3,p_d4_d3] = ttest2(snr(:,3), snr(:,2));

disp(newline);
fprintf('<strong>SNR comparison:</strong>\n');
X1 = ['t-Test between emd and db3 (p-value, h-value): ', num2str(p_e_d3),' , ', num2str(h_e_d3)];
disp(X1);
X2 = ['t-Test between emd and db4 (p-value, h-value): ', num2str(p_e_d4),' , ', num2str(h_e_d4)];
disp(X2);
X3 = ['t-Test between db4 and db3 (p-value, h-value): ', num2str(p_d4_d3),' , ', num2str(h_d4_d3), newline];
disp(X3);

X4 = ['Mean snr of EMD: ', num2str(mean(snr(:,1)))];
disp(X4);
X5 = ['Mean snr of db3: ', num2str(mean(snr(:,2)))];
disp(X5);
X6 = ['Mean snr of db4: ', num2str(mean(snr(:,3)))];
disp(X6);

data_snr = [mean(snr(:,1)), mean(snr(:,2)), mean(snr(:,3))];
columnTitles = {'EMD', 'DWT (db3)', 'DWT (db4)'};
dataTable = array2table(data_snr, 'VariableNames', columnTitles);
filePath = 'E:\Academics\4-1\Thesis\Conference CUET\MATLAB codes\SNR comparison.xlsx';
writetable(dataTable, filePath);

% MSE comparison:
[h_e_d3,p_e_d3] = ttest2(mse(:,1), mse(:,2));
[h_e_d4,p_e_d4] = ttest2(mse(:,1), mse(:,3));
[h_d4_d3,p_d4_d3] = ttest2(mse(:,3), mse(:,2));

disp(newline);
fprintf('<strong>MSE comparison:</strong>\n');
Y1 = ['t-Test between emd and db3 (p-value, h-value): ', num2str(p_e_d3),' , ', num2str(h_e_d3)];
disp(Y1);
Y2 = ['t-Test between emd and db4 (p-value, h-value): ', num2str(p_e_d4),' , ', num2str(h_e_d4)];
disp(Y2);
Y3 = ['t-Test between db4 and db3 (p-value, h-value): ', num2str(p_d4_d3),' , ', num2str(h_d4_d3), newline];
disp(Y3);

Y4 = ['Mean mse of EMD: ', num2str(mean(mse(:,1)))];
disp(Y4);
Y5 = ['Mean mse of db3: ', num2str(mean(mse(:,2)))];
disp(Y5);
Y6 = ['Mean mse of db4: ', num2str(mean(mse(:,3)))];
disp(Y6);

% Execution Time comparison:
[h_e_d3,p_e_d3] = ttest2(ext(:,1), ext(:,2));
[h_e_d4,p_e_d4] = ttest2(ext(:,1), ext(:,3));
[h_d4_d3,p_d4_d3] = ttest2(ext(:,3), ext(:,2));

disp(newline);
fprintf('<strong>Execution Time comparison:</strong>\n');
Z1 = ['t-Test between emd and db3 (p-value, h-value): ', num2str(p_e_d3),' , ', num2str(h_e_d3)];
disp(Z1);
Z2 = ['t-Test between emd and db4 (p-value, h-value): ', num2str(p_e_d4),' , ', num2str(h_e_d4)];
disp(Z2);
Z3 = ['t-Test between db4 and db3 (p-value, h-value): ', num2str(p_d4_d3),' , ', num2str(h_d4_d3), newline];
disp(Z3);

Z4 = ['Mean execution time (mSec) of EMD: ', num2str(mean(ext(:,1)))];
disp(Z4);
Z5 = ['Mean execution time (mSec) of db3: ', num2str(mean(ext(:,2)))];
disp(Z5);
Z6 = ['Mean execution time (mSec) of db4: ', num2str(mean(ext(:,3)))];
disp(Z6);

%% Figures:

t = 1:1:length(noise_signal);
t = t / 1000;

figure
subplot(511)
plot(t,signal, 'LineWidth', 1,'Color','k');
titleText = sprintf('%d dB Noise Level', noise_level_snr);
title(titleText, 'FontName', 'Times New Roman','FontSize',28);
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
