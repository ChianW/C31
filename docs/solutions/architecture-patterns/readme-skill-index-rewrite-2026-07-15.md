---
title: "README Skill Index 重写：从触发词占位符到完整导航目录"
date: "2026-07-15"
category: architecture-patterns
module: C31 README / Skill Index
problem_type: documentation_gap
component: documentation
severity: medium
track: knowledge
applies_when:
  - "README 的 Skill 列表只有触发词，用户无法判断技能用途"
  - "新用户需要在不打开每个 SKILL.md 的情况下理解技能体系"
  - "技能数量超过 15 个，需要分类导航"
  - "为 skill 索引添加可点击链接和描述"
tags:
  - readme
  - skill-index
  - documentation
  - navigation
  - categorization
  - user-experience
---

# README Skill Index 重写：从触发词占位符到完整导航目录

## 问题

原 Skill Index 只包含触发词和技能名称：

```markdown
| Skill | EN Trigger | ZH | JA |
|-------|-----------|----|-----|
| C31-lfg | `lfg` | 开干 | やろう |
```

用户（尤其是新用户）无法：
1. 理解每个技能的用途
2. 判断哪个技能适合当前场景
3. 快速跳转到技能源文件

## 解决方案

将最小化表格替换为完整分类索引，共 6 个分类、43 个技能。

### 表格结构（每个分类）

```markdown
| Skill | Trigger | What it does |
|-------|---------|-------------|
| [技能名](相对路径/SKILL.md) | `触发词` / `中文触发词` | 一句话描述：做什么、何时用、产出是什么 |
```

三列职责：
- **Skill** — 可点击链接，直达 SKILL.md 源文件
- **Trigger** — EN + ZH 触发词（双语）
- **What it does** — 一句话描述，覆盖 What / When / Output

### 分类体系

| 分类目录 | 技能数 | 定位 |
|---------|-------|------|
| `core/` | 18 | 工程工作流核心 skill |
| `review/` | 5 | 多 agent 代码审查 |
| `product/` | 11 | 产品与商业（极简创业框架）|
| `utils/` | 8 | 生产力工具 |
| `personal/` | 2 | 个人工作流（含 c31-loop）|
| `platform-specific/` | 2 | 平台适配 |

### 描述写法原则

好的描述包含三个维度：

```
❌ 差：Uses TDD and wave execution.
✅ 好：Enforces a 7-step disciplined coding workflow: constraints check → brainstorm
       → worktree → TDD → execute → inline review → finish. No placeholders allowed.
```

区别：好的描述说明了**触发时机**（何时用）、**流程**（做什么）、**约束**（产出保证）。

## 关于 Autonomy 列的决策

初版表格包含第四列 `Autonomy`（L1/L2/L3 标签）。用户随后要求移除，原因是增加了 README 视觉噪声。

**移除方式**：Python 逐行处理（见 `runtime-errors/powershell-regex-utf8-markdown-corruption-2026-07-15.md`）。

**Autonomy 信息仍保留在**：各 skill 的 SKILL.md frontmatter 中（`autonomy_level: L1/L2/L3` 字段）。

## 维护规则

1. **新增 skill 时**：同时在 README Skill Index 对应分类添加一行，包含链接和描述
2. **技能超过 15 个时**：必须按目录分类，不能平铺展示
3. **触发词和描述分离维护**：触发词在 SKILL.md frontmatter，描述在 README — 两者服务不同场景（机器触发 vs 人类导航）
4. **链接使用相对路径**：`skills/core/C31-lfg/SKILL.md`，方便在 GitHub 上直接点击跳转

## 相关文档

- [README.md Skill Index 节](../../README.md#skill-index) — 实际的索引内容
- [skills/ 目录](../../skills/) — 所有技能的源文件
