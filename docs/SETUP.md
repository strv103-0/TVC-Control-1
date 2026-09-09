# 새 PC 개발 환경 세팅

작업할 PC마다 한 번씩 진행합니다. 데스크톱은 완료된 상태이므로, 노트북 등 새 PC에서 이 문서를 따라가면 됩니다.

## 1. 필수 프로그램

### 필수 (모든 작업 PC)

```powershell
winget install --id Git.Git -e
winget install --id GitHub.cli -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id Python.Python.3.12 -e
```

VS Code를 연 뒤 확장 마켓에서 **PlatformIO IDE**를 설치하면 컴파일러 툴체인까지 자동으로 받아옵니다.

### 설계 · 회로 (필요해질 때)

```powershell
winget install --id KiCad.KiCad -e          # 회로도 / PCB
winget install --id Autodesk.Fusion -e      # 동체 · 짐벌 기구 설계 (교육용 라이선스 인증 필요)
winget install --id Sigrok.PulseView -e     # 로직 애널라이저 뷰어 (서보 PWM · I2C 확인)
winget install --id AnalogDevices.LTspice -e # 전원부 회로 시뮬 (커스텀 PCB 단계)
```

PlotJuggler(실시간 텔레메트리 플로팅)는 winget에 없어
[GitHub 릴리스](https://github.com/facontidavide/PlotJuggler/releases)에서 내려받습니다.

도구 선정 이유는 [decisions/0001-toolchain.md](decisions/0001-toolchain.md)를 참고하세요.

> 설치 후 **PowerShell을 새로 열어야** `git`, `gh` 명령이 인식됩니다.

## 2. Git 신원 설정 (PC마다 1회)

```powershell
git config --global user.name "strv103-0"
git config --global user.email "yijeong06@gmail.com"
```

**같은 GitHub 계정을 써도 PC마다 따로 해야 합니다.** `--global`은 "계정 전체"가 아니라
"이 PC의 이 사용자 전체"라는 뜻이라, GitHub 계정을 따라 동기화되지 않습니다.
빠뜨리면 첫 커밋에서 `Please tell me who you are.` 오류가 납니다.

이 설정은 **인증과 무관**합니다. 로그인은 3번(`gh auth login`)이 담당하고,
여기 값은 커밋에 새겨지는 작성자 표시일 뿐입니다. `user.name`은 검증되지 않으므로
실명이 아니어도 되고, 모든 PC에서 같은 값만 쓰면 됩니다.

GitHub이 커밋을 계정에 연결하는 기준은 이름이 아니라 **이메일**입니다.
이메일만 모든 PC에서 일치하면 기여 그래프는 정상적으로 잡힙니다.

> **저장소를 나중에 public으로 전환할 계획이라면**: 커밋에 새겨진 이메일은 영구히 남고 그대로 공개됩니다.
> 실제 주소를 노출하고 싶지 않다면 GitHub이 제공하는 noreply 주소를 쓰세요.
> (GitHub 설정에서 *Keep my email addresses private*를 켠 뒤)
>
> ```powershell
> git config --global user.email "112059527+strv103-0@users.noreply.github.com"
> ```
>
> 단, 바꾸기 전에 이미 만든 커밋의 이메일은 소급 변경되지 않습니다.

## 3. GitHub 로그인 (PC마다 1회)

```powershell
gh auth login --web --git-protocol https
gh auth setup-git
```

브라우저가 열리고 일회용 코드를 입력하면 끝입니다.

두 번째 줄(`gh auth setup-git`)을 빠뜨리지 마세요. 이 명령이 git의 자격증명 헬퍼를 gh에 연결합니다.
빠뜨리면 `gh` 명령은 잘 되는데 순수 `git push`만 `could not read Username for 'https://github.com'` 오류로 실패합니다.

## 4. 저장소 내려받기 (새 PC에서 1회)

```powershell
mkdir D:\My_Project_Workspace
cd D:\My_Project_Workspace
gh repo clone strv103-0/TVC-Control-1
```

모든 PC에서 `D:\My_Project_Workspace\TVC-Control-1` 경로를 쓰면 스크립트·설정 경로가 어긋나지 않습니다.
(D 드라이브가 없는 PC라면 `C:\My_Project_Workspace`도 무방합니다. 경로만 본인이 기억하면 됩니다.)

## 5. MATLAB / Simulink 설치 (제어 시뮬레이션을 할 PC만)

1. 학교 계정으로 [MathWorks](https://www.mathworks.com/login)에 로그인해 라이선스를 연결합니다.
2. 설치 관리자를 받아 실행하고, **설치할 제품을 선택**합니다.
3. 설치 위치는 용량이 크므로 여유 있는 드라이브를 고릅니다 (예: `D:\Program Files\MATLAB`).

전체 설치는 매우 크므로 필요한 제품만 고릅니다.
**어떤 제품을 선택할지는 [matlab-products.md](matlab-products.md)에 단계별로 정리돼 있습니다.**

> 여러 PC에서 모델을 열려면 **같은 제품 목록으로 설치**해야 합니다.
> 한쪽에만 있는 툴박스의 블록을 쓰면 다른 PC에서 모델이 열리지 않습니다.

STM32에 코드 생성을 할 계획이면, MATLAB 실행 후 **Add-On Explorer**에서 아래를 추가 설치합니다 (무료).

```
Embedded Coder Support Package for STMicroelectronics STM32 Processors
```

## 6. 일상 작업 흐름

| 시점 | 명령 | 이유 |
|---|---|---|
| 작업 **시작 전** | `git pull` | 다른 PC에서 한 작업을 먼저 받아옵니다 |
| 의미 있는 단위마다 | `git add -A` → `git commit -m "..."` | 되돌릴 수 있는 지점을 만듭니다 |
| 작업 **끝날 때** | `git push` | 다른 PC가 이어받을 수 있게 올립니다 |

`tools\sync.ps1`이 이 과정을 감싸줍니다.

## Simulink 모델(`.slx`) 편집 규칙

`.slx`는 바이너리 파일이라 **git이 내용을 병합하지 못합니다.**
텍스트 파일처럼 다루면 반드시 사고가 납니다.

1. 모델을 열기 전에 **반드시** `.	ools\sync.ps1 start`
2. 작업을 마치면 **반드시** `.	ools\sync.ps1 end "..."` — 다른 PC로 옮기기 전에 push
3. 한 번에 **한 PC에서만** 편집합니다
4. 큰 구조 변경 전에는 커밋을 먼저 만들어 되돌아갈 지점을 확보합니다

파라미터(질량·관성·게인)는 모델 블록 안에 직접 적지 말고 `sim/matlab/params.m`에 변수로 둡니다.
`.m`은 텍스트라 변경 이력이 git에 남습니다.

## 자주 겪는 상황

**"push가 거부됐어요 (rejected / non-fast-forward)"**
다른 PC에서 올린 작업이 있는데 pull을 안 한 경우입니다.

```powershell
git pull --rebase
git push
```

**"양쪽 PC에서 같은 파일을 고쳐서 충돌났어요"**
충돌 파일에 `<<<<<<<`, `=======`, `>>>>>>>` 표시가 들어갑니다. 남길 내용만 남기고 표시 줄을 지운 뒤:

```powershell
git add <파일명>
git rebase --continue
```

**예방책**: PC를 옮기기 전에 반드시 push, 작업을 시작할 때 반드시 pull. 이것만 지키면 충돌은 거의 나지 않습니다.

**"`.slx` 파일이 충돌났어요"**
Simulink 모델은 병합이 불가능하므로 **어느 한쪽을 통째로 고르는 것**이 유일한 해결책입니다.
내 PC의 버전을 살리려면 `--ours`, 원격 버전을 살리려면 `--theirs`를 씁니다.

```powershell
git checkout --ours sim/simulink/모델명.slx
git add sim/simulink/모델명.slx
git rebase --continue
```

버린 쪽의 작업은 되살릴 수 없습니다. 애초에 한 PC에서만 편집하는 것이 유일한 예방책입니다.

**"큰 파일(CAD, 로그)을 올렸더니 느려요"**
100MB 넘는 파일은 GitHub가 거부합니다. 원본 비행 로그는 `logs/`에 두면 자동으로 git에서 제외되고,
정리된 요약본만 `analysis/`에 올리는 것을 권장합니다.

## 참고: PowerShell 스크립트 인코딩

Windows PowerShell 5.1은 BOM 없는 UTF-8 `.ps1` 파일을 cp949로 잘못 읽어 한글 주석·문자열이 깨집니다.
이 저장소에 한글이 들어간 `.ps1`을 추가할 때는 **UTF-8 with BOM**으로 저장하세요.

```powershell
$p = "tools\새스크립트.ps1"
$c = Get-Content -Raw -Encoding UTF8 $p
[IO.File]::WriteAllText($p, $c, (New-Object System.Text.UTF8Encoding $true))
```
