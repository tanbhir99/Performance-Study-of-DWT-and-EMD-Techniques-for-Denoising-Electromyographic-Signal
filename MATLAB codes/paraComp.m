%% Parameter Comparison parameter:

function [snrs, mse] = paraComp(original_signal, denoised_signal)

     %Calculating Signal to Noise Ration (SNR)
    snrs = snr(original_signal, (original_signal - denoised_signal));

    % Calculate Mean Square Error (MSE)
    mse = mean((original_signal - denoised_signal).^2);

end