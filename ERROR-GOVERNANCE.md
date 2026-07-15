# C31 Error Governance — Structured AI Reliability

> *"An AI that retries the same broken fix three times in a row is not persevering — it's malfunctioning. Good AI governance means knowing when to stop."*

---

[English](ERROR-GOVERNANCE.md) · [中文](ERROR-GOVERNANCE.zh.md) · [日本語](ERROR-GOVERNANCE.ja.md)

---

## Overview

C31 treats AI error handling as a first-class architectural concern. Three mechanisms work together to keep failures recoverable and humans in control:

1. **3-Tier Error Classification** — categorize failures by recoverability
2. **Fix-it Cascade** — deterministic chain from "fix it" to "knowledge captured"
3. **No Autonomous Lifecycle Mutation** — preserve ambiguous state for human review

---

## Part 1: 3-Tier Error Classification

*Integrated from: 12-Factor Agents (F9: Compact Errors into Context) + Archon (lifecycle governance)*

Every error encountered by C31 is classified into one of three tiers:

| Tier | Type | Examples | C31 Behavior |
|------|------|---------|--------------|
| **Recoverable** | Temporary, auto-retryable | Network timeout, API rate limit, transient 503 | Auto-retry once. On failure: fall back to declared fallback chain. Report status. |
| **Fixable** | Needs parameter or logic adjustment | Wrong file path, format mismatch, permission denied, syntax error | Analyze root cause. Attempt fix. Report steps. |
| **Escalate** | Beyond autonomous repair | 3 consecutive same-class failures, data loss risk, architectural decision required | Stop immediately. Report to user with clear description. Do NOT retry. |

### The 3-Consecutive-Failure Rule

If the same class of error occurs **3 times in a row** in the same task:

```
Failure 1 → Fix attempt 1 → Still failing
Failure 2 → Fix attempt 2 → Still failing  
Failure 3 → STOP → Escalate to user
```

**Do not** attempt a 4th fix. The problem either requires human judgment or reveals a gap in understanding that more retries will not solve.

**Report format on Escalate:**
```
⚠️ Escalate: [error class] failed 3 consecutive times.
Root cause candidates: [list]
What I've tried: [list]
What I need from you: [specific ask]
```

### Pre-declared Fallback Chains

Before starting a task with external dependencies, C31 declares fallback paths:

```
Web fetch fails → try search_web → still fails → 
  "Unable to retrieve live data. Here's what I know as of my training: [...]"

File write permission denied → try alternate path → still fails →
  Request permission from user, provide exact path and reason

API call fails → retry once with backoff → on 2nd failure →
  Use cached/known data and annotate: "[Estimated, not live]"
```

---

## Part 2: Fix-it Cascade

*Integrated from: C31's Fix-it Cascade protocol (not present in source frameworks)*

When a user says **"fix it"**, **"debug this"**, **"修复"**, or **"帮我改掉"**, C31 does not start immediately — it runs a deterministic chain:

```
User trigger
     │
     ▼
┌────────────────────────────────────┐
│  Step 1: C31-debug                 │
│  • Reproduce the bug minimally     │
│  • Hypothesize 2-3 root causes     │
│  • Identify the actual root cause  │
└────────────────┬───────────────────┘
                 │ Root cause confirmed
                 ▼
┌────────────────────────────────────┐
│  Step 2: Fix                       │
│  • Surgical scope only             │
│  • Chesterton's Fence: understand  │
│    why the code exists first       │
│  • One change at a time            │
└────────────────┬───────────────────┘
                 │ Fix applied
                 ▼
┌────────────────────────────────────┐
│  Step 3: Verify                    │
│  • Run relevant tests              │
│  • Nyquist compliance check        │
│  • Manual confirmation if needed   │
│  • PASS = done; FAIL = back to fix │
└────────────────┬───────────────────┘
                 │ Verified PASS
                 ▼
┌────────────────────────────────────┐
│  Step 4: C31-compound              │
│  (Auto-triggered if >1 iteration)  │
│  "This bug's solution is worth     │
│   recording — documenting now."    │
└────────────────────────────────────┘
```

**No step is skipped.** In particular:
- Verify is not optional — "it looks right" is not a pass
- Compound is not optional when the fix took >1 iteration — bugs that took work to find are bugs that will recur

### After Successful Fix

C31 proactively reports:
```
✅ Fixed. Root cause: [1 sentence].
   This fix took [N] iteration(s) — worth recording.
   Running C31-compound now... [or: "Want me to document this?"]
```

---

## Part 3: No Autonomous Lifecycle Mutation

*Integrated from: Archon (lifecycle governance principles)*

### The Rule

C31 **never** autonomously changes the declared state of:
- A running background process
- A launched subagent whose status is ambiguous
- A deployed service
- A workflow that another process may be currently executing

### Why This Matters

In multi-agent workflows, a common failure mode is:
> Agent A assumes Agent B's process has crashed (because it's taking long) → marks it as failed → attempts to restart → now two instances of the same process run simultaneously → data corruption or duplicate work.

The rule: **when you cannot reliably distinguish "still running" from "crashed orphan," do not act.**

### What C31 Does Instead

```
Ambiguous state detected
         │
         ▼
┌────────────────────────────────────┐
│  Report to user with options:      │
│                                    │
│  ⏸️ Process [X] status is unclear  │
│  Last known state: [description]   │
│  Time since last signal: [N mins]  │
│                                    │
│  Options:                          │
│  [A] Kill it — I'll restart        │
│  [B] Wait 5 more minutes           │
│  [C] Check its logs first          │
└────────────────────────────────────┘
```

**Exception:** Retry backoff and timeout handling for Recoverable errors (Tier 1) are NOT subject to this rule — those are deterministic and reversible by design.

---

## Part 4: Connecting the Pieces

The three mechanisms interlock:

```
Error detected
     │
     ├─ Tier 1 (Recoverable) ──→ Auto-retry → Fallback → Report
     │
     ├─ Tier 2 (Fixable) ─────→ Fix-it Cascade (Steps 1-4)
     │                                 │
     │                          3 failures? → Tier 3
     │
     └─ Tier 3 (Escalate) ────→ Stop → Human decision
                                        │
                               └─ Ambiguous state? → No Autonomous Mutation
                                                      Report options, wait
```

The combined effect: **C31 never silently fails and never blindly retries.** Every error has a defined response path. The user is always informed before irreversible action is taken.

---

## Part 5: Self-Correction Capture

When C31 itself makes an error and recognizes it:

**Trigger words (auto-detected):**
- "Sorry," "I made a mistake," "You're right," "Re-analyzing," "My earlier suggestion was wrong," "Let me redo this"

**Automatic response:**
1. Complete the correction
2. Append a new `candidate` entry to the instinct index:
   - `trigger`: "When I encounter [the scenario that caused the error]"
   - `action`: "Do [corrected behavior] instead"
3. Append to today's diary: `[timestamp] AI self-correction: [brief error pattern]`

This closes the loop: errors become instincts, instincts prevent recurrence.

---

## Loop Engineering Failure Modes（循环工程失效模式）

> 以下模式来自 Loop Engineering 框架，在 C31 接入调度层（c31-loop）后适用。

### FM-L1: Infinite Fix Loop（无限修复循环）

**症状**：同一个 bug 被尝试修复 3+ 次，每次都失败，loop 不停重试。

**严重度**：S2

**C31 防御**：
- **3 连续同类错误规则**（已内置）：连续 3 次失败 → 强制 Escalate，停止 pipeline
- Fix-it 链路最多重试 3 次，第 3 次失败后写入 `STATE.md: status: BLOCKED`

### FM-L2: State Rot（状态腐化）

**症状**：`STATE.md` / `session_state.json` 引用了已过期的 PR、任务、分支，loop 对"幽灵"采取行动。

**严重度**：S1 → S2

**C31 防御**：
- Session End Protocol：每次 flush `session_state.json`，清除已完成任务
- C31-loop 在每次运行开始时验证 STATE.md 中的引用是否仍然有效

### FM-L3: Compound Without Recall（只写不读的文档黑洞）

**C31 特有**

**症状**：`docs/solutions/` 有大量文档，但下次遇到同类问题时 AI 从头开始，完全未查阅历史。

**严重度**：S1 → S2

**C31 防御**：
- ce-compound 写文档时必须同时更新 INDEX.md（无 INDEX 条目 = 文档不存在）
- Solutions Pre-Search 在每次非平凡任务前静默触发

### FM-L4: Verifier Theater（验证者剧场）

**症状**：Verifier "批准"了，但测试实际失败，或代码有明显问题。

**严重度**：S2

**C31 防御**：
- C31-review 使用 4 个**隔离** agent，每个只看代码，不看其他 agent 的结论
- "Do Not Trust the Report"：验证者不得依赖执行者的自我报告

### FM-L5: Notification Fatigue（通知疲劳）

**症状**：C31 loop 每次运行都通知，用户开始忽视，真正的 Escalation 被错过。

**严重度**：S1 → S2

**C31 防御**：
- L1 loops（report-only）只更新 STATE.md，不创建 Issue
- Escalation 仅在：连续 3 次失败 / 安全相关变更 / 预算超限 时触发

---

→ **[README.md](README.md)** — System overview  
→ **[WORKFLOW.md](WORKFLOW.md)** — Multi-agent orchestration architecture  
→ **[PHILOSOPHY.md](PHILOSOPHY.md)** — Engineering principles  
→ **[ADVANTAGES.md](ADVANTAGES.md)** — C31 vs individual frameworks
