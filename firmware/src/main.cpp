// TVC-Control-1 — 펌웨어 골격
//
// 아직 제어기는 비어 있습니다. 보드가 확정되면
// IMU 읽기 → 자세 추정 → 캐스케이드 PID → 짐벌 출력 순으로 채워 나갑니다.

#include <Arduino.h>
#include "config.h"

static uint32_t nextControlUs = 0;

void setup() {
    Serial.begin(115200);
    pinMode(PIN_LED, OUTPUT);

    // TODO: IMU 초기화
    // TODO: 서보 / ESC 초기화 (반드시 스로틀 0 으로 시작)

    nextControlUs = micros();
}

void loop() {
    const uint32_t now = micros();
    if ((int32_t)(now - nextControlUs) < 0) {
        return;
    }
    nextControlUs += CONTROL_PERIOD_US;

    // TODO: 1) IMU 샘플링
    // TODO: 2) 자세 추정 (상보 필터 → 칼만)
    // TODO: 3) 각도 PID → 각속도 PID → 짐벌 목표각
    // TODO: 4) 안전 검사 (ABORT_TILT_DEG, LINK_TIMEOUT_MS)
    // TODO: 5) 서보 / ESC 출력

    // 살아있음 표시 (1초 주기)
    static uint32_t blinkCounter = 0;
    if (++blinkCounter >= CONTROL_HZ) {
        blinkCounter = 0;
        digitalWrite(PIN_LED, !digitalRead(PIN_LED));
    }
}
