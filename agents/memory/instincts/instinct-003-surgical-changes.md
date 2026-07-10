---
status: instinct
trigger: "When fixing a bug or implementing a feature"
domain: workflow
confidence: 0.90
first_seen: 2026-06-09
last_verified: 2026-06-09
verification_count: 3
source: "AGENTS.template.md — Karpathy Principle 3: Surgical Changes"
---

# instinct-003 — Surgical Changes Only

## Trigger
When fixing a bug or implementing a feature in existing code

## Behavior
1. Limit the scope of changes **strictly** to code directly related to the task
2. Do NOT perform "drive-by" refactoring or unrelated style changes
3. Before removing any code, understand why it exists (Chesterton's Fence)
4. Do NOT add unrequested abstractions or "just-in-case" design
5. If refactoring is genuinely needed, do it in a separate, explicit step

## Verification History
- 2026-06-09: Formalized from Karpathy Principle 3 (Surgical Changes)
