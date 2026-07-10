# Cystem31 (C31)

**面向 AI 编程 Agent 的工程纪律工作流系统。**  
来自 10+ 个月的每日生产使用。驱动了 [chian.io](https://chian.io) 和 [chian.io/investment-os](https://chian.io/investment-os) 的全部内容。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-43-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#兼容平台)

---

## 用 C31 构建的项目

> 以下项目从设计、规划到交付，全部使用 C31 工作流完成：

| 项目 | 简介 | 使用的 C31 Skills |
|------|------|-----------------|
| **[chian.io](https://chian.io)** | 个人操作系统与知识平台 | C31-brainstorm · C31-plan · C31-work · C31-compound |
| **[chian.io/investment-os](https://chian.io/investment-os)** | AI 驱动的投资知识系统 | C31-spec · C31-review · C31-coding-discipline · C31-strategy |

*如果你用 C31 构建了项目，欢迎提 PR 添加到这里。*

---

## 什么是 Cystem31？

C31 是 43 个 skills（markdown 指令文件）的集合，为任何 AI 编程 Agent——Claude、Gemini、Kimi 等——提供结构化的工程纪律。

**它不是 prompt 库，而是系统化的思维方式：**

- **编码前**：头脑风暴需求，浮现假设，写清楚计划
- **编码中**：外科手术式修改，怀疑驱动决策，不留"以后再说"
- **编码后**：多角色 review，把解法复利沉淀为机构记忆

结果：每个 session 都有复利。今天记录的解法，为下周节省数小时。

---

## 快速安装

```bash
# 克隆并安装核心 skills（推荐起点）
git clone https://github.com/ChianW/Cystem31.git
cd Cystem31
./install.sh            # macOS / Linux
.\install.ps1           # Windows PowerShell

# 安装全部
./install.sh all

# 只安装产品/商业系列
./install.sh product
```

然后将 `AGENTS.template.md` 复制到项目根目录，重命名为：
- `GEMINI.md` → Gemini CLI / Antigravity
- `CLAUDE.md` → Claude Code / Codex
- `AGENTS.md` → OpenClaw / Hermes / Kimi CLI

---

## Skill 索引

### 🔧 core/ — 工程工作流（15 个）

| Skill | 触发词 | 功能 |
|-------|--------|------|
| C31-1st | `第一性原理`, `first principles` | 把问题拆解到公理级，从底层重新推导 |
| C31-brainstorm | `头脑风暴`, `brainstorm` | 将模糊需求转化为带编号决策点的需求文档 |
| C31-plan | `制定计划`, `plan` | 将需求转化为带验证门和威胁建模的可执行计划 |
| C31-spec | `写需求`, `spec` | 写 PRD，作为意图与实现的契约 |
| C31-work | `开干`, `work` | 带任务追踪和质量门控的计划执行 |
| C31-research | `调研`, `research` | 框架文档、git历史、社区问题、机构记忆统一调研 |
| C31-coding-discipline | `写代码`, `coding` | 7步 TDD 工作流 + 强制内联自审 |
| C31-debug | `调试`, `debug` | 从复现到根因到修复验证的系统化调试 |
| C31-compound | `复利`, `compound` | 记录已解决问题，复利团队知识 |
| C31-strategy | `定战略`, `strategy` | 创建 STRATEGY.md，锚定所有下游工作 |
| C31-lfg | `开干`, `lfg` | 计划就绪时全自动 9 门管道执行 |
| C31-context-engineering | `上下文`, `context` | 管理上下文健康状态，防止上下文腐化 |
| C31-adopt-project | `看看这个项目`, `adopt` | 五阶段调研：哲学→差距分析→整合 |
| C31-compound-refresh | `更新知识库` | 用新发现刷新现有 compound 文档 |
| C31-workflow-bug-reproduction | `复现bug`, `reproduce` | 假设→最小复现→验证根因 |

### 🔍 review/ — 代码审查（5 个）

| Skill | 触发词 | 功能 |
|-------|--------|------|
| C31-review | `审查`, `review` | 并行多角色审查 + UAT + 覆盖率检查 |
| C31-review-security | `安全审查` | 可利用漏洞、认证缺口、注入、XSS |
| C31-review-architecture | `架构审查` | 耦合、分层、抽象泄露、边界 |
| C31-review-adversarial | `对抗审查` | 故障传播、隐藏假设、TOCTOU |
| C31-multi-review | `多角色审查` | 4 代理对抗并行审查 + 冲突检测 |

### 💼 product/ — 产品与商业（11 个）

| Skill | 触发词 | 功能 |
|-------|--------|------|
| c31-community | `找社区` | 找到并验证合适的服务社区 |
| c31-validate | `验证想法` | 构建前先验证想法 |
| c31-mvp | `最小可行产品`, `MVP` | 手动优先 → 流程化 → 产品化 |
| c31-process | `流程化` | 将手动交付转化为可重复流程 |
| c31-sell | `前100客户` | 获取前 100 个付费用户的策略 |
| c31-market | `内容策略` | 以受众为核心的内容营销，不是广告 |
| c31-grow | `可持续增长` | 不烧钱、不burnout的可持续增长 |
| c31-price | `定价` | 基于价值的定价策略 |
| c31-gutcheck | `极简审查` | 用极简创业者视角审查任何决策 |
| c31-values | `价值观` | 定义文化与协作原则 |
| growth-hacker | `增长` | 系统化增长实验 |

### 🛠️ utils/ — 工具类（8 个）

`find-skills` · `time-awareness` · `gsd-map-codebase` · `gsd-new-project` · `gsd-progress` · `gsd-quick` · `gsd-ship` · `worker-safety`

### 🧘 personal/ — 个人工具（2 个）

`c31-sxs`（四寻思观——对情绪、执着和决策的佛教式解构）· `video-content-analysis`

---

## 核心哲学

> 完整内容：[PHILOSOPHY.md](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

**五条原则（来自 Karpathy）：**
1. **先思后行** — 每次行动前先做 Research
2. **极致简约** — 只实现所需的最小逻辑
3. **外科手术式修改** — 严格限定修改范围
4. **目标驱动** — 测试定义完成，而不是"跑起来了"
5. **第一性原理** — 从真相出发推理，而非依赖惯例

**加上**：怀疑驱动开发 · 切斯特顿之栅栏 · 无"以后" · 回滚优先 · 复利 Session

---

## 思想来源

C31 整合了以下项目的设计哲学与框架：

| 来源 | 核心贡献 |
|------|---------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 5 条核心工程原则 |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | 无状态 Reducer 模式、上下文所有权、错误压缩 |
| **[ECC](https://github.com/affaan-m/ecc)** | 持续学习循环、上下文健康系统、本能进化 |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | 头脑风暴→规划→执行→审查→复利 生命周期 |
| **[Superpowers](https://github.com/obra/superpowers)** | 子代理驱动开发、完成前验证 |
| **[Archon](https://github.com/coleam00/Archon)** | Agent 生命周期治理、禁止自主变更 |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | 上下文工程、Artifacts-over-Memory、计划质量门 |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | 怀疑驱动开发、切斯特顿之栅栏、反讨好模式 |
| **心理框架** | Step-by-step 推理、置信度检查输出验证 |

---

## 兼容平台

| 平台 | 安装 | AGENTS 文件 |
|------|------|------------|
| **Antigravity**（Gemini CLI） | `./install.sh` | `GEMINI.md` |
| **Claude Code** | `./install.sh` | `CLAUDE.md` |
| **Codex** | `./install.sh` | `CLAUDE.md` |
| **Kimi CLI** | `./install.sh` | `AGENTS.md` |
| **OpenClaw** | `./install.sh` | `AGENTS.md` |
| **Hermes** | `./install.sh` | `AGENTS.md` |

Windows 用户：使用 `.\install.ps1` 代替 `./install.sh`。

---

## 语言版本

- 🇺🇸 [English](README.md)
- 🇨🇳 [中文](README.zh.md)（当前页面）
- 🇯🇵 [日本語](README.ja.md)

---

## 参与贡献

1. Fork 本 repo
2. 在对应的 `skills/` 类别下添加你的 skill
3. 遵循 [SKILL.md 格式](skills/core/C31-brainstorm/SKILL.md)，包含三语触发词
4. 提 PR

用 C31 构建了项目？在上方的**用 C31 构建的项目**表格中添加你的项目。

---

## License

MIT — 查看 [LICENSE](LICENSE)
