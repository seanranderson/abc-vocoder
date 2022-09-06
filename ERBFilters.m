% This function calculates the center and cut-off frequencies for
% ERB-spaced filters between the two end points provided by the input
% argument in Hz.
% 
% Input: cf - range of frequencies to be used - 1 x 2 column vector
% 
% Output: corners - edges of vocoder channels - p x 2 matrix
%         Hz_centers - center frequencies of vocoder channels - p x 1 row vector
% 
% Sean R. Anderson -- sean.hearing@gmail.com -- 081822

function [corners,Hz_centers] = ERBFilters(cf)

    % Formulas from: https://www.mathworks.com/help/audio/ref/hz2erb.html
        % Also appear in Moore & Glasberg (1990)
    % Calculate constant
    A = (1000 * log(10)) / (24.7 * 4.37);
    % Convert edges to ERBs
    ERB_bounds = A * log10(1 + cf * 0.00437);
    % Round to nearest ERB
    ERB_bounds = round(ERB_bounds);
    % Create evenly spaced ERB vector
    ERB_centers = ERB_bounds(1) : ERB_bounds(2);
    % Calculate CFs of filters
    Hz_centers = (10 .^ (ERB_centers/A) - 1)/0.00437;

    % Create filters based upon CFs
    for ii = 1:length(Hz_centers)
        corners(ii,1) = Hz_centers(ii) - 24.7 * (4.37 * Hz_centers(ii)/1000);
        corners(ii,2) = Hz_centers(ii) + 24.7 * (4.37 * Hz_centers(ii)/1000);
    end

end