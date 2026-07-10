---
name: C31-research
description: research, 调研, 最佳实践 | 统一研究：框架文档、git历史、社区问题、机构记忆、bug复现
triggers: research, 调研, 最佳实践, 资料, 研究, how should I
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | research, 调研, 最佳实践, 资料, 研究, how should I |
| ZH | 调研, 研究, 最佳实践 |
| JA | 調査する, リサーチ, ベストプラクティス |

> **Output language**: Respond automatically in the user's conversation language.

# C31 Research

Unified research skill. Covers best practices, framework documentation, git history, community issues, institutional memory, and bug reproduction. All modes are read-only — does not write code.

## When to Use

- "最佳实践是什么" / "idiomatic way" / "how should I..."
- 进入陌生技术栈前
- 调试框架级错误 / 验证版本变更
- Bug 报告缺少复现步骤 / "以前解决过类似问题吗？"
- 采用新依赖前检查健康度
- 修改复杂代码前了解历史上下文

## Core Principles

1. **Read-only** — never write code, never modify files.
2. **Source hierarchy** — official docs > community consensus > blog posts.
3. **Version-sensitive** — always note framework/library version; docs drift.
4. **Explicit gaps** — say "not found" rather than guess.
5. **Output ≤80 lines** + one code example max.

## 调研降级链（自动降级，不问人）

当任一 Mode 执行中遇到资料缺失或异常，按以下顺序自动降级。严禁停下来询问用户。

```
IF 官方文档未找到 → 搜索社区共识（HN / StackOverflow / 官方 Discussions）
IF 社区共识未找到 → 搜索博客 / RFC / 演讲幻灯片（带 ⚠️ caveats）
IF 所有来源耗尽   → 明确声明 "证据不足" + 输出已搜索的来源列表
IF 版本不匹配     → 标记 deprecation risk，继续用最新版本，但注明 "未验证用户版本"
IF 搜索超时       → 返回部分结果 + 在 gaps 中标注 "搜索超时：未覆盖 [X]"
IF 5 步搜索无结果  → 标记为 gap，不继续穷举
```

**降级原则：**
- 每次降级必须在 `caveat` 字段标注降级层级（"downgraded from official docs to blog posts"）
- 降级后的 claim 自动降级 `confidence`（high→medium→low）
- 最终 gaps 列表必须包含 **"尝试了哪些来源"** 和 **"为什么没找着"**

## Research Modes

Select mode based on user intent. One mode per invocation. Chain multiple modes for deep research.

### Mode A: Best Practices (`mode:best-practices`)

Find idioms, patterns, anti-patterns for a technology.

1. Confirm dependency version.
2. Read official docs (getting started, core concepts, API reference).
3. Search community consensus (HN, StackOverflow, official blog, RFCs).
4. Check project conventions (`.eslintrc`, `CONVENTIONS.md`, `ARCHITECTURE.md`).
5. Compare 2-3 alternatives with tradeoffs table.

**Output:** source citations + recommendation + why.

---

### Mode B: Framework Docs (`mode:framework-docs`)

Verify API behavior, lifecycle, hooks, execution order.

1. Locate official docs (API reference, not tutorials).
2. Find exact page: signatures, parameters, return values, exceptions.
3. Check version migration guide + deprecation notices.
4. Search official examples > community examples.
5. Verify edge cases: defaults, null/undefined handling, async behavior.

**Output:** verified fact + checked version + deprecation warnings if any.

---

### Mode C: Git History (`mode:git-history`)

Understand why code exists, who wrote it, regressions, prior attempts.

1. `git blame` to locate commit and author.
2. `git show` full commit (body, not just subject).
3. `git log --grep` for related changes.
4. Check for Revert commits.
5. `git log --oneline` for recent context.
6. Cross-reference issues (`Fixes #NNN` in commit body).

**Heuristics:**
- Reverted code has hidden reasons — dig deeper.
- Same author touching same file 3+ times = domain expert, read their other commits.
- Commit mentions "workaround" / "temporary" = likely technical debt.

---

### Mode D: Issue Intelligence (`mode:issue-intelligence`)

Check GitHub issues/PRs/discussions for known bugs, workarounds, tribal knowledge.

1. Search issues: `is:issue [keyword]` (open + closed).
2. Check labels: `bug`, `confirmed`, `documentation`, `wontfix`.
3. Read top 3-5 matches — focus on maintainer responses + workarounds.
4. Check PRs: `is:pr` for pending fixes.
5. Check Discussions for edge-case guidance.
6. Assess issue health: last activity? maintainer responsive? stale?

**Filter:** Only include workarounds verified by multiple users or maintainers. Always date-stamp issue references (stale workarounds may no longer apply).

---

### Mode E: Learnings / Institutional Memory (`mode:learnings`)

Search prior solutions, architecture decisions, project history.

1. Search `memory/solutions/` for matching entries.
2. Search `docs/` (ADRs, architecture docs).
3. Search diary/notes for decision rationale.
4. Check `ROADMAP.md` / `STATE.md` for current project position.
5. Cross-reference by tags or shared root causes.

**Quality rule:** Include the "why", not just the "what". If a prior solution was later found flawed, note that.

---

### Mode F: Bug Reproduction (`mode:bug-reproduction`)

Systematically reproduce a bug through hypotheses and controlled experiments.

1. **Hypothesize** — propose 3 ranked hypotheses (code bug / environment issue / configuration problem).
2. **Minimize surface area** — strip unrelated code, minimal dataset, disable cache/async/concurrency, test with defaults first.
3. **Controlled experiment** — change one variable at a time, record each result.
4. **For intermittent bugs** — run N times, record frequency (e.g., "3/10 attempts").
5. **Verify** — clean environment reproduces = code bug; only specific environment = env/config bug; never reproduces = missing condition or already fixed.

**Stop rule:** After 3 failed reproduction attempts, stop and document all attempts. Do not keep guessing.

---

## Workflow

1. **Classify intent** — which mode(s) apply? Can chain: e.g., `best-practices` → `framework-docs` → `issue-intelligence`.
2. **Execute mode** — follow steps above, stay read-only.
3. **Synthesize** — 80-line summary with source citations.
4. **Gap declaration** — explicitly state what was not found.
5. **Route** — return findings to caller (e.g., `C31-plan`, `C31-debug`, or user).

## 关联资源（自动检索路径）

执行 Mode E (`learnings`) 及链式调用时，以下路径如存在则自动检索：

| 路径 | 内容 | 优先级 |
|------|------|--------|
| `memory/solutions/` | 已解决问题的记录（bug 修复、workaround、root cause） | 最高 |
| `memory/moc/` | 知识图谱 / Map of Content（概念关联、决策审计） | 高 |
| `memory/projects/` | 项目历史状态与决策记录 | 高 |
| `memory/decisions/` | 决策审计与效果推理分析 | 中 |
| `memory/prompts/` | Prompt 工程实验记录 | 中 |
| `docs/` | ADRs、架构文档、ROADMAP.md、STATE.md | 中 |
| `references/` | 外部参考资料索引（如存在） | 低 |

> **路径不存在时自动跳过**，不报错、不中断流程。

## Output Contract

```json
{
  "mode": "best-practices|framework-docs|git-history|issue-intelligence|learnings|bug-reproduction",
  "findings": [
    {
      "claim": "One-line fact or recommendation",
      "source": "URL or git ref or memory path",
      "confidence": "high|medium|low",
      "version": "optional: checked framework version",
      "caveat": "optional: deprecation, stale, partial match"
    }
  ],
  "gaps": ["What was searched but not found"],
  "recommended_next": "mode to chain next, or null"
}
```

## 反例黑名单

这些模式在 C31-research 执行中**绝对禁止**。每条反模式对应实际误用场景。

| # | 反模式 | 误用场景 | 正确做法 |
|---|--------|----------|----------|
| 1 | ❌ 调研期间写代码 | 读到 API 文档时手痒直接实现 | 切换到 `C31-work` 或 `C31-plan` skill，research 保持 read-only |
| 2 | ❌ 猜测来源不清的事实 | "这个框架应该支持..." | 明确声明 **"未找到官方确认"**，不输出推测 |
| 3 | ❌ 证据稀缺时无限搜索 | 第 6 步搜索仍无结果，继续翻第 20 页 | **5 步搜索无结果 → 标记为 gap**，输出已搜索的来源列表，停止穷举 |
| 4 | ❌ 遗漏来源引用 | 给出建议但不附 URL/git ref/memory path | 每条 claim 必须有 `source` 字段，无法溯源的 claim 降级为 `confidence: low` 或删除 |
| 5 | ❌ 跳过版本检查 | 直接引用最新文档，不验证用户实际版本 | **先确认版本** → 再读对应版本文档 → 标记 deprecation risk |
| 6 | ❌ 未明确意图时混用研究模式 | Mode A 做到一半觉得 Mode B 也相关，随机切换 | Mode A→B 是**链式调用**（A 输出 `recommended_next: B`），不是随机混用。用户未明确意图时，单模式执行到底 |

> 违反任意一条 = 输出可信度降级为 `confidence: low`，并在 `gaps` 中标注 **"违反反例黑名单 #N"**。

## Escalation

- Finding contradicts project conventions → flag for `C31-plan` or `C31-brainstorm`
- Finding indicates architectural risk → flag for `C31-review` architecture-reviewer
- Bug reproduces intermittently with no clear pattern → flag for `C31-debug` with reproduction log
- Multiple sources conflict → present both, do not resolve alone
