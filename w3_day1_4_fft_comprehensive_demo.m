t = 0 : 1e-5 : 2e-3;              % 2 ms
x1 = sin(2*pi*1000*t);                      % 只有基波
x3 = x1 + sin(2*pi*3000*t)/3;               % 加 3 次
x5 = x3 + sin(2*pi*5000*t)/5;               % 加 5 次
x7 = x5 + sin(2*pi*7000*t)/7;               % 加 7 次

plot(t*1e3, [x1; x3; x5; x7]');
legend('1 次','1+3 次','1+3+5 次','1+3+5+7 次');
xlabel('时间 (ms)'); grid on;

t  = 0 : 1e-6 : 2e-3;
f0 = 1000;

for nterm = [3 11 51]
    x = zeros(size(t));
    for n = 1:2:nterm                 % 只取奇次
        x = x + sin(2*pi*n*f0*t)/n;
    end
    x = x * 4/pi;                     % 方波的傅里叶系数是 4/(nπ)
    figure; plot(t*1e3, x); ylim([-1.4 1.4]);
    title(sprintf('%d 次谐波', nterm)); xlabel('时间 (ms)'); grid on;
end

%检验fft模板的例子
fs = 1000; N = 1000;
t = (0:N-1)/fs;
x = sin(2*pi*100*t);            % 已知：100 Hz，幅度 1
[f, A] = my_spectrum(x, fs);
[~, i] = max(A);
fprintf('峰值在 %.1f Hz，幅度 %.3f\n', f(i), A(i));

%实验 A：栅栏效应
fs = 1000; N = 1000;            % Δf = fs/N = 1 Hz
t  = (0:N-1)/fs;

x1 = sin(2*pi*100*t);           % 落在 bin 100 的正中心
x2 = sin(2*pi*100.5*t);         % 落在 bin 100 和 101 中间

[f1,A1] = my_spectrum(x1, fs);
[f2,A2] = my_spectrum(x2, fs);
% 画图对比：只放大 95~105Hz 区间，看得更清楚
figure;
plot(f1, A1, 'o-', 'LineWidth', 1.2);
hold on;
plot(f2, A2, 'x--', 'LineWidth', 1.2);
xlim([95 105]);   % 只看峰值附近，放大细节
xlabel('频率 (Hz)'); ylabel('幅度');
legend('100 Hz（对齐bin中心）','100.5 Hz（两bin中间）');
grid on;
title('栅栏效应：频率对齐 vs 不对齐的峰值对比');

% 打印两个峰值数值
[~,i1] = max(A1);
[~,i2] = max(A2);
fprintf('100Hz信号：峰值 %.1f Hz，幅度 %.3f\n', f1(i1), A1(i1));
fprintf('100.5Hz信号：峰值 %.1f Hz，幅度 %.3f\n', f2(i2), A2(i2));

%实验 B：两个靠近的音，为什么分不开
fs = 10000;
%% ===== 情况1：间隔200Hz，N=100 =====
N1 = 100;
t1 = (0:N1-1)/fs;
x1 = sin(2*pi*1000*t1) + sin(2*pi*1200*t1);
[f1, A1] = my_spectrum(x1, fs);

%% ===== 情况2：间隔20Hz，N=100 =====
N2 = 100;
t2 = (0:N2-1)/fs;
x2 = sin(2*pi*1000*t2) + sin(2*pi*1020*t2);
[f2, A2] = my_spectrum(x2, fs);

%% ===== 情况3：间隔20Hz，N=1000 =====
N3 = 1000;
t3 = (0:N3-1)/fs;
x3 = sin(2*pi*1000*t3) + sin(2*pi*1020*t3);
[f3, A3] = my_spectrum(x3, fs);

%% ===== 2×2子图对比 =====
tiledlayout(2,2);

nexttile;
plot(f1, A1); xlim([900 1300]);
title('间隔200Hz，N=100（Δf=100Hz）');
ylabel('幅度'); grid on;

nexttile;
plot(f2, A2); xlim([950 1070]);
title('间隔20Hz，N=100（Δf=100Hz）');
grid on;

nexttile;
plot(f3, A3); xlim([950 1070]);
title('间隔20Hz，N=1000（Δf=10Hz）');
xlabel('频率 (Hz)'); ylabel('幅度'); grid on;

%% 关键结论打印
fprintf('Δf = fs/N = 1/T，只和观测时长有关\n');
fprintf('N=100时Δf=%.0fHz，N=1000时Δf=%.0fHz\n', fs/N1, fs/N3);
