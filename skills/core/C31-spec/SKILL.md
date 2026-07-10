---
name: C31-spec
description: spec, 写需求, PRD | 需求定义：任何新项目/功能/重大变更先写PRD，作为意图与实现的契约
triggers: spec, 写需求, PRD, 产品文档, 定义项目
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | spec, 写需求, PRD, 产品文档, 定义项目 |
| ZH | 写需求, 产品需求, PRD |
| JA | 仕様を書く, 要件定義, PRD作成 |

> **Output language**: Respond automatically in the user's conversation language.

# C31-spec — Spec-Driven Development Skill

---

## Philosophy

Process not prose. Verification non-negotiable. Progressive disclosure.

Any new project, feature, or major change starts with a PRD. No exceptions. The PRD is the contract between intent and implementation. Writing it is cheaper than debugging what you should have decided upfront.

---

## When to Activate

- User says: "我要做一个...", "想开发...", "这个项目..."
- User jumps straight to implementation without defining scope
- Any task that will take >30 minutes or modify >3 files
- Any new skill, tool, or workflow

---

## Workflow

### 1. Detect & Interrupt

If user skips spec and goes straight to code:

> "等下。先写 PRD，后写代码。这是规矩。"
>
> "没有 PRD 的代码 = 没有约束的自由发挥 = 返工。"

### 2. Elicit Requirements (Progressive Disclosure)

Ask 5 个问题，一次一个，按顺序：

1. **目标**：这个东西解决了什么问题？用户是谁？成功标准是什么？
2. **命令/接口**：用户怎么调用它？CLI 命令？API 端点？聊天触发词？
3. **结构**：需要哪些文件/模块/数据表？核心数据流是什么？
4. **代码风格**：和现有代码的约定一致吗？用什么语言/框架？
5. **边界**：明确说"不做"什么。范围外的诱惑要抵抗。

### 3. Write PRD

PRD 模板（强制字段）：

```markdown
# PRD: [项目名]

## 目标
- 问题陈述（一句话）
- 成功标准（可验证的 2-3 条）

## 命令/接口
- 触发方式：
- 输入参数：
- 输出格式：

## 结构
- 文件清单：
- 数据流：
- 依赖关系：

## 代码风格
- 语言/框架：
- 命名约定：
- 与现有项目的衔接点：

## 测试
- 如何验证"成功标准"：
- 至少 1 个测试用例：

## 边界（明确不做）
- 不做 X：
- 不做 Y：
- 如果用户后来要求，需重新开 PRD
```

### 4. Verification Gate

PRD 写完必须检查：

- [ ] 成功标准是否可验证？（"更好用"不行，"加载时间<1s"可以）
- [ ] 边界列表是否非空？
- [ ] 是否与现有 `gsd-new-project` / `C31-plan` 冲突？
- [ ] 文件路径是否已存在？（避免覆盖）

不通过 → 打回重写，不进入下一步。

### 5. Handoff to C31-plan / ce-work

PRD 确认后，生成 `PLAN.md`：

```markdown
# PLAN: [项目名]

Based on PRD: [PRD 文件路径]

## Tasks
1. [ ] [具体步骤] → verify: [如何验证]
2. [ ] [具体步骤] → verify: [如何验证]
...

## Risk
- [风险点]: [规避策略]
```

然后调用 `C31-plan` 或 `ce-work` 进入执行阶段。

---

## Anti-Rationalization Table

| 借口 | 反驳 |
|------|------|
| "先写代码再补文档，快" | 补文档时会发现设计错误，那时改的代价是现在的 10 倍 |
| "这个项目很小，不用 PRD" | 小项目变大的速度比你以为的快 3 倍 |
| "PRD 太 formal，不 agile" | 没有约束的敏捷 = 布朗运动。PRD 是轨道，不是牢笼 |
| "用户急着要" | 用户要的从来不是"快"，是"不用返工"。PRD 省的是总时间 |
| "我已经想清楚了" | 想清楚的标志是：能写出没有歧义的 PRD。写不出来 = 没想清 |
| "AI 能帮我重构" | AI 重构的前提是结构清晰。结构清晰的前提是 PRD |

---

## File Placement

- PRD: `memory/.planning/phases/XX-PRD.md` 或项目根目录 `PRD.md`
- PLAN: `memory/.planning/phases/XX-PLAN.md`
- 与 `memory/.planning/REQUIREMENTS.md` 交叉引用

---

## 常见错误

| 错误 | 后果 | 修正 |
|------|------|------|
| PRD 里写"提升用户体验" | 不可验证，验收时扯皮 | 改为"页面加载<1s，错误率<0.1%" |
| 边界写"暂时不做" | "暂时"= 永远不会定义，范围蔓延 | 写"不做 X，如果后续需要重新开 PRD" |
| PRD 跳过测试章节 | 上线后才发现核心路径不通 | 至少写一个端到端验证步骤 |
| 直接复制旧项目 PRD | 上下文不同，设计决策过期 | 每个项目独立写，允许引用但不允许复制 |

---

## Reference

- GSD `gsd-new-project` — 项目初始化
- `C31-plan` — 执行计划生成
- `ce-work` — 任务执行
