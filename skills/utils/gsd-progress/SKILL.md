---
name: gsd-progress
description: progress, next step, what next, 下一步, 继续, gsd-progress | Auto-detect the next step in GSD workflow and suggest or execute it.
triggers: progress, next step, what next, 下一步, 继续, gsd-progress, where are we
metadata: {"category": "gsd"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | progress, next step, what next, 下一步, 继续, gsd-progress, where are we |
| ZH | 下一步, 继续, 进度 |
| JA | 次のステップ, 進捗確認 |

> **Output language**: Respond automatically in the user's conversation language.

# gsd-progress — Next-Step Detector

Detect where the project stands and suggest (or auto-execute) the next GSD command.

## When to Use

- User says "progress", "next step", "what next", "下一步", "继续", or runs `gsd-progress`
- After completing a phase and the user needs direction

## Workflow

### Step 1: Read Planning Files

Read `memory/.planning/STATE.md` and `memory/.planning/ROADMAP.md`.

If either file is missing, stop and report:
```
No active project found. Run `gsd-new-project` first to initialize planning artifacts.
```

### Step 2: Detect Current Phase

From `STATE.md`, extract:
- `Phase`: the numeric or named phase (e.g., "0", "1", "Exploration")
- `Status`: pending / discussed / planned / executed / verified / shipped

If `Status` is not explicitly stated, infer from the content:
- "Active Tasks: _None yet._" or no tasks marked done → **pending**
- Tasks exist but no implementation details → **discussed**
- Plan or task list is present and not yet executed → **planned**
- Code has been written or files modified → **executed**
- Review or testing completed → **verified**
- Deployed or released → **shipped**

### Step 3: Determine Next Command

| Status | Suggestion |
|--------|------------|
| **No project** (files missing) | `gsd-new-project` |
| **pending** | `ce-brainstorm` or `gsd-discuss-phase` |
| **discussed** | `ce-plan` or `gsd-plan-phase` |
| **planned** | `ce-work` or `gsd-execute-phase` |
| **executed** | `ce-code-review` or `gsd-verify-work` |
| **verified** | `gsd-ship` |
| **shipped** | "Project is shipped. Run `gsd-new-project` for a new project." |

### Step 4: Suggest or Execute

Check for `--auto` flag in arguments, or if the user message contains "auto".

- **Suggest mode** (default): Print the detected status and recommended command.
  ```
  📊 Current status: {phase_name} — {status}
  👉 Next step: {command}
  ```

- **Auto mode** (`--auto` or "auto"): Execute the recommended command directly.
  Report before executing:
  ```
  📊 Auto-detected status: {phase_name} — {status}
  🚀 Executing: {command}
  ```

## Rules

- Never modify `STATE.md` or `ROADMAP.md`.
- If status cannot be inferred, report "Unable to determine status" and ask the user to clarify.
- Keep output concise; show only status and next step.
- Under 300 lines total.
