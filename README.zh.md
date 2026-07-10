# C31 — Agent Harness 系统

**不只是 skills，而是完整的 agent harness 系统。**

持久化记忆。不断进化的本能。始终健康的上下文。  
源自 5 个月以上的每日生产实践。驱动 **[chian.io](https://chian.io)** 与 **[chian.io/investment-os](https://chian.io/investment-os)**。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-50+-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#兼容性)
[![Languages](https://img.shields.io/badge/languages-EN%20%7C%20ZH%20%7C%20JA-orange.svg)](#languages)

> 🇺🇸 [English](README.md) · 🇨🇳 [中文](README.zh.md) · 🇯🇵 [日本語](README.ja.md)

---

## 基于 C31 构建

| 项目 | 简介 |
|------|------|
| **[chian.io](https://chian.io)** | *「做一个人，是一种奢侈。」* — 一个探索品味、判断力与人类独特性的知识平台与个人操作系统。产品包括：Investment OS、The Silicon Boardroom（播客）、Project Q、System Reboot。 |
| **[chian.io/investment-os](https://chian.io/investment-os)** | *大师克隆系统* — 巴菲特 70 年股东信（1956–2025）+ 霍华德·马克斯 160+ 份备忘录（1990–2026），解码为完整的跨链接知识图谱，可由人类和 AI Agent 同时查询。 |

*用 C31 做了什么？欢迎提 PR 把你的项目加入这里。*

---

## 什么是 C31？

C31 是一套 **agent harness 系统**——介于你和 AI 工具之间的那一层，让每次会话都比上一次更聪明。

大多数 prompt 集合只给你一次性指令。C31 给你的是一套 **AI 的持久化操作系统**：

| 层级 | 功能 |
|------|------|
| **Skills（技能）**（50+ 个） | 结构化工作流：头脑风暴 → 规划 → 执行 → **简化** → 审查 → 复利 |
| **记忆系统** | `session_state.json` + 日记 + 本能文件——状态跨会话持久化 |
| **本能进化** | AI 从每次交互中学习；模式从 `候选 → 验证中 → 本能` 逐级升级 |
| **上下文健康** | 🟢🟡🟠🔴 四状态监控，防止长会话中的上下文腐化 |
| **心理框架层** | 逐步推理强制执行 + 置信度检查输出校验 |
| **质量门（Critic Gate）** | 自动质量门：超过 300 字且含推断性结论的输出自动触发自我审查 |

---

## 五层架构

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTS.template.md（GEMINI.md / CLAUDE.md / AGENTS.md）    │
│  ─ 工程原则              ─ 决策边界                          │
│  ─ 场景感知软加权         ─ 质量门（Critic Gate）             │
│  ─ 心理框架层            ─ Fix-it 修复链路                   │
├─────────────────────────────────────────────────────────────┤
│  SKILLS 技能（50+ 个）                                       │
│  core/ · review/ · product/ · utils/ · personal/            │
├─────────────────────────────────────────────────────────────┤
│  记忆系统（MEMORY SYSTEM）                                   │
│  session_state.json  ←→  diary/日记  ←→  instincts/本能     │
├─────────────────────────────────────────────────────────────┤
│  本能进化（INSTINCT EVOLUTION）                              │
│  候选（1/3） → 验证中（2/3） → 本能（3/3）                  │
│  置信度：0.3–0.9 · 低于 0.3 则废弃                          │
├─────────────────────────────────────────────────────────────┤
│  上下文健康（CONTEXT HEALTH）                                │
│  🟢 <50%  🟡 50-70%  🟠 70-85%  🔴 >85% → 强制检查点       │
└─────────────────────────────────────────────────────────────┘
```

---

## C31 的独特之处

### 1. 持久化记忆

与无状态的 prompt 文件不同，C31 有记忆。`session_state.json` 追踪活跃项目、待办事项和待定决策。日记记录每日工作。本能文件存储附有置信度分数的已学习模式。

```
~/.cystem31/
├── memory/
│   ├── session_state.json   ← 上次话题、待办事项、已完成任务
│   ├── diary/YYYY-MM-DD.md  ← 每日会话日志
│   └── instincts/           ← 进化后的行为模式
└── solutions-registry.md    ← 所有已记录解决方案的索引
```

### 2. 不断进化的本能

AI 不只是遵循规则——它会积累本能。当一个模式成功 3 次后，它升级为 `本能`（自动应用，无需确认）。当用户说「这不对」时，置信度分数降至 0.3 以下，该模式被废弃。

```
instinct-001-no-overwrite.md     confidence: 0.95  ← 自动应用
instinct-002-research-first.md   confidence: 0.90  ← 自动应用
instinct-003-surgical-changes.md confidence: 0.90  ← 自动应用
instinct-004-C31-compound.md      confidence: 0.85  ← 自动应用
```

### 3. 上下文健康监控

长时间会话会损害 AI 质量。C31 监控上下文窗口使用情况并自动采取行动：

| 状态 | 使用率 | 行动 |
|------|--------|------|
| 🟢 绿色 | <50% | 正常运行 |
| 🟡 黄色 | 50–70% | 开始压缩已完成的工作 |
| 🟠 橙色 | 70–85% | 将决策移至文件，归档假设 |
| 🔴 红色 | >85% | 强制检查点：写入状态后再继续 |

### 4. 心理框架层

C31 将有研究支撑的认知技术直接嵌入 harness：
- **逐步推理**：复杂分析在输出前先在内部展开（可减少约 34% 的错误）
- **置信度检查**：每个重要输出附带差距标注
- **质量门（Critic Gate）**：对超过 300 字的推断性结论自动触发自我审查
- **反讨好机制**：技术严谨优于社交舒适——遭遇质疑时触发独立评估，而非一味妥协

### 5. 知识复利

每一个被解决的问题都成为组织记忆。`C31-compound` 工作流将解决方案写入 `docs/solutions/` 并附带 INDEX 条目。下次遇到同类问题时，只需几分钟而非数小时。

---

## 快速安装

```bash
git clone https://github.com/ChianW/C31.git
cd C31
./install.sh          # macOS / Linux — 安装核心技能
.\install.ps1         # Windows PowerShell

./install.sh all      # 安装全部（50+ 个技能）
./install.sh product  # 仅安装产品/商业技能
```

**然后将 `AGENTS.template.md` 复制到你的项目根目录：**

| 你的工具 | 文件名 | 语言 |
|----------|--------|------|
| Gemini CLI / Antigravity | `GEMINI.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |
| Claude Code / Codex | `CLAUDE.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |
| OpenClaw / Hermes / Kimi CLI | `AGENTS.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |

将 `{YOUR_HOME}`、`{YOUR_PROJECT}`、`{MEMORY_DIR}` 替换为你的实际路径。

---

## 使用指南

> 完整文档见 [PHILOSOPHY.md](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

| 指南 | 你将学到 |
|------|----------|
| **[快速开始](AGENTS.template.md)** | 安装、配置并运行你的第一次 C31 会话 |
| **[工程哲学](PHILOSOPHY.md)** | 5 条 Karpathy 原则 + 怀疑驱动开发 + Chesterton 围栏 |
| **[记忆系统](AGENTS.template.md#session-startup-protocol)** | 会话状态、日记与本能如何协同工作 |
| **[本能进化](AGENTS.template.md#instinct-system)** | 模式如何从候选升级为自动应用的本能 |
| **[上下文健康](AGENTS.template.md#own-your-context-window)** | 管理四状态上下文系统以应对长会话 |
| **[技能索引](skills/)** | 全部 50+ 个技能，附 EN · ZH · JA 触发词 |

---

## 技能索引

### 🔧 core/（18 个）— 工程工作流

| 技能 | 英文触发词 | 中文 | 日文 |
|------|-----------|------|------|
| C31-1st | `first principles` | 第一性原理 | 第一原理 |
| C31-brainstorm | `brainstorm` | 头脑风暴 | ブレスト |
| C31-plan | `plan` | 制定计划 | 計画を立てる |
| C31-spec | `spec` | 写需求 | 仕様を書く |
| C31-work | `work` | 开干 | 実装する |
| C31-research | `research` | 调研 | 調査する |
| C31-coding-discipline | `coding` | 写代码 | コーディング |
| C31-debug | `debug` | 调试 | デバッグ |
| C31-compound | `compound` | 复利 | 知識を記録 |
| C31-strategy | `strategy` | 定战略 | 戦略を立てる |
| C31-lfg | `lfg` | 开干 | やろう |
| C31-context-engineering | `context` | 上下文 | コンテキスト管理 |
| C31-adopt-project | `adopt` | 看看这个项目 | プロジェクト調査 |
| C31-compound-refresh | `refresh` | 更新知识库 | ドキュメント更新 |
| C31-workflow-bug-reproduction | `reproduce` | 复现bug | バグ再現 |
| ce-simplify-code | `simplify` | 简化代码 | コード簡素化 |
| ce-pov | `pov` | 技术决策 | 技術判定 |
| ce-promote | `promote` | 发布公告 | リリース告知 |

### 🔍 review/（5 个）— 多代理代码审查

`C31-review` · `C31-review-security` · `C31-review-architecture` · `C31-review-adversarial` · `C31-multi-review`

### 💼 product/（11 个）— 产品与商业

`c31-community` · `c31-validate` · `c31-mvp` · `c31-process` · `c31-sell` · `c31-market` · `c31-grow` · `c31-price` · `c31-gutcheck` · `c31-values` · `growth-hacker`

### 🛠️ utils/（8 个）· 🧘 personal/（2 个）· ⚙️ platform-specific/（2 个）

---

## 思想基础

C31 融合了来自 9 个框架的设计哲学，构建为统一的 harness：

| 来源 | 对 C31 的核心贡献 |
|------|-----------------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 5 条核心工程原则（基石） |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | 无状态归约器 · 上下文所有权 · 紧凑错误处理 |
| **[ECC](https://github.com/affaan-m/ecc)** | 本能进化系统 · 上下文健康颜色 · 持续学习循环 |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | 头脑风暴→规划→执行→**简化**→审查→复利 生命周期·删除测试·行为变更验证 |
| **[Superpowers](https://github.com/obra/superpowers)** | 子代理驱动开发 · 完成前验证 |
| **[Archon](https://github.com/coleam00/Archon)** | Agent 生命周期治理 · 禁止自主状态变更 |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | 上下文工程 · 产物优先于记忆 · 计划质量门 |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | 怀疑驱动开发 · Chesterton 围栏 · 反讨好机制 |
| **心理框架** | 逐步推理 · 置信度检查 · 质量门（Critic Gate） |

---

## 兼容性

兼容所有支持 markdown 上下文文件的 AI 编程工具：

| 平台 | 安装方式 | 配置文件 |
|------|----------|----------|
| **Antigravity**（Gemini CLI） | `./install.sh` | `GEMINI.md` |
| **Claude Code** | `./install.sh` | `CLAUDE.md` |
| **Codex** | `./install.sh` | `CLAUDE.md` |
| **Kimi CLI** | `./install.sh` | `AGENTS.md` |
| **OpenClaw** | `./install.sh` | `AGENTS.md` |
| **Hermes** | `./install.sh` | `AGENTS.md` |

Windows 用户：请使用 `.\install.ps1`

---

## 语言

- 🇺🇸 [English](README.md)
- 🇨🇳 [中文](README.zh.md)（当前页面）
- 🇯🇵 [日本語](README.ja.md)

---

## 贡献

1. Fork 本仓库
2. 将你的技能添加到对应的 `skills/` 分类下
3. 在 SKILL.md 的 frontmatter 中添加多语言触发词（EN · ZH · JA）
4. 提交 PR

用 C31 构建了什么？把它加到 **基于 C31 构建** 的表格里。

---

## 许可证

MIT — 详见 [LICENSE](LICENSE)

> 🇺🇸 [English](README.md) · 🇨🇳 [中文](README.zh.md) · 🇯🇵 [日本語](README.ja.md)
