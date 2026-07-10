---
name: gsd-new-project
description: new project, 新项目, init project, start project | Initialize a new project with GSD planning artifacts automatically.
triggers: new project, 新项目, init project, start project, bootstrap project
metadata: {"category": "gsd"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | new project, 新项目, init project, start project, bootstrap project |
| ZH | 新项目, 初始化项目 |
| JA | 新規プロジェクト, プロジェクト開始 |

> **Output language**: Respond automatically in the user's conversation language.

# gsd-new-project

Initialize a new project with GSD (Get Stuff Done) planning artifacts.

## When to Use

- User says "new project", "新项目", "init project", "start project"
- User wants to bootstrap a structured project workspace

## Workflow

### Step 1: Gather Project Idea

Ask the user: "What is your project idea?" (or accept from command arguments).

### Step 2: Check for Existing Planning Directory

Use `exec` to check if `memory/.planning/` already exists.

```bash
ls -la memory/.planning/ 2>/dev/null
```

If it exists, warn the user: "`memory/.planning/` already exists. Continuing will overwrite existing planning files. Proceed? (yes/no)"

If the user declines, stop here.

### Step 3: Create Planning Artifacts

Use the `write` tool to create each file.

#### PROJECT.md

```markdown
---
created: {{date}}
status: active
---

# {{project_name}}

## Vision

{{project_idea}}

## Goals

- [ ] Primary goal to be defined

## Context

- **Owner**: {{user}}
- **Started**: {{date}}

## Notes

_Add project notes here._
```

#### ROADMAP.md

```markdown
# Roadmap

## Phase 0: Foundation
- Project setup and planning

## Phase 1: Exploration
- Research and prototyping

## Phase 2: Build
- Core implementation

## Phase 3: Polish
- Testing and refinement

## Phase 4: Ship
- Launch and iterate
```

#### STATE.md

```markdown
# Current State

**Phase**: 0

## Active Tasks

_None yet._

## Blockers

_None._

## Last Updated

{{date}}
```

#### REQUIREMENTS.md

```markdown
# Requirements

## v1 (MVP)

- Core functionality to deliver initial value

## v2 (Next)

- Enhancements after initial feedback

## Out of Scope

- Features explicitly deferred
```

#### config.json

```json
{
  "project_name": "{{project_name}}",
  "created": "{{date}}",
  "default_model": "kimi/k2p6",
  "planning_dir": "memory/.planning",
  "auto_checkpoint": true
}
```

Replace `{{project_name}}`, `{{project_idea}}`, `{{user}}`, and `{{date}}` with actual values.

### Step 4: Confirm Output

Report back to the user:

```
✅ Project initialized: {{project_name}}

Created files:
- memory/.planning/PROJECT.md
- memory/.planning/ROADMAP.md
- memory/.planning/STATE.md
- memory/.planning/REQUIREMENTS.md
- memory/.planning/config.json

Next: Fill in PROJECT.md with details, then run `gsd-plan` to build a task plan.
```

## Rules

- Always ask for confirmation before overwriting `memory/.planning/`.
- Use the `write` tool to create files (do not use `exec` for file creation).
- Keep the initial artifacts lightweight; they are templates to be filled in.
- If no project name is provided, use a sanitized slug from the project idea or default to "untitled-project".
