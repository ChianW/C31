#!/bin/bash
# C31 (C31) — Universal AI Workflow Skills
# https://github.com/ChianW/C31
#
# Usage:
#   ./install.sh              # install core skills (default)
#   ./install.sh all          # install all skill packages
#   ./install.sh product      # install product/business skills
#   ./install.sh personal     # install personal tools (c31-sxs, etc.)
#
# Supports: Gemini CLI · Claude Code · Kimi CLI · OpenClaw · Hermes

set -e

PACKAGE=${1:-"core"}
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEMORY_DIR="${HOME}/.C31"

# ─── Auto-detect AI tool skills directory ───
if [ -d "${HOME}/.claude/skills" ]; then
  SKILLS_DIR="${HOME}/.claude/skills"
  TOOL="Claude Code"
elif [ -d "${HOME}/.gemini/config/skills" ]; then
  SKILLS_DIR="${HOME}/.gemini/config/skills"
  TOOL="Gemini CLI"
elif [ -d "${HOME}/.kimi/skills" ]; then
  SKILLS_DIR="${HOME}/.kimi/skills"
  TOOL="Kimi CLI"
else
  SKILLS_DIR="${HOME}/.gemini/config/skills"
  TOOL="Gemini CLI (default)"
fi

echo ""
echo "  ╔═══════════════════════════════════╗"
echo "  ║        C31 (C31)             ║"
echo "  ║  Engineering Workflow Skills      ║"
echo "  ╚═══════════════════════════════════╝"
echo ""
echo "  Detected: ${TOOL}"
echo "  Skills dir: ${SKILLS_DIR}"
echo "  Package: ${PACKAGE}"
echo ""

# ─── Create directories ───
mkdir -p "${SKILLS_DIR}"
mkdir -p "${MEMORY_DIR}/memory/diary"
mkdir -p "${MEMORY_DIR}/memory/instincts"

# ─── Install skills ───
case $PACKAGE in
  "all")
    for dir in "${REPO}/skills"/*/; do
      cp -r "${dir}"* "${SKILLS_DIR}/" 2>/dev/null || true
    done
    ;;
  "core"|"review"|"product"|"utils"|"personal"|"platform-specific")
    if [ -d "${REPO}/skills/${PACKAGE}" ]; then
      cp -r "${REPO}/skills/${PACKAGE}/"* "${SKILLS_DIR}/"
    else
      echo "  ✗ Package '${PACKAGE}' not found"
      exit 1
    fi
    ;;
  *)
    echo "  ✗ Unknown package: ${PACKAGE}"
    echo "  Available: core, review, product, utils, personal, all"
    exit 1
    ;;
esac

echo "  ✓ C31 [${PACKAGE}] skills installed to ${SKILLS_DIR}"
echo ""
echo "  ─── Next Steps ─────────────────────────────────"
echo "  1. Copy AGENTS.template.md to your project root:"
echo "     GEMINI.md   → Gemini CLI / Antigravity"
echo "     CLAUDE.md   → Claude Code"
echo "     AGENTS.md   → OpenClaw / Hermes / Kimi CLI"
echo ""
echo "  2. Replace placeholders in your AGENTS file:"
echo "     {YOUR_HOME}    → your home directory path"
echo "     {YOUR_PROJECT} → your project name"
echo "     {MEMORY_DIR}   → ${MEMORY_DIR}"
echo ""
echo "  3. Start your AI tool and try: 'brainstorm', 'plan', 'review'"
echo "  ─────────────────────────────────────────────────"
echo ""
