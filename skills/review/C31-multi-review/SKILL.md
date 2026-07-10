---
name: C31-multi-review
description: multi-review, 代码审查 | 4代理对抗审查：并行审查+冲突检测+统一裁决
triggers: multi-review, 代码审查, 检查这个, review
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | multi-review, 代码审查, 检查这个, review |
| ZH | 多角色审查, 对抗审查 |
| JA | 多エージェントレビュー, 対抗レビュー |

> **Output language**: Respond automatically in the user's conversation language.

# C31-multi-review — 4-Agent Adversarial Review

## Trigger
- User says: **"review"**, **"审查"**, **"multi-review"**, **"代码审查"**, **"检查这个"**
- C31-lfg **Gate 5** auto-call (strict mode)
- PR submit pre-check (C31-git-worktree integration)

## Input
- Target: file path, diff, or document to review
- Optional: `--strict` (Gate 5 mode, fail on any blocker)

## Workflow

### Phase 1: Scope & Target Read

1. Read the target file(s) or diff.
2. If diff not provided and in git repo: `git diff HEAD`.
3. Produce **target digest** (≤500 lines of relevant code + file list).

### Phase 2: Spawn 4 Review Agents (Parallel)

Use `sessions_spawn` to dispatch 4 subagents simultaneously. Each receives:
- Full target digest
- Its persona prompt (below)
- Strict rule: **find ≥1 real issue or exit** (no hard-fabricated issues)
- Output schema (JSON)

```json
{
  "agent": "correctness",
  "issues": [
    {
      "id": "C-01",
      "severity": "blocker|warning|nit",
      "line": 42,
      "file": "src/foo.ts",
      "description": "...",
      "suggestion": "..."
    }
  ]
}
```

**Agents:**

| Agent | Focus | Exit if Empty |
|-------|-------|---------------|
| **Correctness** | Logic errors, boundary conditions, error paths, type safety | Yes |
| **Security** | Injection risks, permission checks, sensitive data, dependency vulns | Yes |
| **Maintainability** | Readability, naming, complexity, docs, test coverage | Yes |
| **Simplicity** | Over-engineering, simpler alternatives, YAGNI violations | Yes |

Each agent is **isolated** — no shared context, no knowledge of other agents' findings.

### Phase 3: Conflict Detection

After all 4 agents return, spawn **Conflict Agent** (1 subagent):

**Task:** Compare the 4 issue lists and flag contradictions:
- Correctness says "add mutex" vs Simplicity says "remove mutex, unnecessary"
- Security says "sanitize all inputs" vs Maintainability says "too many guards, refactor instead"
- Severity disagreements on same line (blocker vs nit)

**Conflict output schema:**
```json
{
  "conflicts": [
    {
      "id": "X-01",
      "agents": ["correctness", "simplicity"],
      "topic": "mutex necessity at line 88",
      "positions": {
        "correctness": "need lock for thread safety",
        "simplicity": "single-threaded context, no lock needed"
      },
      "resolution": "needs_human_decision"
    }
  ]
}
```

### Phase 4: Synthesize Report

Merge 4 agent outputs + conflict list into unified markdown:

```
# C31 Multi-Review Report
**4 agents reviewed, X issues found, Y conflicts need human decision**

## Blockers (must fix)
| # | Agent | File:Line | Description | Suggestion |
|---|-------|-----------|-------------|------------|
| 1 | [security] | auth.ts:23 | SQL injection via raw query | Use parameterized queries |

## Warnings (should fix)
...

## Nits (optional)
...

## Conflicts Requiring Human Decision
| # | Agents | Topic | Positions |
|---|--------|-------|-----------|
| X-01 | correctness vs simplicity | Mutex at line 88 | "need lock" vs "unneeded" |

## Verdict
- **BLOCKED**: ≥1 blocker found → fix before merge
- **WARNED**: warnings but no blockers → address or acknowledge
- **APPROVED**: only nits or clean → ready
```

### Phase 5: Integration Actions

**With C31-git-worktree:**
- Run review in isolated worktree
- If verdict = BLOCKED → abort merge to main, report issues
- If verdict = APPROVED → auto-merge worktree, cleanup

**With C31-tdd:**
- Maintainability Agent findings include test-coverage gap → spawn C31-tdd to fill
- Correctness Agent finds untested edge case → add test before merge

**Gate 5 (strict mode):**
- Any blocker = **FAIL**, stop pipeline, require human override
- Any unresolved conflict = **FAIL**, no auto-resolution

## Agent Persona Prompts

**Correctness Agent prompt (excerpt):**
> You are a Correctness Reviewer. Your job is to find logic errors, boundary condition failures, unhandled error paths, and type safety issues. **You must find at least 1 real issue or explicitly state "No issues found" and exit.** Do not invent issues to satisfy a quota. Return JSON only.

**Security Agent prompt (excerpt):**
> You are a Security Reviewer. Check for injection vulnerabilities, missing permission guards, sensitive data exposure, and known dependency CVEs. **Must find ≥1 real issue or exit.** JSON only.

**Maintainability Agent prompt (excerpt):**
> You are a Maintainability Reviewer. Evaluate readability, naming conventions, cyclomatic complexity, documentation gaps, and test coverage. **Must find ≥1 real issue or exit.** JSON only.

**Simplicity Agent prompt (excerpt):**
> You are a Simplicity Reviewer. Look for over-engineering, unnecessary abstractions, premature generalization, and YAGNI violations. Ask: can this be done with 50% less code? **Must find ≥1 real issue or exit.** JSON only.

## Rules

1. **No fabricated issues** — agents exit clean if no real findings.
2. **Line refs mandatory** — every issue must cite `file:line`.
3. **Severity calibration** — blocker = breaks production, warning = likely bug, nit = style.
4. **Conflicts are features** — disagreement between agents is data, not failure.
5. **Human is tie-breaker** — Conflict Agent never auto-resolves, only flags.
6. **Under 400 lines** — this skill file stays lightweight.
