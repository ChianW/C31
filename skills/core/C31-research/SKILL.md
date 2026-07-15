---
name: C31-research
description: research, 调研, 最佳实践 | 统一研究：框架文档、git历史、社区问题、机构记忆、bug复现
triggers: research, 调研, 最佳实践, 资料, 研究, how should I
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | research, 调研, 最佳实践, 资料, 研究, how should I |
| ZH | 调研, 研究, 最佳实践 |
| JA | 調査する, リサーチ, ベストプラクティス |

> **Output language**: Respond automatically in the user's conversation language.

# C31 Research

Unified research skill. Covers best practices, framework documentation, git history, community issues, institutional memory, and bug reproduction. All modes are read-only — does not write code.

## When to Use

- "What is the best practice?" / "idiomatic way" / "how should I..."
- Before entering an unfamiliar tech stack
- Debugging framework-level errors / verifying version changes
- Bug reports lacking reproduction steps / "Have we solved something similar before?"
- Checking health of a new dependency before adoption
- Understanding historical context before modifying complex code

## Core Principles

1. **Read-only** — never write code, never modify files.
2. **Source hierarchy** — official docs > community consensus > blog posts.
3. **Version-sensitive** — always note framework/library version; docs drift.
4. **Explicit gaps** — say "not found" rather than guess.
5. **Output ≤80 lines** + one code example max.

## Research Fallback Chain (Auto-Downgrade — No User Interruption)

If any mode encounters missing data or an error during execution, auto-downgrade in the following order. Never stop to ask the user.

```
IF official docs not found  → search community consensus (HN / StackOverflow / official Discussions)
IF community consensus not found → search blogs / RFCs / talk slides (with ⚠️ caveats)
IF all sources exhausted   → explicitly state "Insufficient evidence" + output list of sources searched
IF version mismatch        → flag deprecation risk, continue with latest version, note "User version unverified"
IF search timeout           → return partial results + mark in gaps: "Search timed out: did not cover [X]"
IF 5 search attempts yield nothing → flag as gap, stop exhaustive search
```

**Downgrade principles:**
- Each downgrade must be noted in the `caveat` field with the downgrade level ("downgraded from official docs to blog posts")
- Claims after downgrade automatically lower `confidence` (high→medium→low)
- The final gaps list must include **"which sources were tried"** and **"why they were not found"**

## Research Modes

Select mode based on user intent. One mode per invocation. Chain multiple modes for deep research.

### Mode A: Best Practices (`mode:best-practices`)

Find idioms, patterns, anti-patterns for a technology.

1. Confirm dependency version.
2. Read official docs (getting started, core concepts, API reference).
3. Search community consensus (HN, StackOverflow, official blog, RFCs).
4. Check project conventions (`.eslintrc`, `CONVENTIONS.md`, `ARCHITECTURE.md`).
5. Compare 2-3 alternatives with tradeoffs table.

**Output:** source citations + recommendation + why.

---

### Mode B: Framework Docs (`mode:framework-docs`)

Verify API behavior, lifecycle, hooks, execution order.

1. Locate official docs (API reference, not tutorials).
2. Find exact page: signatures, parameters, return values, exceptions.
3. Check version migration guide + deprecation notices.
4. Search official examples > community examples.
5. Verify edge cases: defaults, null/undefined handling, async behavior.

**Output:** verified fact + checked version + deprecation warnings if any.

---

### Mode C: Git History (`mode:git-history`)

Understand why code exists, who wrote it, regressions, prior attempts.

1. `git blame` to locate commit and author.
2. `git show` full commit (body, not just subject).
3. `git log --grep` for related changes.
4. Check for Revert commits.
5. `git log --oneline` for recent context.
6. Cross-reference issues (`Fixes #NNN` in commit body).

**Heuristics:**
- Reverted code has hidden reasons — dig deeper.
- Same author touching same file 3+ times = domain expert, read their other commits.
- Commit mentions "workaround" / "temporary" = likely technical debt.

---

### Mode D: Issue Intelligence (`mode:issue-intelligence`)

Check GitHub issues/PRs/discussions for known bugs, workarounds, tribal knowledge.

1. Search issues: `is:issue [keyword]` (open + closed).
2. Check labels: `bug`, `confirmed`, `documentation`, `wontfix`.
3. Read top 3-5 matches — focus on maintainer responses + workarounds.
4. Check PRs: `is:pr` for pending fixes.
5. Check Discussions for edge-case guidance.
6. Assess issue health: last activity? maintainer responsive? stale?

**Filter:** Only include workarounds verified by multiple users or maintainers. Always date-stamp issue references (stale workarounds may no longer apply).

---

### Mode E: Learnings / Institutional Memory (`mode:learnings`)

Search prior solutions, architecture decisions, project history.

1. Search `memory/solutions/` for matching entries.
2. Search `docs/` (ADRs, architecture docs).
3. Search diary/notes for decision rationale.
4. Check `ROADMAP.md` / `STATE.md` for current project position.
5. Cross-reference by tags or shared root causes.

**Quality rule:** Include the "why", not just the "what". If a prior solution was later found flawed, note that.

---

### Mode F: Bug Reproduction (`mode:bug-reproduction`)

Systematically reproduce a bug through hypotheses and controlled experiments.

1. **Hypothesize** — propose 3 ranked hypotheses (code bug / environment issue / configuration problem).
2. **Minimize surface area** — strip unrelated code, minimal dataset, disable cache/async/concurrency, test with defaults first.
3. **Controlled experiment** — change one variable at a time, record each result.
4. **For intermittent bugs** — run N times, record frequency (e.g., "3/10 attempts").
5. **Verify** — clean environment reproduces = code bug; only specific environment = env/config bug; never reproduces = missing condition or already fixed.

**Stop rule:** After 3 failed reproduction attempts, stop and document all attempts. Do not keep guessing.

---

## Workflow

1. **Classify intent** — which mode(s) apply? Can chain: e.g., `best-practices` → `framework-docs` → `issue-intelligence`.
2. **Execute mode** — follow steps above, stay read-only.
3. **Synthesize** — 80-line summary with source citations.
4. **Gap declaration** — explicitly state what was not found.
5. **Route** — return findings to caller (e.g., `C31-plan`, `C31-debug`, or user).

## Associated Resources (Auto-Lookup Paths)

When executing Mode E (`learnings`) and chained calls, the following paths are automatically searched if they exist:

| Path | Contents | Priority |
|------|----------|----------|
| `memory/solutions/` | Records of solved problems (bug fixes, workarounds, root causes) | Highest |
| `memory/moc/` | Knowledge graph / Map of Content (concept associations, decision audits) | High |
| `memory/projects/` | Project history, state, and decision records | High |
| `memory/decisions/` | Decision audits and outcome reasoning analysis | Medium |
| `memory/prompts/` | Prompt engineering experiment records | Medium |
| `docs/` | ADRs, architecture docs, ROADMAP.md, STATE.md | Medium |
| `references/` | External reference material index (if present) | Low |

> **If a path does not exist, skip it silently** — no error, no interruption.

## Output Contract

```json
{
  "mode": "best-practices|framework-docs|git-history|issue-intelligence|learnings|bug-reproduction",
  "findings": [
    {
      "claim": "One-line fact or recommendation",
      "source": "URL or git ref or memory path",
      "confidence": "high|medium|low",
      "version": "optional: checked framework version",
      "caveat": "optional: deprecation, stale, partial match"
    }
  ],
  "gaps": ["What was searched but not found"],
  "recommended_next": "mode to chain next, or null"
}
```

## Anti-Pattern Blacklist

These patterns are **absolutely forbidden** during C31-research execution. Each corresponds to a real misuse scenario.

| # | Anti-Pattern | Misuse Scenario | Correct Practice |
|---|--------------|-----------------|------------------|
| 1 | ❌ Writing code during research | Itching to implement directly after reading the API docs | Switch to `C31-work` or `C31-plan` skill; research stays read-only |
| 2 | ❌ Guessing facts with unclear sources | "This framework should support..." | Explicitly state **"No official confirmation found"**; never output speculation |
| 3 | ❌ Endless searching when evidence is scarce | Still no results on step 6, continuing to page 20 | **5 search steps with no result → flag as gap**, output sources searched, stop |
| 4 | ❌ Omitting source citations | Giving a recommendation without a URL / git ref / memory path | Every claim must have a `source` field; untraceable claims downgrade to `confidence: low` or are removed |
| 5 | ❌ Skipping version check | Citing latest docs without verifying the user's actual version | **Confirm version first** → read the corresponding version docs → flag deprecation risk |
| 6 | ❌ Mixing research modes without clear intent | Midway through Mode A, randomly switching to Mode B | Mode A→B is a **chained call** (A outputs `recommended_next: B`), not a random switch. When intent is unclear, run a single mode to completion |

> Violating any one rule = output confidence downgrades to `confidence: low`, and `gaps` must note **"Anti-pattern blacklist violated #N"**.

## Escalation

- Finding contradicts project conventions → flag for `C31-plan` or `C31-brainstorm`
- Finding indicates architectural risk → flag for `C31-review` architecture-reviewer
- Bug reproduces intermittently with no clear pattern → flag for `C31-debug` with reproduction log
- Multiple sources conflict → present both, do not resolve alone
