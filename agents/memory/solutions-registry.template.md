# Solutions Registry

> Global index of all documented solutions. Used by the AI's **Solutions Pre-Search** protocol:
> before any non-trivial task, silently check this registry for prior art.

## Registered Solution Stores

| Path | Description | Last Updated |
|------|-------------|--------------|
| `~/your-project/docs/solutions/` | Project-specific solutions | — |

---

## How to Use

1. When `ce-compound` or `C31-compound` writes a new solution, add an entry above.
2. The AI checks this registry at the start of every non-trivial task.
3. On a cache hit → injects relevant solution into context automatically.

## Adding a New Store

```markdown
| `~/path/to/docs/solutions/` | Description of this project | YYYY-MM-DD |
```

Each store should have its own `INDEX.md` listing solutions by category.

---

*Empty by default — grows as you solve problems and run `ce-compound`.*
