# C31 — Agent Harness 系统

![C31 工作中 — 12 门全自动化流水线](docs/hero.gif)

> 你为你的 AI 写了 1,000 条提示词。然后对话重置了。它什么都忘了。
> 这就是为什么你需要的不是更好的提示词，而是一个持久化的操作层——Agent Harness。

**C31** 是从 7 个开源框架中锻造而来的 agent harness，历经 5 个月以上的每日生产实践。  
持久化记忆。不断进化的本能。始终健康的上下文。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-43-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#兼容性)
[![Languages](https://img.shields.io/badge/languages-EN%20%7C%20ZH%20%7C%20JA-orange.svg)](#languages)
[![Loop Ready](https://img.shields.io/badge/loop-ready-brightgreen.svg)](https://github.com/ChianW/C31-papers/blob/master/part11_loop_engineering.md)

> 🇺🇸 [English](README.md) · 🇨🇳 [中文](README.zh.md) · 🇯🇵 [日本語](README.ja.md)

---

## 基于 C31 构建

| 项目 | 简介 |
|------|------|
| **[chian.io](https://chian.io)** | *「做一个人，是一种奢侈。」* — 一个探索品味、判断力与人类独特性的知识平台与个人操作系统。产品包括：Investment OS、The Silicon Boardroom（播客）、Project Q、System Reboot。 |
| **[chian.io/investment-os](https://chian.io/investment-os)** | *大师克隆系统* — 巴菲特 70 年股东信（1956–2025）+ 霍华德·马克斯 160+ 份备忘录（1990–2026），解码为完整的跨链接知识图谱，可由人类和 AI Agent 同时查询。 |
| **[chian.io/kyoto](https://chian.io/kyoto)** | *哲学家的京都地图。* — 61 座寺庙、神社与圣道，每一处马孙连接一篇关于时间、无常与审慎生活的散文。旅行即哲学。 |
| **[agi-cd.com](https://agi-cd.com)** | *AGI 倒计时 —— 校准唯一重要的问题。* — 每日更新的信号流，倒计时至 AGI 零日（2029-03-07）。跨学科视角（哲学、历史、经济学、地缘政治、投资），帮你将思维与行动校准到后 AGI 世界。 |

*用 C31 做了什么？欢迎提 PR 把你的项目加入这里。*

---

## 什么是 C31？

在经营智库和投资机构的七年里，AI 横空出世，改变了一切。我逐渐意识到，唯一值得思考的问题只剩一个：*AGI 诞生后，这个社会会变成什么样？* 2025 年，我做了一个重大决定——让我人数冗杂的投资机构成为一家只有我和 Agent 的公司。

开始构建的第一周内，我就发现了核心问题：**AI 在生成代码上极其出色，在记住任何东西上却完全无能。**

我需要的不是更好的提示词，而是一套系统。于是我在 48 小时内审计了 7 个开源 Agent 框架，将它们最好的思想锻造成一个统一的 harness。这个系统，就是 C31。

大多数 prompt 集合只给你一次性指令。C31 给你的是一套 **AI 的持久化操作系统**：

| 层级 | 功能 |
|------|------|
| **Skills（技能）**（43 个） | 结构化工作流：头脑风暴 → 规划 → 执行 → **简化** → 审查 → 复利 |
| **记忆系统** | `session_state.json` + 日记 + 本能文件——状态跨会话持久化 |
| **本能进化** | AI 从每次交互中学习；模式从 `候选 → 验证中 → 本能` 逐级升级 |
| **上下文健康** | 🟢🟡🟠🔴 四状态监控，防止长会话中的上下文腐化 |
| **心理框架层** | 逐步推理强制执行 + 置信度检查输出校验 |
| **质量门（Critic Gate）** | 自动质量门：超过 300 字且含推断性结论的输出自动触发自我审查 |

---

## 2026 年的共识

在 2025–2026 年间，七个独立的开源项目从不同角度攻克了同样的问题。它们有不同的作者、不同的哲学、不同的 star 数，却得出了五个共同的结论：

**1. 架构胜过提示词。**
可靠性不来自更好的措辞，而来自结构——显式控制流、质量门控、状态管理。你不可能靠堆提示词堆出生产级的 Agent，你需要工程化地构建它们。

**2. Agent 需要持久化状态。**
会话级的记忆不够用。本能、学习成果和决策必须跨对话存活。Agent 应该随时间变得更聪明，而不是每次会话都重置到初始水平。

**3. 多 Agent 编排胜过单体 Agent。**
一个做好一件事的小型专业 Agent，胜过一个试图在同一个上下文窗口里同时完成头脑风暴、编码、测试、审查和文档的大而全 Agent。委托不是一个功能——它是一个架构需求。

**4. Human-in-the-loop 是一等公民操作。**
不可逆操作需要审批门控。最好的系统会将「AI 自主决策」和「AI 暂停等待人类输入」之间的边界做得明确且可配置。

**5. 知识会复利——如果你去捕获它的话。**
每个工作流的最后一步，都应该让系统比开始时更好。记录解决方案，索引它，让它可搜索。下次同类问题出现时，应该只需几分钟而不是几小时。

---

## 五层架构

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTS.template.md（GEMINI.md / CLAUDE.md / AGENTS.md）    │
│  ─ 工程原则              ─ 决策边界                          │
│  ─ 场景感知软加权         ─ 质量门（Critic Gate）             │
│  ─ 心理框架层            ─ Fix-it 修复链路                   │
├─────────────────────────────────────────────────────────────┤
│  SKILLS 技能（43 个）                                        │
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

### 1. 带硬门控的工作流——不是清单

> *来源：Compound Engineering Plugin（生命周期）+ 12-Factor Agents（F12：无状态归约器）+ Archon（确定性流水线）*

大多数 AI 工作流只是清单。C31 的生命周期是**流水线**——每一步以上一步的结构化输出为唯一输入，并为下一步生成结构化输出。上下文以文件传递，而非对话。

```
头脑风暴 → 规划 → 执行 → 简化 → 审查 → 复利
   ↓          ↓       ↓        ↓        ↓       ↓
决策文档   规划+     测试     无回归   APPROVED  docs/solutions/
（编号）   威胁模型   通过     验证              + INDEX 条目
```

每一步都有**验证门**——一个必须为真才能进入下一步的二元条件。规划需要人类审批。测试必须在审查前通过。解决方案在声明完成前必须有 INDEX 条目。

> **为什么重要：** 没有文档的 INDEX 条目是不可见的。没有 INDEX 条目的文档也是不可见的。C31 两者都强制执行。→ [完整工作流架构](WORKFLOW.md)

---

### 2. 多 Agent 编排——4 种模式

> *来源：Compound Engineering（复利子代理）+ Archon（子代理治理）+ Superpowers（不要相信报告）*

C31 使用四种不同的子代理编排模式。贯穿所有四种模式的核心架构原则：**并行工作的专业化 Agent 胜过一个试图做所有事情的单体 Agent。**

#### 模式 A — 并行对抗式审查

4 个隔离的 Agent 同时审查同一段代码。第 5 个 Agent 检测它们之间的矛盾。

```
            代码 / Diff
               │（广播）
  ┌────────────┼────────────┬────────────┐
  ▼            ▼            ▼            ▼
正确性        安全性      可维护性      简洁性
（隔离）      （隔离）     （隔离）     （隔离）
  │            │            │            │
  └────────────┼────────────┴────────────┘
               ▼
        冲突检测 Agent（第 5 个）
        检测矛盾 · 严重度差异 · 人类决策项
               ▼
        综合报告：APPROVED / WARNED / BLOCKED
```

**为什么要隔离的 Agent？** 隔离防止群体思维。一个专门寻找安全漏洞的审查者不会同时注意到过度工程——除非那是它唯一在寻找的东西。4 个 Agent 均以只读模式运行，对其他 Agent 的发现一无所知，因此它们的分歧成为信号，而非噪音。

#### 模式 B — 并行知识提取

当问题解决后，3 个 Agent 同时运行，提取解决方案的不同维度：

| Agent | 提取内容 |
|-------|----------|
| **上下文分析器** | 情况是什么？尝试了什么？存在哪些约束？ |
| **解决方案提取器** | 确切的修复是什么？根本原因？为什么有效？逐字命令。 |
| **相关文档查找器** | 哪些先前的解决方案相关？INDEX 缺口？归属何处？ |

输出汇总为单个解决方案文档 + 强制 INDEX 条目。

#### 模式 C — Fix-it 修复链路

```
「修复它」→ C31-debug → 修复（外科手术式）→ 验证 → C31-compound
                                  ↑___失败___|
```

对任何调试请求自动触发。自闭合循环。三连失败规则：同类修复连续失败 3 次，链路停止并上报——不盲目重试。

#### 模式 D — 12 门全自动化（C31-lfg）

对于已审批的规划，`lfg` 以确定性的 12 门流水线运行至完成，不中断：

`规划验证 → 依赖检查 → 测试基线 → 实现 → 多代理审查 → 单元测试 → 集成测试 → Nyquist 覆盖率 → 简化 → 安全扫描 → 构建验证 → 复利`

停止条件明确。其余一切无人值守运行。

---

### 3. 默认自主运行

> *来源：12-Factor Agents（F12）+ ECC（置信度评分）*

**默认状态是完全自主。** AI 执行、迭代、自我纠错并积累知识，无需中断。人类介入仅保留给两种情况：

- **不可逆范围** — 文件覆盖、删除、对外发布
- **意图置信度低** — 低于 0.55，提一个澄清问题。然后执行。

其他一切——包括 12 门流水线、Fix-it 链路、并行审查和知识提取——在封闭的自主循环中运行。

**置信度路由**决定 AI 在行动前是否开口：

| 置信度 | 行为 |
|--------|------|
| ≥0.75 | 直接执行，不确认。|
| 0.55–0.74 | 一句话确认：「你是说 X 对吧？」|
| <0.55 | 一个澄清问题。然后执行。|

---

### 4. 自我进化循环

> *来源：ECC（持续学习 + 置信度评分）+ agent-skills（反讨好机制）*

C31 的本能系统完全自主进化。无需配置文件，无需人类教导。

```
模式观察 → 候选本能（置信度：0.5）
模式重复 → 验证中本能（置信度：0.7）
模式验证 → 本能（置信度：0.9）——自动应用，无需确认

用户说「这不对」→ 置信度降至 0.1 → 废弃 → 不再建议
```

预置种子本能：
```
instinct-001-no-overwrite.md     confidence: 0.95  ← 从不覆盖已有文件
instinct-002-research-first.md   confidence: 0.90  ← 行动前先调研
instinct-003-surgical-changes.md confidence: 0.90  ← 只修改必要的内容
instinct-004-compound-trigger.md confidence: 0.85  ← 修改 ≥2 个文件后自动运行 compound
```

会话状态跨对话持久化：`session_state.json` + 每日日记 + 本能索引。每次会话从上次结束的地方开始。

```
~/.cystem31/
├── memory/
│   ├── session_state.json   ← 活跃项目、待办事项、待定决策
│   ├── diary/YYYY-MM-DD.md  ← 每日会话日志
│   └── instincts/           ← 附带置信度分数的进化行为模式
└── solutions-registry.md    ← 跨项目解决方案索引
```

---

### 5. 知识飞轮

> *来源：Compound Engineering Plugin（compound 步骤）+ GSD Core（产物优先于记忆）*

每一个被解决的问题都成为可搜索的组织记忆。飞轮：

```
解决 → C31-compound → docs/solutions/[类别]/YYYY-MM-DD.md
                              ↓
                        更新 INDEX.md  ← 强制
                              ↓
                 solutions-registry.md（跨项目）
                              ↓
              下次会话：预搜索静默检查注册表
                              ↓
              命中 → 「📋 发现先前方案」→ 注入上下文
              未命中 → 静默继续
                              ↓
          下次遇到同类问题：几分钟而非数小时
```

任何用 C31 引导的新项目立即继承所有先前的解决方案。

---

### 6. 上下文健康监控

> *来源：12-Factor Agents（F3：掌控你的上下文窗口）+ GSD Core（上下文腐化）*

长时间会话会悄悄降低 AI 质量。C31 监控并采取行动：

| 状态 | 使用率 | 行动 |
|------|--------|------|
| 🟢 绿色 | <50% | 正常运行 |
| 🟡 黄色 | 50–70% | 开始压缩已完成的工作 |
| 🟠 橙色 | 70–85% | 将决策移至文件，归档假设 |
| 🔴 红色 | >85% | 强制检查点：写入状态后再继续 |

---

### 7. 心理框架层

> *来源：Superpowers（西奥迪尼合规机制）+ agent-skills（怀疑门、反讨好机制）*

- **逐步推理**：输出前内部思维链，减少错误约 34%
- **质量门（Critic Gate）**：对超过 300 字的推断性结论自动触发自我审查
- **反讨好机制**：技术严谨优于社交舒适——遭遇质疑时触发独立评估，而非妥协
- **怀疑门（Doubt Gate）**：对不可逆操作，写下论断 → 隔离最小可审查单元 → 生成对抗性审查者

---

## 快速安装

```bash
git clone https://github.com/ChianW/C31.git
cd C31
./install.sh          # macOS / Linux — 安装核心技能
.\install.ps1         # Windows PowerShell

./install.sh all      # 安装全部（43 个技能）
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
| **[工程哲学](PHILOSOPHY.md)** | 5 条 Karpathy 原则 + 怀疑驱动开发 + Chesterton 围栏 + 置信度路由 |
| **[工作流架构](WORKFLOW.md)** | 6 步生命周期 + 4 种多代理编排模式（含 Mermaid 图表） |
| **[C31 与各框架对比](ADVANTAGES.md)** | 7 个框架单独使用各自的缺失，以及 C31 补充了什么 |
| **[错误治理](ERROR-GOVERNANCE.md)** | 三级错误分类 · Fix-it 链路 · 禁止自主生命周期变更 |
| **[记忆系统](AGENTS.template.md#session-startup-protocol)** | 会话状态、日记与本能如何协同工作 |
| **[本能进化](AGENTS.template.md#instinct-system)** | 模式如何从候选升级为自动应用的本能 |
| **[上下文健康](AGENTS.template.md#own-your-context-window)** | 管理四状态上下文系统以应对长会话 |
| **[技能索引](skills/)** | 全部 43 个技能，附 EN · ZH · JA 触发词 |
| **[子代理模板](agents/)** | 可直接使用的审查、复利与调试子代理 prompt 模板 |

---

## 技能索引

### 🔀 core/ — 工程工作流（15 个）

| 技能 | 描述 | 英文触发词 | 中文触发词 |
|------|------|-----------|-----------|
| [`C31-1st`](skills/core/C31-1st/) | 追本溯源的思考框架。当用户提到"第一性原理"、"本质"、"追本溯源"、"底层逻辑"、"为什么"、或需要从基本原理重新构建解决方案时触发。用于将复杂问题拆解... |  |  |
| [`C31-adopt-project`](skills/core/C31-adopt-project/) | 当用户提供 GitHub 项目链接或说"adopt", "看看这个项目", "研究这个项目", |  |  |
| [`C31-brainstorm`](skills/core/C31-brainstorm/) | brainstorm, ideate, 需求, discuss \| 讨论阶段：将模糊需求转化为带编号决策点的需求文档 | brainstorm, ideate, think through, discuss, discuss-phase | 需求, 讨论 |
| [`C31-coding-discipline`](skills/core/C31-coding-discipline/) | Use when the user expresses coding intent: '帮我写', '实现', '开发', '修复', 'fix', 'b... | fix, bug, coding, code | 帮我写, 实现, 开发, 修复, 写代码, 改代码 |
| [`C31-compound`](skills/core/C31-compound/) | solved, fixed, compound, 解决了 \| 知识固化：将已解决的问题记录为结构化文档供未来复用 | solved, fixed, working now, root cause, that worked, compound, document this | 解决了, 搞定了, 原来是因为, C一下 |
| [`C31-compound-refresh`](skills/core/C31-compound-refresh/) | compound refresh, 清理知识库 \| 双周维护：扫描memory/和skills/，去重、标记残留、输出健康报告 | compound refresh | 清理知识库, 双周维护 |
| [`C31-context-engineering`](skills/core/C31-context-engineering/) | context, 上下文, 变蠢 \| 上下文工程：在正确的时间给AI正确的信息，解决200K窗口组织不善问题 | context, context engineering | 上下文, 信息组织, 变蠢, 信息太多, 你好像忘了, 上下文不够了 |
| [`C31-debug`](skills/core/C31-debug/) | debug, bug, fix, 排查 \| 调试阶段：系统化错误追踪，从复现到根因到修复验证 | debug, bug, fix, trace this error, find the root cause, debugger | 排查, 为什么会报错, 报错 |
| [`C31-lfg`](skills/core/C31-lfg/) | lfg, 开干, let's go \| 一键执行：已有计划时全自动执行9门管道，无需中途确认 | lfg, let's go, auto execute | 开干, 直接执行, 跑起来 |
| [`C31-plan`](skills/core/C31-plan/) | plan, 制定计划, roadmap \| 规划阶段：将需求转化为带验证门和威胁建模的可执行计划 | plan, plan-phase, roadmap | 制定计划, 实现方案, 怎么实现, 分步 |
| [`C31-research`](skills/core/C31-research/) | research, 调研, 最佳实践 \| 统一研究：框架文档、git历史、社区问题、机构记忆、bug复现 | research, how should I | 调研, 最佳实践, 资料, 研究 |
| [`C31-spec`](skills/core/C31-spec/) | spec, 写需求, PRD \| 需求定义：任何新项目/功能/重大变更先写PRD，作为意图与实现的契约 | spec, PRD | 写需求, 产品文档, 定义项目 |
| [`C31-strategy`](skills/core/C31-strategy/) | Create or maintain STRATEGY.md for a project. Anchors all downstream C31-brai... |  |  |
| [`C31-work`](skills/core/C31-work/) | execute, implement, 实现, 开发 \| 执行阶段：读取计划，按依赖波次并行调度子代理执行 | execute, work on, implement, execute-phase, run | 实现, 开发 |
| [`C31-workflow-bug-reproduction`](skills/core/C31-workflow-bug-reproduction/) | Read-only workflow agent. Systematically reproduces bugs: hypothesize causes ... |  |  |

### 🔍 review/ — 多代理代码审查（3 个）

| 技能 | 描述 | 英文触发词 | 中文触发词 |
|------|------|-----------|-----------|
| [`C31-multi-review`](skills/review/C31-multi-review/) | multi-review, 代码审查 \| 4代理对抗审查：并行审查+冲突检测+统一裁决 | multi-review, review | 代码审查, 检查这个 |
| [`C31-review`](skills/review/C31-review/) | review, 审查, verify \| 审查阶段：并行多角色代码审查+UAT验证+覆盖率检查 | review, code review, verify, verify-work | 审查, 验证 |
| [`C31-review-security`](skills/review/C31-review-security/) | Security reviewer subagent for C31-review. Focus: exploitable vulnerabilities... |  |  |

### 📦 product/ — 产品与商业（10 个）

| 技能 | 描述 | 英文触发词 | 中文触发词 |
|------|------|-----------|-----------|
| [`c31-community`](skills/product/c31-community/) | Identify, evaluate, and select the right community to build a minimalist busi... |  |  |
| [`c31-grow`](skills/product/c31-grow/) | Evaluate business decisions through the lens of sustainable, profitable growt... |  |  |
| [`c31-gutcheck`](skills/product/c31-gutcheck/) | Review any business decision, plan, or strategy through the minimalist entrep... |  |  |
| [`c31-market`](skills/product/c31-market/) | Create a minimalist marketing plan focused on building an audience through au... |  |  |
| [`c31-mvp`](skills/product/c31-mvp/) | Guide building a minimum viable product the minimalist way — manual first, th... |  |  |
| [`c31-price`](skills/product/c31-price/) | Help set pricing for a product or service using minimalist entrepreneur princ... |  |  |
| [`c31-process`](skills/product/c31-process/) | Turn a product or service idea into a manual-first process that can be delive... |  |  |
| [`c31-sell`](skills/product/c31-sell/) | Create a strategy for selling to the first 100 customers using the minimalist... |  |  |
| [`c31-validate`](skills/product/c31-validate/) | Validate a business idea using the minimalist entrepreneur framework before b... |  |  |
| [`c31-values`](skills/product/c31-values/) | Help define company values and culture for a minimalist business. Use when th... |  |  |

### 🛠️ utils/ — 实用工具（7 个）

| 技能 | 描述 | 英文触发词 | 中文触发词 |
|------|------|-----------|-----------|
| [`find-skills`](skills/utils/find-skills/) | Highest-priority skill discovery flow. MUST trigger when users ask to find/in... | find-skill, find-skills, install skill, skill discovery | 技能, 找技能, 插件, 插件管理 |
| [`gsd-map-codebase`](skills/utils/gsd-map-codebase/) | Analyze an existing codebase and create brownfield mapping artifacts. |  |  |
| [`gsd-new-project`](skills/utils/gsd-new-project/) | new project, 新项目, init project, start project \| Initialize a new project with... | new project, init project, start project, bootstrap project | 新项目 |
| [`gsd-progress`](skills/utils/gsd-progress/) | progress, next step, what next, 下一步, 继续, gsd-progress \| Auto-detect the next ... | progress, next step, what next, gsd-progress, where are we | 下一步, 继续 |
| [`gsd-quick`](skills/utils/gsd-quick/) | quick, quickly, fast, 速战速决, 小事, 改一下, 查一下, 看一下, 简单, trivial, just do it \| Hand... | quick, quickly, fast, trivial, just do it | 速战速决, 小事, 改一下, 查一下, 看一下, 简单 |
| [`gsd-ship`](skills/utils/gsd-ship/) | Ship a completed phase or project. Finalize work, generate summary, |  |  |
| [`time-awareness`](skills/utils/time-awareness/) | today \| now \| current date \| 今天 \| 现在 — time-aware query execution policy | today, now, current date, current time | 今天, 现在, 当前时间, 当前日期, 最近, 过去, 接下来 |

### 🧑 personal/ — 个人专属（2 个）

| 技能 | 描述 | 英文触发词 | 中文触发词 |
|------|------|-----------|-----------|
| [`C31-loop`](skills/personal/C31-loop/) | 将 C31 接入 Loop Engineering 调度层，使其从"人工触发的 Harness"升级为"自主定时运行的 Loop System"。 通过 ... | c31-loop, loop init, loop, schedule, loop engineering | 定时运行, 后台运行, 自动运行, 接入loop, 让C31自动跑, 定时任务 |
| [`c31-sxs`](skills/personal/c31-sxs/) | 四寻思观（Four Inquiries）解构技能。用于对情绪、焦虑、执着、身份认同进行唯识宗式拆解。触发词：sxs, c31-sxs, 四寻思, 四寻思观... |  |  |

### ⚙️ platform-specific/ — 平台特定（2 个）

| 技能 | 描述 | 英文触发词 | 中文触发词 |
|------|------|-----------|-----------|
| [`kimiim`](skills/platform-specific/kimiim/) | Use this skill for any interaction with Kimi Group Chat or its Sessions, incl... |  |  |
| [`skillhub-preference`](skills/platform-specific/skillhub-preference/) | Prefer `skillhub` for skill discovery/install/update, then fallback to `clawh... | skillhub, skill preference, clawhub, skill source | 插件, 插件偏好 |


---

## 七大框架——C31 的来源

C31 融合了 7 个开源框架各自最好的思想，每个框架解决了拼图中的一块：

| 框架 | Stars | 对 C31 的核心贡献 | 深度阅读 |
|------|-------|-----------------|---------|
| **[12-Factor Agents](https://github.com/humanlayer/12-factor-agents)** | ~24k | 无状态归约器 · 上下文所有权 · 紧凑错误处理 | [第 1 篇 →](https://github.com/ChianW/C31-papers/blob/master/part1_12_factor_agents.md) |
| **[Superpowers](https://github.com/obra/superpowers)** | ~249k | 西奥迪尼心理学驱动的 AI 合规机制 | [第 2 篇 →](https://github.com/ChianW/C31-papers/blob/master/part2_superpowers.md) |
| **[ECC](https://github.com/affaan-m/ecc)** | ~225k | 本能进化系统 · 上下文健康颜色 | [第 3 篇 →](https://github.com/ChianW/C31-papers/blob/master/part3_ecc.md) |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | ~70k | 怀疑驱动开发 · Chesterton 围栏 · 反讨好机制 | [第 4 篇 →](https://github.com/ChianW/C31-papers/blob/master/part4_agent_skills.md) |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | ~23k | 头脑风暴→规划→执行→**简化**→审查→复利 生命周期 | [第 5 篇 →](https://github.com/ChianW/C31-papers/blob/master/part5_cep.md) |
| **[Archon](https://github.com/coleam00/Archon)** | ~23k | Agent 生命周期治理 · 禁止自主状态变更 | [第 6 篇 →](https://github.com/ChianW/C31-papers/blob/master/part6_archon.md) |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | ~6k | 上下文腐化 · 产物优先于记忆 · 计划质量门 | [第 7 篇 →](https://github.com/ChianW/C31-papers/blob/master/part7_gsd_core.md) |

加上 **Karpathy AI Skills** 作为贯穿所有层的基石工程哲学。

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

## Agent Harness Papers — 文章系列

10 篇文章，记录从问题到系统的全过程——C31 背后的框架，从第一性原理到最终综合。

| 篇目 | 标题 |
|------|------|
| [第 0 篇](https://github.com/ChianW/C31-papers/blob/master/part0_introduction.md) | 为什么你需要一个 Agent Harness |
| [第 1 篇](https://github.com/ChianW/C31-papers/blob/master/part1_12_factor_agents.md) | 12-Factor Agents — 架构宣言 |
| [第 2 篇](https://github.com/ChianW/C31-papers/blob/master/part2_superpowers.md) | Superpowers — 心理学黑客 |
| [第 3 篇](https://github.com/ChianW/C31-papers/blob/master/part3_ecc.md) | Everything Claude Code — 操作系统层 |
| [第 4 篇](https://github.com/ChianW/C31-papers/blob/master/part4_agent_skills.md) | Agent Skills — 反懒惰框架 |
| [第 5 篇](https://github.com/ChianW/C31-papers/blob/master/part5_cep.md) | Compound Engineering — 复利引擎 |
| [第 6 篇](https://github.com/ChianW/C31-papers/blob/master/part6_archon.md) | Archon — 确定性 AI 流水线 |
| [第 7 篇](https://github.com/ChianW/C31-papers/blob/master/part7_gsd_core.md) | GSD Core — 命名上下文腐化 |
| [第 8 篇](https://github.com/ChianW/C31-papers/blob/master/part8_comparison.md) | 7 个框架横向对比 |
| [第 9 篇](https://github.com/ChianW/C31-papers/blob/master/part9_building_c31.md) | 从零到 C31 |
| [第 10 篇](https://github.com/ChianW/C31-papers/blob/master/part10_the_architecture.md) | 架构 — 生产环境中的 C31 |
| [**第 11 篇**](https://github.com/ChianW/C31-papers/blob/master/part11_loop_engineering.md) | **从 Harness 到 Loop — 补齐自动化拼图** |

→ **[ChianW/C31-papers](https://github.com/ChianW/C31-papers)**

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
