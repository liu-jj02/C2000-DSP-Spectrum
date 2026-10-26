function [f, A] = my_spectrum(x, fs)
%MY_SPECTRUM 单边幅度谱
%   x  : 采样序列      fs : 采样率 (Hz)
%   f  : 频率轴 (Hz)   A  : 单边幅度（对应正弦的峰值）

N = numel(x);
X = fft(x(:)) / N;              % 归一化：除以点数
k = 1 : floor(N/2) + 1;         % 0 ~ fs/2
A = abs(X(k));
A(2:end) = 2 * A(2:end);        % 单边谱：除 DC 外乘 2
if mod(N,2) == 0
    A(end) = A(end) / 2;        % 偶数点：Nyquist 那个 bin 不能乘 2
end
f = (k-1)' * (fs/N);
end