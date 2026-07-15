---
name: C31-brainstorm
description: brainstorm, ideate, 需求, discuss | 讨论阶段：将模糊需求转化为带编号决策点的需求文档
triggers: brainstorm, ideate, think through, 需求, discuss, 讨论, discuss-phase
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | brainstorm, ideate, think through, 需求, discuss, 讨论, discuss-phase |
| ZH | 头脑风暴, 讨论需求, 讨论一下 |
| JA | ブレインストーミング, 考えてみよう, 議論しよう |

> **Output language**: Respond automatically in the user's conversation language.

# C31 Brainstorm — Discuss Phase

Brainstorming answers **WHAT** to build. It precedes planning, which answers **HOW** to build it.

The durable output is a **requirements document** with **numbered, traceable decisions (D-01, D-02...)** that MUST carry forward into planning. No decision made here should be silently re-invented later.

## Guardrails: Anti-Rationalization Table

When requirements are fuzzy, agents commonly rationalize skipping structured discovery. Call yourself out.

| Excuse | Why It's Wrong | Correct Approach |
|--------|---------------|------------------|
| "The user will tell me" | Users assume you already understand; they won't proactively fill in gaps | Actively extract, one question at a time |
| "Assume first, adjust later" | Assumptions will contaminate all downstream reasoning | Mark as `A-XX`, wait for confirmation |
| "Open-ended questions are efficient" | Users faced with a blank will skip or give vague answers | Offer options to narrow the answer space |
| "It's already clear enough" | Your "clear" ≠ the user's "clear" | Validate with concrete scenarios |
| "Asking more will annoy the user" | Rework after delivery is far more annoying | Every question has ROI |

**Rule of thumb:** If you can't write down 3 specific acceptance criteria right now, you don't understand the requirement well enough to plan.

## Interview-me Mode

A structured variant of Phase 1.3 for when the user's request is genuinely ambiguous — not merely underspecified, but the *problem space itself* is unclear.

### When to Activate

- You can't articulate the user's goal in one sentence
- You can't list 3 concrete acceptance criteria
- Your internal confidence score is < 70%
- The user said "I want to build a..." / "Can you help me..." with no follow-up detail

### Protocol

**One question at a time.** Not two. Not "here are a few questions". One.

Each question must reduce the uncertainty space. Never ask an open-ended question when a multiple-choice would work.

**Confidence scoring (internal, 0–100%):**

| Tier | Confidence | Action |
|------|-----------|--------|
| 🔴 Red | 0–40% | Problem frame unknown. Ask: "Who uses it? What pain does it solve? What do they do today?" |
| 🟡 Yellow | 41–70% | Mechanism unknown. Ask: "What's the most important outcome? What can't be sacrificed?" |
| 🟢 Green | 71–94% | Details fuzzy but direction locked. Ask 1–2 verification questions. |
| ✅ Ready | 95–100% | Proceed to Phase 2 (approaches) or Phase 3 (requirements doc). |

**Adaptive chaining:** The next question is chosen based on the previous answer. Maintain a running list of knowns and unknowns. Ask the question that eliminates the most unknowns.

**Question types (in order of preference):**

1. **Constrained choice** — "Option A vs. Option B — which do you lean toward?"
2. **Prioritization** — "If you could only pick one, A or B — which matters more?"
3. **Boundary test** — "Does this scenario need to be covered?"
4. **Open-ended (last resort)** — "Can you walk me through a concrete use case?"

**Integration with decision gates:**

- Every confirmed fact during interview-me becomes either a `D-XX` (decision) or `A-XX` (assumption pending confirmation)
- Interview-me does not produce a requirements doc directly — it feeds into Phase 2 and Phase 3
- If confidence stalls at 70–85% for 3+ exchanges, make a `D-XX` to record the tradeoff and move forward explicitly

**Exit criteria (all must be true):**

1. You can state the goal in one sentence
2. You can list 3+ acceptance criteria
3. You know what is *not* in scope
4. No pending `A-XX` assumptions that would change the approach
5. Confidence ≥ 95%

## Core Principles

1. **Assess scope first** — Match ceremony to the size and ambiguity of the work.
2. **Be a thinking partner** — Suggest alternatives, challenge assumptions, and explore what-ifs.
3. **Resolve product decisions here** — User-facing behavior, scope boundaries, and success criteria belong in this workflow. Implementation belongs in planning.
4. **Keep implementation out** — No libraries, schemas, endpoints, or code-level design unless the brainstorm is inherently about a technical or architectural change.
5. **Right-size the artifact** — Simple work gets a compact doc. Larger work gets a fuller one. Skip ceremony that does not help planning.
6. **Apply YAGNI to carrying cost** — Prefer the simplest approach that delivers value. Avoid speculative complexity.
7. **Decision coverage gate** — Every decision (D-XX) made here MUST appear in later plans. No orphaned decisions.
8. **Assumptions mode** — Surface structured assumptions explicitly. Label them `ASSUMPTION-[A-XX]` for the user to confirm or correct.

## When to Use

- User says "brainstorm", "ideate", "think through", "需求", "discuss", "讨论", "discuss-phase"
- Vague or ambitious feature request with unclear scope
- User seems unsure about direction or scope
- Need to write a requirements document before planning
- GSD workflow: Phase is "pending" and needs discussion before planning

## Interaction Rules

1. **Ask one question at a time.** Not two. Not "here are a few questions". One. Never ask an open-ended question when a multiple-choice would work.
2. **Prefer single-select multiple choice** — When choosing one direction, priority, or next step.
3. **Use multi-select rarely** — Only for compatible sets (goals, constraints, non-goals).
4. **Default to the platform's blocking question tool** — In Feishu, use `feishu_ask_user_question`. In other channels, use numbered options in chat.
5. **Use open-ended questions only when genuinely open** — Narrative, diagnostic, or when you cannot write 3–4 distinct, plausibly-correct options without padding.
6. **Open-ended questions must be specific** — Give the user something concrete to anchor on.

## Output Guidance

- Keep outputs concise — short sections, brief bullets.
- Use repo-relative paths — never absolute paths.
- All decisions get stable IDs: `D-01`, `D-02`, etc.
- All assumptions get stable IDs: `A-01`, `A-02`, etc.

## Execution Flow

### Phase 0: Resume, Assess, and Route

#### 0.1 Resume Existing Work

If the user references an existing brainstorm topic or document, or there is a recent matching `*-requirements.md` in `memory/brainstorms/` or `memory/.planning/phases/`:
- Read the document via `memory_get` or `read`.
- Confirm: "Found an existing requirements doc for [topic]. Continue from this, or start fresh?"
- If resuming, summarize state briefly, continue from existing decisions, and update the existing document.

#### 0.1b Classify Task Domain

**Software** (continue to Phase 0.2): involves code, repos, APIs, databases, or building/modifying/debugging/deploying software.

**Non-software brainstorming** (use universal facilitation): BOTH true:
- No software signals present
- Task is about exploring, deciding, or thinking through something in a non-software domain

**Neither** (respond directly, skip all phases): quick-help request, error message, factual question, or single-step task.

If non-software: apply the same Core Principles and Interaction Rules, but skip Phases 0.2–4. Use open-ended collaborative dialogue.

#### 0.2 Assess Whether Brainstorming Is Needed

**Clear requirements indicators:** specific acceptance criteria, existing patterns to follow, exact expected behavior, constrained well-defined scope.

If requirements are already clear: keep the interaction brief. Confirm understanding, present concise next-step options. Skip Phase 1.1 and 1.2. Go straight to Phase 1.3 or Phase 2.5 in announce-mode, then Phase 3.

**If requirements are unclear (< 70% confidence):** Activate **Interview-me Mode** (see above). Do not proceed to planning until confidence reaches ≥ 95% or the user explicitly overrides.

#### 0.3 Assess Scope

Use the feature description plus a light repo scan:
- **Lightweight** — small, well-bounded, low ambiguity
- **Standard** — normal feature or bounded refactor with some decisions
- **Deep** — cross-cutting, strategic, or highly ambiguous

If unclear, ask one targeted question to disambiguate, then proceed.

**Deep sub-mode:**
- **Deep — feature** (default): existing product shape anchors decisions.
- **Deep — product**: must establish product shape (actors, outcome, positioning, flows unresolved).

### Phase 1: Understand the Idea

#### 1.1 Existing Context Scan

Match depth to scope:

**Lightweight** — Search repo for the topic, check if something similar exists, move on.

**Standard and Deep** — Two passes:

*Constraint Check* — Read project instruction files (`AGENTS.md`, `CLAUDE.md` if present) for workflow/product/scope constraints. Read `STRATEGY.md` if it exists.

*Topic Scan* — Search for relevant terms. Read the most relevant existing artifact.

**Technical depth rules:**
1. **Verify before claiming** — When touching checkable infrastructure, read source files to confirm. Label unverified claims as assumptions.
2. **Defer design decisions to planning** — Schemas, migrations, endpoints belong in planning unless the brainstorm is itself about a technical/architectural decision.

#### 1.2 Product Pressure Test

Agent-internal analysis, not user-facing. Read the opening, note gaps, raise only those as questions during Phase 1.3.

**Lightweight gaps:**
- Is this solving the real user problem?
- Are we duplicating something existing?
- Is there a clearly better framing with near-zero extra cost?

**Standard gaps:**
- **Evidence gap** — Opening asserts want/need but no observable action.
- **Specificity gap** — Beneficiary described too abstractly.
- **Counterfactual gap** — No visibility into what users do today.
- **Attachment gap** — Opening treats a solution shape as the thing, not the value.

**Deep** — Standard plus: Is this a local patch, or does it move the broader system forward?

**Deep — product** — Deep plus:
- **Durability gap** — Value proposition rests on a current state that may shift.
- What adjacent product could we accidentally build instead?

#### 1.3 Collaborative Dialogue

Follow Interaction Rules. Use `feishu_ask_user_question` in Feishu; numbered options in other channels.

**Guidelines:**
- Ask what the user is already thinking before offering ideas.
- Start broad (problem, users, value) then narrow (constraints, exclusions, edge cases).
- **Assumptions mode:** When something is unverified, surface it as a structured assumption:
  - `A-01`: We assume [X] because [reason]. Please confirm or correct.
- **UI/UX probing questions** (if frontend involved):
  - What is the primary user flow? Entry point and exit state?
  - What device/form factor is the primary target?
  - Are there existing design patterns or components to reuse?
  - What happens on error, empty state, and loading state?
  - Is accessibility a required constraint?
- **Rigor probes** fire before Phase 2, open-ended, one at a time. Each gap from Phase 1.2 gets a separate probe.
- Clarify problem frame, validate assumptions, ask about success criteria.
- Make requirements concrete enough that planning will not need to invent behavior.

**Integration check before exiting Phase 1.3:** Combine what the user has said. If X + Y + default-Z produces a downstream effect the user likely hasn't tracked, probe it now open-ended.

**Exit condition:** Continue until the idea is clear AND no integration-check questions pending, OR the user explicitly wants to proceed.

### Phase 2: Explore Approaches

If multiple plausible directions remain, propose **2–3 concrete approaches**. Otherwise state the recommendation directly.

Use at least one non-obvious angle — inversion, constraint removal, or analogy from another domain.

When useful, include one deliberately higher-upside alternative as a challenger option alongside the baseline.

For each approach:
- Brief description (2–3 sentences)
- Pros and cons
- Key risks or unknowns
- When it's best suited

**Granularity: mechanism / product shape, not architecture.** No column names, table names, file paths, exact method names.

After presenting all approaches, state recommendation and explain why. Prefer simpler solutions when complexity creates real carrying cost.

**Decision capture:** Every choice here gets a decision ID:
- `D-01`: We will build [X] rather than [Y] because [reason].
- `D-02`: Scope boundary — [feature] is in scope; [feature] is deferred.

### Phase 2.5: Synthesis Summary + Decision Coverage Gate

Surface a scoping synthesis before Phase 3 — the user's last chance to correct scope.

**Decision coverage gate:** List all decisions (D-XX) made so far. State: "These decisions MUST carry forward into planning. No D-XX may be silently dropped or re-invented."

**Path A vs Path B:**
- **Path A** — no blocking questions fired AND tier is Lightweight: announce-mode. Emit "What we're building" (1–3 sentences), then proceed to Phase 3 in the same turn.
- **Path B** — at least one blocking question fired, OR tier is Standard / Deep: full scoping synthesis with confirmation gate.

### Phase 3: Capture the Requirements

Write or update a requirements document only when the conversation produced durable decisions worth preserving.

**Storage location:**
- If `memory/.planning/` exists: write to `memory/.planning/phases/XX-CONTEXT.md` where XX is the phase number (e.g., `01-CONTEXT.md`).
- Otherwise: write to `memory/brainstorms/<topic>-requirements.md`.

**Document sections (right-sized to tier):**
- **Overview** — What we're building and why
- **Goals** — What success looks like
- **Non-goals** — Explicitly out of scope
- **User stories / Key behaviors** — Concrete, testable descriptions
- **Scope boundaries** — "In scope" and "Deferred for later"
- **Success criteria** — How we know it worked
- **Decisions** — `<decisions>` block containing all D-XX decisions with IDs, descriptions, and rationale
- **Assumptions** — `<assumptions>` block containing all A-XX assumptions with IDs and confirmation status (confirmed / pending)
- **Dependencies / Open questions** — Only if they materially affect scope

**Decision block format:**
```markdown
<decisions>
- **D-01**: [Decision description] — Rationale: [reason]
- **D-02**: [Decision description] — Rationale: [reason]
</decisions>
```

**Assumptions block format:**
```markdown
<assumptions>
- **A-01**: [Assumption description] — Status: [confirmed / pending]
- **A-02**: [Assumption description] — Status: [confirmed / pending]
</assumptions>
```

For Lightweight: keep the document compact. Skip doc creation entirely if only brief alignment is needed.

### Error Handling

This skill follows the [AGENTS/error-handling.md](../AGENTS/error-handling.md) standard.

### Common Error Codes

| Error Code | Trigger Scenario | Handling Strategy |
|------------|-----------------|-------------------|
| `API_TIMEOUT` | `feishu_ask_user_question` / search timeout | Wait 4s and retry, max 2 times |
| `RATE_LIMITED` | API rate limiting | Wait 10s and retry |
| `VALIDATION_FAILED` | User input / platform interaction parameter validation failure | Fix parameters and retry |
| `RESOURCE_NOT_FOUND` | Existing requirements doc / project file not found | Check path; escalate if unrecoverable |
| `CONTEXT_OVERFLOW` | Long conversation / large codebase scan exceeds limit | Compress and retry, or process in chunks |
| `SUBAGENT_FAILED` | Subagent (if present) failed | Check subagent logs; retry at most once |

### Escalation Conditions

- Same `error_code` fails 2 times in a row → force escalate on the 3rd
- `retry_count` reaches `max_retries` → escalate
- Non-recoverable errors (PERMISSION_DENIED, SECURITY_BLOCKED, etc.) → escalate immediately

### Fallback Chain

| Primary | Fallback | Condition |
|---------|----------|-----------|
| `feishu_ask_user_question` | `message` (text options) | `API_TIMEOUT` / `RATE_LIMITED` |
| `read` (project files) | `memory_search` | `RESOURCE_NOT_FOUND` |
| `kimi_fetch` (external research) | `web_fetch` | `API_TIMEOUT` / `NETWORK_ERROR` |

## Phase 4: Handoff

Present next-step options and execute the user's selection:

1. **Proceed to planning** — Hand off to the planning skill with the requirements doc as context. Emphasize: "All D-XX decisions above MUST appear in the plan."
2. **Refine scope** — Return to Phase 1.3 or Phase 2 to adjust.
3. **Start implementation** — If the work is small and well-defined enough to skip planning.
4. **Save and close** — Document is saved; no further action needed now.

**Closing summary:** One-sentence recap of what was decided, where the doc lives, and what the recommended next step is.
