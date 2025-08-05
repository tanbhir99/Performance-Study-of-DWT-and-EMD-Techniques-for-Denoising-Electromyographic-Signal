function [EMDdenoised,tIMF,IMF] = EMDdenoiseWithWThresh(signal, T_mult)
    % EMDdenoiseWithWThresh: Perform EMD and apply wthresh for soft thresholding
    % signal    : Input noisy signal
    % nofsifts  : Number of sifting iterations for EMD
    % T_mult    : Multiplication factor for the universal threshold

    % Perform EMD (replace emdfull with your actual EMD function)
    [IMF, ~] = emd(signal); 
    nofIMFs = size(IMF, 2); % Number of IMFs

    % Estimate noise energy for thresholding
    estimenergy_F = (median(abs(IMF(:, 1))) / 0.6745) ^ 2;
    for k = 2:nofIMFs + 3
        estimenergy_F(k) = estimenergy_F(1) / 0.719 * 2.01 ^ (-k);
    end
    T_mult = T_mult * sqrt(2 * log(length(signal)));

    % Apply wthresh for soft thresholding
    for k = 1:nofIMFs
        T = T_mult * sqrt(estimenergy_F(k));
        tIMF(:, k) = wthresh(IMF(:, k), 's', T); % Soft thresholding using wthresh
    end

    % Reconstruct the denoised signal
    EMDdenoised = sum(tIMF, 2);
end