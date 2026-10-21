# new-project.ps1 — create a new project wired to the TheAIOfficers build framework.
# Usage:  & "<framework>\scripts\new-project.ps1" -Name "my-project" [-Path "C:\Users\me\Projects"] [-BuildModel <model> -AdvisorModel <model>]   (e.g. sonnet / opus — example names; run MODEL-CHECK.md)
# Creates <Path>\<Name> with project-docs/, a framework-wired CLAUDE.md, an audit-lessons file,
# a version pin, and git history. -BuildModel/-AdvisorModel (optional, founder's choice — CLAUDE.md
# Section 16 rule 7) write .claude/settings.json; omit them to keep the default model routing.

param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [string]$Path = (Get-Location).Path,

    [string]$BuildModel = '',

    [string]$AdvisorModel = ''
)

$ErrorActionPreference = 'Stop'

# --- validate optional model names before anything is created ---
foreach ($m in @($BuildModel, $AdvisorModel)) {
    if ($m -and $m -notmatch '^[A-Za-z0-9._-]+$') {
        Write-Host "ERROR: model name '$m' may only contain letters, digits, '.', '_' or '-'." -ForegroundColor Red
        exit 1
    }
}

# --- locate the framework (this script lives in <framework>/scripts/) ---
$FrameworkRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $FrameworkRoot 'CLAUDE.md'))) {
    Write-Host "ERROR: framework CLAUDE.md not found at $FrameworkRoot — is this script inside the framework's scripts\ folder?" -ForegroundColor Red
    exit 1
}

# --- read the framework version from CHANGELOG.md ---
$Version = 'unknown'
$ChangelogPath = Join-Path $FrameworkRoot 'CHANGELOG.md'
if (Test-Path $ChangelogPath) {
    $VersionLine = Select-String -Path $ChangelogPath -Pattern '^## (v[0-9]+\.[0-9]+\.[0-9]+)' | Select-Object -First 1
    if ($VersionLine) { $Version = $VersionLine.Matches[0].Groups[1].Value }
}

# --- create the project folder ---
$ProjectDir = Join-Path $Path $Name
if (Test-Path $ProjectDir) {
    Write-Host "ERROR: $ProjectDir already exists. Choose a different name or delete the folder first." -ForegroundColor Red
    exit 1
}
New-Item -ItemType Directory -Path $ProjectDir | Out-Null

# --- copy the planning documents template ---
Copy-Item -Recurse -Path (Join-Path $FrameworkRoot 'project-docs-template') -Destination (Join-Path $ProjectDir 'project-docs')

# --- record the framework version pin in TRD.md ---
$TrdPath = Join-Path $ProjectDir 'project-docs\TRD.md'
if (Test-Path $TrdPath) {
    Add-Content -Path $TrdPath -Value "`n<!-- Framework pin (GOVERNANCE.md Section 4) -->`nFramework: $Version (pinned $(Get-Date -Format 'yyyy-MM-dd'))"
}

# --- write the project-level CLAUDE.md ---
$LessonsFile = "$($Name)_Audit_Lessons.md"
$ProjectClaudeMd = @"
# CLAUDE.md — $Name (project rules)

## The framework governs this project

- Follow the TheAIOfficers build framework at:
  ``$FrameworkRoot``
- Read that framework's ``CLAUDE.md`` at the start of EVERY session, then follow its session-start
  protocol (targeted layer reading, project memory docs, SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT).
- This project is pinned to framework **$Version** (recorded in ``project-docs/TRD.md``). If the
  framework's current version differs, follow GOVERNANCE.md Section 4 before adopting new rules.
- Planning/memory documents live in ``project-docs/`` — the pre-coding gate applies: no application
  code until the six gate docs are complete and mockups are approved.
- Never edit the canonical framework files; propose changes via the framework's ``PROPOSED-RULES.md``.
- Before building, read the framework's ``GLOBAL-AUDIT-LESSONS.md`` and this project's
  ``$LessonsFile``; the auditor checks every lesson and appends new repeatable mistakes.

## Operating rules (apply regardless of model)

1. **Verify, don't assume.** Never claim a file, function, or behaviour exists without reading it
   this session. Label claims as fact (read/ran it), inference, or assumption.
2. **Root cause first.** Reproduce and diagnose before fixing. Never patch a symptom.
3. **Prove it works.** Run or test every change and show the output. "Should work" is not done.
4. **Report honestly.** Lead with the outcome. Failed tests, skipped steps, and unmet criteria are
   stated plainly — never a success report without verification.
5. **No sycophancy.** No praise openers. Push back on flawed ideas with the specific failure case
   and a stronger alternative.
6. **Smallest change that solves it.** Don't refactor, rename, or "improve" untouched code. New
   ideas found mid-task go to ``project-docs/productdebt.md`` — never silent scope growth.
7. **Finish the turn.** No response ends with an unfulfilled promise. Do it now, or name the exact
   input that blocks it.
8. **Ask only when it matters.** Reversible in-scope work proceeds without asking. Destructive,
   outward-facing (deploy/publish/send), or scope-changing actions stop for approval.
9. **Update the docs with the code.** todo.md / techdebt.md / build-log at session end. Code and
   gate docs must never silently diverge.
10. **Explain for the owner.** Plain-language "what this means for you" alongside every technical
    decision — the owner verifies through docs and the admin panel, not code.

## Project-specific notes

(Add project-only rules and context below this line. Standards live in the framework, not here.)
"@
Set-Content -Path (Join-Path $ProjectDir 'CLAUDE.md') -Value $ProjectClaudeMd -Encoding utf8

# --- write the project audit-lessons file (GLOBAL-AUDIT-LESSONS.md explains the system) ---
$LessonsMd = @"
# $Name — Audit Lessons (read before every build; the auditor checks each line)
Append-only. One line per lesson. Never delete; mark RETIRED. Keep it short (~60 live lines).
Hit = one separate audit round where the mistake was found. Tag project-agnostic lessons [GLOBAL?]
and propose them in the framework's PROPOSED-RULES.md.

| # | Lesson | Check | Sev | Hits | Source |
|---|--------|-------|-----|------|--------|
"@
Set-Content -Path (Join-Path $ProjectDir $LessonsFile) -Value $LessonsMd -Encoding utf8

# --- optional model routing (founder's cost override, CLAUDE.md Section 16 rule 7) ---
$SettingsWritten = $false
if ($BuildModel -or $AdvisorModel) {
    # Settings keys 'model' / 'advisorModel' checked against Claude Code docs 2026-10-21; re-verify per MODEL-CHECK.md.
    $Settings = [ordered]@{}
    if ($BuildModel)   { $Settings['model'] = $BuildModel }
    if ($AdvisorModel) { $Settings['advisorModel'] = $AdvisorModel }
    New-Item -ItemType Directory -Path (Join-Path $ProjectDir '.claude') | Out-Null
    # UTF-8 without BOM, so strict JSON readers accept it on Windows PowerShell 5.1 too
    [IO.File]::WriteAllText((Join-Path $ProjectDir '.claude\settings.json'), ($Settings | ConvertTo-Json), (New-Object Text.UTF8Encoding $false))
    $BuildLabel = if ($BuildModel) { $BuildModel } else { 'default' }
    $AdvisorLabel = if ($AdvisorModel) { $AdvisorModel } else { 'none' }
    Add-Content -Path (Join-Path $ProjectDir 'CLAUDE.md') -Value "`n## Model routing (set by the founder at setup, $(Get-Date -Format 'yyyy-MM-dd'); framework CLAUDE.md Section 16 rule 7)`n`n- Build: $BuildLabel · Advisor: $AdvisorLabel (set in ``.claude/settings.json``). Planning and audits stay with the best model.`n- Run the framework's ``MODEL-CHECK.md`` in the first session to confirm all four roles against today's models.`n" -Encoding utf8
    $SettingsWritten = $true
} else {
    Add-Content -Path (Join-Path $ProjectDir 'CLAUDE.md') -Value "`n## Model routing — not yet confirmed`n`n- Run the framework's ``MODEL-CHECK.md`` in the first session: the founder confirms which model builds, advises, plans/audits and searches.`n" -Encoding utf8
}

# --- start git history ---
$GitAvailable = $null -ne (Get-Command git -ErrorAction SilentlyContinue)
if ($GitAvailable) {
    Push-Location $ProjectDir
    try {
        git init --quiet
        Set-Content -Path '.gitignore' -Value ".env`n.env.*`nnode_modules/`ndist/`n__pycache__/`n*.log"
        git add -A
        git commit --quiet -m "chore: bootstrap project from claude-build-framework $Version"
    } finally {
        Pop-Location
    }
} else {
    Write-Host "NOTE: git not found — skipped version history. Install git and run 'git init' in the project later." -ForegroundColor Yellow
}

# --- report ---
Write-Host ""
Write-Host "DONE — project created." -ForegroundColor Green
Write-Host "  Folder:            $ProjectDir"
Write-Host "  Framework version: $Version (pinned in project-docs\TRD.md)"
Write-Host "  Planning docs:     $ProjectDir\project-docs\"
Write-Host "  Audit lessons:     $ProjectDir\$LessonsFile"
if ($SettingsWritten) { Write-Host "  Model routing:     .claude\settings.json (build: $BuildLabel, advisor: $AdvisorLabel)" }
else { Write-Host "  Model routing:     not set — in the first session say 'check my models' (MODEL-CHECK.md)" }
if ($GitAvailable) { Write-Host "  Git:               initialised with first commit" }
Write-Host ""
Write-Host "NEXT STEP: open Claude Code inside this folder and paste the kickoff prompt from START-HERE.md (Step 2)." -ForegroundColor Cyan
