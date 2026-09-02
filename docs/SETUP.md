# 새 PC 개발 환경 세팅

데스크톱과 노트북 양쪽에서 동일하게 진행합니다. (한쪽은 이미 완료된 상태)

## 1. 필수 프로그램

```powershell
winget install --id Git.Git -e
winget install --id GitHub.cli -e
winget install --id Microsoft.VisualStudioCode -e
```

PlatformIO는 VS Code 확장 마켓에서 `PlatformIO IDE`를 설치하면 툴체인까지 자동으로 받아옵니다.

> 설치 후 **PowerShell을 새로 열어야** `git`, `gh` 명령이 인식됩니다.

## 2. Git 신원 설정 (PC마다 1회)

```powershell
git config --global user.name "본인이름"
git config --global user.email "yijeong06@gmail.com"
```

두 PC 모두 **같은 이름/이메일**을 쓰세요. 커밋 기록이 한 사람으로 깔끔하게 남습니다.

## 3. GitHub 로그인 (PC마다 1회)

```powershell
gh auth login --web --git-protocol https
```

브라우저가 열리고 일회용 코드를 입력하면 끝입니다. 이후 push/pull에서 비밀번호를 다시 묻지 않습니다.

## 4. 저장소 내려받기 (새 PC에서 1회)

```powershell
mkdir D:\My_Project_Workspace
cd D:\My_Project_Workspace
gh repo clone <계정명>/TVC-Control-1
```

두 PC 모두 `D:\My_Project_Workspace\TVC-Control-1` 경로를 쓰면 스크립트·설정 경로가 어긋나지 않습니다.

## 5. 일상 작업 흐름

| 시점 | 명령 | 이유 |
|---|---|---|
| 작업 **시작 전** | `git pull` | 다른 PC에서 한 작업을 먼저 받아옵니다 |
| 의미 있는 단위마다 | `git add -A` → `git commit -m "..."` | 되돌릴 수 있는 지점을 만듭니다 |
| 작업 **끝날 때** | `git push` | 다른 PC가 이어받을 수 있게 올립니다 |

`tools\sync.ps1`이 이 과정을 감싸줍니다.

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
