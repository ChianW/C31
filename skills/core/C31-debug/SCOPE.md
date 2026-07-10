# Scope Contract: C31-debug

## In Scope
- Root cause tracing (full causal chain)
- Test-first fix implementation
- Environment validation

## Out of Scope
- Feature development (→ C31-work)
- Code review (→ C31-review)
- Production incident response (escalate)

## Dependencies
- Pre: error report or user complaint
- Post: C31-compound (if novel bug)
- Mutex: none