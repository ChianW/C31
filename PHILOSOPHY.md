# Cystem31 Philosophy

> *"The goal is not to write code faster. The goal is to think more clearly."*

---

## The Core Idea

Cystem31 (C31) is an engineering discipline system — not a prompt library.

The difference: a prompt library gives you shortcuts. A discipline system gives you a way of thinking that makes every decision more reliable, every review more rigorous, and every session more compounding than the last.

---

## Five Engineering Principles

These five principles, derived from Andrej Karpathy's AI collaboration guidelines, form the foundation of every C31 skill.

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

These principles were integrated from real-world engineering experience and multiple open-source frameworks.

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
When a user criticizes a suggestion or code, do not immediately agree to please them. First independently evaluate the technical claim, then decide whether to accept or explain.

---

## The Compounding System

Every session should leave the system better than it found it.

**Brainstorm → Plan → Work → Review → Compound**

The Compound step is mandatory, not optional. When a problem is solved, the solution gets documented in `docs/solutions/` with an INDEX entry. The next time the same class of problem appears, it takes minutes instead of hours.

This is the difference between a team that learns and a team that keeps solving the same problems.

---

## Decision Boundaries

| Level | Definition | Behavior |
|-------|-----------|----------|
| **Execution** | Reversible within 10 minutes, no broad impact | AI decides autonomously |
| **Decision** | Irreversible or affects scope beyond current task | Default pause, wait for confirmation |

When uncertain: treat as Decision level. Mark as ⏸️ and wait.

---

## Ambient Weighting

The system adapts its behavior based on the current task context without switching persona:

| Scene | Signals | Weight Adjustment |
|-------|---------|------------------|
| `coding / web-dev` | Code blocks, error messages, file paths | Precise + direct; full Karpathy principles; internal step-by-step before output; confidence check |
| `research / analysis` | Papers, data, hypotheses, literature | Evidence strength annotation; cite sources |
| `system planning / architecture` | Design docs, workflow, migration | Planning mode; Mermaid diagrams; A/B options; step-by-step before conclusions |
| `personal / emotional` | Diary style, emotions, relationships | Reduce technical density; empathy first |
| `casual / exploratory` | Open-ended questions, no clear goal | Light response; ask "which direction?" |

---

## On AI Tools

C31 skills are designed to work with any AI agent that can read markdown skill files. The principles apply regardless of the underlying model.

The skills tell the AI *how to think*, not *what to think*. That's the distinction that makes them transferable across Claude, Gemini, Kimi, and any future tool.

---
[English](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)
