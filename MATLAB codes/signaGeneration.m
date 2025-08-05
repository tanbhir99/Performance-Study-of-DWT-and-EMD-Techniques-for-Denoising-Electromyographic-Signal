%% Signal load and noise generation:

function [noise_signal, signal, noise] = signaGeneration(datapath, snr)

    % datapath = path where the original signal is stored
    % noise_amp = the amplitude of the noise signal compared to the original signal (<1)
    % noise_segment = the segment range where it has only noise element
    % noise_signal = returned the signal mixed with artificial noise
    % signal = returned the original raw signal
    % noise = returned only generated noise

    signal_load = load(datapath);
    signal_load = signal_load.data;
    signal_load = signal_load(:,2);
    signal1 = signal_load / max(abs(signal_load));
    signaldc = mean(signal1);
    signal = signal1 - signaldc;

    % A_noise = noise_amp * max(abs(signal));
    % noise = A_noise * randn(size(signal));
    % noise_signal = signal + noise;

    noise_signal = awgn(signal, snr, "measured");
    noise = noise_signal - signal;
end