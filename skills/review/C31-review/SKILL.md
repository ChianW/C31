---
name: C31-review
description: review, 审查, verify | 审查阶段：并行多角色代码审查+UAT验证+覆盖率检查
triggers: review, 审查, code review, verify, 验证, verify-work
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | review, 审查, code review, verify, 验证, verify-work |
| ZH | 审查, 代码审查, 验证 |
| JA | レビュー, コードレビュー, 検証 |

> **Output language**: Respond automatically in the user's conversation language.

# C31 Review

Reviews code changes using dynamically selected reviewer personas, then runs a
verify-work pass: UAT walkthrough, verifier validation, and decision coverage
logging. Writes `memory/.planning/phases/XX-VERIFICATION.md`.

## When to Use

- Before creating a PR or merging code
- After completing a coding or implementation task
- When the user says "code review", "审查", "review my code", "看看这段代码",
  "verify", "验证", "verify-work", or "review"

## Modes

| Mode | Trigger | Behavior |
|------|---------|----------|
| **interactive** (default) | No mode token | Review, UAT, ask user how to proceed |
| **autofix** | `mode:autofix` | Apply `safe_auto` fixes, auto-run UAT, report residuals |
| **report-only** | `mode:report-only` | Read-only review + UAT, no edits |
| **headless** | `mode:headless` | Programmatic mode; structured output, no interaction |

Conflicting mode flags: stop and emit `Review failed. Reason: conflicting mode flags`.

## Severity Scale

All reviewers use P0-P3:

| Level | Meaning | Action |
|-------|---------|--------|
| **P0** | Critical: vulnerability, data loss, logic breakage | Must fix before merge |
| **P1** | High: likely hit in normal usage, breaking contract | Should fix |
| **P2** | Moderate: edge case, perf regression, maintainability | Fix if straightforward |
| **P3** | Low: minor improvement, narrow scope | User's discretion |

## Action Routing

| `autofix_class` | Default Owner | Meaning |
|-----------------|---------------|---------|
| `safe_auto` | `review-fixer` | Local, deterministic fix — can auto-apply |
| `gated_auto` | `downstream-resolver` | Concrete fix exists but changes behavior/contracts |
| `manual` | `downstream-resolver` | Actionable work requiring handoff |
| `advisory` | `human` | Report-only (learnings, rollout notes, residual risk) |

Routing rules:
- Synthesis owns the final route. Choose the more conservative route on disagreement.
- Only `safe_auto -> review-fixer` enters the in-skill fixer queue automatically.
- `requires_verification: true` means a fix is not complete without targeted tests or re-review.

## Reviewers

**Lightweight path (default for small changes):**

Use the [30-Second Inline Checklist](#lightweight-review-path-30-second-inline-checklist) below. Covers correctness, maintainability, simplicity, performance, data, schema, deployment, pattern, design, and doc quality without spawning subagents.

**Escalate to subagent review when:**
- Security-related → spawn `security-reviewer`
- Architecture change → spawn `architecture-reviewer`  
- Resilience/chaos testing → spawn `adversarial-reviewer`
- >3 files or >100 lines, or any checklist uncertainty → full pipeline (all stages)

**Reserved subagent personas (spawned on escalation):**

| Agent | Focus | When to spawn |
|-------|-------|---------------|
| `security-reviewer` | Injection, XSS, auth bypass, secrets leak, CORS, PII exposure | Auth, public endpoints, user input, permissions |
| `architecture-reviewer` | Coupling, layering, abstraction leaks, scalability, boundaries | New service boundary, dependency direction change, stateful design |
| `adversarial-reviewer` | Fault propagation, undeclared assumptions, resource exhaustion, TOCTOU | Error handling, retries, timeouts, background jobs, distributed systems |
| `testing-reviewer` | Coverage gaps, weak assertions, brittle tests | Any non-trivial change (can run in parallel with checklist) |
## Workflow

### Stage 1: Determine Scope

1. Parse optional tokens: `mode:autofix`, `mode:report-only`, `mode:headless`, `base:<ref>`.
2. If `base:` provided, use `git diff -U10 <base>`. Else detect base branch (`origin/HEAD`, `main`, `master`) and compute merge-base.
3. Produce: file list, diff with 10 lines of context, untracked files list.

If untracked files exist, note them as excluded. In headless/autofix, proceed with tracked changes only.

### Stage 2: Intent Discovery

Summarize the change's goal in 2-3 lines:

```
Intent: Replace multi-tier rate lookup with flat-rate computation.
Must not regress edge cases in tax-exempt handling.
```

Sources: PR title/body, commit messages, branch name, conversation context.
If ambiguous and mode is **interactive**, ask the user before spawning reviewers.
For non-interactive modes, infer conservatively and note uncertainty in Coverage.

### Stage 3: Select Reviewers

Read the diff and file list. Spawn all always-on personas. Add conditionals that fit the diff. Skip runtime reviewers for Markdown, JSON schema, or config-only diffs. Announce the team before spawning.

### Stage 4: Spawn Reviewer Subagents

Use `sessions_spawn` to dispatch reviewers in parallel. Each receives:
1. Their persona prompt (from `references/reviewer-prompts.md`)
2. Intent summary, file list, diff
3. JSON output contract (see below)

**Model tiering:**
- `correctness-reviewer` and `security-reviewer` inherit the session model.
- All others use the configured mid-tier model.

Each reviewer returns compact JSON:

```json
{
  "reviewer": "security",
  "findings": [
    {
      "title": "User-supplied ID without ownership check",
      "severity": "P0",
      "file": "orders_controller.rb",
      "line": 42,
      "confidence": 100,
      "autofix_class": "gated_auto",
      "owner": "downstream-resolver",
      "requires_verification": true,
      "pre_existing": false,
      "suggested_fix": "Add current_user.owns?(account) guard"
    }
  ],
  "residual_risks": [],
  "testing_gaps": []
}
```

`confidence` is one of 5 discrete anchors: `0, 25, 50, 75, 100`.
Reviewer subagents are **read-only** — they do not edit files, change branches, commit, or push.

### Stage 5: Merge & Deduplicate

1. **Validate.** Check required fields and value constraints. Drop malformed findings.
   - Required: `title`, `severity`, `file`, `line`, `confidence`, `autofix_class`, `owner`, `requires_verification`, `pre_existing`
   - Constraints: `severity` in {P0,P1,P2,P3}, `autofix_class` in {safe_auto,gated_auto,manual,advisory}, `confidence` in {0,25,50,75,100}, `line` > 0

2. **Deduplicate.** Fingerprint: `normalize(file) + line_bucket(line, ±3) + normalize(title)`. Merge matches: keep highest severity, highest confidence, note reviewers.

3. **Cross-reviewer agreement.** 2+ reviewers on the same issue promote one confidence step: `50 → 75`, `75 → 100`.

4. **Separate pre-existing.** Pull `pre_existing: true` findings into a separate list.

5. **Resolve disagreements.** Annotate and keep the most conservative route.

6. **Derive recommended action:**
   | `autofix_class` | `suggested_fix` present? | Recommended action |
   |-----------------|--------------------------|--------------------|
   | `safe_auto` | — | Apply |
   | `gated_auto` | yes | Apply |
   | `gated_auto` | no | Defer |
   | `manual` | yes | Apply |
   | `manual` | no | Defer |
   | `advisory` | n/a | Acknowledge |
   Tie-break: `Skip > Defer > Apply > Acknowledge`.

7. **Mode-aware demotion.** P2/P3 + `advisory` + all reviewers are `testing` or `maintainability`:
   - Interactive/report-only: move to `testing_gaps` or `residual_risks`.
   - Headless/autofix: suppress entirely. Record count in Coverage.

8. **Confidence gate.** Suppress findings below anchor 75. Exception: P0 findings at anchor 50+ survive.

9. **Sort and number.** Order by severity (P0 first) → confidence (descending) → file → line. Assign stable `#` values.

10. **Collect coverage.** Union `residual_risks` and `testing_gaps` across reviewers.

### Stage 6: Synthesize & Present

**Header:** Scope, intent, mode, reviewer team with justifications.

**Findings:** Pipe-delimited markdown tables grouped by severity. Omit empty levels.

| # | File | Issue | Reviewer | Confidence | Route |
|---|------|-------|----------|------------|-------|
| 1 | `orders_controller.rb:42` | User-supplied ID without ownership check | security | 100 | gated_auto → downstream-resolver |

**Pre-existing:** Separate section, does not count toward verdict.

**Applied Fixes:** Include only if a fix phase ran.

**Residual Actionable Work:** Include when unresolved actionable findings remain.

**Coverage:** Suppressed count by anchor, mode-aware demotion count, failed reviewers, intent uncertainty.

**Verdict:** Ready to merge / Ready with fixes / Not ready. No time estimates.

### Stage 7: UAT Walkthrough (Verify-Work)

Walk through every testable deliverable produced by the change:

1. **Identify testables.** From the diff, list files, features, endpoints, or UI flows that can be exercised.
2. **Build test plan.** For each testable, define: input, expected output, pass criteria.
3. **Execute or simulate.** In interactive mode, guide the user through each step. In headless/autofix, simulate or run automated acceptance tests if available.
4. **Log results.** Record PASS / FAIL / BLOCKED per testable with line references.

If a testable lacks automated tests and cannot be manually exercised in the current context, mark it `BLOCKED` and note the gap.

### Stage 8: Nyquist Compliance Check

Verify automated test coverage exists for the changed code:

1. Check for new or updated unit tests touching modified functions.
2. Check for integration tests covering modified endpoints or flows.
3. If coverage is missing for a significant path, flag it as a `testing_gaps` item.
4. In the final report, add a **Nyquist** section: `Compliant / Partial / Non-compliant` with specific gaps.

### Stage 9: Decision Coverage Gate

Non-blocking check: log any architectural or design decisions that were made (or should have been made) during the change but are not documented.

1. Scan commit messages, PR description, and code comments for decision rationale.
2. If a significant decision (algorithm choice, schema change, API shape, dependency addition) has no trace, log it to the VERIFICATION.md under `Missed Decisions`.
3. This gate never blocks merge — it is a learning signal for the team.

### Stage 10: Verifier Agent

Run a verifier check against phase goals and requirements:

1. Re-read the intent summary from Stage 2.
2. Verify the change satisfies the stated goal.
3. Check for regressions against the "must not" constraints.
4. Confirm no P0 findings remain unresolved.
5. If the change introduced new behavior, verify it is covered by UAT or automated tests.
6. Output: **Verifier verdict** — `PASS / FAIL / CONDITIONAL_PASS` with rationale.

### Stage 11: Diagnose Failures & Fix Plan

If any stage produces a FAIL or unresolved P0/P1:

1. **Diagnose:** Root-cause the failure (code bug, test gap, missing dependency, environment issue).
2. **Generate PLAN.md:** Write a concise re-execution plan to `memory/.planning/phases/XX-PLAN.md` containing:
   - Failure summary
   - Root cause
   - Fix steps (ordered)
   - Re-verification steps
   - Owner assignment (default: `downstream-resolver`)
3. In **autofix** mode, apply `safe_auto` fixes first, then regenerate the PLAN.md for remaining items.
4. In **interactive** mode, present the PLAN.md and ask the user to confirm or edit before proceeding.

## Quality Gates

Before delivering the review:

1. Every finding is actionable. Rewrite vague "consider" items.
2. No false positives. Verify surrounding code was read.
3. Severity is calibrated. Style nits are never P0; SQLi is never P3.
4. Line numbers are accurate.
5. Findings don't duplicate linter output. Focus on semantic issues.
6. UAT walkthrough is complete or explicitly blocked with reason.
7. Nyquist section is present in the output.

## Output Artifact: VERIFICATION.md

Write the final report to `memory/.planning/phases/XX-VERIFICATION.md` (use next available phase number, e.g., `03-VERIFICATION.md`).

The file must include:

```markdown
# Phase XX Verification

## Intent
<!-- 2-3 lines from Stage 2 -->

## Review Findings
<!-- Findings tables from Stage 6 -->

## UAT Results
<!-- PASS / FAIL / BLOCKED per testable from Stage 7 -->

## Nyquist Compliance
<!-- Compliant / Partial / Non-compliant from Stage 8 -->

## Decision Coverage
<!-- List of missed decisions from Stage 9, or "All major decisions documented" -->

## Verifier Verdict
<!-- PASS / FAIL / CONDITIONAL_PASS from Stage 10 -->

## Fix Plan
<!-- Link to PLAN.md if generated, or "No fix plan required" -->

## Verdict
<!-- Ready to merge / Ready with fixes / Not ready -->
```

## Post-Review Routing (Interactive Mode)

After presenting findings:

- Apply `safe_auto` fixes automatically without asking.
- If no actionable findings remain, emit completion summary and verdict.
- Otherwise, ask the user:
  - (A) Walk through findings one by one
  - (B) Auto-resolve with best judgment
  - (C) Report only — take no further action

For **autofix** mode: apply `safe_auto` fixes, run UAT, write VERIFICATION.md + PLAN.md (if needed), report residuals, stop. Never commit or push.

For **headless** mode: apply `safe_auto` fixes in a single pass, run UAT, write VERIFICATION.md + PLAN.md (if needed), return structured output with residuals, end with `Review complete`. Never commit or push.

For **report-only** mode: stop after Stage 10 (verifier). No edits, no artifacts.

## Fallback

If parallel subagents are unavailable, run reviewers sequentially. Everything else (stages, merge pipeline, UAT, output format) stays the same.

---

## References

- `references/reviewer-prompts.md` — Persona definitions and output contracts for all reviewer types.

---

## Lightweight Review Path: 30-Second Inline Checklist

**Use when:** Change is small (1-3 files, ≤50 lines), no security/auth/data-layer impact, no schema changes, no production deploy. Replaces Stages 3-10 above with a fast self-check.

**Rule:** If any item below fails with ≥moderate confidence, escalate to full review pipeline (Stages 1-11 above). Never skip for P0-class risk areas (auth, payments, data migrations, schema changes, external API contracts).

### Checklist

| # | Category | Check | Pass / Escalate |
|---|----------|-------|-----------------|
| 1 | **Correctness** | Logic error (off-by-one, flipped condition)? Edge cases (null, empty, zero, overflow)? | |
| 2 | **Correctness** | Error paths tested? Right exception thrown? Error not swallowed? | |
| 3 | **Maintainability** | Naming describes intent? No dead code (unused imports, unreachable branches)? | |
| 4 | **Maintainability** | Coupling: no cross-layer leakage, no new import cycles? | |
| 5 | **Simplicity** | No unnecessary abstraction? No premature generalization? No framework worship? | |
| 6 | **Simplicity** | Can someone else understand this in ≤2 min without your explanation? | |
| 7 | **Performance** | No N+1 queries? No unbounded result sets? Cache TTL appropriate? | |
| 8 | **Data** | If touching DB: migration reversible? Constraints safe on existing data? No data loss path? | |
| 9 | **Schema** | If schema change: isolated to target table? Backward compatible? CONCURRENTLY for large indexes? | |
| 10 | **Deployment** | New env vars in all environments? Graceful shutdown handled? Rollback path exists? | |
| 11 | **Pattern** | DRY: same logic not repeated 3+ times? Magic values extracted? Language idioms used? | |
| 12 | **Design-UI** | If UI change: all states handled (empty/loading/error/success)? Touch target ≥44×44? | |
| 13 | **Design-UX** | Interaction steps minimal? Error message says what happened + how to fix? | |
| 14 | **Doc** | Internal consistency? No term drift? No broken cross-references? Scope creep absent? | |

### Escalation Criteria

Escalate to full review if **any** of:
- Security-related (auth, input handling, permissions, secrets) → spawn `security-reviewer` + `adversarial-reviewer`
- Architecture change (new service boundary, new dependency direction, stateful design) → spawn `architecture-reviewer`
- Data layer change (migration, schema, backfill, constraint) → spawn `data-reviewer`
- >3 files or >100 lines → full pipeline
- You are unsure on any checklist item → full pipeline

### Execution

1. Read diff / files.
2. Run checklist top-to-bottom (30 sec estimate).
3. If all pass → emit `PASS — no full review needed` with optional quick notes.
4. If any fail → emit `ESCALATE: [item #] — [reason]` and run full pipeline.

---

*Lightweight path inspired by Superpowers v5.0.6 inline self-review validation (5 versions × 5 trials = equivalent quality to 25-min subagent loops).*
