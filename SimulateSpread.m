% This function introduces spread of excitation into neighboring channels
% by adding input from neighboring channels at a level according to the
% decay (in dB/ERB).
% 
% Input: channel_signal - matrix of channel-vocoded signals - p x q matrix
%        n - current channel number - 0 < integer <= n
%        decay - amount of channel overlap in dB/ERB - empty or double
% 
% Output: sig - spread-simulated vocoder channel n - length q row vector
% 
% Sean R. Anderson -- sean.hearing@gmail.com -- 081822

function sig = SimulateSpread(channel_signal,n,decay)

% Store number of channels in signal
nchans = size(channel_signal,1);

% Store number of channels above current channel number
chans_above = nchans - n;

% Store number of channels below current channel number 
chans_below = n - 1;

% Create vector of attenuation values
if decay ~= 0
    decay_vals = 10 .^ ((decay : decay : (decay * max(chans_above,chans_below)))/20);
else
    decay_vals = ones(1,nchans);
end
    
% Add spread from channels above existing channel
for ii = 1:chans_above

    % Store degraded signal
    sig(ii,:) = channel_signal(n,:) + decay_vals(ii) * channel_signal(nchans-chans_above+ii,:);

end

% Add spread from channels below existing channel
for ii = 1:chans_below
    
    % Append existing 'sig' variable
    jj = ii + chans_above;
    % Store degraded signal
    sig(jj,:) = channel_signal(n,:) + decay_vals(ii) * channel_signal(n-ii,:);
    
end

% Sum over channels
sig = sum(sig)/nchans;

end