% This function builds butterworth filters based upon the cut-off
% frequencies provided in the input.
% 
% Input: corners - corner frequencies of vocoder - p x 2 matrix
%        fs - sampling frequency - integer
%        order - order of Butterworth filter - positive integer
% 
% Output: filterparams - parameters for butterworth filter - structure
% 
% Sean R. Anderson -- sean.hearing@gmail.com -- 081822

function filterparams = BuildChannelFilters(corners,fs,order)

% Default to fourth order butterworth
if ~exist('order','var')
    order = 4;
end

d = 0.5 * fs;

% Build filters for vocoding
for ii = 1:length(corners)
    [filterparams.B(:,ii), filterparams.A(:,ii)] = ... 
        butter(order, [corners(ii,1)/d corners(ii,2)/d]);
end

end