close all
clear variables
clc
%% Signal loading:

datapath = "RifatEEE2-L01.mat";
noise_level_snr = -2;   % Initial noise level
increment_snr = 1;      % Increment of noise level with each loop
M = 6;                  % No. of loops with different noise level. Indicates how much noise level is taken
N = 25;                 % No. of readings per noise level. Like, 'N' number of readings taken for a specific 'M' No.
v = zeros(M,1);         % Indicates different taken noise levels.
snr_emd = zeros(M,1);
snr_db3 = zeros(M,1);
snr_db4 = zeros(M,1);
mse_emd = zeros(M,1);
mse_db3 = zeros(M,1);
mse_db4 = zeros(M,1);
ext_emd = zeros(M,1);
ext_db3 = zeros(M,1);
ext_db4 = zeros(M,1);
t_test_ed3 = zeros(M,1);
t_test_ed4 = zeros(M,1);
t_test_d34 = zeros(M,1);

snr = zeros(N,3);
mse = zeros(N,3);
ext = zeros(N,3);

for j = 1:M
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
[snrs_emd, mse1_emd] = paraComp(signal, denoise_emd);
[snrs_db3, mse1_db3] = paraComp(signal, denoise_db3);
[snrs_db4, mse1_db4] = paraComp(signal, denoise_db4);

snr(i,1) = snrs_emd;
snr(i,2) = snrs_db3;
snr(i,3) = snrs_db4;

mse(i,1) = mse1_emd;
mse(i,2) = mse1_db3;
mse(i,3) = mse1_db4;

end
%% t-Test:

% SNR comparison:
[h_e_d3,p_e_d3] = ttest2(snr(:,1), snr(:,2));
[h_e_d4,p_e_d4] = ttest2(snr(:,1), snr(:,3));
[h_d4_d3,p_d4_d3] = ttest2(snr(:,3), snr(:,2));

disp(newline);
fprintf('<strong>SNR comparison:</strong>\n');
X1 = ['t-Test between emd and db3 (p-value, h-value): ', num2str(p_e_d3),' , ', num2str(h_e_d3)];
% disp(X1);
X2 = ['t-Test between emd and db4 (p-value, h-value): ', num2str(p_e_d4),' , ', num2str(h_e_d4)];
% disp(X2);
X3 = ['t-Test between db4 and db3 (p-value, h-value): ', num2str(p_d4_d3),' , ', num2str(h_d4_d3), newline];
% disp(X3);

m1 = mean(snr(:,1));
m2 = mean(snr(:,2));
m3 = mean(snr(:,3));
snr_emd(j,1) = m1;
snr_db3(j,1) = m2;
snr_db4(j,1) = m3;
t_test_ed3(j,1) = p_e_d3;
t_test_ed4(j,1) = p_e_d4;
t_test_d34(j,1) = p_d4_d3;

% MSE comparison:
[h_e_d3,p_e_d3] = ttest2(mse(:,1), mse(:,2));
[h_e_d4,p_e_d4] = ttest2(mse(:,1), mse(:,3));
[h_d4_d3,p_d4_d3] = ttest2(mse(:,3), mse(:,2));

disp(newline);
fprintf('<strong>MSE comparison:</strong>\n');
Y1 = ['t-Test between emd and db3 (p-value, h-value): ', num2str(p_e_d3),' , ', num2str(h_e_d3)];
% disp(Y1);
Y2 = ['t-Test between emd and db4 (p-value, h-value): ', num2str(p_e_d4),' , ', num2str(h_e_d4)];
% disp(Y2);
Y3 = ['t-Test between db4 and db3 (p-value, h-value): ', num2str(p_d4_d3),' , ', num2str(h_d4_d3), newline];
% disp(Y3);

m1 = mean(mse(:,1));
m2 = mean(mse(:,2));
m3 = mean(mse(:,3));
mse_emd(j,1) = m1;
mse_db3(j,1) = m2;
mse_db4(j,1) = m3;

% Execution Time comparison:
[h_e_d3,p_e_d3] = ttest2(ext(:,1), ext(:,2));
[h_e_d4,p_e_d4] = ttest2(ext(:,1), ext(:,3));
[h_d4_d3,p_d4_d3] = ttest2(ext(:,3), ext(:,2));

disp(newline);
fprintf('<strong>Execution Time comparison:</strong>\n');
Z1 = ['t-Test between emd and db3 (p-value, h-value): ', num2str(p_e_d3),' , ', num2str(h_e_d3)];
% disp(Z1);
Z2 = ['t-Test between emd and db4 (p-value, h-value): ', num2str(p_e_d4),' , ', num2str(h_e_d4)];
% disp(Z2);
Z3 = ['t-Test between db4 and db3 (p-value, h-value): ', num2str(p_d4_d3),' , ', num2str(h_d4_d3), newline];
% disp(Z3);

m1 = mean(ext(:,1));
m2 = mean(ext(:,2));
m3 = mean(ext(:,3));
ext_emd(j,1) = m1;
ext_db3(j,1) = m2;
ext_db4(j,1) = m3;
v(j,1) = noise_level_snr;
noise_level_snr = noise_level_snr + increment_snr;
end

% SNR = [snr_emd;snr_db3;snr_db4];
% MSE = [mse_emd;mse_db3;mse_db4];
% EXT = [ext_emd;ext_db3;ext_db4];

Noise_Level = num2cell(v);
snremd = num2cell(snr_emd);
mseemd = num2cell(mse_emd);
extemd = num2cell(ext_emd);
snrd3 = num2cell(snr_db3);
msed3 = num2cell(mse_db3);
extd3 = num2cell(ext_db3);
snrd4 = num2cell(snr_db4);
msed4 = num2cell(mse_db4);
extd4 = num2cell(ext_db4);

combinedata = [Noise_Level,snremd,mseemd,extemd,snrd3,msed3,extd3,snrd4,msed4,extd4];
columntitle = {'Noise Level', 'EMD (SNR)', 'EMD (MSE)', 'EMD (EXT)','db3 (SNR)','db3 (MSE)','db3 (EXT)','db4 (SNR)','db4 (MSE)','db4 (EXT)'};

T2 = cell2table(combinedata, 'VariableNames',columntitle);

% Display the table
disp(T2);

data_snr = [mean(snr(:,1)), mean(snr(:,2)), mean(snr(:,3))];
columnTitles = {'EMD', 'DWT (db3)', 'DWT (db4)'};
dataTable = array2table(data_snr, 'VariableNames', columnTitles);
filePath = 'E:\Academics\4-1\Thesis\Conference CUET\MATLAB codes\Parameter Comparisons.xlsx';
writetable(T2, filePath);

%% Figures:

t = 1:1:length(noise_signal);
t = t / 1000;

figure
subplot(511)
plot(t,signal, 'LineWidth', 1,'Color','k');
titleText = sprintf('%d dB Noise Level', noise_level_snr - increment_snr);
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
