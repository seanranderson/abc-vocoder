% This is the workhorse function used for vocoding.
% 
% Input: wavfile - path and filename of stimulus to be vocoded - string
%        cf - range of frequencies to be used - 1 x 2 column vector
%        audiogram - frequencies and hearing loss (dB HL) - m x 2 matrix
%        spread - amount of channel overlap in dB/ERB - empty or double
%        compressionratio - dynamic range - real number between [0,1]
%        fs - desired output sampling rate - integer
% 
% Output: vocoded_signal - vocoded signal RMS equalized to input - j x 1 row vector
%         t - time vector for plotting - 1 x j column vector
% 
% Sean R. Anderson -- sean.hearing@gmail.com -- 081822

function [vocoded_signal,t] = Vocode(wavfile,cf,audiogram,spread,compressionratio,fs)

if ~exist('cf','var')
    cf = [250 10000];
end

if cf(1) < 250
   warning('Vocoder may not work! Gets weird artefact below 250 Hz');
end

%% 1. Calculate ERB edges
[corners,centers] = ERBFilters(cf);

%% 2. Calculate butterworth parameters
filterparams = BuildChannelFilters(corners,fs,4);

%% 3. Determine gain based on audiogram input
gain = CalcGain(centers,audiogram);

%% 4. Filter signals
[y,ifs] = audioread(wavfile);

if ifs ~= fs
    % Resample if there is a mismatch
    y = resample(y,fs,ifs);
end

for ii = 1:length(centers)
    % Bandpass filter each channel
    channel_signal(ii,:) = filter(filterparams.B(:,ii),...
        filterparams.A(:,ii),y);
    
    % Rectify
    channel_signal(ii,:) = 0.5*(abs(channel_signal(ii,:))+channel_signal(ii,:));
    
end

%% 5. Apply audiogram gain
for ii = 1:length(centers)
    channel_signal(ii,:) = channel_signal(ii,:) * 10^(gain(ii)/20);
end
    
%% 6. Introduce spread
if ~isempty(spread)
    if spread <= 0
        for ii = 1:length(centers)
            channel_signal(ii,:) = SimulateSpread(channel_signal,ii,spread);
        end
    else
        error('Broadness must be less than or equal to zero!');
    end
end
    
%% 7. Extract envelope
d = 0.5 * fs;
[B, A] = butter(2, 300/d, 'low');
for ii = 1:length(centers)    
    env(ii,:) = filtfilt(B, A, channel_signal(ii,:));
end

%% 8. Compress envelope
if compressionratio >= 0 && compressionratio < 1
    % Compress signal using technique adopted from Winn code in Praat
    for ii = 1:length(centers)
        env(ii,:) = CompressEnvelope(env(ii,:),compressionratio);
    end
elseif compressionratio == 1
    % Move minimum to zero to be consistent with compression
    for ii = 1:length(centers)
        env(ii,:) = env(ii,:) - min(env(ii,:));
    end
else
    error('Compression ratio entered incorrectly!');
end

%% 9. Multiply envelope by carrier
t = 1/fs : 1/fs : length(env(1,:))/fs;
for ii = 1:length(centers)
    channel_output(ii,:) = env(ii,:) .* sin(2 * pi * centers(ii) * t);
end

%% 10. Sum 
% Sum over vocoded channels
vocoded_signal = sum(channel_output,1);
% Calculate gain re: original signal
vocode_gain = 20*log10(rms(y)) - 20*log10(rms(vocoded_signal));
% Set RMS energy equal to input
vocoded_signal = 10 ^ (vocode_gain/20) * vocoded_signal;

end