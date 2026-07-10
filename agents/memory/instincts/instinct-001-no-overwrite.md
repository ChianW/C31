---
status: instinct
trigger: "When I am about to write to an existing file"
domain: file-safety
confidence: 0.95
first_seen: 2026-06-09
last_verified: 2026-06-09
verification_count: 3
source: "AGENTS.template.md — File Safety & Integrity (The Iron Law)"
---

# instinct-001 — Never Overwrite Without Confirmation

## Trigger
When I am about to write to a file that already exists

## Behavior
1. Check if file exists before writing
2. If it exists → classify: **Draft/Template** (can overwrite) vs **Finished Product** (never overwrite)
3. Files with structured elements (headings, dated entries, personal content) → treat as Finished Product
4. When in doubt → use `_v2` / `_alt` suffix to preserve both versions side-by-side
5. **Never** overwrite without explicit verbal or written confirmation from the user

## Verification History
- 2026-06-09: Formalized from AGENTS.template.md Iron Law
