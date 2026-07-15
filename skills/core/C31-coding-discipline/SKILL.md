---
name: C31-coding-discipline
description: "Use when the user expresses coding intent: '帮我写', '实现', '开发', '修复', 'fix', 'bug', 'coding', 'code', '写代码', '改代码', or any request to write, modify, or debug software. Enforces a disciplined 7-step workflow with mandatory TDD, inline self-review, and No Placeholders."
triggers:
  - "帮我写"
  - "实现"
  - "开发"
  - "修复"
  - "fix"
  - "bug"
  - "coding"
  - "code"
  - "写代码"
  - "改代码"
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | - "帮我写" |
| ZH | 写代码, 编程纪律 |
| JA | コーディング規律, 実装 |

> **Output language**: Respond automatically in the user's conversation language.

# C31 Coding Discipline

Enforced software development workflow for coding tasks. Not a suggestion — a gate. Each step must complete before the next begins.

## Philosophy

> "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST." — Iron Law of TDD

This skill fuses Superpowers' RED-GREEN-REFACTOR discipline with C31's wave execution and compound knowledge. The goal: code that ships, not code that "should work."

## 7-Step Workflow

```
1. Brainstorm     ← If requirements unclear, run C31-brainstorm first
2. Worktree       ← git worktree add .feature-branch. Isolated development
3. Plan           ← C31-plan with No Placeholders enforced
4. TDD            ← RED → GREEN → REFACTOR for every unit
5. Execute        ← C31-work wave execution, fresh subagent per task
6. Inline Review  ← 30-second checklist (not 25-minute subagent loops)
7. Finish         ← Verify tests → merge / PR / keep / discard
```

### Step 1: Brainstorm (Conditional)

If the coding task is unclear, ambiguous, or cross-cutting:
- Run `C31-brainstorm` to produce a requirements doc.
- If already clear, skip to Step 2.

**Gate**: Requirements doc must exist (from brainstorm or user) before planning.

### Step 2: Worktree (Mandatory for Non-Trivial Tasks)

```bash
# Create isolated branch
git worktree add .worktrees/feature-name -b feature/feature-name
cd .worktrees/feature-name
```

- Verify clean test baseline: `npm test` / `pytest` / etc. must pass before changes.
- If tests fail on baseline → fix baseline first, or document known failures.

**Trivial fast-path**: Single-file typo fix, one-line change → skip worktree, edit in place.

### Step 3: Plan (Mandatory)

Run `C31-plan` with **No Placeholders** enforced:

```
Every unit must contain:
- Exact file path (repo-relative)
- Complete code blocks (not "similar to Task N")
- Exact commands with expected output
- Test scenario: input → action → expected outcome
```

**Placeholder Detection Gate**:
| Marker | Severity | Action |
|--------|----------|--------|
| "TBD" / "TODO" / "implement later" | BLOCKING | Stop. Investigate. Fill or remove. |
| "add appropriate error handling" | BLOCKING | Specify exact error cases and handling. |
| "similar to Task N" | BLOCKING | Inline the actual code. |
| Vague file paths ("the controller") | BLOCKING | Use `app/controllers/orders_controller.rb`. |

**Plan granularity**: 2–5 minutes per unit. If a unit takes >5 minutes, split it.

### Step 4: TDD — RED → GREEN → REFACTOR (Mandatory)

For every implementation unit:

**RED**: Write one minimal failing test
- One behavior per test
- Clear descriptive name
- Real code in test (no mocks unless external API)
- Run test. Confirm it fails for the *expected* reason. **Never skip verification.**

**GREEN**: Write simplest code to pass
- Minimal implementation. No gold plating.
- Run test. Confirm pass + all other tests still pass + no warnings.

**REFACTOR**: Clean up, keep tests green
- Remove duplication. Improve naming. Simplify.
- Run full suite after each refactor.

**Anti-Rationalization Table**:
| Excuse | Counter |
|--------|---------|
| "Skip TDD just this once" | Stop. This is the slipperiest slope. |
| "I'll write tests after" | Delete any code written before test. Start over. |
| "This is too simple for TDD" | If it's that simple, the test takes 30 seconds. Write it. |
| "TDD is dogmatic" | TDD is not religion. It is verification. Verify first. |

### Step 5: Execute (Wave Parallel)

Run `C31-work` with wave analysis:
- Wave 1: Independent tasks → parallel subagents
- Wave 2+: Dependent tasks → sequential
- Fresh subagent per task (context isolation)

**Commit per task**:
```bash
git add <task-specific-files>
git commit -m "feat(scope): U3 Add parser coverage"
```

### Step 6: Inline Review (30-Second Checklist)

After each task (or wave), run this checklist — do NOT spawn a subagent:

| # | Check | Pass? |
|---|-------|-------|
| 1 | Spec compliance: Does implementation match the plan? | [ ] |
| 2 | Code quality: Does it follow project conventions? | [ ] |
| 3 | Test coverage: Is there a test for this behavior? Does it pass? | [ ] |
| 4 | No placeholders: No TBD/TODO/similar-to in code? | [ ] |
| 5 | Type consistency: Function names/types match across tasks? | [ ] |
| 6 | Regression check: Full suite passes? | [ ] |
| 7 | Documentation: Comments explain "why", not "what"? | [ ] |

**If any check fails**: Fix immediately before proceeding.

**Why inline instead of subagent?**
- Superpowers v5.0.6 empirically proved: 30s checklist = 25min subagent review loop, same quality.
- Only spawn subagents for: security review, adversarial review, or complex architecture review.

### Step 7: Finish — Merge / PR / Keep / Discard

```bash
# Verify
cd main-repo
npm test  # full suite must pass

# Options:
git merge feature/feature-name          # merge to main
git push origin feature/feature-name    # open PR
git worktree remove .worktrees/feature-name  # cleanup
```

**If tests fail**: Return to Step 4. Do not merge with failing tests.

## Guardrails

### 3-Fix Rule (from C31-debug)
After 3 failed fix attempts on a bug: STOP. This is an architectural problem. Escalate to human.

### Fresh Subagent Per Task
Each task in wave execution gets a fresh subagent. No context pollution from prior tasks.

### Commit Discipline
- One commit per task (atomic, bisectable, revertible)
- Commit message follows conventional commits: `feat(scope): description`
- No commit without passing tests

## Integration with C31 Skills

```
User: "Help me implement user authentication"

1. C31-brainstorm (if unclear) → requirements doc
2. C31-plan → detailed plan with No Placeholders
3. C31-coding-discipline (this skill) → TDD + wave execution
   - Step 4: RED-GREEN-REFACTOR for each unit
   - Step 5: C31-work wave execution
   - Step 6: Inline checklist
4. C31-review → final quality gate (spawn subagents for security/architecture)
5. C31-compound → record lessons
```

## Output Format

After completing the 7 steps:

```
✅ C31-coding-discipline complete

Branch: feature/feature-name
Commits: N
Tests: all pass (X total, 0 failures)
Inline reviews passed: N
Files changed:
  - path/to/file1 (lines +X -Y)
  - path/to/file2 (lines +X -Y)

Residuals (if any):
  - [description] → /tmp/c31-coding-residuals.md
```

## Anti-Rationalization Guard

| Excuse | Counter |
|--------|---------|
| "I'll commit manually later" | Commit is part of discipline. Skipping breaks traceability. |
| "The plan looks good, skip TDD" | Iron Law: NO CODE WITHOUT FAILING TEST. |
| "Review is slow, skip checklist" | 30 seconds. Not slow. |
| "I'll fix edge cases later" | Edge cases are the first cases. Handle now. |
| "This is just a quick script" | Quick scripts become production. Discipline always. |
