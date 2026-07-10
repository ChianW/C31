---
status: instinct
trigger: "Session ends after modifying 2 or more files"
domain: knowledge
confidence: 0.85
first_seen: 2026-06-09
last_verified: 2026-06-09
verification_count: 3
source: "AGENTS.template.md — Project Completion Ritual: Knowledge Compounding"
---

# instinct-004 — Trigger ce-compound / C31-compound After Significant Work

## Trigger
When a session ends and ≥2 files were modified, OR a non-trivial bug was fixed, OR a design decision was made after multiple iterations

## Behavior
1. At session end, proactively offer to run `ce-compound` / `C31-compound`
2. Do NOT wait for the user to remember or ask
3. If the user confirms the solution works ("可以", "不错", "good"), run immediately
4. Write solutions to `docs/solutions/[category]/`
5. Add an entry to `docs/solutions/INDEX.md` — without this, the doc is invisible to future agents

## Verification History
- 2026-06-09: Formalized from Knowledge Compounding ritual
