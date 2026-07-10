---
name: gsd-quick
description: quick, quickly, fast, 速战速决, 小事, 改一下, 查一下, 看一下, 简单, trivial, just do it | Handle a quick task without full GSD phase workflow. Just do it, record, and move on.
triggers: quick, quickly, fast, 速战速决, 小事, 改一下, 查一下, 看一下, 简单, trivial, just do it
metadata: {"category": "gsd"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | quick, quickly, fast, 速战速决, 小事, 改一下, 查一下, 看一下, 简单, trivial, just do it |
| ZH | 快速, 简单改一下 |
| JA | 素早く, 簡単な変更 |

> **Output language**: Respond automatically in the user's conversation language.

# gsd-quick — Just Do It

Execute a small task without the overhead of full GSD workflow.
No `.planning/phases/` files. Minimal ceremony. Maximum speed.

## When to Use

**Use gsd-quick when:**
- Task takes < 15 minutes
- No design decisions needed
- No risk of breaking existing work
- User explicitly says "quick" or "小事"

**Do NOT use when:**
- Task touches core architecture
- Task requires user research or validation
- Task is part of a milestone deliverable
→ Use full C31 workflow instead

## Workflow

### Phase 1: Load & Triage (10 seconds)

1. Read `memory/.planning/STATE.md` (if exists) — note current position only
2. Ask user (or infer from context):
   - What exactly to do?
   - Any constraints? (read-only? specific file?)
   - Expected output?

### Phase 2: Execute (Immediate)

1. Do the task directly — no subagents unless necessary
2. Use surgical changes (Karpathy Principle 3)
3. If error occurs → switch to `C31-debug` automatically

### Phase 3: Record (Lightweight)

Write to `memory/.planning/quick/YYMMDD-slug.md`:

```markdown
# Quick Task — <date>

## Request
<what_user_asked>

## Done
<what_was_done>

## Files Changed
- <file_1>
- <file_2>

## Time Spent
<minutes>

## Notes
<anything_to_remember>
```

**No STATE.md update. No ROADMAP.md update.** Keep project state clean.

## Success Output

```
✅ Quick task done — <minutes> min

Changed:
  - <file_1>
  - <file_2>

Recorded: memory/.planning/quick/YYMMDD-slug.md
```

## Example Tasks

```
"Quick: fix the typo in README"
"Fast: check why cron job failed yesterday"
"小事: add timezone note to AGENTS.md"
"查一下: what does this error mean"
```

## Auto-Invoke

<auto_invoke>
<trigger_phrases>
- "quick"
- "quickly"
- "fast"
- "速战速决"
- "小事"
- "改一下"
- "查一下"
- "看一下"
- "简单"
- "trivial"
- "just do it"
- "顺手"
</trigger_phrases>
</auto_invoke>
