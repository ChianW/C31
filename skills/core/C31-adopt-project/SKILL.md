---
name: C31-adopt-project
description: |
  当用户提供 GitHub 项目链接或说"adopt", "看看这个项目", "研究这个项目",
  "整合", "学习这个项目"时，自动进行五阶段调研：提取核心哲学 → 差距分析
  → 生成报告 → 门控确认 → 执行整合。报告保存到 memory/moc/，执行需用户确认。

  MUST trigger when user sends github.com URL or says "adopt", "看看",
  "研究这个项目", "整合这个项目", "学习这个项目".
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | C31-adopt-project |
| ZH | 看看这个项目, 研究这个项目 |
| JA | プロジェクト調査, このプロジェクトを調べる |

> **Output language**: Respond automatically in the user's conversation language.

# C31-adopt-project — Five-Phase Research Integration Pipeline

Automatically analyze an external project and generate a structured report. Reports are generated automatically; execution requires user confirmation.

## When to Use

- User sends a GitHub project link
- User says "adopt", "look at this", "research", "learn", "integrate this project"
- User says "what does this project do"

## When NOT to Use

- Project is clearly unrelated (pure game, pure hardware)
- README < 200 words with no clear architecture or philosophy
- User says "no need to research, just do X"

## Workflow

### Phase 1: Discover (Fully Automatic)

**Input:** GitHub URL  
**Output:** Repository summary

**Steps:**
1. `kimi_fetch` README.md → extract elevator pitch (one-sentence core concept)
2. **Failure fallback** — if fetch fails (404 / anti-scraping / private):
   - `kimi_search` "site:github.com {owner}/{repo}"
   - Extract description and key info from search results
   - Mark `[FETCH_FALLBACK]` in report
3. `kimi_fetch` docs/architecture.md or .md files under docs/ (if present)
4. List directory structure (from README or search result directory tree)
5. Statistics: count of skills / agents / references, stars, license

**Stop-if:** After extraction, still < 200 words of valid information → mark "insufficient info", emit brief summary, and stop.

### Phase 2: Analyze (Fully Automatic)

**Input:** Phase 1 summary  
**Output:** 6-dimension analysis

| Dimension | What to Extract | Output Format |
|-----------|----------------|---------------|
| Core Problem | What pain point does it solve? | One sentence |
| Design Philosophy | Core beliefs | 1–3 items |
| Key Mechanisms | Key mechanisms | List |
| Target User | Who is it for? | One sentence |
| Maturity | Maturity level | Experimental / Early / Production |
| Integration Surface | What can be borrowed? | skills? workflow? philosophy? |

**Red flag detection:**
- "Claims N features but only M visible" → mark `⚠️ N-M gap`
- Version-sensitive items (e.g., "requires Node 20+", "Claude only") → mark

### Phase 3: Gap Analysis (Fully Automatic)

**Input:** Phase 2's 6 dimensions + existing C31 system  
**Output:** Gap matrix

**Comparison dimensions (5 items):**
1. **Skills** — what they have vs. what C31 has → mapping table
2. **Workflow** — built-in flows vs. C31 flows → direct copy / needs adaptation / not applicable
3. **Philosophy** — philosophical complement / conflict analysis
4. **Mechanism** — specific mechanisms (hooks, DAG, isolation) → implications for C31
5. **Maturity** — immediately usable / needs evaluation / ignore

**Search C31 system:**
- `memory_search` "skill system" / "workflow" / "{project}"
- Check if `skills/` directory already has an equivalent skill

### Phase 4: Report + Gate (Automatic report output; execution requires user confirmation)

**Input:** Gap matrix  
**Output:** Report + integration recommendation

**Step 1: Generate Report**

Save to `memory/moc/analysis-{project}-deep-dive.md`, structure:
```
1. Core philosophy (one sentence + design principles)
2. Implementation framework (key mechanisms)
3. Full inventory (built-in features/workflows, key evolution)
4. Use cases (typical scenarios)
5. Gap matrix (vs. C31)
6. Integration recommendation (tiered suggestions: adopt now / short-term / mid-term / ignore)
```

**Chapter 6 "Integration Recommendation" requirements:**
- Generate **specific suggestions** based on the gap matrix (not vague generalizations)
- Each tier includes: suggested item + rationale + relation to C31's existing system
- **Does NOT include** specific file locations / code changes (that is `C31-plan`'s job)
- **Does NOT include** time estimates or risk ratings (to avoid looking like an execution plan)

**Step 2: Display Gate**

Send the complete report directly to the user, appended with:

```
---

## Integration Recommendation

### [A] Adopt Now ({N} items)
- ...

### [B] Short-term Addition ({N} items)
- ...

### [C] Mid-term Exploration ({N} items)
- ...

### [D] Ignore ({N} items)
- ...

**Which do you choose?** Reply "A" / "B" / "C" / "D" / "All" / "None"
**Or say "more detail on X"** to dive deeper into an item.
```

**Step 3: Wait for User Confirmation**

- **User doesn't reply** → do not execute; report is saved; flow ends naturally
- **User says "do A" / "all"** → enter `C31-plan` → `C31-work`
- **User says "more detail on X"** → enter `C31-research` for deeper investigation
- **User says "none"** → stop; report is saved

**Gate Rules:**
- ❌ Never automatically execute any file modifications
- ❌ Never overwrite existing skills
- ✅ Only enter the execution phase after the user **explicitly selects** an option

### Phase 5: Execute (Only after user confirmation)

**Input:** User's selected integration items  
**Execution method:** `C31-plan` → `C31-work` Wave execution

**Wave 1 (independent items, parallel):**
- Create new skills (subagents in parallel)
- Update AGENTS.md (lightweight, direct edit)
- Update existing skills (subagents in parallel)

**Wave 2 (depends on Wave 1, sequential):**
- Validation (`C31-review`)
- Documentation update (`C31-compound`)
- GBrain incremental import

**After Execute:**
- Automatically enter `C31-compound` — record the adoption process
- Update `memory/.planning/STATE.md` — mark new skills

## Trigger Phrases

```
- "https://github.com/..." (any GitHub URL)
- "adopt"
- "看看这个项目"
- "研究这个项目"
- "学习这个项目"
- "整合这个项目"
- "这个项目是做什么的"
- "看看 https://github.com/..."
```

## Anti-Rationalization

| Excuse | Counter-Argument |
|--------|------------------|
| "The README is long; analysis takes too much time" | Progressive disclosure — read the first 500 words of the README, then go deeper as needed. Not a full read. |
| "User said 'just take a look,' no need for a full report" | Even without integration, a saved analysis in memory/moc/ has future value. The user may return in 3 months. |
| "Fetch failed = give up" | Search fallback is the standard fallback. Imperfect information > no information. |
| "User didn't reply to Gate = flow is stuck" | No reply = no execution = correct. The Gate is a safety block, not a prompt to rush the user. |
| "Phase 5 execution is too slow; user can't wait" | Execute only when user says "do it" — the AI doesn't decide for the user. "Waiting" is the correct behavior. |

## Success Criteria

- From trigger to report output ≤ 3 minutes
- Fetch failure rate doesn't block completion (search fallback covers it)
- Report sent as a complete version (not a summary/abstract)
- Gate phase: user no reply = no execution = correct behavior
- Execution phase (Phase 5): only starts after user **explicitly selects** an option
- Output to `memory/moc/analysis-{project}-deep-dive.md`

## Integration with C31 System

**After report generation (Phase 4 Step 2 displaying Gate):**
- **User doesn't reply** → do not execute; report is saved; flow ends naturally
- **User says "do [A]" / "all"** → enter `C31-plan` → `C31-work`
- **User says "more detail on X"** → enter `C31-research` for deeper investigation
- **User says "never mind"** → stop; report is saved

**Phase 5 execution calls:**
- `C31-plan` — generate execution plan
- `C31-work` — Wave execution
- `C31-review` — validation
- `C31-compound` — record adoption process

## Example Runs

### Example 1: CEP (EveryInc) — Typical Integration

```
User: https://github.com/EveryInc/compound-engineering-plugin
[C31-adopt-project triggered]
Phase 1: fetch README → extract elevator pitch (Compound Engineering Plugin)
Phase 2: 6-dimension analysis → 40+ skills / 35+ agents / multi-platform adapters / version-evolution driven
Phase 3: Gap analysis → vs. C31: already has C31-brainstorm/plan/work etc., but lacks lfg/slfg, multi-platform adapters, version evolution tracking
Phase 4: Generate report → save to memory/moc/analysis-eep-deep-dive.md
  → Send report + Gate:
      [A] Adopt Now: introduce lfg (9-step fully automatic pipeline)
      [B] Short-term: create C31-version-tracker (track skill version evolution)
      [C] Mid-term: multi-platform adapter architecture (unified abstraction for Feishu/Discord/Telegram)
      [D] Ignore: Python-specific tools (C31 uses OpenClaw toolset)
User: "do A and B"
Phase 5: Enter C31-plan → C31-work execution
  → Wave 1: create skills/C31-lfg/ + scripts/ (parallel)
  → Wave 2: C31-review validation + C31-compound records adoption
```

### Example 2: Superpowers — Partial Integration (Stage 5 Hooks)

```
User: https://github.com/obra/superpowers
[C31-adopt-project triggered]
Phase 1: fetch README → extract 8 superpowers + Stage 1–5 lifecycle
Phase 2: 6-dimension analysis → CSO / No Placeholders / 3-fix / Hooks framework
Phase 3: Gap analysis → vs. C31: already has coding-discipline, but lacks Stage 5 Hooks (session-compact, context-pressure-guard, daily-pulse, etc.)
Phase 4: Generate report → save to memory/moc/analysis-superpowers-deep-dive.md
  → Send report + Gate:
      [A] Adopt Now: No Placeholders (already in coding-discipline)
      [B] Short-term: Stage 5 Hooks (auto-compound, context-pressure-guard, daily-pulse)
      [C] Mid-term: CSO as standalone skill (C31-cso)
      [D] Ignore: Electron/Puppeteer-specific dependencies (C31 is headless tool-call based)
User: "do B"
Phase 5: Enter C31-plan → C31-work
  → Wave 1: create AGENTS/hooks/auto-compound.md + context-pressure-guard.md + daily-pulse.md (parallel)
  → Wave 2: C31-review validation + C31-compound records
```

### Example 3: ECC (everything-claude-code) — 10-Stage Pipeline

```
User: https://github.com/affaan-m/everything-claude-code
[C31-adopt-project triggered]
Phase 1: fetch README → extract 10-stage development pipeline + 3-stage Review Process
Phase 2: 6-dimension analysis → Knowledge Graph / 10-stage pipeline / 3-stage review / 10-Minute Rules
Phase 3: Gap analysis → vs. C31: already has brainstorm/plan/work/review, but lacks Knowledge Graph, 10-Minute Rules, Claude-specific dependency injection
Phase 4: Generate report → save to memory/moc/analysis-ecc-deep-dive.md
  → Send report + Gate:
      [A] Adopt Now: 10-Minute Rules (task decomposition granularity)
      [B] Short-term: Knowledge Graph index (project knowledge graph)
      [C] Mid-term: 3-stage Review process (Security/Architecture/Standards)
      [D] Ignore: MCP ecosystem-specific integrations (C31 uses OpenClaw tool system)
User: "do A and C"
Phase 5: Enter C31-plan → C31-work
  → Wave 1: update C31-plan SKILL.md (add 10-Minute Rules) + update C31-review (3-stage process)
  → Wave 2: C31-review validation + C31-compound records
```

### Example 4: gstack — No Integration (All Ignored)

```
User: https://github.com/garrytan/gstack
[C31-adopt-project triggered]
Phase 1: fetch README → extract 6-layer architecture (Ideation→Spec→Stub→Tests→Implementation→Polish)
Phase 2: 6-dimension analysis → GTD + LLM / Timeboxing / PRD template / Context Window management
Phase 3: Gap analysis → vs. C31:
      - GTD: C31 already has GSD workflow (more complete phase gating)
      - Timeboxing: C31 already has cron/heartbeat scheduling
      - PRD template: C31 already has C31-brainstorm → C31-plan flow
      - Context Window: C31 already has context-pressure-guard hook
      - 6-layer architecture: highly overlaps with GSD Discuss→Plan→Execute→Verify→Ship
Phase 4: Generate report → save to memory/moc/analysis-gstack-deep-dive.md
  → Send report + Gate:
      [A] Adopt Now: (none — C31 already has equivalent)
      [B] Short-term: (none — functional overlap)
      [C] Mid-term: (none — similar architectural philosophy)
      [D] Ignore: All — gstack is a complete CLI tool; architecture differs from C31 OpenClaw; all features already have equivalent or better solutions
User: "none" / no reply
→ Do not execute; report saved; flow ends naturally
```

### Example 5: simota/agent-skills — Role Analysis + Multi-select Execution

```
User: https://github.com/simota/agent-skills
[C31-adopt-project triggered]
Phase 1: fetch README → extract directory structure (137 skills / 14 agents / Growth 4 roles)
Phase 2: 6-dimension analysis → Lure orchestrator / Funnel framework / Crest brand / Pulse KPI
Phase 3: Gap analysis → vs. C31: already has distribution concept, but lacks LP design, CTA optimization, social proof hierarchy
Phase 4: Generate report → save to memory/moc/analysis-simota-deep-dive.md
  → Send report + Gate:
      [A] Adopt Now: Lure 9-stage orchestration concept (map to C31-distribution)
      [B] Short-term: Funnel framework (AIDA/PAS/BAB/4Ps → C31-landing-page skill)
      [C] Mid-term: Growth SEO/SMO/CRO skill matrix
      [D] Ignore: Compete (competitive research — C31 already has C31-research comparison mode)
User: "all"
Phase 5: Enter C31-plan → C31-work Wave execution
  → Wave 1: create skills/C31-distribution/ + C31-landing-page/ + C31-growth-seo/ (parallel)
  → Wave 2: update AGENTS.md distribution section + C31-compound records
  → Wave 3: C31-review validates all new skills
```
