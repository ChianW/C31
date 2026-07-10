---
name: gsd-map-codebase
description: |
  Analyze an existing codebase and create brownfield mapping artifacts.
  Use when the user says "map codebase", "analyze codebase", "代码库分析",
  "brownfield", "existing code", or needs to understand a legacy project's
  structure, tech stack, conventions, and concerns.
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | gsd-map-codebase |
| ZH | 分析代码库, 代码库分析 |
| JA | コードベース分析 |

> **Output language**: Respond automatically in the user's conversation language.

# Map an Existing Codebase

Produce a durable reference of an existing codebase so future work doesn't
start from zero context. The output is a set of Markdown files in
`memory/.planning/codebase/`.

## When to Use

- User says "map this codebase", "analyze the repo", "what's in this project?"
- Before planning a refactor, migration, or major feature on a legacy codebase
- After inheriting a project with no documentation
- When onboarding a new contributor who needs orientation

## Execution Flow

### Phase 1: Scan

1. **Directory structure** — Run `find . -maxdepth 3 -type f` (or deeper as needed).
   Ignore `node_modules/`, `.git/`, `dist/`, `build/`, `__pycache__/`, `.venv/`.
2. **Tech stack markers** — Look for:
   - `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, etc.
   - `Dockerfile`, `docker-compose.yml`, `k8s/`, `helm/`
   - Config files (`vite.config.*`, `webpack.config.*`, `tsconfig.json`, etc.)
3. **Architecture signals** — Count of services/modules, entry points, API
   definitions, database schema files, message queue configs, event bus usage.

### Phase 2: Detect

**Tech Stack** (for STACK.md)
- Primary language(s) and versions
- Framework(s) and runtime
- Build tools and package managers
- Database(s), caches, message queues
- Deployment / CI platform(s)
- Testing frameworks

**Architecture** (for ARCHITECTURE.md)
- Pattern: monolith, modular monolith, microservices, serverless, etc.
- Communication style: REST, GraphQL, gRPC, events, message bus
- Data flow: where is state, where is compute, what is the boundary
- Key entry points and hot paths

**Conventions** (for CONVENTIONS.md)
- Naming: files, classes, functions, variables, branches
- Folder structure: by feature, by layer, by domain
- Import / module organization
- Code style (formatter, linter config if detectable)
- Commit message style if visible in git log

**Concerns** (for CONCERNS.md)
- Security: secrets in code, exposed ports, auth patterns
- Performance: synchronous blocking calls, N+1 queries, unbounded loops
- Debt: TODO/FIXME count, deprecated dependencies, code duplication
- Reliability: missing tests, error handling gaps, no retry logic
- Scalability: hardcoded limits, single points of failure

### Phase 3: Write Artifacts

Create directory `memory/.planning/codebase/` if it doesn't exist.
Write one file per topic. Each file uses YAML frontmatter:

```yaml
---
topic: <topic-name>
generated_at: <ISO-8601 timestamp>
---
```

**STACK.md** — Bulleted inventory of languages, frameworks, infra.
**ARCHITECTURE.md** — Narrative + a simple ASCII or bullet diagram.
**CONVENTIONS.md** — Patterns the team follows. Note deviations.
**CONCERNS.md** — Ranked by severity: High / Medium / Low. Include file paths.
**STRUCTURE.md** — Directory tree (pruned) with one-line purpose per directory.
**TESTING.md** — Test frameworks, coverage signals, mock strategy, gaps.

### Phase 4: Summarize

Return a concise summary:
- Lines of code / file count (approximate)
- Primary stack
- One-line architecture description
- Top 3 concerns
- Location of the artifact files

## Rules

1. **Never modify source code** — This skill is read-only.
2. **Label assumptions** — If you infer something without direct evidence, mark it `(assumption)`.
3. **Keep paths repo-relative** — Never absolute paths.
4. **Skip generated artifacts** — `node_modules`, `dist`, lockfiles are metadata only.
5. **Stay under 300 lines total output** across all files combined. Be terse.
6. **Idempotent** — Re-running should overwrite artifacts cleanly.

## Example Artifact (STACK.md)

```markdown
---
topic: stack
generated_at: 2026-05-19T01:30:00+08:00
---

# Tech Stack

- **Language**: TypeScript 5.4 (Node 20)
- **Framework**: Express + React 18 (Vite)
- **Package Manager**: pnpm
- **Database**: PostgreSQL 15 (Prisma ORM)
- **Cache**: Redis (ioredis)
- **Queue**: BullMQ on Redis
- **Testing**: Vitest + Playwright
- **CI**: GitHub Actions
- **Deploy**: Docker Compose on AWS EC2
```
