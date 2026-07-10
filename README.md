# Cystem31 (C31)

**An opinionated engineering workflow system for AI coding agents.**  
Built from 10+ months of daily production use. Powers [chian.io](https://chian.io) and [chian.io/investment-os](https://chian.io/investment-os).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-43-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#compatibility)

---

## Built With C31

> These projects were designed, planned, and shipped entirely using the C31 workflow:

| Project | What it is | C31 Skills Used |
|---------|-----------|-----------------|
| **[chian.io](https://chian.io)** | Personal OS & knowledge platform | C31-brainstorm · C31-plan · C31-work · C31-compound |
| **[chian.io/investment-os](https://chian.io/investment-os)** | AI-powered investment knowledge system | C31-spec · C31-review · C31-coding-discipline · C31-strategy |

*If you build something with C31, open a PR to add it here.*

---

## What is Cystem31?

C31 is a collection of 43 skills (markdown instruction files) that give any AI coding agent — Claude, Gemini, Kimi, or others — a structured engineering discipline.

**It is not a prompt library.** It is a way of thinking made systematic:

- **Before you code**: brainstorm requirements, surface assumptions, write a plan
- **While you code**: surgical changes, doubt-driven decisions, no "later" shortcuts
- **After you code**: multi-agent review, compound learnings into institutional memory

The result: every session compounds. Solutions documented today save hours next week.

---

## Quick Install

```bash
# Clone and install core skills (recommended start)
git clone https://github.com/ChianW/Cystem31.git
cd Cystem31
./install.sh            # macOS / Linux
.\install.ps1           # Windows PowerShell

# Install everything
./install.sh all

# Install only product/business skills
./install.sh product
```

Then copy `AGENTS.template.md` to your project root as:
- `GEMINI.md` → Gemini CLI / Antigravity
- `CLAUDE.md` → Claude Code / Codex
- `AGENTS.md` → OpenClaw / Hermes / Kimi CLI

---

## Skill Index

### 🔧 core/ — Engineering Workflow (15 skills)

| Skill | Trigger | What it does |
|-------|---------|-------------|
| C31-1st | `first principles`, `第一性原理`, `第一原理` | Strip problems to axioms and rebuild from truth |
| C31-brainstorm | `brainstorm`, `头脑风暴`, `ブレスト` | Convert fuzzy requirements into numbered decision points |
| C31-plan | `plan`, `制定计划`, `計画を立てる` | Turn requirements into validated, executable plans |
| C31-spec | `spec`, `写需求`, `仕様を書く` | Write PRDs that serve as intent-implementation contracts |
| C31-work | `work`, `开干`, `実装する` | Execute plans with task tracking and quality gates |
| C31-research | `research`, `调研`, `調査する` | Framework docs, git history, community issues, institutional memory |
| C31-coding-discipline | `coding`, `写代码`, `コーディング` | 7-step TDD workflow with mandatory self-review |
| C31-debug | `debug`, `修复`, `デバッグ` | Root-cause tracing from reproduction to verified fix |
| C31-compound | `compound`, `复利`, `記録する` | Document solved problems to compound team knowledge |
| C31-strategy | `strategy`, `定战略`, `戦略を立てる` | Create STRATEGY.md anchoring all downstream work |
| C31-lfg | `lfg`, `开干`, `やろう` | Full-auto 9-gate execution pipeline when plan is ready |
| C31-context-engineering | `context`, `上下文`, `コンテキスト` | Manage context window health and prevent context rot |
| C31-adopt-project | `adopt`, `看看这个项目`, `プロジェクト調査` | 5-phase research: philosophy → gap analysis → integration |
| C31-compound-refresh | `refresh compound`, `更新知识库` | Refresh existing compound docs with new findings |
| C31-workflow-bug-reproduction | `reproduce`, `复现bug`, `バグ再現` | Hypothesis → minimal reproduction → verified root cause |

### 🔍 review/ — Code Review (5 skills)

| Skill | Trigger | What it does |
|-------|---------|-------------|
| C31-review | `review`, `审查`, `レビュー` | Parallel multi-persona review + UAT + coverage check |
| C31-review-security | `security review`, `安全审查` | Exploitable vulnerabilities, auth gaps, injection, XSS |
| C31-review-architecture | `arch review`, `架构审查` | Coupling, layering, abstraction leaks, boundaries |
| C31-review-adversarial | `adversarial review`, `对抗审查` | Fault propagation, undeclared assumptions, TOCTOU |
| C31-multi-review | `multi-review`, `多角色审查` | 4-agent adversarial parallel review with conflict detection |

### 💼 product/ — Product & Business (11 skills)

| Skill | Trigger | What it does |
|-------|---------|-------------|
| c31-community | `找社区`, `community` | Find and validate the right community to serve |
| c31-validate | `validate`, `验证想法` | Test ideas before building anything |
| c31-mvp | `MVP`, `最小可行产品` | Build manual-first, then processize, then productize |
| c31-process | `processize`, `流程化` | Turn manual delivery into repeatable process |
| c31-sell | `first customers`, `前100客户` | Strategy for landing first 100 paying customers |
| c31-market | `marketing plan`, `内容策略` | Audience-first content marketing, not ads |
| c31-grow | `profitable growth`, `可持续增长` | Sustainable growth without burnout |
| c31-price | `pricing`, `定价` | Value-based pricing strategy |
| c31-gutcheck | `gut check`, `极简审查` | Minimalist entrepreneur lens on any decision |
| c31-values | `company values`, `价值观` | Define culture and collaboration principles |
| growth-hacker | `growth hacking`, `增长` | Systematic growth experimentation |

### 🛠️ utils/ — Utilities (8 skills)

`find-skills` · `time-awareness` · `gsd-map-codebase` · `gsd-new-project` · `gsd-progress` · `gsd-quick` · `gsd-ship` · `worker-safety`

### 🧘 personal/ — Personal Tools (2 skills)

`c31-sxs` (四寻思观 — Buddhist deconstruction of emotions and decisions) · `video-content-analysis`

---

## Core Philosophy

> Full details: [PHILOSOPHY.md](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

**Five Principles (Karpathy-derived):**
1. **Think Before Coding** — Research phase before every action
2. **Simplicity First** — Minimum viable logic only
3. **Surgical Changes** — Scope strictly limited to the task
4. **Goal-Driven Execution** — Tests define done, not "it works on my machine"
5. **First-Principles Thinking** — Reason from truth, not convention

**Plus:** Doubt-Driven Development · Chesterton's Fence · No "Later" · Rollback-First · Compounding Sessions

---

## Intellectual Foundations

C31 integrates design philosophy and frameworks from:

| Source | Key Contribution |
|--------|-----------------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 5 core engineering principles |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | Stateless reducer pattern, context ownership, compact errors |
| **[ECC](https://github.com/affaan-m/ecc)** | Continuous learning loop, context health system, instinct evolution |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | Brainstorm→Plan→Work→Review→Compound lifecycle |
| **[Superpowers](https://github.com/obra/superpowers)** | Subagent-driven development, verification-before-completion |
| **[Archon](https://github.com/coleam00/Archon)** | Agent lifecycle governance, no autonomous mutation |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | Context engineering, artifacts-over-memory, plan quality gate |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | Doubt-Driven Development, Chesterton's Fence, anti-sycophancy |
| **Psychological Framing** | Step-by-step reasoning, confidence-check output validation |

---

## Compatibility

| Platform | Install | AGENTS file |
|----------|---------|-------------|
| **Antigravity** (Gemini CLI) | `./install.sh` | `GEMINI.md` |
| **Claude Code** | `./install.sh` | `CLAUDE.md` |
| **Codex** | `./install.sh` | `CLAUDE.md` |
| **Kimi CLI** | `./install.sh` | `AGENTS.md` |
| **OpenClaw** | `./install.sh` | `AGENTS.md` |
| **Hermes** | `./install.sh` | `AGENTS.md` |

Windows users: use `.\install.ps1` instead of `./install.sh`.

---

## Languages

- 🇺🇸 [English](README.md) (this file)
- 🇨🇳 [中文](README.zh.md)
- 🇯🇵 [日本語](README.ja.md)

---

## Contributing

1. Fork the repo
2. Add your skill under the appropriate `skills/` category
3. Follow the [SKILL.md format](skills/core/C31-brainstorm/SKILL.md) with multilingual triggers
4. Open a PR

Built with C31? Add your project to the **Built With C31** table above.

---

## License

MIT — see [LICENSE](LICENSE)
