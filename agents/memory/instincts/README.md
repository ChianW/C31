# C31 Instinct Index

> **Behavioral Instinct System** — Automated behavioral rules extracted from user corrections and repeated patterns.
> Adapted from: everything-claude-code continuous-learning-v2 + C31

Evolution path: `candidate (1/3)` → `verifying (2/3)` → `instinct (3/3)` → auto-applied, no confirmation needed

---

## Instinct Index

| File | Trigger | Status | Confidence | Domain |
|------|---------|--------|------------|--------|
| `instinct-001-no-overwrite.md` | About to write to an existing file | **instinct** | 0.95 | file-safety |
| `instinct-002-research-first.md` | Receiving a complex or multi-file modification request | **instinct** | 0.90 | workflow |
| `instinct-003-surgical-changes.md` | Fixing a bug or implementing a feature | **instinct** | 0.90 | workflow |
| `instinct-004-compound-trigger.md` | Session ends after modifying ≥2 files | **instinct** | 0.85 | knowledge |

> These 4 are seed instincts included with C31. Add your own as you use the system.

---

## Three-Level Upgrade Protocol

| Level | Count | Behavior |
|-------|-------|----------|
| candidate | 1/3 | Suggested but not enforced |
| verifying | 2/3 | Applied when relevant |
| instinct | 3/3 | Auto-applied, no confirmation |

## Reset Rules
- User explicitly corrects → immediately drop to 0, deprecate the instinct
- No time decay — active correction mechanism is sufficient

## Domain Tags
- `file-safety` — file operation safety, overwrite confirmation, version preservation
- `workflow` — task execution, scope control, research-first
- `knowledge` — knowledge compounding, ce-compound trigger timing
- `user-communication` — communication patterns, when to clarify
- `reasoning` — inference quality, evidence standards

---

## Adding a New Instinct

1. Create `instinct-XXX-name.md` in this directory (use the template below)
2. Add a row to the table above
3. After 3 successful applications, upgrade status to `instinct`

### Template

```markdown
---
status: candidate
trigger: "When I am about to [specific situation]"
domain: workflow
confidence: 0.5
first_seen: YYYY-MM-DD
last_verified: YYYY-MM-DD
verification_count: 1
source: "User correction / Pattern observed"
---

# instinct-XXX — [Short Name]

## Trigger
When I [specific situation]

## Behavior
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Verification History
- YYYY-MM-DD: [What happened that confirmed this]
```
