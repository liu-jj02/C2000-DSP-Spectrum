fs = 10000; T = 0.5; N = T*fs;          % 0.5 s，Δf = 2 Hz
t = (0:N-1)/fs;

x = 1.0*sin(2*pi*1000*t) ...            % 主音，幅度 1.0
    + 0.5*sin(2*pi*2500*t) ...            % 二次成分，幅度 0.5
    + 0.3*sin(2*pi*50*t + pi/4) ...       % 低频干扰，幅度 0.3
    + 0.1*randn(size(t));                 % 白噪声

%% 用 `my_spectrum` 画出频谱
figure(1);
[f,A]=my_spectrum(x,fs);
plot(f,A);
xlabel('频率 (Hz)'); ylabel('幅度');

%% 换成 **Hann 窗**再做一次（`x .* hann(N)`），对比泄漏
N = numel(x);
w = hann(N);                     % 汉宁窗
xw = x(:) .* w / mean(w);           % 加窗 + 幅度补偿

[f, A_rect] = my_spectrum(x,  fs);
[~, A_hann] = my_spectrum(xw, fs);

figure(2);
plot(f, A_rect, 'LineWidth', 1); hold on;
plot(f, A_hann, 'LineWidth', 1, 'LineStyle', '--');
xlim([800 1200]);                % 放大看 1000 Hz 附近
xlabel('频率 (Hz)'); ylabel('幅度');
title('加窗对比：矩形窗 vs Hann 窗');
legend('矩形窗（不加窗）', 'Hann 窗'); grid on;

%% 第 3 步：dB 坐标
AdB_rect = 20*log10(A_rect + eps);
AdB_hann = 20*log10(A_hann + eps);

figure(3);
plot(f, AdB_rect, 'LineWidth', 1); hold on;
plot(f, AdB_hann, 'LineWidth', 1, 'LineStyle', '--');
ylim([-100 5]);
xlabel('频率 (Hz)'); ylabel('幅度 (dB)');
title('dB 坐标：泄漏和噪声底一目了然');
legend('矩形窗', 'Hann 窗'); grid on;

%% 

fs = 10000;
T  = 0.1;                   % ★ 观测时长缩到 0.1 s
N  = T*fs;                  % 1000 点
t  = (0:N-1)/fs;            % Δf = 10 Hz

x  = 1.0*sin(2*pi*1005*t) ...      % ★ 1005 Hz = bin 100.5，正中间！
    + 0.1*randn(size(t));

w  = hann(N);
xw = x(:) .* w / mean(w);

[f, A_rect] = my_spectrum(x,  fs);
[~, A_hann] = my_spectrum(xw, fs);

% 线性：放大到 ±40 Hz
figure;
plot(f, A_rect, 'LineWidth', 1); hold on;
plot(f, A_hann, 'LineWidth', 1, 'LineStyle', '--');
xlim([965 1045]); xlabel('频率 (Hz)'); ylabel('幅度');
legend('矩形窗', 'Hann 窗'); grid on;

% dB：同一段，看旁瓣差多少
figure;
plot(f, 20*log10(A_rect + eps), 'LineWidth', 1); hold on;
plot(f, 20*log10(A_hann + eps), 'LineWidth', 1, 'LineStyle', '--');
xlim([965 1045]); ylim([-100 5]);
xlabel('频率 (Hz)'); ylabel('幅度 (dB)');
legend('矩形窗', 'Hann 窗'); grid on;