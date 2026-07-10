# C31 (C31) — Universal AI Workflow Skills
# https://github.com/ChianW/C31
#
# Usage:
#   .\install.ps1              # install core skills (default)
#   .\install.ps1 all          # install all skill packages
#   .\install.ps1 product      # install product/business skills
#   .\install.ps1 personal     # install personal tools
#
# Supports: Gemini CLI · Claude Code · Kimi CLI · OpenClaw · Hermes

param(
    [string]$Package = "core"
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$MemoryDir = Join-Path $env:USERPROFILE ".C31"

# ─── Auto-detect AI tool skills directory ───
if (Test-Path (Join-Path $env:USERPROFILE ".claude\skills")) {
    $SkillsDir = Join-Path $env:USERPROFILE ".claude\skills"
    $Tool = "Claude Code"
} elseif (Test-Path (Join-Path $env:USERPROFILE ".gemini\config\skills")) {
    $SkillsDir = Join-Path $env:USERPROFILE ".gemini\config\skills"
    $Tool = "Gemini CLI"
} else {
    $SkillsDir = Join-Path $env:USERPROFILE ".gemini\config\skills"
    $Tool = "Gemini CLI (default)"
}

Write-Host ""
Write-Host "  +===================================+"
Write-Host "  |        C31 (C31)             |"
Write-Host "  |  Engineering Workflow Skills      |"
Write-Host "  +===================================+"
Write-Host ""
Write-Host "  Detected: $Tool"
Write-Host "  Skills dir: $SkillsDir"
Write-Host "  Package: $Package"
Write-Host ""

# ─── Create directories ───
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path "$MemoryDir\memory\diary" | Out-Null
New-Item -ItemType Directory -Force -Path "$MemoryDir\memory\instincts" | Out-Null

# ─── Install skills ───
$SkillsRoot = Join-Path $Repo "skills"

switch ($Package) {
    "all" {
        Get-ChildItem -Path $SkillsRoot -Directory | ForEach-Object {
            Copy-Item -Recurse -Force (Join-Path $_.FullName "*") $SkillsDir -ErrorAction SilentlyContinue
        }
    }
    { $_ -in "core","review","product","utils","personal","platform-specific" } {
        $PkgPath = Join-Path $SkillsRoot $Package
        if (Test-Path $PkgPath) {
            Copy-Item -Recurse -Force (Join-Path $PkgPath "*") $SkillsDir
        } else {
            Write-Host "  x Package '$Package' not found"
            exit 1
        }
    }
    default {
        Write-Host "  x Unknown package: $Package"
        Write-Host "  Available: core, review, product, utils, personal, all"
        exit 1
    }
}

Write-Host "  v C31 [$Package] skills installed to $SkillsDir"
Write-Host ""
Write-Host "  --- Next Steps -------------------------------------------"
Write-Host "  1. Copy AGENTS.template.md to your project root as:"
Write-Host "     GEMINI.md   -> Gemini CLI / Antigravity"
Write-Host "     CLAUDE.md   -> Claude Code"
Write-Host "     AGENTS.md   -> OpenClaw / Hermes / Kimi CLI"
Write-Host ""
Write-Host "  2. Replace placeholders:"
Write-Host "     {YOUR_HOME}    -> $env:USERPROFILE"
Write-Host "     {YOUR_PROJECT} -> your project name"
Write-Host "     {MEMORY_DIR}   -> $MemoryDir"
Write-Host ""
Write-Host "  3. Start your AI tool and try: 'brainstorm', 'plan', 'review'"
Write-Host "  ----------------------------------------------------------"
Write-Host ""
