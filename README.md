# C31 — Agent Harness System

**Not just skills. A complete agent harness.**

Memory that persists. Instincts that evolve. Context that stays healthy.  
Built from 5+ months of daily production use. Powers **[chian.io](https://chian.io)** and **[chian.io/investment-os](https://chian.io/investment-os)**.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-50%2B-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#compatibility)
[![Languages](https://img.shields.io/badge/languages-EN%20%7C%20ZH%20%7C%20JA-orange.svg)](#languages)

> 🇨🇳 [中文版](README.zh.md) · 🇯🇵 [日本語版](README.ja.md)

---

## Built With C31

| Project | Description |
|---------|-------------|
| **[chian.io](https://chian.io)** | *"Being Human is a Luxury."* — A knowledge platform and personal OS exploring taste, judgment, and the irreducible human edge. Products include Investment OS, The Silicon Boardroom (podcast), Project Q, and System Reboot. |
| **[chian.io/investment-os](https://chian.io/investment-os)** | *Master Clone System* — Buffett's 70 years of shareholder letters (1956–2025) + Howard Marks' 160+ memos (1990–2026), decoded into fully cross-linked knowledge graphs queryable by humans and AI agents. |

*Built something with C31? Open a PR to add it here.*

---

## What is C31?

C31 is an **agent harness system** — the layer between you and your AI tool that makes every session smarter than the last.

Most prompt collections give you one-shot instructions. C31 gives you a **persistent operating system for your AI**:

| Layer | What It Does |
|-------|-------------|
| **Skills** (50+) | Structured workflows: brainstorm → plan → work → **simplify** → review → compound |
| **Memory System** | `session_state.json` + diary + instincts — state persists across sessions |
| **Instinct Evolution** | AI learns from every interaction; patterns graduate from `candidate → verifying → instinct` |
| **Context Health** | 🟢🟡🟠🔴 four-state monitoring prevents context rot in long sessions |
| **Psych-Framing** | Step-by-step reasoning enforcement + confidence-check output validation |
| **Critic Gate** | Auto quality gate: outputs >300 words with inferred conclusions trigger self-audit |

---

## The 5-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTS.template.md  (GEMINI.md / CLAUDE.md / AGENTS.md)   │
│  ─ Engineering principles  ─ Decision boundaries            │
│  ─ Ambient weighting       ─ Critic Gate                    │
│  ─ Psych-framing layer     ─ Fix-it Cascade                 │
├─────────────────────────────────────────────────────────────┤
│  SKILLS (50+)                                               │
│  core/ · review/ · product/ · utils/ · personal/           │
├─────────────────────────────────────────────────────────────┤
│  MEMORY SYSTEM                                              │
│  session_state.json  ←→  diary/  ←→  instincts/            │
├─────────────────────────────────────────────────────────────┤
│  INSTINCT EVOLUTION                                         │
│  candidate (1/3) → verifying (2/3) → instinct (3/3)        │
│  confidence: 0.3–0.9 · deprecated if <0.3                  │
├─────────────────────────────────────────────────────────────┤
│  CONTEXT HEALTH                                             │
│  🟢 <50%  🟡 50-70%  🟠 70-85%  🔴 >85% → force checkpoint │
└─────────────────────────────────────────────────────────────┘
```

---

## What Makes C31 Different

### 1. Memory That Persists
Unlike stateless prompt files, C31 remembers. `session_state.json` tracks active projects, open todos, and pending decisions. A diary captures daily work. Instinct files store learned patterns with confidence scores.

```
~/.cystem31/
├── memory/
│   ├── session_state.json   ← last topic, open todos, completed tasks
│   ├── diary/YYYY-MM-DD.md  ← daily session logs
│   └── instincts/           ← evolved behavioral patterns
└── solutions-registry.md    ← index of all documented solutions
```

### 2. Instincts That Evolve
The AI doesn't just follow rules — it builds up instincts. When a pattern succeeds 3 times, it graduates to an `instinct` (auto-applied, no confirmation needed). When a user says "that's wrong," the confidence score drops below 0.3 and the pattern is deprecated.

```
instinct-001-no-overwrite.md     confidence: 0.95  ← auto-applied
instinct-002-research-first.md   confidence: 0.90  ← auto-applied
instinct-003-surgical-changes.md confidence: 0.90  ← auto-applied
instinct-004-C31-compound.md      confidence: 0.85  ← auto-applied
```

### 3. Context Health Monitoring
Long sessions kill AI quality. C31 monitors context window usage and takes automatic action:

| State | Usage | Action |
|-------|-------|--------|
| 🟢 Green | <50% | Normal operation |
| 🟡 Yellow | 50–70% | Begin compressing completed work |
| 🟠 Orange | 70–85% | Move decisions to files, archive assumptions |
| 🔴 Red | >85% | Force checkpoint: write state, then continue |

### 4. Psychological Framing Layer
C31 embeds research-backed cognitive techniques directly into the harness:
- **Step-by-step reasoning**: Complex analysis unfolds internally before output (reduces errors ~34%)
- **Confidence check**: Every significant output carries a gap annotation
- **Critic Gate**: Auto-triggered self-audit on inferred conclusions >300 words
- **Anti-sycophancy**: Technical rigor over social comfort — disagreement triggers independent evaluation, not capitulation

### 5. Compounding Knowledge
Every solved problem becomes institutional memory. The `C31-compound` workflow writes solutions to `docs/solutions/` with an INDEX entry. The next time the same class of problem appears, it takes minutes instead of hours.

---

## Quick Install

```bash
git clone https://github.com/ChianW/C31.git
cd C31
./install.sh          # macOS / Linux — installs core skills
.\install.ps1         # Windows PowerShell

./install.sh all      # everything (43 skills)
./install.sh product  # product/business skills only
```

**Then copy `AGENTS.template.md` to your project root:**

| Your Tool | Filename | Language |
|-----------|----------|----------|
| Gemini CLI / Antigravity | `GEMINI.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |
| Claude Code / Codex | `CLAUDE.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |
| OpenClaw / Hermes / Kimi CLI | `AGENTS.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |

Replace `{YOUR_HOME}`, `{YOUR_PROJECT}`, `{MEMORY_DIR}` with your actual paths.

---

## The Guides

> Full documentation is in [PHILOSOPHY.md](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

| Guide | What You'll Learn |
|-------|------------------|
| **[Quick Start](AGENTS.template.md)** | Install, configure, and run your first C31 session |
| **[Engineering Philosophy](PHILOSOPHY.md)** | The 5 Karpathy principles + Doubt-Driven Development + Chesterton's Fence |
| **[Memory System](AGENTS.template.md#session-startup-protocol)** | How session state, diary, and instincts work together |
| **[Instinct Evolution](AGENTS.template.md#instinct-system)** | How patterns graduate from candidate to auto-applied instinct |
| **[Context Health](AGENTS.template.md#own-your-context-window)** | Managing the 4-state context system for long sessions |
| **[Skill Index](skills/)** | All 43 skills with triggers in EN · ZH · JA |

---

## Skill Index

### 🔧 core/ (18) — Engineering Workflow

| Skill | EN Trigger | ZH | JA |
|-------|-----------|----|----|
| C31-1st | `first principles` | 第一性原理 | 第一原理 |
| C31-brainstorm | `brainstorm` | 头脑风暴 | ブレスト |
| C31-plan | `plan` | 制定计划 | 計画を立てる |
| C31-spec | `spec` | 写需求 | 仕様を書く |
| C31-work | `work` | 开干 | 実装する |
| C31-research | `research` | 调研 | 調査する |
| C31-coding-discipline | `coding` | 写代码 | コーディング |
| C31-debug | `debug` | 调试 | デバッグ |
| C31-compound | `compound` | 复利 | 知識を記録 |
| C31-strategy | `strategy` | 定战略 | 戦略を立てる |
| C31-lfg | `lfg` | 开干 | やろう |
| C31-context-engineering | `context` | 上下文 | コンテキスト管理 |
| C31-adopt-project | `adopt` | 看看这个项目 | プロジェクト調査 |
| C31-compound-refresh | `refresh` | 更新知识库 | ドキュメント更新 |
| C31-workflow-bug-reproduction | `reproduce` | 复现bug | バグ再現 |
| ce-simplify-code | `simplify` | 简化代码 | コード簡素化 |
| ce-pov | `pov` | 技术决策 | 技術判定 |
| ce-promote | `promote` | 发布公告 | リリース告知 |

### 🔍 review/ (5) — Multi-Agent Code Review

`C31-review` · `C31-review-security` · `C31-review-architecture` · `C31-review-adversarial` · `C31-multi-review`

### 💼 product/ (11) — Product & Business

`c31-community` · `c31-validate` · `c31-mvp` · `c31-process` · `c31-sell` · `c31-market` · `c31-grow` · `c31-price` · `c31-gutcheck` · `c31-values` · `growth-hacker`

### 🛠️ utils/ (8) · 🧘 personal/ (2) · ⚙️ platform-specific/ (2)

---

## Intellectual Foundations

C31 synthesizes design philosophy from 9 frameworks, built into a unified harness:

| Source | Key Contribution to C31 |
|--------|------------------------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 5 core engineering principles (the bedrock) |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | Stateless reducer · context ownership · compact errors |
| **[ECC](https://github.com/affaan-m/ecc)** | Instinct evolution system · context health colors · continuous learning loop |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | Brainstorm→Plan→Work→**Simplify**→Review→Compound lifecycle · Deletion Test · Behavior Change Contract |
| **[Superpowers](https://github.com/obra/superpowers)** | Subagent-driven development · verification-before-completion |
| **[Archon](https://github.com/coleam00/Archon)** | Agent lifecycle governance · no autonomous mutation |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | Context engineering · artifacts-over-memory · plan quality gate |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | Doubt-Driven Development · Chesterton's Fence · anti-sycophancy |
| **Psychological Framing** | Step-by-step reasoning · confidence-check · Critic Gate |

---

## Compatibility

Works with any AI coding tool that supports markdown context files:

| Platform | Install | Config File |
|----------|---------|-------------|
| **Antigravity** (Gemini CLI) | `./install.sh` | `GEMINI.md` |
| **Claude Code** | `./install.sh` | `CLAUDE.md` |
| **Codex** | `./install.sh` | `CLAUDE.md` |
| **Kimi CLI** | `./install.sh` | `AGENTS.md` |
| **OpenClaw** | `./install.sh` | `AGENTS.md` |
| **Hermes** | `./install.sh` | `AGENTS.md` |

Windows: use `.\install.ps1`

---

## Languages

- 🇺🇸 [English](README.md) (this page)
- 🇨🇳 [中文](README.zh.md)
- 🇯🇵 [日本語](README.ja.md)

---

## Contributing

1. Fork the repo
2. Add your skill to the appropriate `skills/` category
3. Include multilingual triggers (EN · ZH · JA) in the SKILL.md frontmatter
4. Open a PR

Built something with C31? Add it to the **Built With C31** table.

---

## License

MIT — see [LICENSE](LICENSE)
