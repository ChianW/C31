---
name: C31-strategy
description: "Create or maintain STRATEGY.md for a project. Anchors all downstream C31-brainstorm, C31-plan, C31-brainstorm so they stay aligned to the project's actual goal. Use when starting a project, reviewing direction, or when prompts like '定战略', '写策略', 'strategy', '目标是什么', '这个项目到底要做什么', 'update strategy', 'what are we working on' appear. Also triggers when C31-brainstorm or C31-plan need upstream grounding and no STRATEGY.md exists."
argument-hint: "[optional: project name, or section to revisit, e.g. 'metrics' or 'approach']"
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | C31-strategy |
| ZH | 定战略, 写策略, 目标是什么 |
| JA | 戦略を立てる, ストラテジー, 目標設定 |

> **Output language**: Respond automatically in the user's conversation language.

# C31-strategy — 项目战略锚点

**当前年份：2026。**

## 用途

`C31-strategy` 生成并维护 `STRATEGY.md`——一个简短、持久的锚点文档，记录项目**是什么、服务谁、如何衡量成功、当前在做什么**。

一旦 `STRATEGY.md` 存在，后续 `C31-brainstorm`、`C31-brainstorm`、`C31-plan` 在执行时**自动读取它作为 grounding**，防止每次讨论都从零判断、方向漂移。

**文档保持简短是刻意设计的。** 好的 5 个问题比任何数量的 prose 都更能锁定战略。

---

## 核心原则

1. **锚点，不是计划**：战略是"做什么/为谁/为何"。功能列表属于 `C31-brainstorm`；排期属于 issue tracker。两者都不要进入这个文档。
2. **问题的严格性，而不是标题的严格性**：section 头是普通英文，但提问要有战略纪律——不接受模糊答案。
3. **短是功能**：整个文档读完应 < 5 分钟。拒绝扩充节数。
4. **跨运行持久**：可重复运行。第二次运行时在原地更新，保留有效部分，只挑战看起来过时或空洞的 section。

---

## 关于 Chian 的项目背景（Agent 内部参考）

Chian 当前活跃项目（可能出现在 session_state.json 的 active_projects 中）：

| 项目 | 性质 | 当前阶段 |
|------|------|---------|
| Antigravity Workflow | AI 工作流系统 | 持续迭代 |
| C31-Kimi Export | 导出/迁移工具 | 维护中 |
| Project Q | 个人品牌/内容 | 规划中 |
| Human OS | 内容/课程产品 | 构想中 |
| System Reboot | 个人系统重启 | 进行中 |
| 个人官网 | 落地页/展示 | 构建中 |
| 冈仁波齐旅游 | 旅行项目 | 规划中 |
| 京都大学 GSM | 学术申请 | 进行中 |

**语言策略**：英文为杠杆（触达全球），中文为高净值基本盘。
**位置**：旅居京都（Kyoto，UTC+9）。

在对话中识别出是哪个项目后，自动加载对应 `STRATEGY.md`（如果存在）。

---

## 执行流程

### Phase 0：路由

1. **从 Focus Hint 或对话上下文判断是哪个项目**
   - 如果用户指定了项目名 → 直接用
   - 如果不明确 → 问："是哪个项目？" 提供上面项目列表作为选项

2. **确定目标文件路径**
   - 如果是有 git repo 的项目 → `STRATEGY.md`（repo 根目录）
   - 如果是无代码的想法/规划项目 → `memory/.planning/STRATEGY.md`

3. **读取现有 STRATEGY.md（如果存在）**
   - 存在且完整 → 进入 **Update 模式**：只挑战看起来过时的 section
   - 存在但不完整 → 进入 **Fill-in 模式**：补完缺失的 section
   - 不存在 → 进入 **Create 模式**：完整访谈

### Phase 1：访谈（每次一个问题）

使用 `ask_user` 工具（Gemini CLI），每次只问一个问题。等待回答后再问下一个。

**问题 1 — Target Problem（目标问题）**
> 「这个项目要解决什么具体问题？用 1-2 句话描述用户处境和让这个问题棘手的核心矛盾。不要说解决方案。」
- 追问信号：答案里有解决方案语言、太宽泛（"让生活更好"）、没有具体用户处境

**问题 2 — Our Approach（我们的方法）**
> 「我们选择了什么具体路径来解决这个问题？哪些事情我们明确不做？」
- 追问信号：答案是功能列表而不是方法论、没有 trade-off、没有排除项

**问题 3 — Who It's For（受众）**
> 「主要用户是谁？用一句话描述他们"雇用"这个产品是为了完成什么工作（JTBD 格式：他们雇用 X 是为了...）」
- 追问信号：太宽（"所有人"）、没有具体处境、缺少 JTBD 动词

**问题 4 — Success Metrics（成功指标）**
> 「3 个月后，我们怎么知道这个项目成功了？给出 1-3 个具体可测量的指标。」
- 追问信号：虚假指标（"用户满意"）、没有数字/时间框架、无法观察

**问题 5 — Current Tracks（当前工作流）**
> 「现在有哪些并行推进的工作主线（tracks）？每条主线的当前状态是什么？」
- 这个问题允许列表；如果项目刚开始、还没有 tracks，可以跳过

### Phase 2：写文件

收集所有回答后，写入 `STRATEGY.md`（或 `memory/.planning/STRATEGY.md`）：

```markdown
---
name: {{project_name}}
last_updated: {{YYYY-MM-DD}}
project_type: {{software | content | personal | academic}}
---

# {{project_name}} Strategy

## Target problem

{{1-2 句诊断。命名用户处境和让问题棘手的核心矛盾。不含解决方案语言。}}

## Our approach

{{1-2 句指导政策。这个项目承诺做什么，从而让目标问题变得可处理。}}

## Who it's for

**Primary:** {{Persona 名称}} — {{一句话 JTBD，例如"他们雇用 X 是为了..."}}

<!-- 只有真正不同的次要 Persona 才加这一行 -->
<!-- **Secondary:** {{Persona}} — {{JTBD}} -->

## Success metrics

- {{指标 1：具体可测量，带时间框架}}
- {{指标 2}}
<!-- 最多 3 个。删除这一行如果不需要 -->

## Current tracks

<!-- 只有有明确并行工作流时才填这一节 -->
- **{{Track 名称}}** — {{一句话当前状态}}
- **{{Track 名称}}** — {{当前状态}}
```

**写文件规则：**
- 用用户自己的语言，不要改写成 PM 术语
- 删除所有没有答案的 optional section（不留空标题）
- `last_updated` 用今天的 ISO 日期
- 写完后，向用户确认路径

### Phase 3：Grounding 说明

写完后告诉用户：

```
✅ STRATEGY.md 已写入：{{路径}}

下次运行 C31-brainstorm 或 C31-plan 时，我会自动读取这个文档作为上下文。
不需要手动粘贴——战略会自动 ground 所有后续讨论。

需要更新某个 section？直接说「更新 strategy 的 metrics」即可。
```

---

## Update 模式（文件已存在时）

不重新问所有问题。只做：
1. 展示现有 `STRATEGY.md` 的摘要（每节一行）
2. 问：「哪些部分需要更新？」
3. 只针对指定 section 重新访谈
4. 保留其余内容不变
5. 更新 `last_updated` 字段

---

## 与其他 skills 的连接

- **C31-brainstorm / C31-brainstorm**：在 Phase 1 开始时，检查项目路径下是否有 `STRATEGY.md`。有则读取并在对话开头说：「已加载 {{project_name}} 的战略文档，以下讨论将基于它的方向展开。」
- **C31-plan / C31-plan**：同上，在 Research Phase 开始时自动加载。
- **C31-brainstorm**：在生成想法前读取，确保候选想法对齐 Target problem 和 Who it's for。

---

## Auto-invoke 触发词

```
定战略, 写策略, strategy, 目标是什么, 这个项目到底要做什么,
update strategy, what are we working on, 方向确认,
我们在做什么, 项目战略, 战略文档, 策略锚点
```
