function gain = CalcGain(cf,audiogram)

% This function calculates the gain applied to each filter output based
% upon a linearly interpolated audiogram. 
% 
% Input: cf - edge frequencies for filterbank (Hz) - n x 1 column vector
%        audiogram - frequencies and hearing loss (dB HL) - n x 2 matrix
% 
% Output: gain - gain at each frequency in the input cf (dB HL)
% 
% Sean R. Anderson -- sean.hearing@gmail.com -- 081822

    % Estimate audiogram values for filter CFs
    gain = -interp1(audiogram(:,1),audiogram(:,2),cf);
    
    % Store estimates
    estimates = gain(~isnan(gain));
    
    % Where filter cannot be applied, set gain first/last estimate
    gain(cf < min(audiogram(:,1))) = estimates(1);
    gain(cf > max(audiogram(:,1))) = estimates(end);
    
end