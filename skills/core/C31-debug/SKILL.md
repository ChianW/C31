---
name: C31-debug
description: debug, bug, fix, 排查 | 调试阶段：系统化错误追踪，从复现到根因到修复验证
triggers: debug, bug, fix, 排查, 为什么会报错, 报错, trace this error, find the root cause, debugger
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | debug, bug, fix, 排查, 为什么会报错, 报错, trace this error, find the root cause, debugger |
| ZH | 调试, 修复bug, 排查 |
| JA | デバッグ, バグ修正, 調査 |

> **Output language**: Respond automatically in the user's conversation language.

# C31-debug — Systematic Debug with Session Management

Investigate bugs through reproduction → trace → hypothesis → test-first fix → verify → archive. All active sessions are tracked in `memory/.planning/debug/` for resumption and knowledge compounding.

## Session Lifecycle

### Check Existing Sessions (always first)

List `memory/.planning/debug/*.md`. If any non-resolved session exists, present it and ask:
1. **Resume** — load the session and continue from the last phase
2. **New session** — archive the old one (move to `resolved/`) and start fresh
3. **Ignore** — proceed without archiving

If no active sessions exist, create a new one at `memory/.planning/debug/YYMMDD-{brief-desc}.md` with frontmatter:
```yaml
---
session_id: YYMMDD-{brief-desc}
status: active   # active | investigating | fixing | verifying | resolved | stalled
phase: 0         # 0=triage, 1=investigate, 2=root-cause, 3=fix, 4=verify, 5=archive
created: YYYY-MM-DD HH:MM
target: [file/module/test or issue link]
---
```

### Session Resume

If resuming, read the session file, update `status: active`, and continue from the recorded `phase`. Preserve all prior hypotheses, ruled-out causes, and evidence in the session file.

## Execution Flow

| Phase | Name | Output |
|-------|------|--------|
| 0 | Triage | Problem statement + session file created/resumed |
| 1 | Investigate | Reproduction confirmed, environment sanity checked, code path traced |
| 2 | Root Cause | Causal chain confirmed with predictions; session updated |
| 3 | Fix | Test-first patch applied |
| 4 | Verify | Tests pass, no regressions; session marked resolved |
| 5 | Archive | Session moved to `resolved/`, knowledge-base updated |

### Phase 0: Triage

Parse input. If an issue tracker is referenced, fetch it. Extract symptoms, expected behavior, reproduction steps, environment.

**Trivial fast-path:** If the cause is immediately obvious (single-file typo, missing import, clear null deref) and verification is shallow, present cause + one-line fix, ask whether to apply or diagnose, and skip to Phase 5 if applied. When in doubt, run full framework.

**Solutions 强制搜索**（新增）：
在分析任何 bug 之前，先搜索 `memory/solutions/` 是否有相关记录：
1. 用 `memory_search` 查询 `{error_type} {component} {symptom}`（如 "cron timeout fix"）
2. 若命中 ≥1 个相关 solution（score > 0.5）：
   - **注入上下文**：将 solution 的 Problem + Solution + Prevention 追加到 session 文件
   - **提示用户**：`📋 发现历史记录：{filename}（compound_score: X）— 已自动注入上下文`
   - 基于历史方案调整 Phase 1 的调查方向（如已知根因是 API timeout，则直接验证而非从头排查）
3. 若未命中或 score < 0.5：正常进入 Phase 1

**Prior-attempt awareness:** If the user indicates prior failed attempts, ask what was tried first to avoid repetition.

Update session: `phase: 1`, `status: investigating`.

### Phase 1: Investigate

#### 1.1 Reproduce
Run the test, trigger the error, or follow reproduction steps. If the project has testing conventions, apply them; otherwise write a minimal isolated test that fails now and will pass post-fix.

- Cannot reproduce after 2–3 attempts → document conditions tried; note possible timing/state dependency.
- Cannot reproduce at all → document missing conditions and stop.

#### 1.2 Environment Sanity
- Correct branch; no unintended uncommitted changes.
- Dependencies installed and up to date.
- Expected interpreter/runtime version.
- Required env vars present.
- No stale build artifacts.
- Dependent services running when relevant.

#### 1.3 Trace the Code Path
Trace data flow backward from symptom to where valid state first became invalid.

1. Read stack trace bottom-to-top; open each frame.
2. Identify the first frame where input is already invalid — upper bound.
3. Instrument boundaries: targeted logs, assertions, or prints. Assumed values lie; observed values don't.
4. Walk boundaries until valid input becomes invalid output. That transition is the root cause site.

While tracing: check `git log --oneline -10 -- [file]`, consider `git bisect` for regressions, and check logs/metrics for additional evidence.

Update session: record reproduction steps, environment state, traced code path, and boundary observations.

### Phase 2: Root Cause

**Do not propose a fix until the full causal chain is explained with no gaps.**

**Assumption audit:** List concrete "this must be true" beliefs. Mark each *verified* (read code, checked state, ran it) or *assumed*. Assumptions are the most common source of stuck debugging.

**Form hypotheses** ranked by likelihood. For each state:
- What is wrong and where (file:line)
- At least one concrete supporting observation
- Full causal chain: trigger → symptom, step by step
- For uncertain links: a prediction — something in a different code path or scenario that must also be true

When the chain is obvious (missing import, explicit type error), the chain itself is the gate — no prediction needed.

**Pattern detection (before Phase 3):**
- Check `memory/.planning/evolution/signals/*.jsonl` for same-type signals in last 7 days
- If frequency ≥ 3 for same skill/type → severity auto-upgrades to P0
- Write/update signal file before proposing fix

**AEF Trajectory Check (before Phase 3):**
- Score the bug: Severity × Frequency × Uniqueness
- If score ≥ 5 → add to `memory/.planning/evolution/signals/`
- Include: skill_involved, causal_chain_summary, fix_pattern

**Causal chain gate:** Do not proceed to Phase 3 until the full chain is confirmed. The user may explicitly authorize proceeding with the best-available hypothesis if stuck.

**Smart escalation** (2–3 hypotheses exhausted):

| Pattern | Diagnosis | Next move |
|---------|-----------|-----------|
| Different subsystems | Architecture/design problem | Rethink design |
| Contradictory evidence | Wrong mental model | Re-read code path without assumptions |
| Local OK, CI/prod fails | Environment problem | Focus on env differences |
| Fix works, prediction wrong | Symptom patch, not root cause | Keep investigating |

Present: root cause (causal chain + file:line), proposed fix, tests to add/modify, whether existing tests should have caught this and why they didn't.

Ask user:
1. **Fix it now** → Phase 3
2. **Diagnosis only** → skip Phase 3, go to Phase 5
3. **Rethink the design** → end skill

Update session: `phase: 2`, record hypotheses (with ruled-out ones), confirmed root cause, and user decision.

### Phase 3: Fix

If user chose "Diagnosis only" or "Rethink the design", skip to Phase 5.

**Workspace check:**
- `git status` — confirm no unintended uncommitted changes in files to edit.
- If on default branch (`main`/`master`), ask whether to create a feature branch. Default to creating one named from the bug.

**Test-first:**
1. Write failing test capturing the bug (or use existing failing test).
2. Verify it fails for the right reason — the root cause, not unrelated setup.
3. Implement minimal fix: address root cause only. No drive-by refactors or formatting.
4. Verify test passes.
5. Run broader test suite for regressions.
6. Self-review diff: check style, edge cases, adjacent regressions, coverage gaps.

**Failed fix:** Return to Phase 2. Invalidate current hypothesis with evidence, then form a new one. **3 failed attempts = architectural escalation.** After 3 failed fix attempts, STOP. Do not attempt a 4th. The root cause was likely wrong — this is an architectural or design problem, not a hypothesis failure. Escalate to the human: present the 3 attempts, the evidence that invalidated each, and ask whether to rethink the design.

**Conditional defense-in-depth** (root-cause pattern found in 3+ other files, OR bug would have been catastrophic in production):
- Add entry validation at public API boundary.
- Add invariant checks inside affected module.
- Add diagnostic breadcrumbs for future debugging.
Apply only layers that make sense.

Update session: `phase: 3`, `status: fixing`, record changed files and test additions.

### Phase 4: Verify

- Confirm the original reproduction test passes.
- Confirm no regressions in broader suite.
- If verification fails, return to Phase 2.

Update session: `phase: 4`, `status: verifying`, record verification results.

### Phase 5: Archive & Knowledge Capture

**Structured summary** (write to session file before moving):

```
## Debug Summary
**Problem**: [What was broken]
**Root Cause**: [Full causal chain with file:line]
**Recommended Tests**: [Tests to add/modify to prevent recurrence]
**Fix**: [What changed — or "diagnosis only"]
**Prevention**: [Test coverage; defense-in-depth if applicable]
**Confidence**: [High/Medium/Low]
```

If user chose "Diagnosis only", stop after summary. Mark session `status: stalled` and leave in `debug/` for future resumption.

If Phase 3 ran, ask:
1. **Commit and open a PR**
2. **Commit the fix locally**
3. **Stop here** — user takes over

**Archive session:** Move `memory/.planning/debug/YYMMDD-{desc}.md` to `memory/.planning/debug/resolved/`. Rename to include resolution date: `YYMMDD-{desc}-RESOLVED-YYMMDD.md`.

**Knowledge-base update:** Append to `memory/.planning/debug/knowledge-base.md` only when:
- The pattern appears in 3+ locations, OR
- The root cause reveals a wrong assumption about a shared dependency/framework/convention that other code is likely to repeat.

KB entry format:
```markdown
## YYYY-MM-DD — {brief pattern name}
**Symptom**: ...
**Root Cause**: ...
**Fix Pattern**: ...
**Files Affected**: ...
```

Create `knowledge-base.md` if it does not exist.

## 错误处理

本 skill 遵循 [AGENTS/error-handling.md](../AGENTS/error-handling.md) 标准。

### 常见错误码

| 错误码 | 触发场景 | 处理策略 |
|--------|---------|---------|
| `API_TIMEOUT` | `exec` 测试运行超时 | 等待 4s 重试，最多 2 次 |
| `RATE_LIMITED` | API 限流 | 等待 10s 重试 |
| `VALIDATION_FAILED` | 测试参数 / 环境校验失败 | 修正参数后重试 |
| `RESOURCE_NOT_FOUND` | 测试文件 / 源码不存在 | 检查路径，无法恢复则 escalate |
| `CONTEXT_OVERFLOW` | 长调用链 / 大堆栈 | 压缩后重试，或分片处理 |
| `SUBAGENT_FAILED` | 并行调查子代理失败 | 检查子代理日志，最多重试 1 次 |

### Escalation 条件

- 同一 error_code 连续 2 次 → 第 3 次强制 escalate
- retry_count 达到 max_retries → escalate
- 非 recoverable 错误（PERMISSION_DENIED, SECURITY_BLOCKED 等）→ 立即 escalate

### 回退链

| Primary | Fallback | 条件 |
|---------|---------|------|
| `exec` (运行测试) | `read` 手动检查测试文件 | `API_TIMEOUT` / `RESOURCE_NOT_FOUND` |
| `browser` (浏览器 bug) | `web_fetch` | `API_TIMEOUT` |
| `kimi_fetch` | `web_fetch` | `API_TIMEOUT` / `NETWORK_ERROR` |

## Parallel Investigation (Optional)

When hypotheses are evidence-bottlenecked across clearly independent subsystems, dispatch read-only sub-agents in parallel, each with a single explicit hypothesis and structured evidence-return format. No code edits by sub-agents. If parallel dispatch is unavailable, run sequentially in ranked-likelihood order.

## Rules

- One change at a time. If you're changing multiple things to "see if it helps," stop — that's shotgun debugging.
- Stop and re-examine if your internal monologue contains: "quick fix for now," "this should work" (untested), or "let me just try..." (no hypothesis).
- When stuck, diagnose why — don't just try harder.
- Default to no questions — investigate first (read code, run tests, trace errors). Ask one specific question only when a genuine ambiguity blocks investigation and cannot be resolved by reading code or running tests.
