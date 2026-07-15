---
name: C31-compound-refresh
description: compound refresh, 清理知识库 | 双周维护：扫描memory/和skills/，去重、标记残留、输出健康报告
triggers: compound refresh, 清理知识库, 双周维护
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | compound refresh, 清理知识库, 双周维护 |
| ZH | 更新知识库, 刷新文档 |
| JA | ドキュメント更新, 知識更新 |

> **Output language**: Respond automatically in the user's conversation language.

# C31-compound-refresh — Bi-weekly Knowledge Base Maintenance + Evolution Assessment

Headless health check for the C31 knowledge base. Runs automatically or on-demand to keep `memory/` and `skills/` fresh, and evaluates whether any skill needs evolution.

## Trigger

- **Headless**: Cron — every 2 weeks, day 9 and 23, 02:00 Asia/Tokyo
- **Manual**: User says "compound refresh" / "清理知识库" / "双周维护"

## What It Does

Scans five zones and emits a single report. No user interaction unless threshold breached.

### Zone A: `memory/solutions/`

**Stale signals:**
1. **Confidence decay** — compound_score ≥ 5 but last referenced > 90 days ago
2. **Obsolescence** — solution references code paths, APIs, or files that no longer exist

**Action:** Mark `status: review` in frontmatter. If confirmed obsolete, redirect to newer solution or archive.

### Zone B: `memory/YYYY-MM-DD.md`

**Stale signal:** File age > 90 days.

**Action:**
- Extract long-term value (decisions, solutions, patterns)
- Migrate worthy fragments to `memory/solutions/` or `memory/moc/`
- Mark file `status: archived` in a one-line header
- Never delete — only redirect

### Zone C: `skills/*/SKILL.md`

**Stale signal:** References files or paths that no longer exist (broken links).

**Action:**
- List broken references with skill name and missing path
- Do not auto-fix — user decides whether skill is obsolete or path changed

### Zone D: `.planning/STATE.md`

**Stale signals:**
1. **Phantom DONE** — task marked DONE but residual file exists in `memory/.planning/todos/residual-*.md`
2. **Ghost task** — task exists but no parent plan file found

**Action:**
- Phantom DONE → downgrade status to `PENDING`, link to residual file
- Ghost task → flag for user review

## DONE Criteria (Hard Rule)

A task is **genuinely DONE** only if ALL true:
- Status explicitly marked DONE
- Has commit hash, file path, or merge proof
- **No open residual** in `memory/.planning/todos/residual-*.md`

If residual exists → status becomes `PENDING` regardless of mark.

## Residual Handling

1. **Discovery** → Write to `memory/.planning/todos/residual-YYYYMMDD.md` with source link
2. **Aging** → If residual untouched for > 30 days:
   - Upgrade to user-visible alert
   - Include in report under `⚠️ CRITICAL: Unresolved residuals`
3. **Resolution** → When residual addressed, append `(resolved: YYYY-MM-DD)` to file

## Duplicate Knowledge Merge

**Detection:** Two solutions describe the same problem/symptom pair.

**Resolution:**
- Keep the one with higher `compound_score`
- Mark the other `status: deprecated` with redirect link
- Preserve both titles for searchability

### Zone E: `memory/.planning/evolution/signals/` — Evolution Signal Aggregation and Assessment

**Goal**: Aggregate the evolution signals captured daily by C31 Dream into a bi-weekly evolution assessment report.

**Steps:**
1. Read `memory/.planning/evolution/signals/*.jsonl` from the last 14 days
2. Group and count by skill:
   - How many ≥P1 signals each skill received
   - Signal type distribution (user_correction / repetition / tool_failure)
   - Top 3 skills by signal frequency
3. **LLM-as-judge evaluation**: For the skills with the most signals, read the current SKILL.md and assess improvement potential
   - Input: skill content + accumulated signal summary
   - Output: `{ "needs_evolution": true/false, "confidence": 0-1, "reasoning": "why it should/shouldn't change" }`
4. If confidence ≥ 0.7 and needs_evolution = true:
   - Generate 1 improvement candidate (diff format, not a full rewrite)
   - Write to `memory/.planning/evolution/candidates/YYYY-MM-DD-{skill-name}/diff.md`
   - Write assessment report to `report.md`
5. **Constraint gate pre-check** (three gates):
   - Size Gate: does the candidate diff increase file size by < 20%?
   - Test Gate: is Markdown format valid and frontmatter complete?
   - Cache Gate: does it avoid touching core sections of AGENTS.md?
   - Any gate failure → do not generate candidate; record reason only

**Output:**
- If no skill reaches confidence ≥ 0.7 → zone is silent; no files written
- If one does → candidates/ directory + report

## Execution Flow

### Phase 1: Scan (Silent)

1. List all `memory/solutions/*.md` — check `compound_score` and `last_referenced`
2. List `memory/20*.md` files — check age
3. `grep` all `skills/*/SKILL.md` for repo-relative path references — verify existence
4. Read `.planning/STATE.md` — cross-check against `memory/.planning/todos/residual-*.md`
5. **Read `memory/.planning/evolution/signals/*.jsonl` — aggregate signals from last 14 days**

### Phase 2: Classify

Build three buckets:

| Bucket | Action Required |
|--------|----------------|
| `clean` | Nothing |
| `review` | Flagged for attention, not urgent |
| `critical` | ≥3 issues OR any phantom DONE with >30d residual |

### Phase 3: Write Report

**Path:** `memory/.planning/reports/compound-refresh-YYYY-MM-DD.md`

**Template:**
```markdown
---
report: compound-refresh
date: YYYY-MM-DD
status: clean | review | critical
issues_found: N
evolution_candidates: N
candidates_path: memory/.planning/evolution/candidates/YYYY-MM-DD-{skill}/
---

## Summary
One-line health score + evolution status.

## Zone A: Solutions (N flagged)
| File | Score | Signal | Action |

## Zone B: Daily Notes (N aged)
| File | Age | Long-term value | Action |

## Zone C: Skills (N broken links)
| Skill | Broken ref | Suggested fix |

## Zone D: Planning (N phantom DONE)
| Task | Status | Residual file | Action |

## Zone E: Evolution Signals (N signals, N candidates)
| Skill | Signal count | Confidence | Candidate | Action |
|-------|-------------|------------|-----------|--------|
| skill-name | 5 | 0.85 | ✅ diff.md | Awaiting user confirmation |

## Residuals (N open, N aged >30d)
| File | Age | Urgency |

## Duplicate Detection (N pairs)
| Kept | Merged into | Deprecated |
```

### Phase 4: Notify (Conditional)

| Status | Action |
|--------|--------|
| `clean` | Silent. Log only. |
| `review` | Silent. User discovers report on demand. |
| `critical` | Announce to user: "Bi-weekly knowledge base scan found N items requiring attention: `path/to/report`" |
| **evolution candidate** | **Outer Loop push**: "🌙 Bi-weekly evolution suggestion: skill `{name}` detected 5 correction signals, confidence 0.85. Candidate diff generated — awaiting confirm." |

**Critical threshold:** ≥3 total issues, OR any phantom DONE with residual aged >30 days.  
**Evolution threshold:** ≥1 candidate with confidence ≥ 0.7.

## Headless Cron Config

```json
{
  "schedule": "0 2 9,23 * *",
  "timezone": "Asia/Tokyo",
  "delivery": {
    "mode": "announce",
    "to": "user",
    "condition": "status == 'critical' OR evolution_candidates > 0"
  }
}
```

## Rules

1. **Never delete** — only mark, redirect, or archive
2. **Never auto-fix skills** — broken links are user decisions
3. **Residuals are debt** — 30-day aging makes them visible
4. **Report is the artifact** — everything else is side effect
5. **Under threshold = silent** — do not nag user for minor drift
6. **Evolution candidates = waiting** — do not auto-merge; auto-discard if not confirmed within 48h
7. **Size Gate first** — candidate diff exceeding 20% size increase is rejected immediately
