---
name: c31-dev
description: 新产品/新功能/新项目的完整开发流水线引导。当用户说"我要做个新项目"、"开发新功能"、"build"、"实现"、"启动项目"或任何需要从零开始构建软件/功能/工具时激活。引导用户依次经过 Grill（需求拷问）→ Spec（PRD 撰写）→ Plan（技术规划）→ Work（执行）四个阶段，每个阶段有确认门控，支持降级跳过。适用于任何需要多阶段规划与执行的开发任务。
---

# C31-Dev — 完整开发流水线引导

## Philosophy

Process over speed. Shared understanding before execution.

C31-Dev 不是"一键自动化"，而是"有刹车的流水线"。每个阶段的用户确认是不可跳过的——这正是它存在的理由。

## Pipeline 概览

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  C31-    │ ──→ │  C31-    │ ──→ │  C31-    │ ──→ │  C31-    │
│  Grill   │     │  Spec    │     │  Plan    │     │  Work    │
│ (拷问)   │     │ (PRD)    │     │ (蓝图)   │     │ (执行)   │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     ↑                 ↑                ↑                ↑
  用户确认          用户确认         用户确认         用户确认
  "共识达成"        "PRD OK"        "Plan OK"        "开干"
```

## 触发条件

- "我要做个…" / "我想开发…" / "I want to build..."
- "实现这个…" / "开发新功能"
- "走完整流程" / "pipeline" / "全流程"
- 任何从零开始构建软件/工具/功能的请求

## Workflow

### Phase 0: 初始化

**步骤 0.1: 读取已有上下文**
- 检查 `memory/.planning/phases/` 是否有相关 PRD/Plan
- 检查 `memory/grill-sessions/` 是否有相关共识文档
- 搜索 `memory/` 看是否有历史项目关联

**步骤 0.2: 初始化状态**
- 创建/读取 `memory/.planning/pipeline-state-{project}.md`
- 标记当前阶段为 `grill`
- 向用户说明 Pipeline 流程和确认门控机制

> "进入 C31-Dev 流水线。我们会依次经过 Grill（需求拷问）→ Spec（PRD）→ Plan（技术规划）→ Work（执行）。每个阶段需要你的确认才能进入下一步。随时可以喊停。"

### Phase 1: Grill（需求拷问 + 复杂度判定）

Grill 阶段**同时承担复杂度判定职责**——通过逐层拷问暴露隐藏假设，让真实复杂度自然浮现。不需要预评估。

**步骤 1.1**: 遵循 `skills/C31-grill/SKILL.md` 的完整流程：
- 一次一问，附带推荐答案
- 自动检测新术语、关键决策、记忆冲突
- 实时写入 `memory/glossary.md` 和 `memory/decisions/`

**步骤 1.2: 复杂度判定（Grill 过程中自然浮现）**

| 信号 | 含义 |
|------|------|
| 3-5 个问题后用户说"行了，很清楚了" | 项目简单，可能跳过 Spec 直接 Plan 或直接 Work |
| 多个分支都需要深入确认 | 标准流程：Grill → Spec → Plan → Work |
| 涉及架构变更、安全、外部依赖 | 深度流程：Grill 不跳过，Plan 需 CEDAR + STRIDE |

**步骤 1.3: 共识确认**
- 输出共识文档摘要
- 询问用户："共识是否达成？进入 Spec 阶段，还是跳过直接 Plan/Work？"
- 选项：确认进 Spec / 跳过 Spec 直接 Plan / 跳过 Spec+Plan 直接 Work / 继续 Grill / 暂停

### Phase 2: Spec（PRD 撰写）

**激活条件**：Grill 共识达成后，用户未选择跳过

**步骤 2.1**: 读取 Phase 1 的共识文档（如存在）和现有 REQUIREMENTS.md

**步骤 2.2**: 遵循 `skills/C31-spec/SKILL.md` 的 5 步流程：
1. 必要时拦截"直接写代码"的冲动
2. 渐进式披露 5 个问题
3. 撰写 PRD → `memory/.planning/phases/XX-PRD.md`
4. 验证门：成功标准可验证？边界非空？
5. 生成 PLAN 骨架

**步骤 2.3: 确认**
- 呈现 PRD 摘要
- 询问："PRD 是否确认？进入 Plan 阶段，还是跳过直接 Work？"
- 选项：确认进 Plan / 跳过 Plan 直接 Work / 修改 / 暂停

### Phase 3: Plan（技术规划）

**步骤 3.1**: 读取 Phase 2 的 PRD 作为上游文档

**步骤 3.2**: 遵循 `skills/C31-plan/SKILL.md` 的完整流程：
- Phase 0-5 依次执行
- CEDAR 质疑每个非平凡决策
- Wave 分析（依赖 DAG → 波次分组）
- Nyquist 验证（每个需求有测试覆盖）
- STRIDE 威胁建模（如涉及部署/安全）
- Plan-Checker 验证循环（最多 3 次）
- 写入 `memory/.planning/phases/XX-PLAN.md`

**步骤 3.3: 确认**
- 呈现计划摘要（Wave 分析、关键决策、风险）
- 询问："计划是否确认？是否进入 Work 阶段？"
- 选项：确认开干 / 深化 / 跳过

### Phase 4: Work（执行）

**步骤 4.1**: 读取 Phase 3 的 PLAN.md

**步骤 4.2**: 遵循 `skills/C31-work/SKILL.md` 的完整流程：
- Wave 1 → Wave 2 → ... 逐波执行
- 每任务 spawn 独立子代理
- 原子提交 + STATE.md 文件锁
- 每波质量门（测试 + lint + 冲突检查）

**步骤 4.3: 完成**
- 全量测试
- 最终 review
- 标记计划完成
- 输出总结

## 状态管理

Pipeline 执行期间维护状态文件：

```markdown
# Pipeline 状态 | {project_name}

## 当前阶段
{grill | spec | plan | work | done}

## 已产出
- 共识：`memory/grill-sessions/...`
- PRD：`memory/.planning/phases/...`
- Plan：`memory/.planning/phases/...`

## 确认记录
- Grill：{confirmed | skipped | pending}
- PRD：{confirmed | skipped | pending}
- Plan：{confirmed | skipped | pending}

## 跳过/降级
- {阶段}：{原因} | 风险：{描述}
```

路径：`memory/.planning/pipeline-state-{project}.md`

## 降级路径

每个阶段结束时，用户可选择跳过后续阶段。记录风险：

| 跳过 | 风险 |
|------|------|
| Grill → 直接 Spec | 隐藏假设未暴露 |
| Grill → 直接 Plan | 假设+边界双重风险 |
| Grill → 直接 Work | 极高返工风险，不推荐 |
| Spec → 直接 Plan | 边界不清，scope creep |
| Spec → 直接 Work | 需求未经文档化 |
| Plan → 直接 Work | 技术债务，架构风险 |

## 关键原则

1. **不替代独立 skills** — C31-Dev 是编排层，每个阶段加载对应 skill 的 SKILL.md
2. **确认不可跳过** — 用户说"确认"之前，不进入下一阶段
3. **读取上游文档** — 每个阶段开始前，必须读取上一阶段的产出
4. **一次一问** — 在 Grill 阶段严格遵守；其他阶段按需

## 反模式

| # | 反模式 | 后果 |
|---|--------|------|
| 1 | 用户说"先执行"就跳过确认 | 摧毁 pipeline 的价值 |
| 2 | 在 Grill 阶段就开始写代码 | 违反共识门控 |
| 3 | 不读取上游文档就进入下一阶段 | 信息断层 |
| 4 | 自动推断用户意图 | 导致错误路径 |
| 5 | Work 阶段修改 Plan | 应回到 Plan 重新确认 |

## 参考

- `skills/C31-grill/SKILL.md` — 需求拷问
- `skills/C31-spec/SKILL.md` — 需求定义
- `skills/C31-plan/SKILL.md` — 技术规划
- `skills/C31-work/SKILL.md` — 执行引擎
- `references/pipeline-state-template.md` — 状态文件模板
- `references/phase-handoff-checklist.md` — 阶段交接检查清单
