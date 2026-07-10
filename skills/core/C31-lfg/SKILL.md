---
name: C31-lfg
description: lfg, 开干, let's go | 一键执行：已有计划时全自动执行9门管道，无需中途确认
triggers: lfg, 开干, let's go, 直接执行, 跑起来, auto execute
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | lfg, 开干, let's go, 直接执行, 跑起来, auto execute |
| ZH | 开干, let's go |
| JA | やろう, 始めよう |

> **Output language**: Respond automatically in the user's conversation language.

# C31-lfg — Autonomous Execution Pipeline

> "Plan exists. Hands off the wheel. I'll drive."

## Trigger

User says: **"lfg"**, **"开干"**, **"let's go"**, **"直接执行"**, **"跑起来"**, **"auto execute"**

Optional suffix: `strict` → Gate 5 uses strict review checklist.

## Precondition (Hard Gate)

**C31-lfg is execution-layer only.** It never plans.

Before any gate runs, verify one of:
- `memory/.planning/phases/XX-YY-PLAN.md` exists and is active
- User provided a plan file path as argument
- `STATE.md` has a `current_plan` field pointing to a valid plan

**If no plan exists → REJECT immediately.**
```
❌ NO PLAN LOADED
C31-lfg is execution-only. Run `C31-plan` first, or pass a plan path.
No plan found in memory/.planning/phases/ or STATE.md.
```

## Arguments

```
C31-lfg [plan-path] [--strict]
```

- `plan-path` (optional) — override auto-detected plan
- `--strict` — Gate 5 review uses strict checklist (TDD / type-safety / error-handling)

## 9-Gate Pipeline

Each gate is blocking. Fail = abort pipeline, write partial report, handoff residual.

---

### Gate 0: Load Plan

1. Read the plan file into working memory
2. Extract: title, plan_id, type, units (U1..Un), wave analysis, test posture
3. Read `STATE.md` if exists → resume from last checkpoint
4. Compute: total units, waves count, estimated checkpoints

**Output**: `plan_loaded: true | false`

---

### Gate 1: Validate Plan (Nyquist 3-Question Gate)

Answer each with `[PASS]` or `[FAIL]`:

| # | Question | Decision |
|---|----------|----------|
| 1 | **目标清晰？** Does every unit have a concrete, verifiable goal? | |
| 2 | **范围可测？** Does every requirement have ≥1 test scenario mapped? | |
| 3 | **依赖已就绪？** Are all Gate 2+ dependencies (files, env, packages) present? | |

- 3× `[PASS]` → proceed
- Any `[FAIL]` → **abort**, write `VALIDATION_FAIL` report, suggest `C31-plan --deepen`

---

### Gate 2: Setup Worktree

1. Ensure git repo context (workspace root or specified)
2. Create isolated execution space:
   - **Code tasks**: `git worktree add .worktrees/lfg-YYYYMMDD-HHMM` or temp directory
   - **Non-code tasks**: `mkdir -p .tmp/lfg-YYYYMMDD-HHMM`
3. Record worktree path in execution log
4. Verify clean state (stash if needed, log it)

**Output**: `worktree: <path>`

---

### Gate 3: Execute Wave 1 (Parallel)

Load Wave 1 units from plan's **Wave Analysis** table.

```
for unit in Wave_1:
    sessions_spawn(
        name=f"lfg-{unit.uid}",
        prompt=TRUNCATED_PROMPT(unit)  # ≤16K tokens
    )
```

**Rules**:
- One subagent per unit
- Each subagent gets: unit spec + relevant file excerpts (≤8K) + conventions
- No full plan body in prompts
- Parallel commit with `--no-verify` to avoid hook races
- File-collision guard: if two units touch same files → serial fallback (move collider to Wave 2)

**Output**: `wave1_status: done | partial_fail`

---

### Gate 4: Execute Wave 2+ (Serial)

For each dependent wave (W2, W3, ...):
1. Wait for prior wave completion
2. Verify dependencies satisfied (file existence, prior outputs)
3. Execute units in dependency order (serial or parallel within wave if independent)
4. Run lint/type-check once per wave
5. Update STATE.md with wave completion

**Output**: `all_waves_status: done | partial_fail`

---

### Gate 5: Self-Review (C31-review)

Invoke `C31-review` or equivalent internal review pass.

**Checklist selection**:
- **Normal mode** → light checklist (logic, boundaries, obvious bugs)
- **`--strict` mode** → strict checklist:
  - TDD compliance (tests exist for every behavior change)
  - Type safety (no `any`, no unchecked nulls)
  - Error handling (all failure paths covered)
  - No placeholder / TODO in committed code

**Output**: `review_pass: true | false`, findings list

---

### Gate 6: Auto-Fix (Max 3 Rounds)

If Gate 5 found issues:
```
round = 0
while findings and round < 3:
    fix_findings(findings)
    re_run_review()
    round += 1
```

- Round 1: fix all obvious issues
- Round 2: fix residual, re-review
- Round 3: last chance; if still failing → **escalate to residual handoff**

**Output**: `autofix_rounds: N`, `autofix_status: resolved | residual`

---

### Gate 7: Persist

1. **Atomic commit** per unit (or per wave if unit commits already done)
2. **Write / update STATE.md**:
   ```yaml
   current_plan: <plan_path>
   execution_id: lfg-YYYYMMDD-HHMM
   status: completed | partial
   waves_done: [W1, W2, ...]
   units_done: [U1, U2, ...]
   units_failed: [U5, ...]
   review_passed: true | false
   autofix_rounds: N
   worktree: <path>
   ```
3. **Update plan file**: change `status: active → completed` (if fully done)
4. **Clean worktree**: remove temp directory or keep for debugging (log path)

---

### Gate 8: Residual Handoff

Never silently drop unfinished work.

For every incomplete unit, fix, or deferred item:
1. Generate a ticket / todo entry:
   ```markdown
   - [ ] U5: <goal> — blocked by: <reason> — next: <action>
   ```
2. Write to `memory/.planning/tickets/YYYYMMDD-lfg-residual.md`
3. If `feishu_task_task` available → create task
4. Log in STATE.md under `residual_handoff`

**Output**: `residual_count: N`, `residual_path: <path>`

---

### Gate 9: Report

**One-sentence result** to user (first line of response):
```
✅ LFG complete — 5/5 units shipped, review passed, zero residual.
```
or
```
⚠️ LFG partial — 4/5 units done, 1 residual ticket created (U5: parser edge case).
```
or
```
❌ LFG aborted — validation failed at Gate 1, plan needs deepening.
```

**Detailed summary** written to:
```
memory/.planning/executions/YYYYMMDD-lfg-report.md
```

Report template:
```markdown
---
execution_id: lfg-YYYYMMDD-HHMM
plan_id: XX-YY
status: completed | partial | aborted
gates_passed: N/9
---

## Summary
One-line result.

## Gate Log
| Gate | Status | Notes |
|------|--------|-------|
| 0 Load Plan | ✅ | Loaded XX-YY-PLAN.md |
| 1 Validate | ✅ | 3/3 PASS |
| 2 Worktree | ✅ | .worktrees/lfg-... |
| 3 Wave 1 | ✅ | 2 units parallel, 0 collisions |
| 4 Wave 2+ | ✅ | 3 units serial |
| 5 Review | ✅ | light checklist, 0 findings |
| 6 Auto-Fix | N/A | no issues found |
| 7 Persist | ✅ | STATE.md updated |
| 8 Residual | ✅ | 0 residual |
| 9 Report | ✅ | this file |

## Units Executed
| Unit | Status | Commit | Notes |
|------|--------|--------|-------|
| U1 | done | abc1234 | ... |

## Residual Tickets
- None (or list with paths)

## Files Changed
- list

## Next Steps
- suggestion
```

## Prohibited Behaviors

| Behavior | Rule |
|----------|------|
| Ask mid-flight | **Never** ask user for info during execution. If blocked → ticketize, continue, report. |
| Confirm correctness | **Never** say "这样可以吗？" or "这样对吗？". Ship and report. |
| Skip gates | **Never** skip a gate. Even trivial tasks run all 9 gates (some may be N/A). |
| Invent plans | If no plan, **abort**. Do not improvise. |
| Silent failure | If a unit fails, **ticketize** it in Gate 8. Never silently drop. |

## Failure Modes & Escalation

| Stage | Condition | Action |
|-------|-----------|--------|
| No plan | Gate 0 | Abort, report `NO_PLAN`, suggest `C31-plan` |
| Validation fail | Gate 1 | Abort, report `VALIDATION_FAIL`, suggest plan deepen |
| Wave execution fail | Gate 3/4 | Continue remaining waves, ticketize failed unit, mark partial |
| Review fail + fix exhausted | Gate 6 (round 3) | Ticketize residual, mark partial, report |
| Unrecoverable error | Any gate | Abort, preserve worktree, report with traceback |

## Integration with C31 Ecosystem

| Skill | Relationship |
|-------|-------------|
| `C31-plan` | **Upstream** — produces plans that C31-lfg consumes |
| `C31-work` | **Reference** — wave/parallel execution logic borrowed from; C31-lfg is the headless/autonomous wrapper |
| `C31-review` | **Gate 5** — invoked as sub-routine for review pass |
| `ce-compound` | **Post-execution** — if execution reveals new knowledge, trigger compound after report |

## Success Criteria

- All 9 gates executed in order
- No mid-flight user questions
- Residual items never silently dropped
- Report written to `memory/.planning/executions/`
- STATE.md updated with execution trace

## One-Liner

> Load plan → validate → worktree → execute waves → review → auto-fix → commit → handoff residual → report. No questions asked.
