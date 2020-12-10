function data = istft(stft, window, noverlap, padding, varargin)
%   DATA = ISTFT(STFT, WINDOW, NOVERLAP, PADDING, ANALYSIS_WINDOW)
%
%   Computes inverse short-time fourier transform given by the STFT
% function,removing padding added by it in the process.
%
%   If analysis window is not provided, function assumes that it is the same
% as synthesis window.
%
% See also:
%   STFT, COLA_CHECK

    % Check if analysis window differs from synthesis window
    if nargin == 5
        awin = varargin{1};
    else
        awin = window;
    end
    
    nfft = size(stft, 1);
    nframes = size(stft, 2);
    frame_len = length(window);
    hop_size = frame_len - noverlap;
    
    % preallocate output
    len = nframes * (frame_len - noverlap) + noverlap;
    data = zeros(len, 1); 
    
    % process each frame
    fstart = 1;
    fend = nfft;
        
    for i = 1 : nframes
        frame = ifft(stft(:, i), nfft) .* window;
        data(fstart : fend) = data(fstart : fend) + frame;
        fstart = fstart + hop_size;
        fend = fend + hop_size;
    end
    
    % remove padding added by stft
    data = data(padding(1) + 1 : end - padding(2));
    
    % remove amplitude gain induced by windowing
    data = data * hop_size / (awin' * window);

end