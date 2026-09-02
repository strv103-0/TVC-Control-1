#pragma once
// TVC-Control-1 설정값 모음.
// 핀 배치와 제어 게인은 하드웨어가 확정되면 채웁니다.

// ---- 제어 루프 ----
constexpr uint32_t CONTROL_HZ = 250;                  // 제어 주기 [Hz]
constexpr uint32_t CONTROL_PERIOD_US = 1000000UL / CONTROL_HZ;

// ---- 핀 배치 (TBD) ----
constexpr uint8_t PIN_SERVO_X = 0;
constexpr uint8_t PIN_SERVO_Y = 0;
constexpr uint8_t PIN_ESC     = 0;
constexpr uint8_t PIN_LED     = LED_BUILTIN;

// ---- 짐벌 한계 ----
constexpr float GIMBAL_LIMIT_DEG = 10.0f;             // 짐벌 최대 편향각

// ---- 안전 ----
constexpr float ABORT_TILT_DEG = 45.0f;               // 이 각도를 넘으면 모터 정지
constexpr uint32_t LINK_TIMEOUT_MS = 500;             // 통신 두절 판정 시간
