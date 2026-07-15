---
name: C31-context-engineering
description: context, 上下文, 变蠢 | 上下文工程：在正确的时间给AI正确的信息，解决200K窗口组织不善问题
triggers: context, 上下文, 信息组织, 变蠢, context engineering, 信息太多, 你好像忘了, 上下文不够了
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | context, 上下文, 信息组织, 变蠢, context engineering, 信息太多, 你好像忘了, 上下文不够了 |
| ZH | 上下文工程, 管理上下文 |
| JA | コンテキストエンジニアリング, コンテキスト管理 |

> **Output language**: Respond automatically in the user's conversation language.

# C31 Context Engineering

The core pain point of the C31 system: **a 200K context window, but with poor information organization = effective capacity of only ~30K.**

This is not a capacity problem — it is an **information structure problem**.

## Core Principles

1. **Layered loading** — Not all information is worth loading
2. **On-demand retrieval** — GBrain searches only when needed, not on every call
3. **Active discarding** — Expired, completed, or irrelevant information is cleaned up promptly
4. **Anti-rationalization** — Do not retain information "just in case"

---

## Information Layering Architecture (Four-Layer Model)

| Layer | Content | When to Load | Discard Condition |
|-------|---------|-------------|-------------------|
| **L1 Immediate** | Current conversation, task instructions for this turn, active tool calls | Always loaded | Discard when conversation ends |
| **L2 Working** | Current project files (STATE.md, PLAN.md, CONTEXT.md), active todos | Load at session start | On project switch or completion |
| **L3 Rules** | AGENTS.md, SKILL.md, SOUL.md, USER.md | Load on-demand at session start | Replace when rules are updated |
| **L4 Memory** | Historical knowledge, solutions, past projects, long-term memory | **Search only when needed** | Never proactively loaded |

**Hard rule: L4 is never automatically injected into context.** It must be explicitly retrieved via GBrain search or `memory_search`.

---

## Rules Files Management

### On-Demand Loading Strategy

AGENTS.md uses modular splits (core.md, decision-boundary.md, communication.md, workflow.md).

**Loading rules:**
- Every session → load `core.md` (always)
- Involves decisions/permissions → load `decision-boundary.md`
- Involves message format/platform → load `communication.md`
- Involves scheduling/cron/heartbeat → load `workflow.md`
- **Sub-files not relevant to the current task are not loaded**

### SKILL Trigger Management

- Read the corresponding SKILL.md only when user input matches a trigger phrase
- Do not "preload all skills"
- Subagents only receive the SKILL.md content they actually need

---

## Context Packing

### Packing Principles

1. **Summary over full text** — 10 pages of conversation → 3-line summary + key conclusions
2. **Structured over narrative** — Use tables, lists, YAML frontmatter instead of long paragraphs
3. **Reference over copy** — "See PLAN.md Phase 3" is better than copying Phase 3 in full
4. **State over history** — "Current state: X" is better than "how we got from Y to X"

### Packing Operations

**At session start:**
```
1. Read session_state.json (if present)
2. Read active project files (PROJECT.md + STATE.md + current PLAN.md)
3. Assess context usage → if >35%, skip non-critical files
4. If >50%, ask user whether to /clear
```

**On task switch:**
```
1. Save current task state to STATE.md
2. Unload old task's L2 files
3. Load new task's L2 files
4. Retain L1 immediate layer (conversation continuity)
```

---

## Information Discard Strategy (Active Forgetting)

### Discard Decision Tree

```
Does this information affect the current decision?
├── Yes → Retain (L1/L2)
└── No → Is this information long-term knowledge?
    ├── Yes → Write to memory/solutions/ or GBrain; discard from context
    └── No → Discard immediately
```

### Specific Discard Rules

| Scenario | Action |
|----------|--------|
| Task completed with no further dependencies | Unload from L2; record to MILESTONES.md |
| Conversation resolved with no new knowledge | Do not retain conversation history; only keep conclusion |
| Debugging a fixed bug | Worth recording → compound; not worth it → discard |
| Temporary files / intermediate artifacts | Delete immediately or mark as cleanable |
| Expired schedules / reminders | Archive or delete; do not retain in active context |
| Merged PRs / closed issues | Reference by number only; do not retain details |

### Anti-Rationalization Table

When you're about to say "keep it just in case," consult this table:

| Excuse | Rebuttal | Correct Action |
|--------|----------|----------------|
| "Might need it later" | It can be retrieved from GBrain/memory_search when needed | Discard; retrieve when needed |
| "This information is special" | Special information should be compounded into long-term storage | Write to solutions; discard |
| "It took a lot of effort to produce" | Sunk cost is not a reason to retain | Extract conclusion; discard process |
| "User emphasized this before" | What the user emphasized is already in USER.md | Reference USER.md; don't keep the original conversation |
| "Keeping it doesn't take much space" | Mental occupation is more fatal than token occupation | Clean it up; maintain clarity |
| "I'll organize after this project is done" | It will never be "done" | Summarize or discard now |

---

## GBrain Integration Rules

### Retrieval Trigger Conditions

**Must search GBrain/memory when:**
1. User mentions "said before", "did before", "wasn't this already done"
2. Before solving a new problem, check if a solution already exists
3. Involves past project decisions or technology choices
4. User asks "why did I choose this"
5. Before debugging a bug, search for similar existing records

**Do NOT search when:**
1. User is asking about general knowledge (unless related to a historical project)
2. Current task is completely independent with no historical connection
3. Context already contains the required information

### Post-Retrieval Processing

```
1. memory_search returns results
2. Assess relevance: directly relevant / indirectly relevant / unrelated
3. Directly relevant → extract key info, inject summary into context
4. Indirectly relevant → record reference; do not inject full text
5. Unrelated → ignore; do not retain because it "might be useful"
```

---

## Context Budget Management Integration

Connects with the threshold system in AGENTS.md:

| Context Usage | Strategy |
|---------------|----------|
| **> 35%** | Warning: avoid starting complex new work; prioritize completing current task |
| **> 50%** | Suggest /clear or new session; if continuing → write `continue-here.md` |
| **> 70%** | Force cleanup: discard all non-critical L2 files; retain L1 + current PLAN.md only |
| **> 85%** | Emergency mode: stop work, save state, request new session |

---

## Execution Flow

### At Session Start

1. Load session_state.json (restore active projects)
2. Read L3 Rules layer (core.md + on-demand sub-files)
3. Read L2 Working layer (current project STATE.md + PLAN.md)
4. Calculate context usage
5. If >35%: report status, suggest completing current task before starting a new one
6. **Do not load any L4 memory** (unless session_state.json explicitly requires it)

### During Task Execution

1. When historical information is needed → trigger memory_search or gbrain think
2. After task completion → update STATE.md, clean up expired intermediate files in L2
3. When a solution worth recording is found → trigger compound flow

### Before Session End (user says "that's it for today" / long idle period)

1. Save session_state.json (active projects, todos, pending decisions)
2. Summarize key decisions from this turn to STATE.md
3. Clean up all temporary / intermediate artifacts
4. Confirm that L4-worthy information has been compounded

---

## Anti-Rationalization Commitment

> "I commit not to hoard information out of anxiety. I trust the retrieval system. I trust that when information is needed, it will come back."

**Discarding takes more courage than retaining.** A clean context beats 100K of redundant information.

---

## Trigger Phrases

- "context", "上下文", "信息组织", "变蠢"
- "context engineering", "信息太多"
- "AI怎么变笨了", "你好像忘了"
- "之前不是说过", "上下文不够了"
- "清理上下文", "精简上下文"
- "为什么你不记得", "搜索一下记忆"

---

## Output Format

When asked to check context health:

```
📊 Context Health Report
Usage: X% (X / 200K tokens)
L1 Immediate: [summary]
L2 Working: [active projects/files]
L3 Rules: [loaded rules]
L4 Memory: [not loaded, retrievable]
Recommendation: [maintain / clean up / suggest new session]
```
