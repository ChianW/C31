# C31 Philosophy

> *"Stop prompting an LLM. Start engineering an agent harness."*

---

[English](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

---

## What C31 Is

C31 is not a prompt library. It is an **agent harness system** — the persistent layer between you and your AI tool that makes every session smarter than the last.

Most prompt collections give you one-shot instructions that disappear when the conversation ends. C31 gives you five interconnected layers that compound over time:

| Layer | What It Does |
|-------|-------------|
| **Skills** | Structured workflows for every phase of engineering work |
| **Memory System** | State that persists across sessions — todos, decisions, context |
| **Instinct Evolution** | Learned behavioral patterns that auto-apply as confidence grows |
| **Context Health** | Active monitoring to prevent quality degradation in long sessions |
| **Psych-Framing** | Cognitive techniques embedded directly into the harness |

---

## The Five Engineering Principles

*Derived from Andrej Karpathy's AI collaboration guidelines. The foundation of every C31 skill.*

### 1. Think Before Coding
Before executing any command, perform a Research phase. Identify assumptions. Surface risks. Never guess at vague requirements — stop and ask.

### 2. Simplicity First
Implement only the minimal logic required. Avoid unrequested abstractions, new dependencies, or "just-in-case" design. If it wasn't asked for, don't build it.

### 3. Surgical Changes
Strictly limit the scope of modifications to code directly related to the task. No drive-by refactoring. No unrelated style changes. Understand why code exists before changing it — see *Chesterton's Fence* below.

### 4. Goal-Driven Execution
Success is defined by passing tests or completing specific verification steps. Write failing test cases first to define bugs before fixing them. Tests, docs, and refactoring are part of the current task's definition of done — not deferred to "later."

### 5. First-Principles Thinking
Reason from raw requirements and the essence of the problem, not from conventions or templates. If the goal is clear but the path is suboptimal, surface a better way.

---

## Extended Principles

*Integrated from real-world engineering experience and multiple open-source frameworks.*

### Doubt-Driven Development
For high-stakes decisions — branching logic, module boundaries, irreversible operations — apply the CLAIM→EXTRACT→DOUBT loop:

1. **CLAIM**: Write down the assertion you're about to act on
2. **EXTRACT**: Isolate the minimal auditable unit (without your reasoning)
3. **DOUBT**: Generate a fresh-context adversarial review of that claim

Do not skip this loop for irreversible operations.

### Chesterton's Fence
Before modifying or deleting any code, understand why it exists. Do not remove code because it "looks unused" until you understand its original purpose.

### No "Later"
Tests, documentation, and refactoring are not next PR's problem. They are part of the current task's definition of done.

### Rollback-First Thinking
For high-risk changes, think through the rollback path before executing. Avoid mixed large patches that cannot be safely rolled back.

### Technical Rigor over Social Comfort
When a user criticizes a suggestion or code, do not immediately agree to please them. First independently evaluate the technical claim, then decide whether to accept or explain. Sycophancy is a failure mode — disagreement triggers independent evaluation, not capitulation.

---

## The Memory System

The AI doesn't just follow rules — it remembers.

```
~/.c31/
├── memory/
│   ├── session_state.json   ← active projects, open todos, pending decisions
│   ├── diary/YYYY-MM-DD.md  ← daily session logs (1-5 lines)
│   └── instincts/           ← evolved behavioral patterns with confidence scores
└── solutions-registry.md    ← index of all documented solutions
```

At the **start** of every session, the harness loads `session_state.json` and today's diary — surfacing unresolved items from the last session. At the **end** of every session, it flushes new state back to disk.

This is the **Agent as Stateless Reducer** principle (F12 from 12-factor-agents): every execution is `f(context) → action`. No hidden state. All cross-session memory lives in files, not conversation history.

---

## The Instinct Evolution System

Patterns that work get promoted. Patterns that fail get deprecated.

```
candidate (1/3 verifications) → verifying (2/3) → instinct (3/3)
confidence: 0.3–0.9  ·  deprecated if < 0.3
```

**Positive reinforcement**: A pattern that succeeds repeatedly has its confidence score raised. At 3 verifications it becomes an *instinct* — auto-applied without confirmation.

**Negative feedback**: When a user says "that's wrong" or "don't do that," the confidence score drops immediately to 0.1. If confidence falls below 0.3, the pattern is flagged as deprecated and avoided in future sessions.

**Seed instincts** (pre-initialized):
- `instinct-001-no-overwrite` — Never overwrite existing files without confirmation (confidence: 0.95)
- `instinct-002-research-first` — Always research before acting (confidence: 0.90)
- `instinct-003-surgical-changes` — Limit scope to the current task (confidence: 0.90)
- `instinct-004-C31-compound-trigger` — Proactively trigger C31-compound (confidence: 0.85)

---

## Context Health

Long sessions kill AI quality. As conversations grow, early instructions get buried, decisions get forgotten, and the model begins contradicting its earlier reasoning. This is not a bug — it is an inherent property of transformer attention on long sequences.

C31 monitors context window usage and takes automatic action:

| State | Usage | Action |
|-------|-------|--------|
| 🟢 Green | < 50% | Normal operation |
| 🟡 Yellow | 50–70% | Begin compressing completed work into summaries |
| 🟠 Orange | 70–85% | Move decisions to files; archive assumptions |
| 🔴 Red | > 85% | Force checkpoint: write state first, then continue |

**Own Your Context Window** (F3 from 12-factor-agents): Actively decide what lives in context. Don't let the system fill it passively. Prefer recent messages over old ones. Inject relevant files explicitly — never assume "the model will remember."

---

## Psychological Framing Layer

C31 embeds research-backed cognitive techniques directly into the harness:

### Step-by-Step Reasoning
Complex analysis unfolds internally before output. This reduces reasoning errors significantly compared to top-of-mind answers. The user sees the conclusion; the harness did the work.

### Confidence Check
Every significant plan or action carries a **Confidence Score (0.3–0.9)**. Outputs below 0.9 include a gap annotation explaining what's uncertain. This makes the AI's epistemic state visible and auditable.

### Critic Gate
**Auto-triggered when both conditions are met:**
- Output > 300 words
- Contains inferred conclusions (keywords: "therefore," "should," "recommend," "must," "best")

The harness performs a self-audit checking for: factual errors, logic gaps, over-generalization, missing perspectives, and sycophantic reasoning. Result is appended as a `【self-check】` block.

### Ambient Weighting
The harness detects the current scene from the first message and adjusts behavior weights without switching persona:

| Scene | Signals | Adjustments |
|-------|---------|-------------|
| `coding` | Code blocks, errors, file paths | Full Karpathy; step-by-step internal; confidence check |
| `research` | Papers, data, hypotheses | Evidence strength annotation; cite sources |
| `architecture` | Design docs, migration, planning | Planning mode; Mermaid diagrams; A/B options |
| `personal` | Diary, emotions, relationships | Reduce technical density; empathy first |
| `casual` | Open-ended, no clear goal | Light response; ask "which direction?" |

### Confidence Routing
> *Unique to C31 — not present in any of the 7 source frameworks.*

Before executing, C31 scores the confidence in its interpretation of the user's intent:

| Confidence | Condition | Behavior |
|------------|-----------|----------|
| **High ≥ 0.75** | Intent clear, context sufficient | Execute directly — no confirmation needed |
| **Mid 0.55–0.74** | Ambiguous but inferable | One-line confirmation first: "You mean X, right?" |
| **Low < 0.55** | Requirements vague, key params missing | Ask a clarifying question |

**Clarification templates:**
- Binary: "Do you want A ([description]) or B ([description])?"
- Missing params: "I need [specific parameter] to continue."
- Insufficient context: "This involves [X] — can you show me [file/example]?"

This prevents the most common AI failure mode: confidently executing the wrong interpretation. Most frameworks treat user intent as binary (understood / not understood). Confidence Routing treats it as a spectrum and responds proportionally.

---

## The Compounding Lifecycle

Every session should leave the system better than it found it.

```
Brainstorm → Spec → Plan → Work → Simplify → Review → C31-compound
```

The **Simplify** step (powered by `ce-simplify-code`) runs between Work and Review. Three parallel reviewer agents check for code reuse, quality, and efficiency — simplifying the code before it reaches the review gate. The **C31-compound** step is mandatory, not optional. When a significant problem is solved, the solution gets documented in `docs/solutions/` with an INDEX entry. The `solutions-registry.md` indexes all known solution stores across projects.

**Pre-Search Protocol**: Before starting any non-trivial task, the harness silently checks the solutions registry for relevant prior art. A match injects the prior solution as guidance. No match — silent continue.

This is the difference between a system that learns and a system that keeps solving the same problems.

---

## Decision Boundaries

| Level | Definition | Behavior |
|-------|-----------|----------|
| **Execution** | Reversible within 10 minutes, no broad impact | AI decides autonomously |
| **Decision** | Irreversible or affects scope beyond current task | Default pause — mark ⏸️, wait for confirmation |

When uncertain: treat as Decision level. The pause format:
```
⏸️ [Type: file overwrite / direction change / external publish]
   [Impact: <specific description>]
   [Needs: confirm / modify / cancel]
```

---

## Intellectual Foundations

C31 synthesizes design philosophy from nine frameworks:

| Source | Key Contribution |
|--------|----------------|
| **[Karpathy AI Skills](https://karpathy.ai)** | The five core engineering principles |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | Stateless reducer · context ownership · compact errors |
| **[ECC](https://github.com/affaan-m/ecc)** | Instinct evolution · context health colors · continuous learning |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | Brainstorm→Spec→Plan→Work→**Simplify**→Review→Compound lifecycle · Deletion Test · Behavior Change Contract |
| **[Superpowers](https://github.com/obra/superpowers)** | Subagent-driven development · verification-before-completion · do not trust the report |
| **[Archon](https://github.com/coleam00/Archon)** | Agent lifecycle governance · no autonomous state mutation |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | Context engineering · artifacts-over-memory · plan quality gate |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | Doubt-driven development · Chesterton's Fence · anti-sycophancy |
| **Psychological Framing** | Step-by-step reasoning · confidence check · Critic Gate |

---

[English](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)
