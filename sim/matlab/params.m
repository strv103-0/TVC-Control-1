%% TVC-Control-1 — 시뮬레이션 파라미터
%
% Simulink 모델은 숫자를 직접 적지 말고 이 파일의 변수를 참조한다.
% 값의 근거는 docs/requirements.md, 수식 유도는 docs/dynamics-and-control.md 참고.
%
% 사용법:  Simulink 모델을 열기 전에 이 스크립트를 먼저 실행한다.
%
% 단위 규칙: 내부 계산은 모두 SI (m, kg, s, rad).
%            사람이 읽는 값만 deg 로 두고 즉시 rad 로 환산한다.

clear; clc;

%% ── 환경 ───────────────────────────────────────────────
p.g = 9.81;                 % 중력가속도 [m/s^2]

%% ── 기체 물성 ──────────────────────────────────────────
p.m       = 0.800;          % 이륙 중량 [kg]
p.L_body  = 0.600;          % 전장 [m]
p.D_body  = 0.090;          % 직경 [m]
p.L       = 0.250;          % 모멘트 팔: 짐벌 회전중심 ~ 무게중심 [m]

% 관성모멘트 (pitch/yaw축)
% 세장형 막대 근사.  ★ CAD 완성 후 Fusion 실측 관성텐서로 교체할 것
p.I = (1/12) * p.m * p.L_body^2;        % [kg*m^2]

%% ── 추력 ───────────────────────────────────────────────
p.TW      = 1.8;                        % 추력 대 중량비
p.T_hover = p.m * p.g;                  % 호버 필요 추력 [N]
p.T_max   = p.TW * p.T_hover;           % 최대 추력 [N]

%% ── 짐벌 · 서보 ────────────────────────────────────────
p.delta_max_deg  = 12;                  % 짐벌 최대 편향각 [deg]
p.delta_rate_deg = 600;                 % 서보 각속도 [deg/s]  (0.10 s/60deg 환산)
p.tau_servo      = 0.020;               % 서보 지연 [s]        ★ 실측 후 갱신

p.delta_max  = deg2rad(p.delta_max_deg);
p.delta_rate = deg2rad(p.delta_rate_deg);

%% ── 제어 루프 ──────────────────────────────────────────
p.f_ctrl = 250;                         % 제어 주기 [Hz]
p.Ts     = 1 / p.f_ctrl;                % 샘플 시간 [s]

% 루프별 목표 교차주파수 [Hz]
% 각 루프 사이를 4배씩 벌린다 (시간 척도 분리).
% 각속도 루프의 상한은 서보 지연이 정한다:  wc <= 0.52/tau  (위상지연 30deg 기준)
% tau = 20 ms 이면 상한 4.1 Hz 이므로 여유를 두어 3.5 Hz 로 잡는다.
% ★ 더 빠른 응답이 필요하면 게인이 아니라 서보를 바꿔야 한다.
p.bw_rate = 3.5;                        % 각속도 루프
p.bw_att  = 0.9;                        % 자세각 루프
p.bw_pos  = 0.22;                       % 위치 루프

%% ── 제어 게인 (설계 후 채운다) ─────────────────────────
p.rate.Kp = 0;   p.rate.Ki = 0;
p.att.Kp  = 0;
p.pos.Kp  = 0;   p.pos.Kd  = 0;

%% ── IMU 노이즈 (MPU6050 데이터시트 대략치) ─────────────
% Navigation Toolbox 의 imuSensor 에 넣어 현실적인 신호를 만든다.
% ★ 실제 센서로 정지 상태 로그를 받아 갱신할 것
p.imu.gyro_noise_dens  = 0.005;         % [deg/s/sqrt(Hz)]
p.imu.gyro_bias_inst   = 0.02;          % [deg/s]
p.imu.accel_noise_dens = 400e-6;        % [g/sqrt(Hz)]

%% ── 파생값 · 선형화 플랜트 ─────────────────────────────
% 자세 운동방정식:  I * theta_ddot = T * L * sin(delta)
% 작은 각 근사:     theta_ddot = (T*L/I) * delta
%
% 주의: 여기서 T 는 "그 순간의 추력"이다.
%       제어기는 호버 부근에서 설계하므로 T_hover 를 쓴다.
%       T_max 를 쓰면 게인이 과대평가되어 실기에서 진동한다.

p.K_att = p.T_hover * p.L / p.I;        % 플랜트 이득 [1/s^2 per rad]

% theta(s)/delta(s) = K_att / s^2   (이중적분기)
if exist('tf', 'file')
    p.sys_att = tf(p.K_att, [1 0 0]);
end

%% ── 검산 ───────────────────────────────────────────────
M_hover  = p.T_hover * p.L * sin(p.delta_max);   % 호버 시 최대 제어 모멘트 [N*m]
M_full   = p.T_max   * p.L * sin(p.delta_max);   % 최대 추력 시 [N*m]
acc_hover = M_hover / p.I;                       % [rad/s^2]
acc_full  = M_full  / p.I;

% 서보 지연이 정하는 대역폭 상한 (위상지연 30deg 기준)
wc_max_rad = 0.52 / p.tau_servo;
wc_max_hz  = wc_max_rad / (2*pi);

fprintf('\n=== TVC-Control-1 파라미터 ===\n');
fprintf('  질량 %.3f kg   관성 %.4f kg*m^2   모멘트팔 %.3f m\n', p.m, p.I, p.L);
fprintf('  추력  호버 %.2f N / 최대 %.2f N  (T/W %.1f)\n', p.T_hover, p.T_max, p.TW);
fprintf('  플랜트 이득 K_att = %.1f  [rad/s^2 per rad]\n', p.K_att);
fprintf('\n--- 제어 권한 ---\n');
fprintf('  호버 시 최대 각가속도 : %6.1f rad/s^2  (%.0f deg/s^2)\n', acc_hover, rad2deg(acc_hover));
fprintf('  최대추력 시           : %6.1f rad/s^2  (%.0f deg/s^2)\n', acc_full,  rad2deg(acc_full));
fprintf('\n--- 대역폭 ---\n');
fprintf('  서보 지연 %.0f ms 가 정하는 상한 : %.1f Hz\n', p.tau_servo*1000, wc_max_hz);
fprintf('  목표 각속도 루프                 : %.1f Hz\n', p.bw_rate);
if p.bw_rate > wc_max_hz
    fprintf('  [경고] 목표 대역폭이 서보 한계를 넘는다. 더 빠른 서보가 필요하다.\n');
else
    fprintf('  -> 여유 있음\n');
end
fprintf('  제어 주기 %d Hz (사용 가능 대역폭 약 %.0f~%.0f Hz)\n', ...
        p.f_ctrl, p.f_ctrl/20, p.f_ctrl/10);
fprintf('\n');

% 원하는 대역폭에서 거꾸로 서보 요구사양을 뽑는다 (부품 선정 기준)
fprintf('\n--- 서보 요구사양 (목표 대역폭 -> 허용 지연) ---\n');
for bw = [3.5 6 8]
    fprintf('  각속도 루프 %.1f Hz 를 원하면  서보 지연 <= %.0f ms\n', ...
            bw, 1000 * 0.52 / (2*pi*bw));
end
fprintf('\n');

clear M_hover M_full acc_hover acc_full wc_max_rad wc_max_hz bw
