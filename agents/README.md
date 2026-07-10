# C31 Memory System — `agents/`

This directory contains the **persistent memory layer** of C31.
Copy it to your home directory and configure the path in `AGENTS.template.md`.

```
~/.cystem31/          ← recommended location
├── memory/
│   ├── session_state.json    ← cross-session state (read at start, written at end)
│   ├── diary/                ← daily session logs (YYYY-MM-DD.md)
│   │   └── YYYY-MM-DD.md
│   ├── instincts/            ← evolved behavioral patterns
│   │   ├── README.md         ← instinct index
│   │   └── instinct-XXX-name.md
│   └── solutions-registry.md ← index of all documented solutions
└── (your AGENTS.template / GEMINI.md / CLAUDE.md)
```

## Quick Setup

```bash
mkdir -p ~/.cystem31/memory/diary
mkdir -p ~/.cystem31/memory/instincts
cp agents/memory/session_state.template.json ~/.cystem31/memory/session_state.json
cp agents/memory/instincts/README.md ~/.cystem31/memory/instincts/README.md
cp agents/memory/solutions-registry.template.md ~/.cystem31/memory/solutions-registry.md
```

Then in your `AGENTS.template.md`, update the paths:
```
Session State: ~/.cystem31/memory/session_state.json
Diary:         ~/.cystem31/memory/diary/YYYY-MM-DD.md
Instincts:     ~/.cystem31/memory/instincts/
Solutions:     ~/.cystem31/memory/solutions-registry.md
```

## How It Works

| File | Read | Written | Purpose |
|------|------|---------|---------|
| `session_state.json` | Session start | Session end | Active projects, todos, last topic |
| `diary/YYYY-MM-DD.md` | If today's exists | Session end | Daily log, 1–5 lines per session |
| `instincts/` | Always (auto-applied) | When patterns detected | Evolved behavioral rules |
| `solutions-registry.md` | Before non-trivial tasks | After ce-compound runs | Index of solved problems |

---

> 🇨🇳 See also: [AGENTS.template.zh.md](../AGENTS.template.zh.md) for Chinese memory system documentation.
