---
name: C31-compound
description: solved, fixed, compound, 解决了 | 知识固化：将已解决的问题记录为结构化文档供未来复用
triggers: solved, fixed, working now, root cause, that worked, compound, document this, 解决了, 搞定了, 原来是因为, C一下
metadata: {"category": "c31"}
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | solved, fixed, working now, root cause, that worked, compound, document this, 解决了, 搞定了, 原来是因为, C一下 |
| ZH | 复利, 记录知识, 总结 |
| JA | 知識を記録する, コンパウンド, まとめる |

> **Output language**: Respond automatically in the user's conversation language.

# C31-compound — Knowledge Compounding

Capture a recently solved problem as structured documentation so future
occurrences take minutes instead of research cycles.

## Preconditions

- Problem has been solved (not in-progress)
- Solution has been verified working
- Non-trivial problem (compound_score ≥ 15, or user insists)

## Auto-Draft Mode (Default)

When triggered by auto-invoke phrases (not manual command), enter lightweight
draft mode first.

**Behavior:**
1. Skip blocking questions
2. Extract from recent conversation context:
   - **Problem**: 1-2 sentence description
   - **Symptoms**: Observable symptoms
   - **What Didn't Work**: Failed attempts
   - **Solution**: Actual fix
3. **Duplicate detection:**
   - Use `memory_search` to query key words from the Problem description + core tool/filename from Solution
   - If a similar solution with **score > 0.7** is found:
     - Emit a brief note: `⚠️ Similar record detected: {filename} (date)`
     - Append options: `[Overwrite] update existing file / [Append] add new case study / [Skip] do not save`
     - **If user says "Overwrite"** → update existing file (append `last_updated: YYYY-MM-DD`, add new observations at end)
     - **If user says "Append"** → append a new case study block at end of existing file
     - **If user says "Skip" or no response (30s)** → discard current draft, do not save
     - Interrupt current Auto-Draft flow; next steps are user-driven
   - If no match or score ≤ 0.7 → continue to step 4
4. Auto-calculate **compound_score** = Severity × Frequency × Uniqueness × Scope
   - Severity: 1-5 (how bad was the problem)
   - Frequency: 1-5 (how likely to recur)
   - Uniqueness: 1-5 (how non-obvious was the solution)
   - **Scope: 1-5** (impact range: single file → cross-skill → systemic)
     - 1 = within a single file / single skill
     - 2-3 = across files or across skills
     - 4-5 = systemic / framework-level / affects multiple workflows
4. **Tiered auto-save:**
   - **compound_score ≥ 50** → trigger **Full Mode async execution**
     - Spawn background subagent to run Phases 0.5–4 (parallel research + full assembly)
     - Main conversation only emits: `✍️ High-value problem detected ({score} pts) — generating full compound doc in background...`
     - Completes silently; no further interruption
   - **15 ≤ compound_score < 50** → auto-save **lightweight version** to `memory/solutions/`, silently
     - Emit brief note: `✍️ Auto-recorded — {filename} (compound_score: {score})`
   - **compound_score < 15** → skip silently. No notification.

   **No checkpoint. No user selection.** The skill runs and completes without interruption.

**If user explicitly says "compound this" / "document this" / "保存" / "记录":**
→ Proceed directly to **Full Mode** (Phase 0.5 onwards), bypassing Auto-Draft tiering.

**If user explicitly says "skip" / "不要记" / "不用记录":**
→ Discard silently, no save, no notification.

## Full Mode (Manual or Selected)

When user chooses "Full" or invoked with "compound this" / "document this":

### Phase 0.5: Auto Memory Scan

Run `memory_search` with query matching the problem topic. If relevant entries
found, prepare labeled excerpt block for Phase 1 subagents.

### Phase 1: Parallel Research

**Critical: subagents return TEXT DATA only. Orchestrator writes files.**

🛑 **STOP**: Based on the problem description, make a preliminary determination of track type:
- Unexpected failure / error / abnormal behavior → **bug**
- Working pattern / best practice / design decision → **knowledge**
- Cannot determine → mark as `unknown`; let the Context Analyzer subagent make the final call

After recording the preliminary track determination, launch the following subagents:

Launch these subagents in parallel:

#### 1. Context Analyzer
- Determines track: **bug** (unexpected failure) or **knowledge** (pattern/guidance)
- Identifies: problem_type, component, category
- Suggests filename: `YYYY-MM-DD-[sanitized-slug].md`
- Returns: YAML frontmatter skeleton, category, track

#### 2. Solution Extractor
- Adapts output structure based on track:

**Bug track** sections:
- **Problem**: 1-2 sentence description
- **Symptoms**: Observable symptoms
- **What Didn't Work**: Failed attempts and why
- **Solution**: Actual fix with examples (before/after)
- **Why This Works**: Root cause explanation
- **Prevention**: Concrete strategies, test cases, lint rules

**Knowledge track** sections:
- **Context**: Situation that prompted guidance
- **Guidance**: Practice/pattern with examples
- **Why This Matters**: Rationale and impact
- **When to Apply**: Conditions where this applies
- **Examples**: Concrete before/after or usage

#### 3. Related Docs Finder
- Searches `memory/solutions/` for related documentation
- Uses grep/ripgrep for pre-filtering on `title:`, `tags:`, `problem_type:`
- Assesses overlap: **High** (same problem, update existing) / **Moderate** (related) / **Low** (distinct)
- Returns: links, relationships, refresh candidates

#### 4. Session History (optional)
Run `memory_search` with tight query (default: 7 days). Structure findings as:
- What was tried before
- What didn't work
- Key decisions

### Phase 2: Assembly & Write

**WAIT for all Phase 1 subagents to complete.**

1. Collect all Phase 1 text results
2. Check overlap assessment:
   | Overlap | Action |
   |---|---|
   | High | Update existing doc. Add `last_updated: YYYY-MM-DD`. |
   | Moderate/Low/None | Create new doc. |
3. Assemble complete markdown
4. Validate YAML frontmatter
5. Write to `memory/solutions/YYYY-MM-DD-[slug].md`

### Phase 3: Discoverability Check

Check whether AGENTS.md / MEMORY.md references `memory/solutions/`:
1. Read existing instruction files
2. Assess whether an agent would learn:
   - That a searchable knowledge store exists
   - Its structure (YAML frontmatter, category organization)
   - When to search it
3. If not met → draft smallest addition to communicate these three things

**Interactive mode:** Show proposed change, ask consent before editing.
**Headless mode:** Apply edit silently, surface in report.

### Phase 4: Project Integration (if .planning/ exists)

If `memory/.planning/` exists:
- Append a summary entry to `.planning/debug/knowledge-base.md`
- Format: `- YYYY-MM-DD: [title] (compound_score: X, file: solutions/...)`
- This links compound knowledge to active project tracking

## YAML Frontmatter Template

```yaml
---
compound_score: [1-125]
date: YYYY-MM-DD
category: [tooling | workflow | database | api | frontend | backend | security | performance | unknown]
problem_type: [brief-classification]
track: [bug | knowledge]
tags: [tag1, tag2]
status: [active | resolved | deprecated]
---
```

## Success Output

```
✓ Documentation complete

File: memory/solutions/YYYY-MM-DD-[slug].md  (created | updated)
Track: <bug | knowledge>
Category: <category>
compound_score: <score>
Overlap: <none | low | moderate | high — existing doc updated>
Knowledge-base: <not updated | appended to .planning/debug/knowledge-base.md>
```

## The Compounding Philosophy

```
Build → Test → Find Issue → Research → Improve → Document → Validate → Deploy
    ↑                                                                      ↓
    └──────────────────────────────────────────────────────────────────────┘
```

Each unit of work should make subsequent units easier — not harder.

## Error Handling

This skill follows the [AGENTS/error-handling.md](../AGENTS/error-handling.md) standard.

### Common Error Codes

| Error Code | Trigger Scenario | Handling Strategy |
|------------|-----------------|-------------------|
| `API_TIMEOUT` | `memory_search` / file operation timeout | Wait 4s and retry, max 2 times |
| `RATE_LIMITED` | API rate limiting (search, subagents) | Wait 10s and retry |
| `VALIDATION_FAILED` | YAML frontmatter validation failure | Fix parameters and retry |
| `RESOURCE_NOT_FOUND` | File / data does not exist | Check path; escalate if unrecoverable |
| `CONTEXT_OVERFLOW` | Long session context exceeds limit | Compress and retry, or process in chunks |
| `SUBAGENT_FAILED` | Phase 1 subagent failed | Check subagent logs; retry at most once |

### Escalation Conditions

- Same `error_code` fails 2 times in a row → force escalate on the 3rd
- `retry_count` reaches `max_retries` → escalate
- Non-recoverable errors (PERMISSION_DENIED, SECURITY_BLOCKED, etc.) → escalate immediately

### Fallback Chain

| Primary | Fallback | Condition |
|---------|----------|-----------|
| `memory_search` | `exec` + `grep/ripgrep` | `API_TIMEOUT` / `RATE_LIMITED` |
| `kimi_fetch` | `web_fetch` | `API_TIMEOUT` / `NETWORK_ERROR` |
| `read` (large file) | `read` + offset/limit | `CONTEXT_OVERFLOW` |

### If-Then Failure Mode Fallbacks

| Condition | Trigger Scenario | Action |
|-----------|-----------------|--------|
| User selects [skip] | User explicitly declines in Auto-Draft mode | Immediately discard draft; do not save; do not spawn subagents; flow terminates |
| compound_score < 15 and user doesn't insist | Low-value problem; user has no strong desire to record | Only display draft content; do not pre-recommend [1]; wait for user to actively choose |
| `memory/.planning/` is not writable | Directory permission / path error during Phase 4 project integration | Fall back to `/tmp/c31-compound-fallback/` for temporary save; prompt user to migrate manually |
| Related doc search times out | Phase 0.5 `memory_search` times out or API fails | Skip Phase 0.5; proceed directly to Phase 1; subagents handle context on their own |

## Anti-Pattern Blacklist

The following anti-patterns are **strictly forbidden** during C31-compound execution:

1. **❌ Never record unverified solutions**
   - User says "should be fine" but hasn't actually tested it → do not record; mark as `pending_verification`
   - Must see "solved" / "verified" or equivalent confirmation before entering draft flow

2. **❌ Never skip user confirmation in Auto-Draft mode**
   - Even a draft must be shown to the user with [1]-[4] options
   - Silent saving is forbidden; bypassing pre-select recommendation logic is forbidden

3. **❌ Never modify the original SKILL.md file content**
   - compound only writes to `memory/solutions/`; it does not modify `skills/C31-compound/SKILL.md`
   - If a bug is found in the skill itself → go through the normal fix process; do not patch it via compound

4. **❌ Never record "solutions" from pure casual chat / emotional expressions**
   - "I understand" / "I see" / "Thanks" → do not trigger compound
   - There must be a reusable technical / process / cognitive output

5. **❌ Never forcefully save when user explicitly says "don't record / skip"**
   - User selects [skip] → immediately discard draft; do not write to any file
   - User says "stop recording" / "no need to record" → equivalent to [skip]; do not ask again or try to retain

### Blacklist Violation Consequences

| Violation | Consequence |
|-----------|-------------|
| Items 1, 4 | Draft is invalid; do not enter Phase 2 |
| Items 2, 5 | User trust degrades; future auto-invoke sensitivity decreases |
| Item 3 | Skill system contamination; requires manual rollback |

## Auto-Invoke

<auto_invoke>
<trigger_phrases>
- "that worked"
- "it's fixed"
- "working now"
- "problem solved"
- "solved"
- "fixed"
- "root cause"
- "解决了"
- "搞定了"
- "原来是因为"
- "根因是"
- "终于找到原因"
- "原来要这样"
- "没想到是"
- "错在"
</trigger_phrases>
<manual_override>
Invoke with: "compound this" or "document this solution" or "记录"
</manual_override>
</auto_invoke>
