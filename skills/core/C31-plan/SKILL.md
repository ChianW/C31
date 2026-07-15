---
name: C31-plan
description: plan, 制定计划, roadmap | 规划阶段：将需求转化为带验证门和威胁建模的可执行计划
triggers: plan, 制定计划, 实现方案, 怎么实现, 分步, plan-phase, roadmap
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | plan, 制定计划, 实现方案, 怎么实现, 分步, plan-phase, roadmap |
| ZH | 制定计划, 规划, 怎么实现, 分步 |
| JA | 計画を立てる, プランニング, 実装方法を考える |

> **Output language**: Respond automatically in the user's conversation language.

# C31-plan

Turn requirements into **validated, executable plans**. `C31-brainstorm` defines **WHAT**; C31-plan defines **HOW** — with coverage gates, wave analysis, and threat modeling.

## Trigger

User says "plan", "制定计划", "实现方案", "怎么实现", "分步", "plan-phase", "roadmap", or any request to break down a task into an executable plan.

## Inputs

Gather before proceeding. If not provided, ask:

1. **What to plan** — task, goal, feature, or project. Accepts a feature description, a requirements doc path, a brainstorm output, or a bug report.
2. **Upstream document** (optional) — path to a `*-requirements.md` or `STRATEGY.md` in `docs/brainstorms/` or `memory/.planning/`. Read first; treat as source of truth.
3. **Existing plan to deepen** (optional) — identify target in `memory/.planning/phases/` and short-circuit to Plan-Checker (Phase 5).

## Core Principles

1. **Requirements as source of truth** — Build from upstream docs; never re-invent behavior.
2. **Decisions, not code** — Capture approach, boundaries, files, dependencies, risks, and test scenarios.
3. **Research before structuring** — Explore codebase, `docs/solutions/`, `AGENTS.md`, `CLAUDE.md`.
4. **Nyquist validation** — Map test coverage to every requirement before execution.
5. **Decision coverage gate (blocking)** — Every `CONTEXT.md` decision must appear in the plan.
6. **Package legitimacy gate** — Audit external dependencies with `[OK]` / `[SUS]` / `[SLOP]` tagging.
7. **Right-size the artifact** — Same philosophy at every depth.
8. **Separate planning from execution discovery** — Resolve planning-time questions here.
9. **Keep the plan portable** — Repo-relative paths only.
10. **Doubt-Driven Development** — Every non-trivial decision must survive adversarial scrutiny before it enters the plan.

## Workflow

### Phase 0: Resume, Source, and Scope

#### 0.1 Resume or Deepen

- If user references an existing plan in `memory/.planning/phases/`: read it, confirm update-vs-new, revise.
- If user says "deepen the plan": identify target, verify completeness, short-circuit to Phase 5.

#### 0.2 Classify Domain

- **Software** (code, APIs, databases, deployment) → continue.
- **Ambiguous** → ask before routing.
- **Universal** → lightweight structure (scope, steps, risks, verification); skip software-specific phases.

#### 0.3 Find Upstream Requirements

Search `docs/brainstorms/` and `memory/.planning/` for `*-requirements.md`. If `STRATEGY.md` exists at repo root, read it and anchor decisions to active tracks. If multiple match, ask the user which to use.

#### 0.4 Bootstrap (No Requirements Doc)

If no upstream doc exists:
- Assess if request is clear enough for direct planning.
- If scope is ambiguous, recommend `C31-brainstorm` — but offer to continue.
- Bootstrap: problem frame, intended behavior, scope boundaries, success criteria, blocking assumptions.
- If **bug-shaped**, surface `C31-debug`. If **ready-to-execute**, suggest `C31-work`.

#### 0.5 Resolve Blockers

If origin doc has blocking questions affecting behavior, scope, or success criteria: surface them, ask whether to resume `C31-brainstorm` or convert to assumptions. Do not continue while true blockers remain.

#### 0.6 Assess Plan Depth

- **Lightweight** — small, well-bounded; 2–4 units.
- **Standard** — normal feature or refactor; 3–6 units.
- **Deep** — cross-cutting, strategic, high-risk; 4–8+ units or phased.

#### 0.7 Scope Synthesis (Solo Mode)

Read `references/synthesis-summary.md` if available. Compose internal three-bucket draft (Stated / Inferred / Out of scope). Derive call-outs where user input changes the plan.
- **Lightweight + zero call-outs**: auto-proceed.
- **Standard / Deep or call-outs**: present confirmation gate and wait.

> 🔴 **CHECKPOINT — Scope Confirmation Gate**
> For Standard / Deep or when call-outs exist: present the scope draft (three-bucket classification + key call-outs) and wait for user confirmation before entering Phase 1. Do not auto-advance.

### Phase 1: Gather Context

#### 1.1 Local Research (Always)

Prepare concise context: problem frame, requirements, key decisions, `STRATEGY.md` context. Then explore codebase (tech stack, patterns, conventions, files, tests), check `docs/solutions/`, `AGENTS.md`, `CLAUDE.md`. Detect posture: test-first, characterization-first, legacy fragility.

#### 1.2 Decide on External Research

Lean toward external research when: high-risk topic (security, payments, privacy, APIs, compliance); codebase lacks local patterns (< 3 examples); unfamiliar territory. Skip when strong local patterns exist.

#### 1.3 External Research (Conditional)

Research best practices, version-specific docs, domain pitfalls.

#### 1.4 Consolidate

Summarize: relevant patterns, institutional learnings, external references, constraints.

#### 1.5 Flow and Edge-Case Analysis (Conditional)

For Standard/Deep plans: analyze missing edge cases, state transitions, handoff gaps; requirements trace and verification strategy.

### Phase 2: Resolve Planning Questions

Build question list from: deferred questions in origin doc, research gaps, technical decisions.

For each:
- **Resolved during planning** — knowable from context.
- **Deferred to implementation** — depends on runtime behavior.

Ask the user only when the answer materially affects architecture, scope, sequencing, or risk and cannot be inferred.

### Phase 3: Structure the Plan

#### 3.0 Doubt-Driven Development (CEDAR Process)

Before any unit or decision is committed to the plan, run the **CEDAR** adversarial loop on non-trivial items (anything that affects architecture, scope, sequencing, risk, or introduces external dependencies):

| Step | Action | Prompt | Output |
|------|--------|--------|--------|
| **CLAIM** | State the decision clearly | "We will do X because Y." | A single-sentence claim |
| **EXTRACT** | Surface the evidence | "What facts, requirements, or precedents support this?" | Evidence list (from upstream docs, codebase, research) |
| **DOUBT** | Generate counter-arguments | "Why might this be wrong? What if the opposite were true?" | ≥2 genuine counter-arguments |
| **RECONCILE** | Resolve or hedge | "Given the doubt, adjust the claim or add a contingency." | Revised claim + hedge/deferral |
| **STOP** | Decide to proceed or abandon | "Does the reconciled claim still hold?" | `[PROCEED]`, `[DEFER]`, or `[ABANDON]` |

**Nyquist Compatibility**: CEDAR feeds into Nyquist by ensuring test scenarios are born from doubt, not assumption. A doubt that cannot be reconciled becomes a risk in `Risks and Mitigations` or a deferred question.

**Escalation hint**: If your model supports multi-model reasoning, run DOUBT with a "devil's advocate" system prompt. If not, force yourself to write the counter-argument you least want to hear.

> 🛑 **CHECKPOINT — CEDAR Stop Gate**
> For every CEDAR decision that returns `[ABANDON]` or `[DEFER]`:
> - `[ABANDON]` → Confirm skipping that unit; record the reason for abandonment in Risks.
> - `[DEFER]` → Confirm deferral; move to Deferred Implementation Notes.
> Do not force `[ABANDON]` units into the plan. Obtain user confirmation or record explicitly before continuing.

#### 3.1 Title and File Naming

Draft title: `feat: ...`, `fix: ...`, or `refactor: ...`. Filename:
```
memory/.planning/phases/XX-YY-PLAN.md
```
`XX` = phase number, `YY` = sequence. Create `memory/.planning/phases/` if needed. Name concise (3–5 words), kebab-cased.

#### 3.2 Stakeholder and Impact Awareness

For Standard/Deep: note who is affected (users, devs, ops, teams) and how.

#### 3.3 Break into Implementation Units

Break into logical, atomic units. Good units: focused on one component/behavior; touch related files; ordered by dependency; concrete enough for execution. Avoid micro-steps, spanning unrelated concerns, or vague units.

#### 3.4 Wave Analysis (Required)

Group units by dependency for parallel execution:

```markdown
## Wave Analysis

| Wave | Units | Dependency | Parallel? |
|------|-------|------------|-----------|
| W1   | U1, U2 | None (foundation) | ✅ |
| W2   | U3, U4 | U1, U2 | ✅ |
| W3   | U5 | U3 | ❌ |
```

- **Independent wave** — no inter-dependency; can execute in parallel.
- **Dependent wave** — requires prior wave; sequential.
- A unit appears in exactly one wave.

#### 3.5 High-Level Technical Design (Optional)

Include for DSL/API design, multi-component integration, data pipelines, state-heavy lifecycles, complex branching. Frame as **directional guidance, not spec**.

#### 3.6 Define Each Implementation Unit

Each unit is a level-3 heading with stable **U-ID**: `### U1. [Name]`, `### U2. [Name]`, etc.

**Stability rule:** U-ID never renumbered. Reordering keeps IDs. Splitting: original ID stays, next unused for new. Deletion leaves a gap.

Per unit, include:
- **Goal** — what this unit accomplishes
- **Requirements** — which requirements it advances (cite R/F/AE IDs)
- **Dependencies** — what must exist first (cite by U-ID)
- **Files** — repo-relative paths (include test files)
- **Approach** — key decisions, data flow, boundaries
- **Execution note** — non-default posture (test-first, characterization-first)
- **Patterns to follow** — existing conventions to mirror
- **Test scenarios** — from every applicable category:
  - **Happy path behaviors**
  - **Edge cases** — boundaries, empty inputs, nil/null, concurrency
  - **Error and failure paths** — invalid input, downstream failures, timeouts
  - **Integration scenarios** — cross-layer behaviors mocks cannot prove
  - Each: input, action, expected outcome.
  - Non-feature units: `Test expectation: none -- [reason]`
- **Verification** — how to know the unit is complete

#### 3.7 Nyquist Validation Layer

Map test coverage to each requirement before finalizing:

```markdown
## Nyquist Validation

| Requirement | Covered By | Test Scenarios | Gap? |
|-------------|------------|----------------|------|
| R1: ... | U1, U2 | U1-T1, U1-T2 | No |
| R2: ... | U3 | U3-T1 | ⚠️ Add edge case |
```

- Every requirement must have at least one covering unit.
- Every covering unit must have test scenarios verifying the requirement.
- Flag gaps explicitly. Do not proceed until resolved or deferred.

#### 3.8 Decision Coverage Gate (Blocking)

Read `memory/.planning/CONTEXT.md` (or `docs/brainstorms/CONTEXT.md`) if it exists. Every decision must appear in the plan: in a unit's **Approach**, in **Key Technical Decisions**, or in **Deferred Implementation Notes** with rationale. Missing decision = **blocking** — add before proceeding.

#### 3.9 Package Legitimacy Gate

For plans introducing external dependencies, audit each:

| Package | Version | Source | Tag | Rationale |
|---------|---------|--------|-----|-----------|
| `pkg-a` | `^1.2.3` | npm | [OK] | Maintained, >10k stars, MIT |
| `pkg-b` | `^0.4.1` | npm | [SUS] | Low activity, single maintainer |
| `pkg-c` | `latest` | pip | [SLOP] | No pin, no changelog |

- **[OK]** — mainstream, maintained, clear license, version-pinned.
- **[SUS]** — niche, low activity, unproven; extra scrutiny.
- **[SLOP]** — no version pin, no provenance, or abandonware.

Default for no new dependencies: `No external dependencies introduced`.

#### 3.10 STRIDE Threat Modeling (Install-Bearing Plans)

For plans involving installation, deployment, infrastructure, or auth/security:

```markdown
## STRIDE Analysis

| Threat | Risk | Mitigation | Owner |
|--------|------|------------|-------|
| Spoofing | ... | ... | U3 |
| Tampering | ... | ... | U2 |
| Repudiation | ... | ... | U4 |
| Information Disclosure | ... | ... | U5 |
| Denial of Service | ... | ... | U2 |
| Elevation of Privilege | ... | ... | U3 |
```

Consider each STRIDE category. Mark N/A where irrelevant. Tie mitigations to specific units.

#### 3.11 Keep Unknowns Separate

Record unresolvable items under **Deferred Implementation Notes**.

#### 3.12 Route Tangential Work to Deferred

Adjacent refactors go to `### Deferred to Follow-Up Work` — not active units.

### Phase 4: Write the Plan

**Never code during this skill.** Research, decide, validate, and write.

#### 4.1 Plan Depth Guidance

- **Lightweight** — compact, 2–4 units; omit optional sections.
- **Standard** — full template; 3–6 units; include risks, deferred questions, impact.
- **Deep** — full template plus analysis; 4–8+ units; group into phases; include alternatives, risk analysis, rollout notes.

#### 4.2 Core Plan Template

```markdown
---
plan_id: XX-YY
type: feat | fix | refactor
status: active
title: "..."
created: YYYY-MM-DD
dependencies: []
---

## Problem Frame
## Summary
## Requirements Traceability
## Scope Boundaries
### In Scope
### Out of Scope
### Deferred to Follow-Up Work
## Key Technical Decisions
## Wave Analysis
## Nyquist Validation
## Decision Coverage Gate
## Package Legitimacy Gate
## STRIDE Analysis (if install-bearing)
## System-Wide Impact (Standard/Deep)
## Implementation Units
### U1. [Name]
[Goal, Requirements, Dependencies, Files, Approach, Test scenarios, Verification]
### U2. [Name]
[...]
## Deferred Implementation Notes
## Risks and Mitigations (Standard/Deep)
```

#### 4.3 Planning Rules

- Use `---` between top-level sections in Standard/Deep plans.
- All paths repo-relative. No absolute paths, git commands, exact test recipes.
- No implementation code. Pseudo-code/Mermaid allowed as directional guidance.
- **No Placeholders Rule**: "TBD", "TODO", "implement later", "add appropriate error handling", "similar to Task N", or any deferred work marker is a **plan failure**. Every unit must contain: exact file paths, complete code blocks, exact commands with expected output. If you cannot fill a field, stop and investigate — do not proceed with placeholders.

### Phase 5: Plan-Checker, Write, and Handoff

#### 5.1 Review Before Writing

Check: plan does not invent product behavior; decisions grounded; units concrete and ordered; test posture carried forward; feature units have full test scenarios; deferred items explicit; U-IDs stable; **Nyquist** complete; **Decision Coverage** satisfied; **Package Legitimacy** audited; **STRIDE** present for install-bearing plans.

#### 5.2 Plan-Checker Agent (Verify Loop, Max 3 Iterations)

For each gate (Nyquist, Decision Coverage, Package Legitimacy, STRIDE, Wave Analysis):
1. Check completeness.
2. If gaps found → flag, patch, increment counter.
3. Re-check.
4. Max 3 iterations. If still failing, record as `⚠️ UNRESOLVED` and proceed.

Report: `Plan-checker pass: N iterations, N unresolved items.`

#### 5.3 Scope Synthesis (Brainstorm-Sourced)

Fires only when sourced from upstream brainstorm. Read `references/synthesis-summary.md` if available. Emit two paragraphs: (1) brainstorm-scope restatement, (2) plan-specific scoping decisions. Lightweight + zero call-outs: auto-proceed. Standard/Deep or call-outs: confirmation gate.

#### 5.4 Write Plan File

**Required:** Write to disk before presenting options.
```
memory/.planning/phases/XX-YY-PLAN.md
```
Confirm: `Plan written to <absolute path>`.

#### 5.5 Confidence Check and Deepening

Classify depth and risk. High-risk: auth/security, payments, migrations, external APIs, compliance, rollout.

- **Lightweight**: skip unless high-risk.
- **Standard**: deepen if sections look thin.
- **Deep** or high-risk: often benefit from second pass.
- **Thin local grounding override**: if Phase 1.2 triggered external research, always score.

If sufficiently grounded: "Confidence check passed" and proceed to 5.6.

When warranted, read `references/deepening-workflow.md` if available. Execute deepening, return here.

#### 5.6 Document Review and Handoff

Read `references/plan-handoff.md` if available. Run document review (mandatory). Present menu:

1. **Start `/C31-work`** (recommended)
2. **Run deeper doc review**
3. **Create Issue**
4. **Done for now**

Act on selection. In pipeline/headless mode, skip menu and return after plan write, plan-checker pass, and document review.

## Anti-Rationalization Table

When you catch yourself skipping CEDAR or rushing a decision, check against these common excuses:

| Excuse | Translation | Correct Response |
|--------|-------------|------------------|
| "This is obvious, no need to doubt" | I am anchoring on familiarity bias. | Run CEDAR anyway. Obvious decisions are the most dangerous. |
| "We don't have time" | I am trading a 5-minute doubt loop for a 5-hour rollback. | Time pressure is a *mandatory* trigger for CEDAR, not an exemption. |
| "The user said to do it this way" | I am outsourcing my judgment without recording the trade-off. | Document the user's constraint as evidence, then still run DOUBT on implementation. |
| "We've always done it this way" | I am carrying institutional debt forward. | Run CEDAR. If it survives, the precedent becomes evidence, not excuse. |
| "It's just a small change" | I am underestimating blast radius. | Run CEDAR on impact scope. Small surface, deep internals. |
| "The other model said it's fine" | I am confusing authority with validation. | Re-run DOUBT locally. Models rationalize too. |
| "I'll fix it in the implementation phase" | I am creating a blocking surprise for `C31-work`. | If CEDAR surfaces an issue, it belongs in the plan as a risk or deferral. |
| "No one will notice if I skip this" | I am eroding plan integrity. | CEDAR is a discipline, not an audience. Run it. |

**Cross-model escalation**: If a single model cannot break its own claim (common with sycophancy), escalate to a second reasoning pass with an explicit "adversarial judge" prompt, or flag the decision as `[SINGLE-MODEL CLAIM — VERIFY BEFORE EXECUTION]`.

## Failure Mode Codes

When the planning workflow deviates from the normal path, handle it using the following if-then fallback table. Do not guess, do not force ahead, do not skip.

| Trigger | Detection Point | Fallback Action | Artifact |
|---------|-----------------|-----------------|----------|
| Upstream document missing | Phase 0.3–0.4 | Bootstrap: problem frame + scope boundaries + success criteria + blocking assumptions | Minimal requirements draft |
| Blocker unresolved | Phase 0.5 | **STOP**. Ask user: resume brainstorm or convert to assumption | User decision recorded |
| CEDAR returns [ABANDON] | Phase 3.0 | Skip that unit; record abandonment reason in **Risks and Mitigations** | Risk entry |
| Related doc search timed out | Phase 0.3 / 1.1 | Skip Phase 0.5, continue with known information; mark `[Doc unconfirmed]` in Deferred Notes | Plan with marker |
| User didn't provide "What to plan" | Phase 0 start | **Ask directly** — do not guess or infer the goal | Clarifying question |
| Nyquist finds coverage gap | Phase 3.7 | No auto-fill allowed. Flag gap; decide: add test scenario / lower requirement priority / list as risk | Gap decision record |
| Decision Coverage fails | Phase 3.8 | **Blocking**. Add missing decision to the relevant unit or Key Technical Decisions, or mark as Deferred | Addition recorded |

**Principle**: Every fallback path must produce a traceable artifact (record, marker, or user confirmation). Spinning without output = process defect.

## Error Handling

This skill follows the [AGENTS/error-handling.md](../AGENTS/error-handling.md) standard.

### Common Error Codes

| Error Code | Trigger | Handling Strategy |
|------------|---------|-------------------|
| `API_TIMEOUT` | Codebase scan / external research timed out | Wait 4s and retry, max 2 times |
| `RATE_LIMITED` | API rate limit hit | Wait 10s and retry |
| `VALIDATION_FAILED` | Upstream document parameter validation failed | Fix parameters and retry |
| `RESOURCE_NOT_FOUND` | Upstream requirements doc / CONTEXT.md not found | Check path; escalate if unrecoverable |
| `CONTEXT_OVERFLOW` | Large plan document generation exceeded limit | Compress and retry, or process in chunks |
| `SUBAGENT_FAILED` | Plan-Checker subagent failed | Check subagent logs; retry max 1 time |

### Escalation Conditions

- Same error_code 2 consecutive times → force escalate on the 3rd
- retry_count reaches max_retries → escalate
- Non-recoverable errors (PERMISSION_DENIED, SECURITY_BLOCKED, etc.) → escalate immediately

### Fallback Chain

| Primary | Fallback | Condition |
|---------|----------|-----------|
| `read` (upstream doc) | `memory_search` | `RESOURCE_NOT_FOUND` |
| `kimi_fetch` (external research) | `web_fetch` | `API_TIMEOUT` / `NETWORK_ERROR` |
| `kimi_search` | `exec` + `curl` | `RATE_LIMITED` persists |

## Worktree / Task Tracking Integration

If TaskFlow or worktree context is active:
- Record plan path in flow metadata.
- Update parent task: planning complete, implementation ready.
- When `C31-work` invoked from handoff, pass plan path as work target.

---

## Anti-Pattern Blacklist

Six anti-patterns based on real C31-plan misuse scenarios. Triggering any one of these degrades plan quality.

| # | Anti-Pattern | Correct Practice | Trigger Scenario |
|---|--------------|-----------------|------------------|
| 1 | ❌ Skip threat modeling | ✅ Even lightweight plans require a minimal threat scan (STRIDE Lite) | User says "no permission issues here" or "it's a small feature, don't overthink" |
| 2 | ❌ Advancing with unresolved blockers | ✅ Phase 0.5 must confirm all blockers are cleared or converted to assumptions | User rushes: "write the plan first, deal with issues later" |
| 3 | ❌ Missing Nyquist validation | ✅ Every requirement must have a corresponding test scenario, no exceptions | Plan is finished but a requirement has no test coverage |
| 4 | ❌ Missing CONTEXT.md decision coverage | ✅ Decision Coverage Gate is not optional; every decision must appear in the plan | CONTEXT.md exists but the plan has no corresponding decisions |
| 5 | ❌ Forcing [ABANDON] CEDAR units into the plan | ✅ Skip that unit; record the abandonment reason in Risks | Thinking "I already wrote it, it's a shame to delete" |
| 6 | ❌ Writing High-Level Technical Design for every unit | ✅ Only write it when needed (DSL/API/multi-component integration/complex state) | Template OCD: filling sections to complete the template |

**Usage**: Check each item during plan review. Hitting any one → mark as `⚠️ Anti-pattern triggered`, revert to the corresponding Phase to fix.
