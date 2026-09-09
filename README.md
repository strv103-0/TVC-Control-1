# TVC-Control-1

프로펠러 추력으로 자세를 제어하는 로켓형 동체(TVC, Thrust Vector Control) 프로젝트.

- **상태**: 개발 환경 구축 · 도구 선정 완료 / 시뮬레이션 착수 예정
- **작업 환경**: Windows 11 · VS Code + PlatformIO · MATLAB/Simulink
- **작업 PC**: 데스크톱 · 노트북 — GitHub로 동기화하며 이어서 작업
- **제어 보드**: 미확정 — Teensy 4.x / STM32 계열, 또는 자체 회로 설계 검토 중

## 프로젝트 동기

제어 분야, 그중에서도 로켓 제어에 관심을 가지면서 추력의 방향을 바꿔 자세를 잡는
추력 벡터 제어(TVC)에 흥미를 갖게 되었습니다.

다만 고체연료 모터는 한 번 점화하면 추력을 조절할 수 없고 재사용도 어려워,
제어 알고리즘을 반복해서 시험하기에는 적합하지 않을 것이라고 예상하였습니다.
그래서 추력원을 프로펠러로 대체하고, 로켓과 유사한 동체에 짐벌을 달아 TVC를 구현하기로 했습니다.
추력을 연속적으로 조절할 수 있고 몇 번이든 다시 시험할 수 있어,
제어기 설계와 튜닝 자체에 집중할 수 있습니다.

### 목표

1. **호버링** — 기체를 세운 자세로 공중에 유지
2. **위치 제어** — 원하는 지점으로 이동하고 그 자리를 유지

## 폴더 구조

```
TVC-Control-1/
├─ firmware/     제어 펌웨어 (PlatformIO 프로젝트)
│  ├─ src/         메인 소스
│  ├─ include/     공용 헤더 (config.h 등)
│  ├─ lib/         프로젝트 전용 라이브러리
│  └─ test/        단위 테스트
├─ hardware/     회로 · 기구 설계
│  ├─ kicad/       PCB / 회로도
│  ├─ cad/         동체 · 짐벌 기구 설계
│  └─ datasheets/  부품 데이터시트
├─ sim/          제어기 시뮬레이션 (Simulink)
├─ analysis/     비행 · 벤치 로그 분석 스크립트
├─ logs/         실측 로그 (대용량 원본은 git 제외)
├─ docs/         설계 문서 · 실험 기록 · 의사결정 기록
└─ tools/        보조 스크립트 (동기화 등)
```

## 작업 방식

데스크톱과 노트북 등 여러 PC에서 GitHub를 통해 이어서 작업합니다.
새 PC 세팅 절차는 [docs/SETUP.md](docs/SETUP.md)에 있습니다.

매번 지켜야 할 규칙은 하나입니다:

```
작업 시작 = git pull   |   작업 끝 = git add → commit → push
```

편의 스크립트도 있습니다:

```powershell
.\tools\sync.ps1 start          # 작업 시작 시: 최신 내려받기
.\tools\sync.ps1 end "커밋 메시지"   # 작업 종료 시: 커밋 + 푸시
```

> Simulink 모델(`.slx`)은 바이너리라 **git이 자동 병합하지 못합니다.**
> 한 번에 한 PC에서만 편집하고, 다른 PC로 옮기기 전에 반드시 push 하세요.

## 문서

| 문서 | 내용 |
|---|---|
| [docs/SETUP.md](docs/SETUP.md) | 새 PC에서 개발 환경 준비하기 |
| [docs/matlab-products.md](docs/matlab-products.md) | MATLAB 설치 시 선택할 제품 목록 |
| [docs/requirements.md](docs/requirements.md) | 기체 요구사항 · 설계 목표 · 시뮬레이션 파라미터 |
| [docs/dynamics-and-control.md](docs/dynamics-and-control.md) | 동역학 유도와 제어 구조 설계 이론 |
| [docs/hardware-log.md](docs/hardware-log.md) | 부품 선정 · 배선 · 조립 기록 |
| [docs/test-log.md](docs/test-log.md) | 벤치 테스트 · 비행 시험 기록 |
| [docs/decisions/0001-toolchain.md](docs/decisions/0001-toolchain.md) | 개발 도구 선정 근거 (ADR) |
| [docs/decisions/](docs/decisions/) | 설계 결정 기록 전체 |

## 개발 과정에 대하여

이 프로젝트는 Anthropic의 Claude를 활용해 진행하고 있습니다.

- **AI 활용**: 개발 환경 구축, 도구 후보 조사와 비교, 문서 초안 작성, 오류 원인 분석, 커밋 메시지 작성
- **직접 수행**: 프로젝트 주제와 목표 설정, 도구 최종 선택, 문서 검토와 수정,
  이후의 설계 · 시뮬레이션 · 구현

AI가 관여한 커밋에는 커밋 메시지에 `Co-Authored-By` 표기를 남겼습니다.
