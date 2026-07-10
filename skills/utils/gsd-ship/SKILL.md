---
name: gsd-ship
description: |
  Ship a completed phase or project. Finalize work, generate summary,
  and mark state as shipped. MUST trigger when user says "ship",
  "ship it", "done", "finish", "收尾", "交付", "完成了", "上线",
  "publish", "release".
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | gsd-ship |
| ZH | 收尾, 交付, 上线 |
| JA | リリース, 完成, デプロイ |

> **Output language**: Respond automatically in the user's conversation language.

# gsd-ship — Deliver & Close

Finalize a completed phase or entire project. Confirm acceptance,
generate deliverable summary, update project state, and archive.

## Preconditions

- All verification (C31-review or ce-code-review) has passed
- No unresolved blockers in STATE.md
- User confirms readiness to ship

## Workflow

### Phase 1: Load & Assess

1. Read `memory/.planning/STATE.md`
2. Read `memory/.planning/ROADMAP.md`
3. Identify:
   - Current phase number and name
   - Phase status (must be "verified" or later)
   - List of deliverables produced
   - Blocker status (must be empty or resolved)

### Phase 2: Acceptance Checklist

Walk through each deliverable with user:

```
Ship Checklist for Phase XX — <phase_name>

Deliverables:
  [ ] <deliverable_1> — <brief_description>
  [ ] <deliverable_2> — <brief_description>
  ...

Verification:
  [ ] All tests passing (or UAT signed off)
  [ ] Code reviewed (C31-review completed)
  [ ] Documentation updated
  [ ] No regressions identified

Blockers:
  (none or list resolved status)

Ship? [yes] [no] [hold]
```

If user selects [no] or [hold], stop. Update STATE.md with reason.

### Phase 3: Generate Summary

Create `memory/.planning/phases/XX-SUMMARY.md`:

```markdown
# Phase XX Summary — <phase_name>

## What Was Done
- <achievement_1>
- <achievement_2>

## Key Decisions
- D-01: <decision> (from CONTEXT.md)
- D-02: <decision>

## Deliverables
- <file/link_1>
- <file/link_2>

## Verification
- Reviewer: <reviewer_name>
- Result: PASS / PARTIAL / FAIL (with notes)

## Time
- Started: <date>
- Shipped: <date>
```

### Phase 4: Update STATE.md

```
Current Position → Next phase (or "COMPLETE" if last phase)
Phase XX status: shipped
```

### Phase 5: Update ROADMAP.md

Mark phase as ✅ shipped. If all phases shipped, mark milestone as ✅.

### Phase 6: Archive (optional)

If project complete:
1. Write `memory/.planning/MILESTONES.md` entry:
   ```
   ## Milestone X.Y — <name> — <date>
   - Duration: N days
   - Phases completed: N
   - Key outcomes: ...
   ```
2. Optionally tag/zip `.planning/` as archive

## Success Output

```
✅ Phase XX shipped

Summary: memory/.planning/phases/XX-SUMMARY.md
State: updated → Phase YY (or COMPLETE)
Roadmap: phase marked ✅
Next: <suggested_next_action>
```

## Quick Ship (lightweight)

If invoked with `--quick` or user says "quick ship":
- Skip detailed checklist (trust user)
- Still update STATE.md and ROADMAP.md
- Generate lightweight 3-line summary

## Auto-Invoke

<auto_invoke>
<trigger_phrases>
- "ship"
- "ship it"
- "done"
- "finish"
- "收尾"
- "交付"
- "完成了"
- "上线"
- "publish"
- "release"
</trigger_phrases>
</auto_invoke>
