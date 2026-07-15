---
title: "Loop Engineering Integration: C31 Becomes Loop-Ready Agent Harness"
date: "2026-07-15"
category: architecture-patterns
module: C31 Skill Harness
problem_type: architecture_pattern
component: development_workflow
severity: high
track: knowledge
applies_when:
  - "需要 C31 agent 无人值守、按计划自主运行"
  - "设计需要 budget 约束和结构化失败模式的 agent 系统"
  - "评估外部 loop-engineering 框架对现有 harness 的适配程度"
  - "为 agent 项目添加 autonomy 声明和调度层"
tags:
  - loop-engineering
  - autonomy-level
  - scheduling
  - constraints
  - failure-modes
  - c31-loop
  - loop-ready
  - agent-harness
---

# Loop Engineering Integration: C31 Becomes Loop-Ready Agent Harness

## 背景与问题

C31 在对 cobusgreyling/loop-engineering 框架审计后，发现四个结构性缺口：

| 缺口 | 描述 |
|------|------|
| 无 Scheduling Layer | Skill 需要人工触发，无法按计划自主运行 |
| 无 Budget Constraints | 无机制防止 agent 无限 fix loop 或资源耗尽 |
| 无 Autonomy 声明 | 技能的授权范围未显式标注，用户和 agent 均不清晰 |
| 无结构化 Failure Mode 命名 | 失败模式散落各处，无法系统性识别和预防 |

## 整合的 5 个机制

### 1. Autonomy Level 字段（7 个 Skill）

在以下 skill 的 YAML frontmatter 新增 `autonomy_level` 字段：

| Skill | Level | 含义 |
|-------|-------|------|
| C31-lfg | L3 | 全自动执行，无需人工确认 |
| C31-coding-discipline | L2 | 自动执行，决策层暂停等待确认 |
| C31-plan | L2 | 同上 |
| C31-grill | L2 | 同上 |
| C31-debug | L2 | 同上 |
| C31-research | L1 | 只读/分析，不执行任何变更 |
| C31-review | L1 | 只读/分析，不执行任何变更 |

**注意**：`autonomy_level` 是文档级元数据，不是平台硬约束。真正的控制来自 skill 正文逻辑（如 C31-lfg 的"全程无人介入"规则）。字段的价值在于让行为显式化、可查询。

### 2. C31-lfg Gate 0 扩展

Gate 0 重命名为 **"Gate 0: Load Plan + Constraints"**，新增第 4 步：

```
4. Read CONSTRAINTS.md if exists → load project-level binding constraints
   - If found: output constraints_loaded: true, list forbidden paths
   - If not found: output constraints_loaded: false, proceed with global GEMINI.md rules only
```

这使 lfg 在执行前先加载项目级约束，防止 agent 超出授权边界。

### 3. C31-coding-discipline Step 1 扩展

Step 1 重命名为 **"Load Constraints + Brainstorm"**，首个动作改为：

```
First action (always): Check for CONSTRAINTS.md in the project root.
- If found → read it, note all forbidden paths. Binding for all subsequent steps.
- If not found → proceed with global GEMINI.md rules only.
```

### 4. ERROR-GOVERNANCE.md — 5 个 Loop Engineering Failure Modes

追加至 `ERROR-GOVERNANCE.md` 的结构化失败模式（`FM-L1` 至 `FM-L5`）：

| ID | 名称 | 症状 | C31 防御 |
|----|------|------|---------|
| FM-L1 | Infinite Fix Loop | 同一 bug 连续失败 3+ 次仍重试 | 3 连续错误规则→强制 Escalate |
| FM-L2 | State Rot | Loop 对过期 PR/任务采取行动 | 每次运行开始时验证 STATE.md |
| FM-L3 | Compound Without Recall | 有文档但 AI 不查 | 无 INDEX 条目 = 文档不存在 |
| FM-L4 | Verifier Theater | Verifier 批准了但代码有明显问题 | 4 个隔离 agent，不信任自我报告 |
| FM-L5 | Notification Fatigue | Loop 每次都通知，用户开始忽视 | L1 loop 只更新 STATE.md |

### 5. 新 Skill: C31-loop（5 问访谈 → 一键部署）

```
c31 loop → 触发 5 问访谈
         ↓
Q1: 做什么任务？ (daily-triage / dep-sweep / ci-watch / changelog / custom)
Q2: 多久运行？  (每天 / 每6小时 / 每次push / 每周 / 自定义)
Q3: 在哪里运行？(GitHub Actions / Windows Task Scheduler / 两个都要)
Q4: 失败通知？  (创建 Issue / 更新 STATE.md / 不通知)
Q5: Token 预算？(宽松20k / 标准8k / 严格3k / 不限)
         ↓
自动生成：
├── STATE.md
├── CONSTRAINTS.md
├── loop-budget.md
├── loop-adr.md
├── .github/workflows/c31-loop.yml  （GitHub Actions 选项）
└── c31-loop-setup.ps1              （Windows Task Scheduler 选项）
```

## 整合后的完整架构栈

```
完整 Loop = Harness + Schedule + State + Budget + Verification Chain
               ✅         ✅*       ✅       ✅*           ✅
```

*（Schedule 和 Budget 由 `c31-loop` 提供，用户选择是否接入）

## Guidance（未来决策参考）

- **新项目接入 C31 时**：先运行 `c31-loop` 生成 CONSTRAINTS.md 和 loop-budget.md，再运行 c31-lfg
- **设计新 skill 时**：在 frontmatter 声明 `autonomy_level`（L1/L2/L3）
- **遇到 FM-L1（连续失败 3 次）**：强制 Escalate，不继续重试
- **Verifier 子代理设计**：必须独立验证，不得依赖执行者自我报告（防 FM-L4）
- **C31 vs Loop Engineering 的核心差异**：C31 的 State 更丰富（session_state + instincts + diary + solutions），Verification 更强（4 并行隔离 agent + 冲突检测），Knowledge 有飞轮（Instinct System + Pre-Search）

## 相关文档

- [`docs/loop-ready-integration.md`](../loop-ready-integration.md) — 完整叙述文章（Why + What + How）
- [`ERROR-GOVERNANCE.md`](../../ERROR-GOVERNANCE.md) — 包含 FM-L1 至 FM-L5 的完整定义
- [`skills/personal/C31-loop/SKILL.md`](../../skills/personal/C31-loop/SKILL.md) — 访谈 skill 源文件
