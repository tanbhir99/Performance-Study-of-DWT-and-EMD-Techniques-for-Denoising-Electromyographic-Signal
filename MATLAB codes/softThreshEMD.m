%% Soft thresholding and denoising:

function [EMDdenoised, tIMF] = softThreshEMD(IMFs, T_mult)

    % EMDdenoised  : denoised signal
    % IMFs         : Intrinsic Mode Functions (IMFs) from EMD
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
         IMFs(:, k) = sign(IMFs(:, k)) .* max(abs(IMFs(:, k)) - T, 0);
    end
    % Sum the thresholded IMFs to reconstruct the denoised signal
    tIMF = IMFs;
    EMDdenoised = sum(IMFs, 2);
end