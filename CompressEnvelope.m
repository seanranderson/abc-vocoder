% This function applies compression to the vocoded envelope by multiplying
% it by some ratio of its original value (between 0 and 1) and ensuring
% that the mean voltage in dB remains equal to the original signal.
% 
% Input: env - original envelope - length q row vector
%        compressionratio - dynamic range - real number between [0,1]
% 
% Output: env - compressed envelope - length q row vector
% 
% Sean R. Anderson -- sean.hearing@gmail.com -- 081822

function env = CompressEnvelope(env,compressionratio)

    % Shift entire envelope to positive values to prevent imaginary numbers
    min_correct = min(env);
    % Convert to dB
    dB = 20 * log10(env - min_correct + 0.001);
    % Store mean to correct later
    mean_dB = mean(dB);
    % Apply compression
    dB = compressionratio * dB;
    % Calculate gain required to reach same mean
    dB_gaincorrect = mean_dB - mean(dB);
    % Correct compression
    dB = dB + dB_gaincorrect;
    % Convert back to correct amplitude
    dB = dB - min_correct;
    % Convert back to ~actual values
    env = 10.^(dB/20) - 0.001;

end