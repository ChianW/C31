# Scope Contract: C31-multi-review

## In Scope
- 4 independent reviewer subagents
- Conflict Agent contradiction detection
- Unified ruling with confidence scores

## Out of Scope
- Single-pass review (→ C31-review)
- Security-only review (→ internal)
- Architecture-only review (→ internal)

## Dependencies
- Pre: C31-work output
- Post: C31-lfg or C31-debug
- Mutex: C31-review