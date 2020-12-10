close all
fs = 1e3;
t = 0 : 1/fs : 0.5;
x = exp(-3 * t) .* sin (2 * pi * 50 .* t);
x = sin (2 * pi * 50 .* t);

frame_len = 128;
noverlap = 96;
% noverlap = frame_len - 1;
win = window('hann', frame_len, 'periodic');
win2 = window('hamming', frame_len, 'periodic');

cola_check(win.*win2, noverlap, 5)

awin = win;
swin = win2;

[S, padding] = stft(x, awin, noverlap);
x_i = istft(S, swin, noverlap, padding, awin);

figure()
plot(t, x, 'b', t, x_i, 'r--')
legend('Originalni signal', 'Rekonstruisani signal')