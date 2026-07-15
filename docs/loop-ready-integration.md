# C31 与 Loop Engineering：从 Agent Harness 到 Loop-Ready System

*作者：C31 项目*  
*发布日期：2026-07-15*

---

## 引言：一句话改变了我们对 AI 工程的理解

> *"I don't prompt Claude anymore. I have loops running that prompt Claude. My job is to write loops."*  
> — Boris Cherny，Anthropic Claude Code 负责人

这句话道出了 AI 工程演化的下一个阶段：**从手动提示，到设计自动运行的控制系统**。

这也让我们重新审视 C31 是什么——以及它还缺什么。

---

## C31 是什么？Loop Engineering 是什么？

C31 是一个 **Agent Harness System**：一套让 AI agent 按纪律执行任务的框架。它定义了 12 门流水线、4 种编排模式、知识复利飞轮。它的设计哲学是"Autonomous by Default"——AI 默认全自主执行，人类只在关键决策点介入。

**Loop Engineering**（`cobusgreyling/loop-engineering`）则是另一个层次的框架：它研究的不是"单次任务如何执行"，而是**"谁来持续触发这些任务"**。

把它们放在完整的 AI 工程栈里：

```
Context Engineering    ← 模型看到什么？
Harness Engineering    ← 单次运行如何安全执行？    ← C31 主要在这里
Loop Engineering       ← 谁来持续触发和验证？       ← 这是 LE 的专长
Fleet Engineering      ← 多个 loop 如何协调？
```

C31 在 Harness 层做得很深，但缺少 Loop 层——没有自动触发机制，每次都需要人来说"开始"。

---

## 为什么整合？

我们做了一个精确的对比：

| 属性 | Loop Engineering | C31 |
|------|-----------------|-----|
| **State（状态持久化）** | STATE.md（简单 Markdown）| session_state + instincts + diary（更完整）|
| **Verification Chain** | 基础 Maker/Checker 分离 | 4 并行隔离 agent + 冲突检测（更强）|
| **Knowledge Flywheel** | 无 | Instinct System + Compound + INDEX（独有）|
| **Schedule（调度层）** | cron / GitHub Actions / 事件驱动 | ❌ 只有人工触发 |
| **Budget Control** | loop-budget.md（token 预算约束）| ❌ 无 |
| **Failure Mode Catalog** | 结构化失效模式（Thrashing/Surrender 等）| 只有 Error Tiers（粗粒度）|

C31 在内在能力上比 Loop Engineering 更强，但缺少**调度层**和**预算约束**这两块关键基础设施。

加上这两块，C31 就从"人触发的 Harness"升级为**真正自主运行的 Loop System**。

---

## 我们整合了什么？

### 1. L1/L2/L3 自主级别声明

每个 C31 skill 现在在 frontmatter 中声明自己的自主级别：

```yaml
# C31-lfg
autonomy_level: L3   # 全自动，无人值守

# C31-plan
autonomy_level: L2   # Plan gate 需要人类确认

# C31-research
autonomy_level: L1   # 只读报告，零副作用
```

| 级别 | 含义 | C31 技能示例 |
|------|------|------------|
| **L1** | 只读/只报告，零副作用 | C31-research, C31-review |
| **L2** | 执行，但关键决策点需要人类确认 | C31-plan, C31-coding-discipline, C31-debug |
| **L3** | 全自动，12 门完整 pipeline，无人值守 | C31-lfg, C31-loop |

**效果**：用户一眼就知道"这个技能会不会自动修改文件"，大幅降低信任建立的摩擦。

---

### 2. CONSTRAINTS.md — 项目级运行时约束绑定

C31 的全局约束在 `GEMINI.md` 里。但每个项目的"禁区"是不同的：这个项目不能碰 `payments/`，那个项目的 `db/migrations/` 是高风险路径。

现在，**C31-lfg 的 Gate 0 和 C31-coding-discipline 的 Step 1 都强制读取 `CONSTRAINTS.md`**：

```markdown
# CONSTRAINTS.md（项目根目录）

## Hard Stops
- Never edit files in /payments
- Never auto-merge to main

## Escalation Triggers
- Any change touching /db/migrations → require human review
```

如果项目根目录存在 `CONSTRAINTS.md`，C31 就以它为边界执行。不存在则退回全局规则。

**效果**：C31 的安全边界从个人级下沉到项目级，不同项目可以有不同的"禁区地图"。

---

### 3. Failure Mode Catalog — 结构化失效模式

我们在 `ERROR-GOVERNANCE.md` 中新增了 5 个 Loop Engineering 派生的失效模式：

| 模式 | 症状 | 防御 |
|------|------|------|
| **FM-L1: Infinite Fix Loop** | 同一修复失败 3+ 次，仍在重试 | 3 连续同类错误 → 强制停止 |
| **FM-L2: State Rot** | Loop 对过期 PR/任务采取行动 | 每次运行开始时验证 STATE.md |
| **FM-L3: Compound Without Recall** | 有文档但 AI 不读 | 无 INDEX 条目 = 文档不存在 |
| **FM-L4: Verifier Theater** | Verifier 批准了，但代码有问题 | 4 个隔离 agent，不信任自我报告 |
| **FM-L5: Notification Fatigue** | Loop 每次都通知，用户开始忽视 | L1 只更新 STATE.md，不创建 Issue |

**效果**：从"知道怎么处理错误"升级为"知道自己正在经历哪种失效"——从被动止损到主动识别。

---

### 4. c31-loop — 5 问访谈，一键接入 Loop Engineering

这是整合中最核心的新增技能。`c31-loop` 不是配置文件，而是一个**5 问访谈 → 自动部署**的完整流程：

```
用户：c31 loop init
         │
         ▼
  Q1: 这个 loop 做什么？      (daily-triage / dep-sweep / ci-watch...)
  Q2: 多久运行一次？          (每天 / 每6小时 / 每次 push...)
  Q3: 在哪个平台运行？        (GitHub Actions / Windows Task Scheduler)
  Q4: 失败时通知谁？          (GitHub Issue / 只更新 STATE.md / 不通知)
  Q5: Token 预算上限是多少？  (宽松 20k / 标准 8k / 严格 3k)
         │
         ▼
  自动生成：
  ├── STATE.md              ← loop 状态记忆
  ├── CONSTRAINTS.md        ← 运行时约束
  ├── loop-budget.md        ← token 预算
  ├── .github/workflows/c31-loop.yml   （如果选了 GitHub Actions）
  └── c31-loop-setup.ps1               （如果选了 Windows）
         │
         ▼
  "配置完成。运行 git push 激活 loop。"
```

**效果**：从"需要读文档手动配置 YAML"到"回答 5 个问题就完成部署"。

---

## C31 现在是什么？

**C31 现在是 Loop-Ready Agent Harness。**

它已经具备 Loop Engineering System 所需的全部内在能力：

```
完整 Loop = Harness + Schedule + State + Verification Chain
               ✅         ✅*        ✅           ✅
```

*（Schedule 层由 `c31-loop` 提供，用户选择是否接入）

与 Loop Engineering 框架相比，C31 在三个维度更深：

1. **State 更丰富**：`session_state + instincts + diary + solutions`，而不只是一个 `STATE.md`
2. **Verification 更强**：4 个并行隔离 agent + 冲突检测，而不只是 Maker/Checker 两分
3. **Knowledge 有飞轮**：Instinct System + Compound + Pre-Search，每次执行让下次更好

C31 不复制 Loop Engineering，而是在它之上构建。

---

## 一个具体的例子

假设你在开发一个 API 项目。配置 C31 loop 后，它每天早上 9 点：

1. 读取 `STATE.md`（上次运行的状态）
2. 读取 `CONSTRAINTS.md`（`/payments` 是禁区）
3. 扫描 CI 结果、open issues、未合并的 PR
4. 对可以自动处理的问题（小 bug、outdated deps）直接修复并提 PR
5. 对需要人类判断的问题创建 GitHub Issue，标记 `needs-human-review`
6. 更新 `STATE.md`，记录本次运行结果
7. 一切完成，不发任何通知（除非触发了 Escalation）

你早上打开电脑，GitHub 上已经有几个 draft PR 等你 review。

**这就是从 Harness 到 Loop 的区别**：不再是你驱动 AI，而是 AI 在你睡觉的时候已经帮你干完了例行工作。

---

## 总结

| | 整合前 | 整合后 |
|--|--------|--------|
| 定位 | Agent Harness System | **Loop-Ready Agent Harness** |
| 自主级别 | 隐式（需要读文档）| **L1/L2/L3 显式声明** |
| 约束范围 | 全局（GEMINI.md）| **全局 + 项目级（CONSTRAINTS.md）** |
| 失效识别 | Error Tiers（粗粒度）| **Failure Mode Catalog（精确命名）** |
| 调度接入 | 需要手动配置 | **`c31 loop init` 5 问自动部署** |

C31 仍然是"人机协作优先"的框架——你永远可以选择不接入调度层，让 AI 只在你主动触发时执行。但如果你准备好了，加上调度层只需要回答 5 个问题。

---

*相关文档：*
- [ERROR-GOVERNANCE.md](../ERROR-GOVERNANCE.md) — 完整失效模式目录
- [c31-loop skill](~/.gemini/config/skills/C31-loop/SKILL.md) — Loop 接入技能
- [Loop Engineering Analysis](loop_engineering_analysis.md) — 完整对比分析
