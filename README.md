# TVC-Control-1

프로펠러 추력으로 자세를 제어하는 로켓형 동체(TVC, Thrust Vector Control) 프로젝트.

- **상태**: 초기 세팅 (2026-09-02)
- **작업 환경**: 데스크톱 + 노트북 2대를 GitHub로 오가며 작업
- **제어 보드**: 미확정 — Teensy 4.x / STM32 계열, 또는 자체 회로 설계 검토 중

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
├─ sim/          제어기 시뮬레이션 (Python)
├─ analysis/     비행 · 벤치 로그 분석 스크립트
├─ logs/         실측 로그 (대용량 원본은 git 제외)
├─ docs/         설계 문서 · 실험 기록 · 의사결정 기록
└─ tools/        보조 스크립트 (동기화 등)
```

## 두 PC에서 작업하는 법

처음 세팅은 [docs/SETUP.md](docs/SETUP.md)를 참고하세요.

매번 지켜야 할 규칙은 하나입니다:

```
작업 시작 = git pull   |   작업 끝 = git add → commit → push
```

편의 스크립트도 있습니다:

```powershell
.\tools\sync.ps1 start          # 작업 시작 시: 최신 내려받기
.\tools\sync.ps1 end "커밋 메시지"   # 작업 종료 시: 커밋 + 푸시
```

## 문서

| 문서 | 내용 |
|---|---|
| [docs/SETUP.md](docs/SETUP.md) | 새 PC에서 개발 환경 준비하기 |
| [docs/requirements.md](docs/requirements.md) | 기체 요구사항 · 설계 목표 |
| [docs/hardware-log.md](docs/hardware-log.md) | 부품 선정 · 배선 · 조립 기록 |
| [docs/test-log.md](docs/test-log.md) | 벤치 테스트 · 비행 시험 기록 |
| [docs/decisions/](docs/decisions/) | 주요 설계 결정과 그 이유 (ADR) |
