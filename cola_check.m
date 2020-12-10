function [] = cola_check(window, noverlap, K)
%   COLA_CHECK(WINDOW, NOVERLAP, K)
%
%   Constant overlap-add check.
%   Visually check if provided window has constant gain during overlap-add
% process.
%
%   Function constructs K windows which are overlapping by NOVERLAP samples,
% then plots them along with sum of all windows in a new figure.
%
%   Window is COLA if the top of the sum line (red) is flat. To check if
% perfect reconstruction requirements are satisfied for STFT and ISTFT, the
% argument of this function should be element-by-element product of analysis
% window (used in STFT) and synthesis window (used in ISTFT)
%
% See also:
%   STFT, ISTFT

    frame_len = length(window);
    hop_size = frame_len - noverlap;
    len = (frame_len - noverlap) * K + noverlap;

    ola = zeros(len, 1);
    
    % process each frame
    fstart = 1;
    fend = frame_len;   
    figure, hold on
    for i = 1 : K
        frame = [zeros(fstart - 1, 1); window; zeros(len - fend, 1)];
        ola = ola + frame;
        plot(frame, 'b');
        fstart = fstart + hop_size;
        fend = fend + hop_size;
    end    
    plot(ola, 'r');

end

