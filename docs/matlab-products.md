# MATLAB 설치 제품 목록

학교 라이선스는 보통 전 제품이 목록에 뜨므로, 문제는 "무엇을 쓸 수 있나"가 아니라
**"무엇을 안 깔 것인가"**다. 전체 설치는 용량이 매우 크다.

> 설치 위치는 **D 드라이브**를 권장한다 (`D:\Program Files\MATLAB`).
> 노트북에도 같은 목록으로 설치하면 모델이 양쪽에서 동일하게 열린다.

## 1단계 — 지금 설치 (제어 설계 최소 구성)

| 제품 | 용도 |
|---|---|
| MATLAB | 기반 |
| Simulink | 모델링 · 시뮬레이션 |
| Control System Toolbox | PID 설계, 보드선도 · 근궤적, 상태공간 |
| Simulink Control Design | 비선형 모델 선형화, Simulink 대상 PID Tuner |
| Stateflow | 비행 모드 상태기계 (대기 → 준비 → 상승 → 호버 → 하강 → Abort) |

**Simulink Control Design은 빠뜨리면 안 된다.** TVC 기체는 비선형이라 모델을 그대로 두고
게인을 뽑을 수 없다. 이 툴박스가 운용점에서 자동 선형화를 해 주고, 그 위에서 PID Tuner가 동작한다.

## 2단계 — 기체 동역학 모델링 시작할 때

| 제품 | 용도 |
|---|---|
| Simscape | Simscape Multibody의 전제 |
| Simscape Multibody | 동체 + 짐벌 다물체 동역학. Fusion STEP 임포트 시 관성텐서 자동 반영, 3D 애니메이션 |
| Aerospace Blockset | 6-DOF 강체 블록, 쿼터니언 ↔ 오일러 변환 |
| Aerospace Toolbox | 위 Blockset의 짝 (좌표계 · 단위 변환) |
| Navigation Toolbox | `imuSensor` (자이로 노이즈 · 바이어스 · 드리프트 주입), `imufilter` / `ahrsfilter` |
| Signal Processing Toolbox | IMU 저역통과 · 노치 필터 설계, 프로펠러 진동 FFT |

`imuSensor`가 특히 중요하다. 깨끗한 자이로 신호로 시뮬하면 실기에서 반드시 배신당한다.

## 3단계 — 보드에 코드 생성해 올릴 때

| 제품 | 용도 |
|---|---|
| MATLAB Coder | Embedded Coder의 전제 |
| Simulink Coder | 위와 동일 |
| Embedded Coder | 임베디드 최적화 C 코드 생성 |

STM32를 쓸 경우, MATLAB 실행 후 **Add-On Explorer**에서 아래를 추가 설치한다 (무료, 설치 관리자에는 없음).

```
Embedded Coder Support Package for STMicroelectronics STM32 Processors
```

> **Teensy 4.x는 MathWorks 공식 타겟 지원이 없다.** 코드 생성 워크플로를 쓸 계획이면
> STM32 쪽이 유리하다. → ADR 0002 참고.

## 선택 (필요해지면)

| 제품 | 언제 |
|---|---|
| System Identification Toolbox | 실측 서보 응답으로 모델 동정 (지연 · 시정수 추출) |
| Optimization Toolbox | 게인 자동 최적화 |
| Instrument Control Toolbox | 시리얼 텔레메트리를 MATLAB에서 직접 수신 |
| Parallel Computing Toolbox | 몬테카를로 시뮬 병렬 실행 |

## 설치하지 말 것

용량만 차지하고 이 프로젝트와 무관하다.

Deep Learning · Computer Vision · Image Processing · Text Analytics ·
Financial · Bioinformatics · Powertrain / Vehicle Dynamics ·
5G / LTE / Wireless · RF / Antenna

아래 둘은 이름 때문에 필요해 보이지만 아니다.

- **Fixed-Point Designer** — 대상 MCU가 부동소수점 연산을 하드웨어로 지원하므로 불필요
- **Robust Control Toolbox** — 이 규모의 기체에는 과하다
