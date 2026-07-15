---
name: C31-spec
description: spec, 写需求, PRD | 需求定义：任何新项目/功能/重大变更先写PRD，作为意图与实现的契约
triggers: spec, 写需求, PRD, 产品文档, 定义项目
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | spec, 写需求, PRD, 产品文档, 定义项目 |
| ZH | 写需求, 产品需求, PRD |
| JA | 仕様を書く, 要件定義, PRD作成 |

> **Output language**: Respond automatically in the user's conversation language.

# C31-spec — Spec-Driven Development Skill

---

## Philosophy

Process not prose. Verification non-negotiable. Progressive disclosure.

Any new project, feature, or major change starts with a PRD. No exceptions. The PRD is the contract between intent and implementation. Writing it is cheaper than debugging what you should have decided upfront.

---

## When to Activate

- User says: "I want to build...", "I want to develop...", "This project..."
- User jumps straight to implementation without defining scope
- Any task that will take >30 minutes or modify >3 files
- Any new skill, tool, or workflow

---

## Workflow

### 1. Detect & Interrupt

If user skips spec and goes straight to code:

> "Hold on. Write the PRD first, then write the code. That's the rule."
>
> "Code without a PRD = unconstrained improvisation = rework."

### 2. Elicit Requirements (Progressive Disclosure)

Ask 5 questions, one at a time, in order:

1. **Goal**: What problem does this solve? Who is the user? What is the success criterion?
2. **Command / Interface**: How does the user invoke it? CLI command? API endpoint? Chat trigger word?
3. **Structure**: What files / modules / tables are needed? What is the core data flow?
4. **Code style**: Consistent with existing code conventions? What language / framework?
5. **Boundaries**: Explicitly state what is **not** in scope. Resist scope temptations.

### 3. Write PRD

PRD template (required fields):

```markdown
# PRD: [Project Name]

## Goal
- Problem statement (one sentence)
- Success criteria (2-3 verifiable items)

## Command / Interface
- How to trigger:
- Input parameters:
- Output format:

## Structure
- File list:
- Data flow:
- Dependencies:

## Code Style
- Language / Framework:
- Naming conventions:
- Integration points with the existing project:

## Testing
- How to verify "success criteria":
- At least 1 test case:

## Boundaries (explicitly excluded)
- Not doing X:
- Not doing Y:
- If the user requests these later, a new PRD must be opened
```

### 4. Verification Gate

Once the PRD is written, check:

- [ ] Are success criteria verifiable? ("Better UX" is not; "Load time < 1s" is)
- [ ] Is the boundary list non-empty?
- [ ] Does this conflict with existing `gsd-new-project` / `C31-plan`?
- [ ] Do the file paths already exist? (Avoid overwrites)

If any check fails → reject and rewrite; do not proceed to the next step.

### 5. Handoff to C31-plan / C31-work

Once the PRD is confirmed, generate `PLAN.md`:

```markdown
# PLAN: [Project Name]

Based on PRD: [PRD file path]

## Tasks
1. [ ] [Specific step] → verify: [how to verify]
2. [ ] [Specific step] → verify: [how to verify]
...

## Risk
- [Risk item]: [Mitigation strategy]
```

Then invoke `C31-plan` or `C31-work` to enter the execution phase.

---

## Anti-Rationalization Table

| Excuse | Counter-Argument |
|--------|------------------|
| "Write code first, document later — it's faster" | When you write the docs later, you'll find design errors. Fixing them then costs 10x what fixing them now would cost. |
| "This project is small, doesn't need a PRD" | Small projects grow 3x faster than you expect. |
| "PRD is too formal, not agile" | Agile without constraints = Brownian motion. PRD is a track, not a cage. |
| "The user needs it urgently" | What the user wants has never been "fast" — it's "no rework". PRD saves total time. |
| "I've already thought it through" | The sign that you've thought it through is: you can write a PRD with no ambiguity. If you can't write it, you haven't thought it through. |
| "AI can help me refactor" | AI refactoring requires a clear structure. Clear structure requires a PRD. |

---

## File Placement

- PRD: `memory/.planning/phases/XX-PRD.md` or project root `PRD.md`
- PLAN: `memory/.planning/phases/XX-PLAN.md`
- Cross-reference with `memory/.planning/REQUIREMENTS.md`

---

## Common Errors

| Error | Consequence | Fix |
|-------|-------------|-----|
| PRD says "improve user experience" | Unverifiable; leads to disputes at sign-off | Change to "page load < 1s, error rate < 0.1%" |
| Boundary says "not doing this for now" | "For now" = never defined, scope creep | Write "not doing X; if needed later, open a new PRD" |
| PRD skips the testing section | Critical paths fail only after launch | Write at least one end-to-end verification step |
| Directly copying an old project's PRD | Different context; design decisions are stale | Write independently for each project; reference allowed but not copy-paste |

---

## Reference

- GSD `gsd-new-project` — project initialization
- `C31-plan` — execution plan generation
- `C31-work` — task execution
