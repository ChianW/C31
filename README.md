# C31 — Agent Harness System

> You wrote 1,000 prompts for your AI. Then the conversation reset. It forgot everything.
> This is why you need an agent harness — not better prompts, but a persistent operating layer.

**C31** is the agent harness forged from 7 open-source frameworks and 5 months of daily production use.  
Memory that persists. Instincts that evolve. Context that stays healthy.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-43-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#compatibility)
[![Languages](https://img.shields.io/badge/languages-EN%20%7C%20ZH%20%7C%20JA-orange.svg)](#languages)

> 🇨🇳 [中文版](README.zh.md) · 🇯🇵 [日本語版](README.ja.md)

---

## Built With C31

| Project | Description |
|---------|-------------|
| **[chian.io](https://chian.io)** | *"Being Human is a Luxury."* — A knowledge platform and personal OS exploring taste, judgment, and the irreducible human edge. Products include Investment OS, The Silicon Boardroom (podcast), Project Q, and System Reboot. |
| **[chian.io/investment-os](https://chian.io/investment-os)** | *Master Clone System* — Buffett's 70 years of shareholder letters (1956–2025) + Howard Marks' 160+ memos (1990–2026), decoded into fully cross-linked knowledge graphs queryable by humans and AI agents. |
| **[chian.io/kyoto](https://chian.io/kyoto)** | *A philosopher's map of Kyoto.* — 61 temples, shrines, and sacred paths, each one connected to an essay on time, impermanence, and the examined life. Travel as philosophy. |
| **[agi-cd.com](https://agi-cd.com)** | *AGI Countdown — Calibrating the Only Question That Matters.* — A daily signal feed counting down to AGI Zero Day (2029-03-07). Cross-disciplinary insights from philosophy, history, economics, geopolitics, and investing to align your thinking with the post-AGI world. |

*Built something with C31? Open a PR to add it here.*

---

## What is C31?

In seven years running a think tank and investment firm, AI arrived and changed everything. I gradually realized that the only question worth thinking about was: *what will society look like after AGI?* In 2025, I made a decisive move — I let my investment firm become a company of just me and Agents.

Within the first week of building, I discovered the core problem: **the AI was brilliant at generating code and completely incapable of remembering anything.**

I needed a system — not better prompts. So I audited 7 open-source agent frameworks in 48 hours and forged their best ideas into a unified harness. That system is C31.

Most prompt collections give you one-shot instructions. C31 gives you a **persistent operating system for your AI**:

| Layer | What It Does |
|-------|-------------|
| **Skills** (43) | Structured workflows: brainstorm → plan → work → **simplify** → review → compound |
| **Memory System** | `session_state.json` + diary + instincts — state persists across sessions |
| **Instinct Evolution** | AI learns from every interaction; patterns graduate from `candidate → verifying → instinct` |
| **Context Health** | 🟢🟡🟠🔴 four-state monitoring prevents context rot in long sessions |
| **Psych-Framing** | Step-by-step reasoning enforcement + confidence-check output validation |
| **Critic Gate** | Auto quality gate: outputs >300 words with inferred conclusions trigger self-audit |

---

## The 2026 Consensus

In 2025–2026, seven independent open-source projects attacked the same problems from different angles. They had different authors, different philosophies, different star counts. But they converged on five conclusions:

**1. Architecture beats prompts.**
Reliability doesn't come from better wording. It comes from structure — explicit control flow, quality gates, state management. You don't prompt your way to production-grade agents. You engineer them.

**2. Agents need persistent state.**
Session-scoped memory is not enough. Instincts, learnings, and decisions must survive across conversations. The agent should get smarter over time, not reset to baseline every session.

**3. Multi-agent orchestration beats monolithic agents.**
A specialized small agent that does one thing well outperforms a single agent trying to brainstorm, code, test, review, and document all in one context window. Delegation is not a feature — it's an architectural requirement.

**4. Human-in-the-loop is a first-class operation.**
Irreversible actions need approval gates. The best systems make the boundary between "AI decides autonomously" and "AI pauses for human input" explicit and configurable.

**5. Knowledge compounds — if you capture it.**
The final step of every workflow should leave the system better than it found it. Document the solution. Index it. Make it searchable. The next time the same class of problem appears, it should take minutes, not hours.

---

## The 5-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTS.template.md  (GEMINI.md / CLAUDE.md / AGENTS.md)   │
│  ─ Engineering principles  ─ Decision boundaries            │
│  ─ Ambient weighting       ─ Critic Gate                    │
│  ─ Psych-framing layer     ─ Fix-it Cascade                 │
├─────────────────────────────────────────────────────────────┤
│  SKILLS (43)                                                │
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

### 1. A Workflow with Hard Gates — Not a Checklist

> *Forged from: Compound Engineering Plugin (lifecycle) + 12-Factor Agents (F12: Stateless Reducer) + Archon (deterministic pipelines)*

Most AI workflows are checklists. C31's lifecycle is a **pipeline** — each step takes structured output from the previous step as its only input, and produces structured output for the next. Context is passed as files, not conversation.

```
Brainstorm → Plan → Work → Simplify → Review → Compound
   ↓             ↓        ↓          ↓         ↓          ↓
Decision doc  Plan+    Tests     No regressions  APPROVED  docs/solutions/
(numbered)    threat    green      verified               + INDEX entry
              model
```

Every step has a **verification gate** — a binary condition that must be true before the next step begins. Plans require human approval. Tests must be green before review. Solutions require an INDEX entry before being declared done.

> **Why it matters:** An INDEX entry without the document is invisible. A document without an INDEX entry is also invisible. C31 enforces both. → [Full Workflow Architecture](WORKFLOW.md)

---

### 2. Multi-Agent Orchestration — 4 Patterns

> *Forged from: Compound Engineering (compound subagents) + Archon (subagent governance) + Superpowers (Do Not Trust the Report)*

C31 uses four distinct subagent orchestration patterns. The core architectural principle across all four: **specialized agents working in parallel outperform a single agent trying to do everything.**

#### Pattern A — Parallel Adversarial Review

4 isolated agents review the same code simultaneously. A 5th agent detects contradictions between them.

```
            Code / Diff
               │ (broadcast)
  ┌────────────┼────────────┐────────────┐
  ▼            ▼            ▼            ▼
CORRECTNESS  SECURITY  MAINTAINABILITY SIMPLICITY
  (isolated)  (isolated)   (isolated)   (isolated)
  │            │            │            │
  └────────────┼────────────┘────────────┘
               ▼
        CONFLICT AGENT (5th)
        Detect contradictions · Severity gaps · Human flags
               ▼
        SYNTHESIS: APPROVED / WARNED / BLOCKED
```

**Why isolated agents?** Isolation prevents groupthink. A reviewer hunting for security vulnerabilities won't also notice over-engineering — unless that's all they're looking for. Each of the 4 agents operates in read-only mode with zero knowledge of the other agents' findings, so their disagreements become signal, not noise.

#### Pattern B — Parallel Knowledge Extraction

When a problem is solved, 3 agents run simultaneously to extract different dimensions of the solution:

| Agent | Extracts |
|-------|---------|
| **Context Analyzer** | What was the situation? What was tried? What constraints existed? |
| **Solution Extractor** | What was the exact fix? Root cause? Why does it work? Verbatim commands. |
| **Related Docs Finder** | What prior solutions relate? Index gaps? Where does this belong? |

Output is assembled into a single solution document + mandatory INDEX entry.

#### Pattern C — Fix-it Cascade

```
"fix it" → C31-debug → Fix (surgical) → Verify → C31-compound
                                ↑___FAIL___|
```

Triggered automatically on any debug request. Self-closing loop. The 3-consecutive-failure rule: if the same class of fix fails 3 times in a row, the cascade halts and escalates — no blind retries.

#### Pattern D — 12-Gate Full Automation (C31-lfg)

For approved plans, `lfg` runs a deterministic 12-gate pipeline to completion without interruption:

`Plan validation → Dependency check → Test baseline → Implement → Multi-review → Unit tests → Integration tests → Nyquist coverage → Simplify → Security scan → Build verify → Compound`

Stop conditions are explicit. Everything else runs unattended.

---

### 3. Autonomous by Default

> *Forged from: 12-Factor Agents (F12) + ECC (confidence scoring)*

**The default state is full autonomy.** The AI executes, iterates, self-corrects, and compounds knowledge without interruption. Human intervention is reserved for exactly two conditions:

- **Irreversible scope** — file overwrites, deletion, external publishing
- **Low intent confidence** — below 0.55, one clarifying question. Then execute.

Everything else — including the 12-gate pipeline, Fix-it Cascade, parallel review, and knowledge extraction — runs in a closed autonomous loop.

**Confidence Routing** governs when the AI speaks before acting:

| Confidence | Behavior |
|------------|----------|
| ≥0.75 | Execute directly. No check-in. |
| 0.55–0.74 | One-sentence confirmation: "You mean X, right?" |
| <0.55 | One clarifying question. Then execute. |

---

### 4. The Self-Improving Loop

> *Forged from: ECC (continuous learning + confidence scoring) + agent-skills (anti-sycophancy)*

C31's instinct system evolves entirely autonomously. No configuration files. No human teaching required.

```
Pattern observed → candidate instinct (confidence: 0.5)
Pattern repeats  → verifying instinct (confidence: 0.7)
Pattern verified → instinct (confidence: 0.9) — auto-applied, no confirmation

User says "that's wrong" → confidence drops to 0.1 → deprecated → never suggested again
```

Pre-loaded seed instincts:
```
instinct-001-no-overwrite.md     confidence: 0.95  ← never overwrite existing files
instinct-002-research-first.md   confidence: 0.90  ← always research before acting
instinct-003-surgical-changes.md confidence: 0.90  ← modify only what's necessary
instinct-004-compound-trigger.md confidence: 0.85  ← auto-run compound after ≥2 file changes
```

Session state persists across conversations: `session_state.json` + daily diary + instinct index. Each session starts where the last one ended.

```
~/.cystem31/
├── memory/
│   ├── session_state.json   ← active projects, open todos, pending decisions
│   ├── diary/YYYY-MM-DD.md  ← daily session logs
│   └── instincts/           ← evolved behavioral patterns with confidence scores
└── solutions-registry.md    ← cross-project solution index
```

---

### 5. Knowledge Flywheel

> *Forged from: Compound Engineering Plugin (compound step) + GSD Core (artifacts over memory)*

Every solved problem becomes searchable institutional memory. The flywheel:

```
Solve → C31-compound → docs/solutions/[category]/YYYY-MM-DD.md
                              ↓
                        Update INDEX.md  ← MANDATORY
                              ↓
                 solutions-registry.md (cross-project)
                              ↓
              Next session: Pre-Search silently checks registry
                              ↓
              Hit → "📋 Found prior art" → inject into context
              Miss → continue silently
                              ↓
          Next occurrence of same problem: minutes, not hours
```

Any new project bootstrapped with C31 instantly inherits all prior solutions.

---

### 6. Context Health Monitoring

> *Forged from: 12-Factor Agents (F3: Own Your Context Window) + GSD Core (Context Rot)*

Long sessions degrade AI quality silently. C31 monitors and acts:

| State | Usage | Action |
|-------|-------|--------|
| 🟢 Green | <50% | Normal operation |
| 🟡 Yellow | 50–70% | Begin compressing completed work |
| 🟠 Orange | 70–85% | Move decisions to files, archive assumptions |
| 🔴 Red | >85% | Force checkpoint: write state, then continue |

---

### 7. Psychological Framing Layer

> *Forged from: Superpowers (Cialdini compliance) + agent-skills (Doubt Gate, anti-sycophancy)*

- **Step-by-step reasoning**: Internal chain-of-thought before output reduces errors ~34%
- **Critic Gate**: Auto-triggered self-audit on inferred conclusions >300 words
- **Anti-sycophancy**: Technical rigor over social comfort — disagreement triggers independent evaluation, not capitulation
- **Doubt Gate**: For irreversible operations, write the claim → isolate the minimal auditable unit → generate a fresh-context adversarial reviewer

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
| **[Engineering Philosophy](PHILOSOPHY.md)** | The 5 Karpathy principles + Doubt-Driven Development + Chesterton's Fence + Confidence Routing |
| **[Workflow Architecture](WORKFLOW.md)** | The 6-step lifecycle + 4 multi-agent orchestration patterns (with Mermaid diagrams) |
| **[C31 vs Individual Frameworks](ADVANTAGES.md)** | Why each of the 7 frameworks falls short alone — and what C31 adds |
| **[Error Governance](ERROR-GOVERNANCE.md)** | 3-tier error classification · Fix-it Cascade · No Autonomous Lifecycle Mutation |
| **[Memory System](AGENTS.template.md#session-startup-protocol)** | How session state, diary, and instincts work together |
| **[Instinct Evolution](AGENTS.template.md#instinct-system)** | How patterns graduate from candidate to auto-applied instinct |
| **[Context Health](AGENTS.template.md#own-your-context-window)** | Managing the 4-state context system for long sessions |
| **[Skill Index](skills/)** | All 43 skills with triggers in EN · ZH · JA |
| **[Subagent Templates](agents/)** | Ready-to-use reviewer, compound, and debug subagent prompts |

---

## Skill Index

### 🔧 core/ (18) — Engineering Workflow

| Skill | EN Trigger | ZH | JA |
|-------|-----------|----|-----|
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

## The 7 Frameworks — Origin of C31

C31 synthesizes the best ideas from 7 open-source frameworks. Each framework solved one piece of the puzzle:

| Framework | Stars | Key Contribution to C31 | Deep Dive |
|-----------|-------|------------------------|-----------|
| **[12-Factor Agents](https://github.com/humanlayer/12-factor-agents)** | ~24k | Stateless reducer · context ownership · compact errors | [Part 1 →](https://github.com/ChianW/C31-papers/blob/master/part1_12_factor_agents.md) |
| **[Superpowers](https://github.com/obra/superpowers)** | ~249k | Psychology-driven AI compliance (Cialdini) | [Part 2 →](https://github.com/ChianW/C31-papers/blob/master/part2_superpowers.md) |
| **[ECC](https://github.com/affaan-m/ecc)** | ~225k | Instinct evolution system · context health colors | [Part 3 →](https://github.com/ChianW/C31-papers/blob/master/part3_ecc.md) |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | ~70k | Doubt-Driven Development · Chesterton's Fence · anti-sycophancy | [Part 4 →](https://github.com/ChianW/C31-papers/blob/master/part4_agent_skills.md) |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | ~23k | Brainstorm→Plan→Work→**Simplify**→Review→Compound lifecycle | [Part 5 →](https://github.com/ChianW/C31-papers/blob/master/part5_cep.md) |
| **[Archon](https://github.com/coleam00/Archon)** | ~23k | Agent lifecycle governance · no autonomous mutation | [Part 6 →](https://github.com/ChianW/C31-papers/blob/master/part6_archon.md) |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | ~6k | Context Rot · artifacts-over-memory · plan quality gate | [Part 7 →](https://github.com/ChianW/C31-papers/blob/master/part7_gsd_core.md) |

Plus **Karpathy AI Skills** as the bedrock engineering philosophy across all layers.

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

## The Agent Harness Papers

10 articles documenting the journey from problem to system — the frameworks behind C31, from first principles to final synthesis.

| Part | Title |
|------|-------|
| [Part 0](https://github.com/ChianW/C31-papers/blob/master/part0_introduction.md) | Why You Need an Agent Harness |
| [Part 1](https://github.com/ChianW/C31-papers/blob/master/part1_12_factor_agents.md) | 12-Factor Agents — The Architectural Manifesto |
| [Part 2](https://github.com/ChianW/C31-papers/blob/master/part2_superpowers.md) | Superpowers — The Psychology Hack |
| [Part 3](https://github.com/ChianW/C31-papers/blob/master/part3_ecc.md) | Everything Claude Code — The Operating Layer |
| [Part 4](https://github.com/ChianW/C31-papers/blob/master/part4_agent_skills.md) | Agent Skills — The Anti-Laziness Framework |
| [Part 5](https://github.com/ChianW/C31-papers/blob/master/part5_cep.md) | Compound Engineering — The Compounding Engine |
| [Part 6](https://github.com/ChianW/C31-papers/blob/master/part6_archon.md) | Archon — Deterministic AI Pipelines |
| [Part 7](https://github.com/ChianW/C31-papers/blob/master/part7_gsd_core.md) | GSD Core — Naming Context Rot |
| [Part 8](https://github.com/ChianW/C31-papers/blob/master/part8_comparison.md) | All 7 Frameworks Compared |
| [Part 9](https://github.com/ChianW/C31-papers/blob/master/part9_building_c31.md) | From Zero to C31 |
| [**Part 10**](https://github.com/ChianW/C31-papers/blob/master/part10_the_architecture.md) | **The Architecture — C31 in Production** |

→ **[ChianW/C31-papers](https://github.com/ChianW/C31-papers)**

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
