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

# C31-compound-refresh — 知识库双周维护 + 进化评估

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

### Zone E: `memory/.planning/evolution/signals/` — 进化信号汇总与评估（新增）

**目标**: 将 C31 Dream 每日捕获的进化信号，汇总成双周进化评估报告。

**操作步骤**:
1. 读取最近 14 天的 `memory/.planning/evolution/signals/*.jsonl`
2. 按 skill 分组统计：
   - 每个 skill 收到了多少条 ≥P1 信号
   - 信号类型分布（user_correction / repetition / tool_failure）
   - 频率最高的前 3 个技能
3. **LLM-as-judge 评估**: 对信号最多的 skill，读取其当前 SKILL.md，评估改进空间
   - 输入: skill 内容 + 累计信号摘要
   - 输出: { "needs_evolution": true/false, "confidence": 0-1, "reasoning": "为什么该改/不该改" }
4. 如果 confidence ≥ 0.7 且 needs_evolution = true:
   - 生成 1 个改进候选（diff 格式，不是完整重写）
   - 写入 `memory/.planning/evolution/candidates/YYYY-MM-DD-{skill-name}/diff.md`
   - 写入评估报告 `report.md`
5. **约束门预检**（三门）:
   - Size Gate: 候选 diff 是否使文件增幅 < 20%
   - Test Gate: Markdown 格式合法、frontmatter 完整
   - Cache Gate: 不触及 AGENTS.md 核心 section
   - 任一失败 → 不生成候选，只记录原因

**输出**: 
- 若无 ≥0.7 confidence 的 skill → zone 静默，不写入文件
- 若有 → candidates/ 目录 + 报告

## Execution Flow

### Phase 1: Scan (Silent)

1. List all `memory/solutions/*.md` — check `compound_score` and `last_referenced`
2. List `memory/20*.md` files — check age
3. `grep` all `skills/*/SKILL.md` for repo-relative path references — verify existence
4. Read `.planning/STATE.md` — cross-check against `memory/.planning/todos/residual-*.md`
5. **Read `memory/.planning/evolution/signals/*.jsonl` — 最近 14 天信号汇总**

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
| skill-name | 5 | 0.85 | ✅ diff.md | 等待用户确认 |

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
| `critical` | Announce to user: "双周知识库扫描发现 N 项需要关注：`path/to/report`" |
| **evolution candidate** | **Outer Loop 推送**: "🌙 双周进化建议：skill `{name}` 检测到 5 次纠正信号，confidence 0.85。候选 diff 已生成，等待 confirm。" |

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
6. **Evolution candidates = waiting** — 不自动 merge，48h 不 confirm 自动丢弃
7. **Size Gate first** — 候选 diff 超过 20% 增幅直接 reject
