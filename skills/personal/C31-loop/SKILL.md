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

# C31-loop — Loop Engineering One-Click Setup

> **Purpose**: C31 is a Loop-Ready Agent Harness. It already has State + Verification Chain + Knowledge Flywheel.
> This skill adds the **scheduling layer (Schedule)**, making it a complete Loop Engineering System.

---

## Hard Rules
1. **Ask only one question at a time** — never combine multiple questions.
2. **Every question must provide options** — reduce cognitive load for the user.
3. **Generate immediately after the interview** — once all 5 questions are answered, generate all files without further confirmation.
4. **Generate means deploy** — provide deployment commands that can be copied and pasted directly.
5. **Record decisions** — write all 5 answers into `loop-adr.md`, using the same ADR format as C31-grill.

---

## Phase 1 — Interview (Strictly one question at a time, in order)

Opening statement (fixed):
```
◆ C31 Loop Setup — 5-Question Configuration Interview
I will ask you 5 questions, then automatically generate all configuration files and provide deployment commands.
You don't need to write any configuration manually.

Ready? Question 1:
```

---

### Q1 — What task should this loop run?

```
What should this loop do?

  A) daily-triage    Scan issues/CI/commits daily and generate a report
  B) dep-sweep       Check for stale dependencies weekly and auto-open a PR
  C) ci-watch        Automatically analyze and attempt to fix CI failures
  D) changelog       Auto-generate release notes before each release
  E) custom          Custom task (I'll describe it)

Enter A/B/C/D/E:
```

→ Record the choice as `LOOP_PATTERN`

---

### Q2 — How often should it run?

```
How often should this loop run?

  A) Every weekday at 9 AM
  B) Every 6 hours
  C) On every push/PR
  D) Every Monday at 9 AM
  E) Custom (I'll describe it)

Enter A/B/C/D/E:
```

→ Convert the choice to a cron expression, record as `LOOP_CRON` and `LOOP_TRIGGER`

| Option | Cron | GitHub Trigger |
|--------|------|----------------|
| A | `0 9 * * 1-5` | schedule |
| B | `0 */6 * * *` | schedule |
| C | n/a | push + pull_request |
| D | `0 9 * * 1` | schedule |
| E | user-provided | user-provided |

---

### Q3 — Where should it run?

```
Which platform should this loop run on?

  A) GitHub Actions (project is already on GitHub — recommended)
  B) Windows Task Scheduler (local scheduled task)
  C) Both

Enter A/B/C:
```

→ Record as `LOOP_PLATFORM`

---

### Q4 — What happens on failure?

```
If the loop fails (3 consecutive errors of the same type), how should you be notified?

  A) Automatically create a GitHub Issue (recommended — keeps a record)
  B) Update STATE.md and stop; remind on next run
  C) Do nothing (I'll check the logs myself)

Enter A/B/C:
```

→ Record as `LOOP_ESCALATION`

---

### Q5 — What is the token budget?

```
How many tokens can each run consume at most? (The loop auto-stops when the limit is exceeded)

  A) Relaxed: 20k tokens per run (suitable for complex tasks)
  B) Standard: 8k tokens per run (suitable for daily triage)
  C) Strict: 3k tokens per run (report only, no execution)
  D) Unlimited

Enter A/B/C/D:
```

→ Record as `LOOP_BUDGET`

| Option | per-run tokens | Strategy |
|--------|---------------|----------|
| A | 20,000 | Allow actual fixes |
| B | 8,000 | Analysis + lightweight fixes |
| C | 3,000 | Report-only mode |
| D | unlimited | No limit |

---

## Phase 2 — Generate Files

After all 5 questions are answered, immediately output the following (no further user confirmation needed):

### Generation Notice

```
✓ Interview complete. Generating configuration files...

  ├── STATE.md              ← loop state memory
  ├── CONSTRAINTS.md        ← runtime constraints (forced read at the start of every loop)
  ├── loop-budget.md        ← token budget constraints
  ├── loop-adr.md           ← decision record for this configuration
  [If GitHub Actions was selected]:
  └── .github/workflows/c31-loop.yml
  [If Windows was selected]:
  └── c31-loop-setup.ps1    ← one-click Task Scheduler registration script
```

### Generation Logic

Fill in the templates below with the user's 5 answers and write them to the corresponding files.
See template files in the `references/` directory for details.

**Write path**: The root of the current workspace (i.e., the project directory the user is working in).
If `.github/workflows/` does not exist, create it automatically.

---

## Phase 3 — Deployment Commands

After files are generated, output the deployment commands for the selected platform:

### GitHub Actions

```bash
# 1. Commit and push (workflow activates automatically)
git add STATE.md CONSTRAINTS.md loop-budget.md loop-adr.md .github/
git commit -m "feat: add C31 loop engineering configuration"
git push

# 2. Add the following secret in GitHub repo Settings → Secrets:
#    ANTIGRAVITY_API_KEY = <your API Key>

# 3. Verify: go to the Actions tab to check the first workflow run
```

### Windows Task Scheduler

```powershell
# Run PowerShell as Administrator, then execute:
.\c31-loop-setup.ps1

# Verify the task is registered:
Get-ScheduledTask -TaskName "C31-Loop-*"
```

---

## Phase 4 — ADR Record

Write the 5-question decisions into `loop-adr.md`:
```markdown
# Loop Engineering ADR — C31 Loop Configuration

Date: {today's date}
Status: DEPLOYED

## Decisions

| # | Question | Decision | Rationale |
|---|----------|----------|-----------|
| D-01 | Loop Pattern | {LOOP_PATTERN} | User choice |
| D-02 | Cadence | {LOOP_CRON} | User choice |
| D-03 | Platform | {LOOP_PLATFORM} | User choice |
| D-04 | Escalation | {LOOP_ESCALATION} | User choice |
| D-05 | Budget | {LOOP_BUDGET} token/run | User choice |

## Generated Files
{list of generated files}
```

---

## Variable Substitution Reference
When generating files, replace the following placeholders with actual values:

| Placeholder | Source | Example Value |
|-------------|--------|---------------|
| `{{PATTERN}}` | Q1 answer | `daily-triage` |
| `{{CRON}}` | Q2 answer (converted) | `0 9 * * 1-5` |
| `{{TRIGGER_TYPE}}` | Q2 answer | `schedule` or `push` |
| `{{PLATFORM}}` | Q3 answer | `github-actions` |
| `{{ESCALATION}}` | Q4 answer | `create-issue` |
| `{{BUDGET_TOKENS}}` | Q5 answer | `8000` |
| `{{TODAY}}` | Current date | `2026-07-15` |
| `{{REPO_NAME}}` | git remote | `ChianW/C31` |
