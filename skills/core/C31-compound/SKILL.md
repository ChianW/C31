---
name: C31-compound
description: solved, fixed, compound, 解决了 | 知识固化：将已解决的问题记录为结构化文档供未来复用
triggers: solved, fixed, working now, root cause, that worked, compound, document this, 解决了, 搞定了, 原来是因为, C一下
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | solved, fixed, working now, root cause, that worked, compound, document this, 解决了, 搞定了, 原来是因为, C一下 |
| ZH | 复利, 记录知识, 总结 |
| JA | 知識を記録する, コンパウンド, まとめる |

> **Output language**: Respond automatically in the user's conversation language.

# C31-compound — Knowledge Compounding

Capture a recently solved problem as structured documentation so future
occurrences take minutes instead of research cycles.

## Preconditions

- Problem has been solved (not in-progress)
- Solution has been verified working
- Non-trivial problem (compound_score ≥ 15, or user insists)

## Auto-Draft Mode (Default)

When triggered by auto-invoke phrases (not manual command), enter lightweight
draft mode first.

**Behavior:**
1. Skip blocking questions
2. Extract from recent conversation context:
   - **Problem**: 1-2 sentence description
   - **Symptoms**: Observable symptoms
   - **What Didn't Work**: Failed attempts
   - **Solution**: Actual fix
3. **Duplicate detection**（重复检测）：
   - 用 `memory_search` 查询 Problem 描述关键词 + Solution 中的核心工具/文件名
   - 若命中 **score > 0.7** 的相似 solution：
     - emit brief note: `⚠️ 检测到相似记录：{filename}（日期）`
     - 追加选项：`[覆盖] 更新现有文件 / [追加] 添加新 case study / [跳过] 不保存`
     - **若用户说"覆盖"** → 更新现有文件（追加 `last_updated: YYYY-MM-DD`，在末尾添加新 observations）
     - **若用户说"追加"** → 在现有文件末尾追加新 case study 区块
     - **若用户说"跳过"或无响应（30s）** → 丢弃当前 draft，不保存
     - 中断当前 Auto-Draft 流程，由用户选择驱动后续
   - 若未命中或 score ≤ 0.7 → 继续第4步
4. Auto-calculate **compound_score** = Severity × Frequency × Uniqueness × Scope
   - Severity: 1-5 (how bad was the problem)
   - Frequency: 1-5 (how likely to recur)
   - Uniqueness: 1-5 (how non-obvious was the solution)
   - **Scope: 1-5** (impact range: single file → cross-skill → systemic)
     - 1 = 单个文件/单一技能内部
     - 2-3 = 跨文件或跨技能
     - 4-5 = 系统性/框架级/影响多个工作流
4. **分级自动保存:**
   - **compound_score ≥ 50** → 触发 **Full Mode 异步执行**
     - spawn 后台子代理跑 Phase 0.5-4（并行研究+完整版组装）
     - 主对话只发：`✍️ 高价值问题检测到（{score}分），后台生成完整版 compound...`
     - 完成后静默写入，不再打扰
   - **15 ≤ compound_score < 50** → auto-save **轻量版** to `memory/solutions/`，silently
     - emit brief note: `✍️ 已自动记录 — {filename} (compound_score: {score})`
   - **compound_score < 15** → skip silently. No notification.

   **No checkpoint. No user selection.** The skill runs and completes without interruption.

**If user explicitly says "compound this" / "document this" / "保存" / "记录":**
→ 直接进入 **Full Mode**（Phase 0.5 onwards），跳过 Auto-Draft 分级。

**If user explicitly says "skip" / "不要记" / "不用记录":**
→ Discard silently, no save, no notification.

## Full Mode (Manual or Selected)

When user chooses "Full" or invoked with "compound this" / "document this":

### Phase 0.5: Auto Memory Scan

Run `memory_search` with query matching the problem topic. If relevant entries
found, prepare labeled excerpt block for Phase 1 subagents.

### Phase 1: Parallel Research

**Critical: subagents return TEXT DATA only. Orchestrator writes files.**

🛑 **STOP**: 根据问题描述初步确认 track 类型：
- 意外失败 / 报错 / 不正常行为 → **bug**
- 工作模式 / 最佳实践 / 设计决策 → **knowledge**
- 无法判断 → 标记为 `unknown`，由 Context Analyzer 子代理最终裁定

记录初步 track 判断后，启动以下子代理：

Launch these subagents in parallel:

#### 1. Context Analyzer
- Determines track: **bug** (unexpected failure) or **knowledge** (pattern/guidance)
- Identifies: problem_type, component, category
- Suggests filename: `YYYY-MM-DD-[sanitized-slug].md`
- Returns: YAML frontmatter skeleton, category, track

#### 2. Solution Extractor
- Adapts output structure based on track:

**Bug track** sections:
- **Problem**: 1-2 sentence description
- **Symptoms**: Observable symptoms
- **What Didn't Work**: Failed attempts and why
- **Solution**: Actual fix with examples (before/after)
- **Why This Works**: Root cause explanation
- **Prevention**: Concrete strategies, test cases, lint rules

**Knowledge track** sections:
- **Context**: Situation that prompted guidance
- **Guidance**: Practice/pattern with examples
- **Why This Matters**: Rationale and impact
- **When to Apply**: Conditions where this applies
- **Examples**: Concrete before/after or usage

#### 3. Related Docs Finder
- Searches `memory/solutions/` for related documentation
- Uses grep/ripgrep for pre-filtering on `title:`, `tags:`, `problem_type:`
- Assesses overlap: **High** (same problem, update existing) / **Moderate** (related) / **Low** (distinct)
- Returns: links, relationships, refresh candidates

#### 4. Session History (optional)
Run `memory_search` with tight query (default: 7 days). Structure findings as:
- What was tried before
- What didn't work
- Key decisions

### Phase 2: Assembly & Write

**WAIT for all Phase 1 subagents to complete.**

1. Collect all Phase 1 text results
2. Check overlap assessment:
   | Overlap | Action |
   |---|---|
   | High | Update existing doc. Add `last_updated: YYYY-MM-DD`. |
   | Moderate/Low/None | Create new doc. |
3. Assemble complete markdown
4. Validate YAML frontmatter
5. Write to `memory/solutions/YYYY-MM-DD-[slug].md`

### Phase 3: Discoverability Check

Check whether AGENTS.md / MEMORY.md references `memory/solutions/`:
1. Read existing instruction files
2. Assess whether an agent would learn:
   - That a searchable knowledge store exists
   - Its structure (YAML frontmatter, category organization)
   - When to search it
3. If not met → draft smallest addition to communicate these three things

**Interactive mode:** Show proposed change, ask consent before editing.
**Headless mode:** Apply edit silently, surface in report.

### Phase 4: Project Integration (if .planning/ exists)

If `memory/.planning/` exists:
- Append a summary entry to `.planning/debug/knowledge-base.md`
- Format: `- YYYY-MM-DD: [title] (compound_score: X, file: solutions/...)`
- This links compound knowledge to active project tracking

## YAML Frontmatter Template

```yaml
---
compound_score: [1-125]
date: YYYY-MM-DD
category: [tooling | workflow | database | api | frontend | backend | security | performance | unknown]
problem_type: [brief-classification]
track: [bug | knowledge]
tags: [tag1, tag2]
status: [active | resolved | deprecated]
---
```

## Success Output

```
✓ Documentation complete

File: memory/solutions/YYYY-MM-DD-[slug].md  (created | updated)
Track: <bug | knowledge>
Category: <category>
compound_score: <score>
Overlap: <none | low | moderate | high — existing doc updated>
Knowledge-base: <not updated | appended to .planning/debug/knowledge-base.md>
```

## The Compounding Philosophy

```
Build → Test → Find Issue → Research → Improve → Document → Validate → Deploy
    ↑                                                                      ↓
    └──────────────────────────────────────────────────────────────────────┘
```

Each unit of work should make subsequent units easier — not harder.

## 错误处理

本 skill 遵循 [AGENTS/error-handling.md](../AGENTS/error-handling.md) 标准。

### 常见错误码

| 错误码 | 触发场景 | 处理策略 |
|--------|---------|---------|
| `API_TIMEOUT` | `memory_search` / 文件操作超时 | 等待 4s 重试，最多 2 次 |
| `RATE_LIMITED` | API 限流（搜索、子代理） | 等待 10s 重试 |
| `VALIDATION_FAILED` | YAML frontmatter 校验失败 | 修正参数后重试 |
| `RESOURCE_NOT_FOUND` | 文件/数据不存在 | 检查路径，无法恢复则 escalate |
| `CONTEXT_OVERFLOW` | 长 session 上下文超限 | 压缩后重试，或分片处理 |
| `SUBAGENT_FAILED` | Phase 1 子代理失败 | 检查子代理日志，最多重试 1 次 |

### Escalation 条件

- 同一 error_code 连续 2 次 → 第 3 次强制 escalate
- retry_count 达到 max_retries → escalate
- 非 recoverable 错误（PERMISSION_DENIED, SECURITY_BLOCKED 等）→ 立即 escalate

### 回退链

| Primary | Fallback | 条件 |
|---------|---------|------|
| `memory_search` | `exec` + `grep/ripgrep` | `API_TIMEOUT` / `RATE_LIMITED` |
| `kimi_fetch` | `web_fetch` | `API_TIMEOUT` / `NETWORK_ERROR` |
| `read` (大文件) | `read` + offset/limit | `CONTEXT_OVERFLOW` |

### If-Then 失败模式 Fallback

| 条件 | 触发场景 | 动作 |
|------|---------|------|
| 用户选 [3] 跳过 | Auto-Draft 模式下用户明确拒绝 | 立即丢弃 draft，不保存，不 spawn 子代理，流程终止 |
| compound_score < 15 且用户未 insist | 低价值问题，用户无强烈记录意愿 | 仅展示 draft 内容，不预推荐 [1]，等待用户主动选择 |
| `memory/.planning/` 不可写 | Phase 4 项目集成时目录权限/路径异常 | 降级到 `/tmp/c31-compound-fallback/` 临时保存，输出提示用户手动迁移 |
| 相关文档搜索超时 | Phase 0.5 `memory_search` 超时或 API 失败 | 跳过 Phase 0.5，直接进入 Phase 1，子代理自行处理上下文 |

## 反例黑名单

以下反模式在 C31-compound 执行中**绝对禁止**：

1. **❌ 不要记录未验证的解决方案**
   - 用户说"应该没问题"但没实际测试 → 不记录，标记为 `pending_verification`
   - 必须看到"解决了"/"验证通过"等确认词才进入 draft 流程

2. **❌ 不要在 Auto-Draft 模式跳过用户确认**
   - 即使是 draft 也必须展示给用户，提供 [1]-[4] 选项
   - 禁止静默保存，禁止绕过 pre-select 推荐逻辑

3. **❌ 不要修改原始 SKILL.md 文件内容**
   - compound 只写 `memory/solutions/`，不改 `skills/C31-compound/SKILL.md`
   - 发现 skill 本身有 bug → 走正常修复流程，不借 compound 之机打补丁

4. **❌ 不要记录纯闲聊/情感表达的"解决方案"**
   - "我懂了""原来如此""谢谢你" → 不触发 compound
   - 必须有可复用的技术/流程/认知产出

5. **❌ 不要在用户明确说"不记/跳过"时强行保存**
   - 用户选 [3] 跳过 → 立即丢弃 draft，不写入任何文件
   - 用户说"别记了""不用记" → 等同于 [3]，不追问、不挽留

### 黑名单触发后果
| 违反项 | 后果 |
|--------|------|
| 第1、4项 | draft 无效，不进入 Phase 2 |
| 第2、5项 | 用户信任降级，未来 auto-invoke 敏感度降低 |
| 第3项 | 技能体系污染，需人工回滚 |

## Auto-Invoke

<auto_invoke>
<trigger_phrases>
- "that worked"
- "it's fixed"
- "working now"
- "problem solved"
- "solved"
- "fixed"
- "root cause"
- "解决了"
- "搞定了"
- "原来是因为"
- "根因是"
- "终于找到原因"
- "原来要这样"
- "没想到是"
- "错在"
</trigger_phrases>
<manual_override>
Invoke with: "compound this" or "document this solution" or "记录"
</manual_override>
</auto_invoke>
