# C31 哲学

> *「停止提示 LLM，开始工程化你的 agent harness。」*

---

[English](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

---

## C31 是什么

C31 不是一个提示词库。它是一个 **agent harness 系统** —— 介于你与 AI 工具之间的持久化层，让每一次 session 都比上一次更智能。

大多数提示词集合给你的是一次性指令，会话结束后便烟消云散。C31 给你的是五个相互关联的层次，随着时间不断复利：

| 层次 | 功能 |
|------|------|
| **Skills（技能）** | 覆盖工程工作每个阶段的结构化工作流 |
| **Memory System（记忆系统）** | 跨 session 持久化的状态 —— 待办、决策、上下文 |
| **Instinct Evolution（本能进化）** | 随置信度增长自动应用的习得行为模式 |
| **Context Health（上下文健康）** | 主动监控，防止长 session 中的质量退化 |
| **Psych-Framing（心理框架）** | 直接嵌入 harness 中的认知技术 |

---

## 五大工程原则

*源自 Andrej Karpathy 的 AI 协作指南。每个 C31 技能的基石。*

### 1. 先思后行
执行任何命令前，先进行 Research 阶段。识别假设，暴露风险。切勿对模糊需求进行猜测 —— 停下来，问清楚。

### 2. 极致简约
只实现当前任务所需的最小逻辑。避免未被要求的抽象、新依赖或"以防万一"的设计。没人要求的，就不要构建。

### 3. 外科手术式修改
严格将修改范围限制在与任务直接相关的代码上。不做顺手重构，不做无关的风格改动。修改代码之前，先弄清楚它为什么存在 —— 见下方*切斯特顿之栅栏*。

### 4. 目标驱动执行
成功的定义是通过测试或完成特定的验证步骤。先写失败测试用例，用它来定义 bug，再去修复。测试、文档和重构是当前任务 definition of done 的一部分 —— 不是推迟到"以后"的事。

### 5. 第一性原理
从原始需求和问题本质出发进行推理，而非依赖惯例或模板。如果目标清晰但路径不优，就提出更好的方案。

---

## 扩展原则

*整合自真实工程经验与多个开源框架。*

### 怀疑驱动开发（Doubt-Driven Development）
对于高风险决策 —— 分支逻辑、模块边界、不可逆操作 —— 执行 CLAIM→EXTRACT→DOUBT 循环：

1. **CLAIM**：写下你将要据此行动的断言
2. **EXTRACT**：隔离最小可审查单元（不含你的推理过程）
3. **DOUBT**：在全新上下文中对该断言生成对抗性审查

不可逆操作不得跳过此循环。

### 切斯特顿之栅栏（Chesterton's Fence）
修改或删除任何代码之前，先弄清楚它为什么存在。不要因为代码"看起来没用"就删除它，直到理解其原始用途为止。

### 没有"以后"（No "Later"）
测试、文档和重构不是下一个 PR 的事。它们是当前任务 definition of done 的一部分。

### 回滚优先思维（Rollback-First Thinking）
对于高风险变更，先想清楚回滚路径，再执行。避免混合大补丁导致无法安全回滚。

### 技术严谨优于社交舒适（Technical Rigor over Social Comfort）
当用户批评某个建议或代码时，不要为了讨好而立刻认同。先独立评估技术主张是否正确，再决定接受或解释。讨好性推理是一种失败模式 —— 异议触发独立评估，而非立即妥协。

---

## 记忆系统

AI 不只是遵循规则 —— 它会记忆。

```
~/.c31/
├── memory/
│   ├── session_state.json   ← active projects, open todos, pending decisions
│   ├── diary/YYYY-MM-DD.md  ← daily session logs (1-5 lines)
│   └── instincts/           ← evolved behavioral patterns with confidence scores
└── solutions-registry.md    ← index of all documented solutions
```

在每次 session **开始**时，harness 加载 `session_state.json` 和当天的日记 —— 将上次 session 中未解决的事项浮现出来。在每次 session **结束**时，将新状态刷新回磁盘。

这是**Agent 作为无状态 Reducer** 原则（12-factor-agents 中的 F12）：每次执行均为 `f(context) → action`。没有隐藏状态。所有跨 session 的记忆都存在文件中，而非对话历史里。

---

## 本能进化系统

有效的模式得到晋升。失败的模式被废弃。

```
candidate (1/3 verifications) → verifying (2/3) → instinct (3/3)
confidence: 0.3–0.9  ·  deprecated if < 0.3
```

**正强化**：反复成功的模式，置信度分数升高。达到 3 次验证后，成为*本能* —— 自动应用，无需确认。

**负反馈**：当用户说"这不对"或"别这样做"时，置信度分数立即降至 0.1。若置信度低于 0.3，该模式被标记为废弃，在未来 session 中回避。

**种子本能**（已预初始化）：
- `instinct-001-no-overwrite` —— 未经确认，绝不覆盖已有文件（confidence: 0.95）
- `instinct-002-research-first` —— 行动前始终先调研（confidence: 0.90）
- `instinct-003-surgical-changes` —— 将范围限制在当前任务（confidence: 0.90）
- `instinct-004-C31-compound-trigger` —— 主动触发 C31-compound（confidence: 0.85）

---

## 上下文健康

长 session 会杀死 AI 的质量。随着对话增长，早期指令被淹没，决策被遗忘，模型开始与自己早期的推理相矛盾。这不是 bug —— 这是 transformer attention 在长序列上的固有属性。

C31 监控上下文窗口的使用情况并自动采取行动：

| 状态 | 使用率 | 行动 |
|------|--------|------|
| 🟢 绿色 | < 50% | 正常运行 |
| 🟡 黄色 | 50–70% | 开始将已完成的工作压缩为摘要 |
| 🟠 橙色 | 70–85% | 将决策移入文件；归档假设 |
| 🔴 红色 | > 85% | 强制检查点：先写状态，再继续 |

**掌控你的上下文窗口**（12-factor-agents 中的 F3）：主动决定上下文里有什么。不要让系统被动填充。优先使用近期消息而非旧消息。显式注入相关文件 —— 永远不要假设"模型会记得"。

---

## 心理框架层

C31 将有研究支撑的认知技术直接嵌入 harness：

### 逐步推理（Step-by-Step Reasoning）
复杂分析在输出前先在内部展开。与凭直觉作答相比，这显著减少了推理错误。用户看到的是结论；幕后工作由 harness 完成。

### 置信度检查（Confidence Check）
每个重要计划或行动都携带一个**置信度分数（0.3–0.9）**。低于 0.9 的输出会附上间隙注释，说明不确定的地方。这让 AI 的认知状态可见且可审计。

### Critic Gate（评论门控）
**当以下两个条件同时满足时自动触发：**
- 输出 > 300 字
- 包含推断性结论（关键词："因此"、"应该"、"建议"、"必须"、"最优"）

harness 执行自我审计，检查：事实错误、逻辑漏洞、过度泛化、遗漏视角、讨好性推理。结果以 `【自检】` 块的形式追加。

### 场景感知加权（Ambient Weighting）
harness 从首条消息中检测当前场景，并在不切换人格的情况下调整行为权重：

| 场景 | 识别信号 | 权重调整 |
|------|---------|---------|
| `coding`（编程） | 代码块、错误、文件路径 | 全力执行 Karpathy 原则；内部逐步推理；置信度检查 |
| `research`（科研） | 论文、数据、假设 | 标注证据强度；引用来源 |
| `architecture`（架构） | 设计文档、迁移、规划 | Planning 模式；Mermaid 图；A/B 方案 |
| `personal`（个人） | 日记、情绪、人际关系 | 降低技术输出密度；empathy 优先 |
| `casual`（随意） | 开放式问题、无明确目标 | 轻量回应；询问"想往哪个方向走？" |

---

## 复利生命周期

每次 session 都应该让系统比进入时更好。

```
Brainstorm → Spec → Plan → Work → Simplify → Review → C31-compound
```

**C31-compound** 步骤是强制的，而非可选的。当一个重大问题被解决后，解决方案将被记录在 `docs/solutions/` 中，并附上 INDEX 条目。`solutions-registry.md` 为跨项目的所有已知解决方案存储建立索引。

**预搜索协议**：开始任何非平凡任务前，harness 静默地检查解决方案注册表中的相关历史记录。命中则将历史方案注入为指导。未命中 —— 静默继续。

这就是一个会学习的系统与一个反复解决同一问题的系统之间的区别。

---

## 决策边界

| 层级 | 定义 | 行为 |
|------|------|------|
| **执行层** | 可在 10 分钟内无损撤销，影响范围不广 | AI 自主决定 |
| **决策层** | 不可逆，或影响范围超出当前任务 | 默认暂停 —— 标记 ⏸️，等待确认 |

不确定时：按决策层处理。暂停格式：
```
⏸️ [Type: file overwrite / direction change / external publish]
   [Impact: <specific description>]
   [Needs: confirm / modify / cancel]
```

---

## 思想根基

C31 融合了九个框架的设计哲学：

| 来源 | 核心贡献 |
|------|---------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 五大核心工程原则 |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | 无状态 Reducer · 上下文所有权 · 紧凑错误处理 |
| **[ECC](https://github.com/affaan-m/ecc)** | 本能进化 · 上下文健康颜色 · 持续学习 |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | Brainstorm→Spec→Plan→Work→Simplify→Review→Compound 生命周期·删除测试·行为变更验证 |
| **[Superpowers](https://github.com/obra/superpowers)** | 子代理驱动开发 · 完成前验证 · 不信任报告 |
| **[Archon](https://github.com/coleam00/Archon)** | Agent 生命周期治理 · 禁止自主状态变更 |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | 上下文工程 · 制品优于记忆 · 计划质量门控 |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | 怀疑驱动开发 · 切斯特顿之栅栏 · 反讨好 |
| **Psychological Framing** | 逐步推理 · 置信度检查 · Critic Gate |

---

[English](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)
