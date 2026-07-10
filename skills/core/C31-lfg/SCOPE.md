# Scope Contract: C31-lfg

## In Scope
- 9-gate shipping checklist
- Pre-launch validation
- Go / No-Go decision support

## Out of Scope
- Post-launch monitoring (→ cron)
- Rollback execution (→ C31-work)
- Marketing / distribution (→ c31-market, not in core 20)

## Dependencies
- Pre: C31-review passed
- Post: none (terminal skill for release)
- Mutex: gsd-quick