---
name: C31-work
description: execute, implement, 实现, 开发 | 执行阶段：读取计划，按依赖波次并行调度子代理执行
triggers: execute, work on, implement, 实现, 开发, execute-phase, run
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | execute, work on, implement, 实现, 开发, execute-phase, run |
| ZH | 开干, 执行, 实现 |
| JA | 実装する, やろう, 開始する |

> **Output language**: Respond automatically in the user's conversation language.

# C31-work — Wave-Parallel Execution Engine

## Input

`$ARGUMENTS` — A plan document path, a STATE.md path, or a bare work description.
Blank uses the latest plan doc or current directory STATE.md.

## Workflow

### Phase 0: Load & Triage

1. **Locate plan**: read the plan file or parse STATE.md for `tasks` and `waves`.
2. **Environment check**: confirm git repo, branch name, clean working tree (stash if needed).
3. **Historical solutions search**（新增）：
   - 用 `memory_search` 查询 `plan {task_type} {project_name}`（如 "skill optimization compound"）
   - 若命中 ≥1 个相关 solution（score > 0.5）：
     - 将相关方案的 Guidance + When to Apply + Examples 注入当前 work 上下文
     - emit brief note: `📋 发现历史工作记录：{filename} — 已自动注入参考`
   - 基于历史方案调整 wave 分组策略（如已知某类任务需要特殊工具配置，提前加入 Phase 0 检查）
4. **Complexity routing**:

| Complexity | Action |
|-----------|--------|
| Trivial (1 file, no behavior change) | Execute inline, skip wave grouping. |
| Small (2–5 tasks) | Group into 1–2 waves, single worktree. |
| Medium+ (6+ tasks or cross-cutting) | Full wave analysis + parallel dispatch. |

### Phase 1: Wave Analysis

Build a dependency DAG from the plan/STATE.md:

- **Nodes**: tasks (preserve U-IDs in subjects, e.g. `U3: Add parser coverage`).
- **Edges**: `depends_on` from the plan, or inferred from file overlap (two tasks touching the same file are ordered by plan sequence).
- **Group into waves**: all tasks with zero unresolved dependencies → Wave 1, then recurse.

Wave grouping rules:
- **Wave 1**: all independent tasks (no edges between them). Executed in parallel.
- **Wave 2+**: tasks whose dependencies are satisfied by prior waves. Executed sequentially per wave, waves ordered by dependency depth.
- **File-collision guard**: if two tasks in the same wave touch overlapping file paths, split the later one to the next wave.

### Phase 2: Dispatch Parallel Executors

For each wave, spawn one lightweight subagent per task using `sessions_spawn`:

```
for task in wave:
  sessions_spawn(
    name=f"exec-{task.uid}",
    prompt=TRUNCATED_PROMPT(task)   # see Context Reduction below
  )
```

**Fresh context per executor** — each subagent receives:
- The single task description + U-ID.
- Relevant file excerpts (truncated to 8K tokens).
- Project conventions (AGENTS.md, coding standards) — 2K tokens max.
- No full plan body (reduces context pressure).

**Parallel commit safety**:
- During wave execution, subagents commit with `--no-verify` to skip hooks.
- After the wave completes, run hooks once: `git commit --amend --no-edit` or CI check.
- This prevents hook races (lint/test collisions) when multiple subagents commit simultaneously.

### Phase 3: Atomic Commits & STATE.md Locking

**Atomic commits** — one commit per task:
```bash
git add <task-specific-files>
git commit -m "feat(scope): U3 Add parser coverage"
```

**STATE.md file locking** (prevents read-modify-write races):
1. Before updating STATE.md, acquire a lock: write `.state.lock` with subagent name + timestamp.
2. Read STATE.md, update task status (`pending` → `in-progress` → `done`), write back.
3. Delete `.state.lock`.
4. If lock exists >5 min, steal it (stale recovery).

### Phase 4: Post-Wave Merge & Quality Gate

After each wave:
1. Pull all subagent branches (if worktree-isolated) or review diffs (if shared).
2. Cross-check for file collisions: actual modified files, not just declared.
3. On collision → abort merge, re-dispatch colliding tasks serially in next wave.
4. Run the relevant test suite for the wave.
5. Run lint/type-check once per wave (not per subagent).
6. Update STATE.md with wave completion status.

### Phase 5: Finish

When all waves complete:
1. Run full test suite.
2. Final review of all changes.
3. Final commit / PR with full attribution.
4. Mark plan `status: active → completed` in STATE.md.

## Context Reduction Rules

For 200K context windows:
- **Truncated prompts**: each subagent prompt ≤ 16K tokens; file excerpts ≤ 8K.
- **Cache-friendly ordering**: static context (conventions, standards) first, variable context (task, files) last — improves KV-cache reuse across subagents.
- **No full plan body** in subagent prompts; only the task + direct file references.

For 1M context models:
- **Adaptive enrichment**: if model supports 1M tokens, include adjacent-task summaries (what upstream tasks changed) to reduce re-discovery.
- Include full test suite output for integration tasks.

## Key Principles

- **Wave parallelism** — independent tasks run together; dependent tasks wait.
- **One commit per task** — atomic, bisectable, revertible.
- **Lock STATE.md** — never lose progress updates to race conditions.
- **Fresh context per executor** — subagents are cheap; context windows are expensive.
- **Ship complete features** — all waves done, all tests green.

## Common Pitfalls

- Skipping wave analysis and running everything serially → slow.
- Putting file-colliding tasks in the same wave → merge pain; guard prevents this.
- Forgetting `--no-verify` during parallel commits → hook failures and broken trees.
- Hand-resolving merge conflicts silently → discards unit intent; re-dispatch instead.
- Not locking STATE.md → lost updates, duplicated work.
- Sending full plan to every subagent → context bloat; truncate and target.


