%% Soft thresholding and denoising:

function [denoisedSignal, c_before] = softThreshDWT(signal, wavelet, level, T_mult)
    % DWTdenoise: Perform DWT-based soft thresholding on a signal
    % signal    : Input noisy signal
    % wavelet   : Wavelet type (e.g., 'db1', 'sym4')
    % level     : Decomposition level
    % T_mult    : Multiplication factor for the universal threshold

    % Perform wavelet decomposition
    [C, L] = wavedec(signal, level, wavelet);
    c_before = C;

    % Calculate the universal threshold
    n = length(signal);
    sigma = median(abs(C)) / 0.6745;  % Estimate noise level
    threshold = T_mult * sigma * sqrt(2 * log(n));

    % Apply soft thresholding
    C = wthresh(C, 's', threshold);

    % Reconstruct the denoised signal
    denoisedSignal = waverec(C, L, wavelet);
end
