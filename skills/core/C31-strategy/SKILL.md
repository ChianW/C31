---
name: C31-strategy
description: "Create or maintain STRATEGY.md for a project. Anchors all downstream C31-brainstorm, C31-plan, C31-brainstorm so they stay aligned to the project's actual goal. Use when starting a project, reviewing direction, or when prompts like '定战略', '写策略', 'strategy', '目标是什么', '这个项目到底要做什么', 'update strategy', 'what are we working on' appear. Also triggers when C31-brainstorm or C31-plan need upstream grounding and no STRATEGY.md exists."
argument-hint: "[optional: project name, or section to revisit, e.g. 'metrics' or 'approach']"
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | C31-strategy |
| ZH | 定战略, 写策略, 目标是什么 |
| JA | 戦略を立てる, ストラテジー, 目標設定 |

> **Output language**: Respond automatically in the user's conversation language.

# C31-strategy — Project Strategy Anchor

**Current year: 2026.**

## Purpose

`C31-strategy` generates and maintains `STRATEGY.md` — a short, durable anchor document recording **what the project is, who it serves, how success is measured, and what is currently being worked on**.

Once `STRATEGY.md` exists, subsequent `C31-brainstorm`, `C31-brainstorm`, and `C31-plan` executions **automatically read it as grounding** — preventing every discussion from starting from scratch and preventing direction drift.

**Keeping the document short is intentional.** Five well-formed questions lock in strategy better than any amount of prose.

---

## Core Principles

1. **Anchor, not plan:** Strategy is "what / for whom / why." Feature lists belong in `C31-brainstorm`; timelines belong in the issue tracker. Neither belongs in this document.
2. **Question rigor, not heading rigor:** Section headers are plain English, but the questions demand strategic discipline — vague answers are not accepted.
3. **Shortness is a feature:** The entire document should take < 5 minutes to read. Refuse to add new sections.
4. **Persistent across runs:** Idempotent. On the second run, update in-place — preserve what is still valid and only challenge sections that appear stale or hollow.

---

## Background: Chian's Active Projects (Agent Internal Reference)

Chian's currently active projects (may appear in `active_projects` in session_state.json):

| Project | Type | Current Phase |
|---------|------|---------------|
| Antigravity Workflow | AI workflow system | Ongoing iteration |
| C31-Kimi Export | Export/migration tool | Maintenance |
| Project Q | Personal brand / content | Planning |
| Human OS | Content / course product | Concept stage |
| System Reboot | Personal system reset | In progress |
| Personal Website | Landing page / showcase | Building |
| Kailash Trip | Travel project | Planning |
| Kyoto Univ. GSM | Academic application | In progress |

**Language strategy:** English as leverage (global reach), Chinese as high-value core base.
**Location:** Nomadic in Kyoto (UTC+9).

After identifying which project the conversation is about, automatically load the corresponding `STRATEGY.md` (if it exists).

---

## Execution Flow

### Phase 0: Route

1. **Determine which project it is from Focus Hint or conversation context**
   - If user specifies a project name → use it directly
   - If unclear → ask: "Which project?" and provide the project list above as options

2. **Determine the target file path**
   - If the project has a git repo → `STRATEGY.md` (at repo root)
   - If it is a no-code idea / planning project → `memory/.planning/STRATEGY.md`

3. **Read existing STRATEGY.md (if present)**
   - Exists and complete → enter **Update mode**: only challenge sections that appear stale
   - Exists but incomplete → enter **Fill-in mode**: complete missing sections
   - Does not exist → enter **Create mode**: full interview

### Phase 1: Interview (One Question at a Time)

Use the `ask_user` tool (Gemini CLI), asking only one question at a time. Wait for the answer before asking the next.

**Question 1 — Target Problem**
> "What specific problem does this project solve? Describe the user's situation and the core tension that makes this problem hard, in 1–2 sentences. Do not mention the solution."
- Follow-up signals: answer contains solution language, too broad ("make life better"), no concrete user situation

**Question 2 — Our Approach**
> "What specific path have we chosen to address this problem? What are we explicitly NOT doing?"
- Follow-up signals: answer is a feature list rather than a methodology, no trade-off, no exclusions

**Question 3 — Who It's For**
> "Who is the primary user? Describe in one sentence what they 'hire' this product to do (JTBD format: 'They hire X to...')"
- Follow-up signals: too broad ("everyone"), no concrete situation, missing JTBD verb

**Question 4 — Success Metrics**
> "In 3 months, how will we know this project succeeded? Give 1–3 specific, measurable indicators."
- Follow-up signals: vanity metrics ("user satisfaction"), no numbers / time frame, not observable

**Question 5 — Current Tracks**
> "What work tracks are being advanced in parallel right now? What is the current status of each?"
- This question allows a list; if the project is just starting and has no tracks yet, it can be skipped

### Phase 2: Write the File

After collecting all answers, write to `STRATEGY.md` (or `memory/.planning/STRATEGY.md`):

```markdown
---
name: {{project_name}}
last_updated: {{YYYY-MM-DD}}
project_type: {{software | content | personal | academic}}
---

# {{project_name}} Strategy

## Target problem

{{1–2 sentence diagnosis. Name the user's situation and the core tension that makes the problem hard. No solution language.}}

## Our approach

{{1–2 sentence guiding policy. What this project commits to doing, making the target problem tractable.}}

## Who it's for

**Primary:** {{Persona name}} — {{One-sentence JTBD, e.g., "They hire X to..."}}

<!-- Only add this line if there is a genuinely distinct secondary persona -->
<!-- **Secondary:** {{Persona}} — {{JTBD}} -->

## Success metrics

- {{Metric 1: specific and measurable, with time frame}}
- {{Metric 2}}
<!-- 3 max. Delete this line if not needed -->

## Current tracks

<!-- Fill this section only when there are clear parallel work streams -->
- **{{Track name}}** — {{one-sentence current status}}
- **{{Track name}}** — {{current status}}
```

**File-writing rules:**
- Use the user's own language; do not rewrite into PM jargon
- Delete all optional sections that have no answer (leave no empty headings)
- Use today's ISO date for `last_updated`
- After writing, confirm the path with the user

### Phase 3: Grounding Explanation

After writing, tell the user:

```
✅ STRATEGY.md written to: {{path}}

The next time C31-brainstorm or C31-plan runs, I will automatically read this document as context.
No need to paste it manually — the strategy will automatically ground all subsequent discussions.

Need to update a section? Just say "update strategy metrics" or similar.
```

---

## Update Mode (When File Already Exists)

Do not re-ask all questions. Only:
1. Display a summary of the existing `STRATEGY.md` (one line per section)
2. Ask: "Which sections need updating?"
3. Re-interview only for the specified sections
4. Leave all other content unchanged
5. Update the `last_updated` field

---

## Connection with Other Skills

- **C31-brainstorm / C31-brainstorm:** At the start of Phase 1, check whether `STRATEGY.md` exists in the project path. If so, read it and say at the top of the conversation: "Loaded the strategy document for {{project_name}}. The following discussion will be grounded in its direction."
- **C31-plan / C31-plan:** Same — automatically load at the start of the Research Phase.
- **C31-brainstorm:** Read before generating ideas, to ensure candidates align with Target problem and Who it's for.

---

## Auto-invoke Trigger Phrases

```
定战略, 写策略, strategy, 目标是什么, 这个项目到底要做什么,
update strategy, what are we working on, 方向确认,
我们在做什么, 项目战略, 战略文档, 策略锚点
```
