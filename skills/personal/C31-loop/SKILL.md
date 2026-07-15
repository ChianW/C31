---
name: c31-loop
description: >
  将 C31 接入 Loop Engineering 调度层，使其从"人工触发的 Harness"升级为"自主定时运行的 Loop System"。
  通过 5 问访谈收集配置意图，自动生成 STATE.md、CONSTRAINTS.md、loop-budget.md，
  以及平台专属部署文件（GitHub Actions workflow 或 Windows Task Scheduler 脚本）。
  访谈结束后一键激活——C31 开始定时自主执行任务，无需人工干预。
triggers: c31-loop, loop init, loop, schedule, 定时运行, 后台运行, 自动运行, 接入loop, loop engineering, 让C31自动跑, 定时任务
autonomy_level: L2
---

# C31-loop — Loop Engineering 一键接入

> **定位**：C31 是 Loop-Ready Agent Harness。它已具备 State + Verification Chain + Knowledge Flywheel。
> 本 skill 为其加上**调度层（Schedule）**，使其成为完整的 Loop Engineering System。

---

## 硬性规则
1. **一次只问一个问题**——绝不合并提问。
2. **每问必须给出选项**——降低用户思考成本。
3. **问完即生成**——5 问结束后立刻生成所有文件，不再确认。
4. **生成即部署**——提供可直接复制粘贴的部署命令。
5. **记录决策**——将 5 个答案写入 `loop-adr.md`，格式同 C31-grill 的 ADR。

---

## Phase 1 — 访谈（严格按顺序，一次一问）

开场白（固定）：
```
◆ C31 Loop Setup — 5 问配置访谈
我会问你 5 个问题，然后自动生成所有配置文件并给出部署命令。
全程不需要你手动写任何配置。

准备好了吗？第 1 问：
```

---

### Q1 — 这个 loop 要执行什么任务？

```
这个 loop 要做什么？

  A) daily-triage    每日扫描 issues/CI/commits，生成报告
  B) dep-sweep       每周检查依赖老化，自动提 PR
  C) ci-watch        CI 失败后自动分析并尝试修复
  D) changelog       每次 release 前自动生成 release notes
  E) custom          自定义任务（我来描述）

请输入 A/B/C/D/E：
```

→ 将选择记录为 `LOOP_PATTERN`

---

### Q2 — 多久运行一次？

```
这个 loop 多久运行一次？

  A) 每天早 9 点（工作日）
  B) 每 6 小时
  C) 每次有新的 push/PR
  D) 每周一早 9 点
  E) 自定义（我来描述）

请输入 A/B/C/D/E：
```

→ 将选择转换为 cron 表达式，记录为 `LOOP_CRON` 和 `LOOP_TRIGGER`

| 选项 | Cron | GitHub 触发 |
|------|------|-------------|
| A | `0 9 * * 1-5` | schedule |
| B | `0 */6 * * *` | schedule |
| C | n/a | push + pull_request |
| D | `0 9 * * 1` | schedule |
| E | 用户提供 | 用户提供 |

---

### Q3 — 在哪里运行？

```
这个 loop 在哪个平台运行？

  A) GitHub Actions（项目已在 GitHub，推荐）
  B) Windows Task Scheduler（本机定时任务）
  C) 两个都要

请输入 A/B/C：
```

→ 记录为 `LOOP_PLATFORM`

---

### Q4 — 失败时怎么办？

```
loop 运行失败（连续 3 次同类错误）时，如何通知你？

  A) 自动创建 GitHub Issue（推荐，有记录）
  B) 更新 STATE.md 并停止，下次运行时提醒
  C) 什么都不做（我自己查日志）

请输入 A/B/C：
```

→ 记录为 `LOOP_ESCALATION`

---

### Q5 — Token 预算是多少？

```
每次运行最多消耗多少 token？（超限后 loop 自动停止）

  A) 宽松：每次 20k token（适合复杂任务）
  B) 标准：每次 8k token（适合日常 triage）
  C) 严格：每次 3k token（只报告，不执行）
  D) 不限制

请输入 A/B/C/D：
```

→ 记录为 `LOOP_BUDGET`

| 选项 | per-run token | 策略 |
|------|--------------|------|
| A | 20,000 | 允许实际修复 |
| B | 8,000 | 分析 + 轻量修复 |
| C | 3,000 | 纯报告模式 |
| D | unlimited | 无限制 |

---

## Phase 2 — 生成文件

5 问结束后，立刻输出以下内容（不需要用户再确认）：

### 生成提示

```
✓ 访谈完成。正在生成配置文件...

  ├── STATE.md              ← loop 状态记忆
  ├── CONSTRAINTS.md        ← 运行时约束（每次 loop 开始时强制读取）
  ├── loop-budget.md        ← token 预算约束
  ├── loop-adr.md           ← 本次配置的决策记录
  [如果选了 GitHub Actions]:
  └── .github/workflows/c31-loop.yml
  [如果选了 Windows]:
  └── c31-loop-setup.ps1    ← 一键注册 Task Scheduler 任务
```

### 生成逻辑

根据用户的 5 个答案，填充以下模板并写入对应文件。
详见 `references/` 目录中的模板文件。

**文件写入路径**：当前工作区根目录（即用户正在工作的项目目录）。
若 `.github/workflows/` 不存在则自动创建。

---

## Phase 3 — 部署指令

生成文件后，输出对应平台的部署命令：

### GitHub Actions

```bash
# 1. 提交并推送（workflow 自动激活）
git add STATE.md CONSTRAINTS.md loop-budget.md loop-adr.md .github/
git commit -m "feat: add C31 loop engineering configuration"
git push

# 2. 在 GitHub repo Settings → Secrets 中添加：
#    ANTIGRAVITY_API_KEY = <你的 API Key>

# 3. 验证：去 Actions tab 查看第一次 workflow 运行
```

### Windows Task Scheduler

```powershell
# 以管理员身份运行 PowerShell，然后执行：
.\c31-loop-setup.ps1

# 验证任务已注册：
Get-ScheduledTask -TaskName "C31-Loop-*"
```

---

## Phase 4 — ADR 记录

将本次 5 问的决策写入 `loop-adr.md`：
```markdown
# Loop Engineering ADR — C31 Loop Configuration

Date: {今天日期}
Status: DEPLOYED

## Decisions

| # | 问题 | 决策 | 理由 |
|---|------|------|------|
| D-01 | Loop Pattern | {LOOP_PATTERN} | 用户选择 |
| D-02 | Cadence | {LOOP_CRON} | 用户选择 |
| D-03 | Platform | {LOOP_PLATFORM} | 用户选择 |
| D-04 | Escalation | {LOOP_ESCALATION} | 用户选择 |
| D-05 | Budget | {LOOP_BUDGET} token/run | 用户选择 |

## Generated Files
{生成的文件列表}
```

---

## 变量替换对照表
执行生成时，用实际值替换以下占位符：

| 占位符 | 来源 | 示例值 |
|--------|------|--------|
| `{{PATTERN}}` | Q1 答案 | `daily-triage` |
| `{{CRON}}` | Q2 答案转换 | `0 9 * * 1-5` |
| `{{TRIGGER_TYPE}}` | Q2 答案 | `schedule` 或 `push` |
| `{{PLATFORM}}` | Q3 答案 | `github-actions` |
| `{{ESCALATION}}` | Q4 答案 | `create-issue` |
| `{{BUDGET_TOKENS}}` | Q5 答案 | `8000` |
| `{{TODAY}}` | 当前日期 | `2026-07-15` |
| `{{REPO_NAME}}` | git remote | `ChianW/C31` |
