<#
.SYNOPSIS
    데스크톱 <-> 노트북 작업 전환용 Git 보조 스크립트.

.EXAMPLE
    .\tools\sync.ps1 start
    작업을 시작하기 전에 다른 PC의 변경사항을 받아옵니다.

.EXAMPLE
    .\tools\sync.ps1 end "짐벌 PID 게인 1차 조정"
    변경사항을 커밋하고 올립니다. 메시지를 생략하면 날짜로 자동 생성됩니다.

.EXAMPLE
    .\tools\sync.ps1 status
    현재 상태만 확인합니다.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('start', 'end', 'status')]
    [string]$Command = 'status',

    [Parameter(Position = 1)]
    [string]$Message
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

function Write-Step($text) { Write-Host "`n== $text" -ForegroundColor Cyan }
function Write-Ok($text)   { Write-Host "   $text" -ForegroundColor Green }
function Write-Warn($text) { Write-Host "   $text" -ForegroundColor Yellow }

switch ($Command) {

    'status' {
        Write-Step '현재 상태'
        git status -sb
        Write-Step '최근 커밋'
        git --no-pager log --oneline -5
    }

    'start' {
        Write-Step '원격 변경사항 받아오는 중'

        $dirty = git status --porcelain
        if ($dirty) {
            Write-Warn '저장하지 않은 변경사항이 있습니다:'
            git status -s
            Write-Warn "먼저 정리하거나 '.\tools\sync.ps1 end' 로 커밋한 뒤 다시 실행하세요."
            exit 1
        }

        git pull --rebase
        if ($LASTEXITCODE -ne 0) {
            Write-Warn 'pull 실패. 위 메시지를 확인하세요.'
            exit $LASTEXITCODE
        }
        Write-Ok '최신 상태입니다. 작업을 시작하세요.'
    }

    'end' {
        Write-Step '변경사항 확인'
        $dirty = git status --porcelain
        if (-not $dirty) {
            Write-Ok '커밋할 변경사항이 없습니다.'
        }
        else {
            git status -s

            if ([string]::IsNullOrWhiteSpace($Message)) {
                $Message = "작업 저장 $(Get-Date -Format 'yyyy-MM-dd HH:mm') ($env:COMPUTERNAME)"
                Write-Warn "메시지가 없어 자동 생성했습니다: $Message"
            }

            Write-Step '커밋'
            git add -A
            git commit -m $Message
            if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        }

        Write-Step '푸시'
        git push
        if ($LASTEXITCODE -ne 0) {
            Write-Warn 'push 실패. 다른 PC에서 올린 작업이 있을 수 있습니다. 아래를 실행해 보세요:'
            Write-Warn '   git pull --rebase'
            Write-Warn '   git push'
            exit $LASTEXITCODE
        }
        Write-Ok '올렸습니다. 다른 PC에서 이어서 작업할 수 있습니다.'
    }
}
