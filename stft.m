function [ S, padding ] = stft(data, window, noverlap)
%   [S, PADDING] = STFT(DATA, WINDOW, NOVERLAP)
%
%   Computes a perfect reconstruction short-time fourier transform using
% provided window with NOVERLAP overlapping samples between consecutive
% windows.
%   Perfect reconstruction is only possible if using complementary ISTFT
% function with appropriate analysis and synthesis windows. See COLA_CHECK
% for details.
%   Original signal is pre-padded and post-padded with zeros allowing entire
% signal to be reconstructed. Padding is used as an argument by the ISTFT
% fuction
%
% See also:
%   ISTFT, COLA_CHECK

    % assert input signal as a column vector
    data = data(:);
    
    frame_len = length(window);
    nfft = frame_len;
    hop_size = frame_len - noverlap;
    
    % check input parameters
    if noverlap > frame_len || noverlap < 0
        error('stft: noverlap must be smaller than window size');
    end   

    % find number of frames
    nframes = (length(data) - noverlap) / hop_size;
    
    % assert integer number of frames in order to obtain same-length reconstruction
    padding = [0; 0];
    if round(nframes) ~= nframes
        padding(2) = (frame_len - noverlap) * ceil(nframes) + noverlap - length(data);       
    end
       
    % add padding from both sides in order to remove edge-effecs
    padding = padding + ceil(noverlap / hop_size) * hop_size;
    data = cat(1, zeros(padding(1), 1), data, zeros(padding(2),1));
    nframes = (length(data) - noverlap) / hop_size;
    
    % prealocate output
    S = zeros(nfft, nframes);
    
    % process each frame
    fstart = 1;
    fend = frame_len;    
    for i = 1 : nframes
        frame = data(fstart : fend) .* window;
        S(:, i) = fft(frame, nfft);
        fstart = fstart + hop_size;
        fend = fend + hop_size;
    end
   
end

