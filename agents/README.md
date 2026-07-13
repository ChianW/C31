# C31 Subagent Templates

This directory contains **ready-to-use subagent prompt templates** for C31's core orchestration patterns.

Each template is designed to be passed as the initial prompt when spawning a subagent. They are **self-contained** — a fresh agent with no prior context can execute them without needing to ask clarifying questions.

## Directory Structure

```
agents/
├── README.md               ← this file
├── memory/                 ← persistent memory layer (install to ~/.c31/)
│   ├── session_state.template.json
│   ├── solutions-registry.template.md
│   └── instincts/
│       ├── README.md
│       └── instinct-00X-*.md
├── reviewer/               ← C31-review subagent prompts
│   ├── correctness.md
│   ├── security.md
│   ├── architecture.md
│   ├── adversarial.md
│   └── simplicity.md
├── compound/               ← C31-compound extraction subagent prompts
│   ├── context-analyzer.md
│   ├── solution-extractor.md
│   └── docs-finder.md
└── debug/
    └── reproducer.md       ← C31-debug minimal reproduction subagent
```

## How Subagents Work in C31

C31's orchestration follows the **Do Not Trust the Report** principle:

> When a verifier subagent reviews an executor subagent's work, it must independently verify — never rely on the executor's self-report. "It's done" ≠ truly compliant with spec.

Each subagent receives:
1. A self-contained prompt (from this directory)
2. The minimum context needed to complete its specific task
3. A structured output schema (JSON or markdown)

No subagent shares context with another during execution. Findings are merged by the orchestrator **after** all subagents complete.

→ See [WORKFLOW.md](../WORKFLOW.md) for orchestration pattern details.
