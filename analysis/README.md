# 로그 분석

`logs/`의 원본 데이터를 읽어 자세 응답, 짐벌 출력, 진동 스펙트럼 등을 확인한다.
결과물(그래프 · 요약)은 git에 올려 두 PC와 시험 기록에서 함께 본다.

제어 설계는 Simulink에서 하지만(→ `sim/`), **로그 분석은 Python으로 한다.**
비행 로그 처리는 스크립트가 빠르고, `.py`는 텍스트라 git diff가 된다.

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

`.venv/`는 git에서 제외되므로 PC마다 위 명령을 한 번씩 실행한다.

실시간 텔레메트리 확인에는 [PlotJuggler](https://github.com/facontidavide/PlotJuggler/releases)를 쓴다.
