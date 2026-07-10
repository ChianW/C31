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

# C31-adopt-project — 五阶段调研整合流水线

自动分析外部项目并生成结构化报告。报告自动生成，执行需用户确认。

## When to Use

- 用户发送 GitHub 项目链接
- 用户说 "adopt", "看看", "研究", "学习", "整合这个项目"
- 用户说 "这个项目是做什么的"

## When NOT to Use

- 项目明显不相关（纯游戏、纯硬件）
- README < 200 字、无明确架构或理念
- 用户说"不用调研，直接做 X"

## Workflow

### Phase 1: Discover（发现 — 全自动）

**输入:** GitHub URL
**输出:** 仓库摘要

**Steps:**
1. `kimi_fetch` README.md → 提取 elevator pitch（一句话核心理念）
2. **失败回退** — 如果 fetch 失败（404/反爬/私有）：
   - `kimi_search` "site:github.com {owner}/{repo}"
   - 从搜索结果提取描述和关键信息
   - 标记 `[FETCH_FALLBACK]` 在报告中
3. `kimi_fetch` docs/architecture.md 或 docs/ 下 .md（如有）
4. List 目录结构（从 README 或搜索结果的目录树）
5. 统计：skills/agents/references 数量、stars、license

**Stop-if:** 提取后仍 < 200 字有效信息 → 标记 "insufficient info"，输出简短摘要即停止。

### Phase 2: Analyze（分析 — 全自动）

**输入:** Phase 1 摘要
**输出:** 6 维度分析

| 维度 | 提取内容 | 输出格式 |
|------|---------|---------|
| Core Problem | 解决什么痛点？ | 一句话 |
| Design Philosophy | 核心信念 | 1-3 条 |
| Key Mechanisms | 关键机制 | 列表 |
| Target User | 给谁用的？ | 一句话 |
| Maturity | 成熟度 | 实验性 / 早期 / 生产级 |
| Integration Surface | 可借鉴元素 | skills? workflow? philosophy? |

**Red flag 检测：**
- "声称有 N 个功能但只看到 M 个" → 标记 `⚠️ N-M gap`
- 版本敏感项（如 "requires Node 20+", "仅支持 Claude"）→ 标记

### Phase 3: Gap Analysis（差距分析 — 全自动）

**输入:** Phase 2 的 6 维度 + C31 现有系统
**输出:** 差距矩阵

**对比维度（5 项）：**
1. **Skills** — 他们有 vs C31 有 → 映射表
2. **Workflow** — 内置流程 vs C31 流程 → 可直接复制 / 需适配 / 不适用
3. **Philosophy** — 理念补充 / 冲突分析
4. **Mechanism** — 具体机制（hooks, DAG, isolation）→ 对 C31 的启示
5. **Maturity** — 可立即用 / 需评估 / 忽略

**搜索 C31 系统：**
- `memory_search` "skill system" / "workflow" / "{project}"
- 检查 `skills/` 目录是否已有等效 skill

### Phase 4: Report + Gate（报告 + 确认 — 全自动输出报告，人工确认后执行）

**输入:** 差距矩阵
**输出:** 报告 + 整合方案建议

**Step 1: 生成报告**

保存到 `memory/moc/analysis-{project}-deep-dive.md`，结构：
```
1. 核心理念（一句话 + 设计哲学）
2. 实现框架（关键机制）
3. 全量清单（内置功能/workflow，关键演进）
4. 使用场景（典型场景）
5. 差距矩阵（vs C31）
6. 整合方案（建议分级：立即采用 / 短期补充 / 中期探索 / 忽略）
```

**第 6 章"整合方案"要求：**
- 基于差距矩阵生成**具体建议**（不是泛泛而谈）
- 每级分类含：建议项 + 理由 + 与 C31 现有系统的关联
- **不包含**具体文件位置/代码改动（那是 `C31-plan` 的工作）
- **不包含**预估时间和风险评级（避免看起来像执行计划）

**Step 2: 展示 Gate**

直接发送完整报告给用户，末尾附加：

```
---

## 整合方案建议

### [A] 立即采用（{N} 项）
- ...

### [B] 短期补充（{N} 项）
- ...

### [C] 中期探索（{N} 项）
- ...

### [D] 忽略（{N} 项）
- ...

**你选哪些？** 回复 "A" / "B" / "C" / "D" / "全部" / "都不做"
**或说"详细看 X"** 深入了解某一项。
```

**Step 3: 等待用户确认**

- **用户不回** → 不执行，报告已保存，流程自然结束
- **用户说"做 A" / "全部"** → 进入 `C31-plan` → `C31-work`
- **用户说"详细看 X"** → 进入 `C31-research` 深度调研
- **用户说"都不做"** → 停止，报告已保存

**Gate 规则：**
- ❌ 绝不自动执行任何文件修改
- ❌ 绝不覆盖现有 skills
- ✅ 仅当用户**明确选择**后才进入执行阶段

### Phase 5: Execute（执行 — 仅当用户确认后）

**输入:** 用户选择的整合项
**执行方式:** `C31-plan` → `C31-work` Wave 执行

**Wave 1（独立项，并行）:**
- 创建新 skills（子代理并行）
- 更新 AGENTS.md（轻量，直接 edit）
- 更新现有 skills（子代理并行）

**Wave 2（依赖 Wave 1，串行）:**
- 验证（`C31-review`）
- 文档更新（`C31-compound`）
- GBrain 增量导入

**After Execute:**
- 自动进入 `C31-compound` — 记录 adoption 过程
- 更新 `memory/.planning/STATE.md` — 标记新 skills

## 触发词（Trigger Phrases）

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
| "README 很长，分析太花时间" | Progressive disclosure — 先读 README 前 500 字，再按需深入。不是全读。 |
| "用户说'看看就行'，不用写报告" | 即使不整合，分析报告沉淀到 memory/moc/ 也有价值。3 个月后用户可能回来找。 |
| "fetch 失败 = 放弃" | 搜索降级是标准回退。不完美的信息 > 没有信息。 |
| "用户不回 Gate = 流程卡住" | 不回 = 不执行 = 正确。Gate 是为了安全阻塞，不是为了催促用户。 |
| "Phase 5 执行太慢，用户等不及" | 用户说"做"才执行，不是 AI 替用户决定。","等待"是正确的。 |

## Success Criteria

- 从触发到报告输出 ≤ 3 分钟
- fetch 失败率不影响完成（搜索降级覆盖）
- 报告直接发送完整版（不发梗概/摘要）
- Gate 阶段：用户不回 = 不执行 = 正确行为
- 执行阶段（Phase 5）：仅当用户**明确选择**后才启动
- 输出到 `memory/moc/analysis-{project}-deep-dive.md`

## Integration with C31 System

**报告生成后（Phase 4 Step 2 展示 Gate）：**
- **用户不回** → 不执行，报告已保存，流程自然结束
- **用户说"做 [A]" / "全部"** → 进入 `C31-plan` → `C31-work`
- **用户说"详细看 X"** → 进入 `C31-research` 深度调研
- **用户说"不用了"** → 停止，报告已保存

**Phase 5 执行时调用：**
- `C31-plan` — 生成执行计划
- `C31-work` — Wave 执行
- `C31-review` — 验证
- `C31-compound` — 记录 adoption 过程

## Example Runs

### Example 1: CEP (EveryInc) — 典型整合

```
User: https://github.com/EveryInc/compound-engineering-plugin
[C31-adopt-project 触发]
Phase 1: fetch README → 提取 elevator pitch（Compound Engineering Plugin）
Phase 2: 6 维度分析 → 40+ skills / 35+ agents / 多平台适配器 / 版本演进驱动
Phase 3: Gap 分析 → 对比 C31：已有 C31-brainstorm/plan/work 等，但缺少 lfg/slfg、多平台适配器、版本演进追踪
Phase 4: 生成报告 → 保存到 memory/moc/analysis-eep-deep-dive.md
  → 发送报告 + Gate：
      [A] 立即采用：引入 lfg（9 步全自动管道）
      [B] 短期补充：创建 C31-version-tracker（追踪 skill 版本演进）
      [C] 中期探索：多平台适配器架构（飞书/Discord/Telegram 统一抽象）
      [D] 忽略：Python 特定工具（C31 用 OpenClaw 工具集）
User: "做 A 和 B"
Phase 5: 进入 C31-plan → C31-work 执行
  → Wave 1: 创建 skills/C31-lfg/ + scripts/（并行）
  → Wave 2: C31-review 验证 + C31-compound 记录 adoption
```

### Example 2: Superpowers — 部分整合（Stage 5 Hooks）

```
User: https://github.com/obra/superpowers
[C31-adopt-project 触发]
Phase 1: fetch README → 提取 8 大 superpower + Stage 1-5 lifecycle
Phase 2: 6 维度分析 → CSO / No Placeholders / 3-fix / Hooks 框架
Phase 3: Gap 分析 → 对比 C31：已有 coding-discipline，但缺少 Stage 5 Hooks（session-compact, context-pressure-guard, daily-pulse 等）
Phase 4: 生成报告 → 保存到 memory/moc/analysis-superpowers-deep-dive.md
  → 发送报告 + Gate：
      [A] 立即采用：No Placeholders（已在 coding-discipline）
      [B] 短期补充：Stage 5 Hooks（auto-compound, context-pressure-guard, daily-pulse）
      [C] 中期探索：CSO 独立 skill（C31-cso）
      [D] 忽略：Electron/Puppeteer 特定依赖（C31 是 headless 工具调用）
User: "做 B"
Phase 5: 进入 C31-plan → C31-work
  → Wave 1: 创建 AGENTS/hooks/auto-compound.md + context-pressure-guard.md + daily-pulse.md（并行）
  → Wave 2: C31-review 验证 + C31-compound 记录
```

### Example 3: ECC (everything-claude-code) — 10 阶段管道

```
User: https://github.com/affaan-m/everything-claude-code
[C31-adopt-project 触发]
Phase 1: fetch README → 提取 10 阶段开发管道 + 3 阶段 Review Process
Phase 2: 6 维度分析 → Knowledge Graph / 10-stage pipeline / 3-stage review / 10-Minute Rules
Phase 3: Gap 分析 → 对比 C31：已有 brainstorm/plan/work/review，但缺少 Knowledge Graph、10-Minute Rules、Claude-specific 依赖注入
Phase 4: 生成报告 → 保存到 memory/moc/analysis-ecc-deep-dive.md
  → 发送报告 + Gate：
      [A] 立即采用：10-Minute Rules（任务分解粒度）
      [B] 短期补充：Knowledge Graph 索引（项目知识图谱）
      [C] 中期探索：3 阶段 Review 流程（Security/Architecture/Standards）
      [D] 忽略：MCP 生态特定集成（C31 用 OpenClaw 工具系统）
User: "做 A 和 C"
Phase 5: 进入 C31-plan → C31-work
  → Wave 1: 更新 C31-plan SKILL.md（加入 10-Minute Rules）+ 更新 C31-review（3 阶段流程）
  → Wave 2: C31-review 验证 + C31-compound 记录
```

### Example 4: gstack — 不整合（全部忽略）

```
User: https://github.com/garrytan/gstack
[C31-adopt-project 触发]
Phase 1: fetch README → 提取 6 层架构（Ideation→Spec→Stub→Tests→Implementation→Polish）
Phase 2: 6 维度分析 → GTD + LLM / Timeboxing / PRD 模板 / Context Window 管理
Phase 3: Gap 分析 → 对比 C31：
      - GTD：C31 已有 GSD 工作流（更完整的阶段门控）
      - Timeboxing：C31 已有 cron/heartbeat 调度
      - PRD 模板：C31 已有 ce-brainstorm → ce-plan 流程
      - Context Window：C31 已有 context-pressure-guard hook
      - 6 层架构：与 GSD Discuss→Plan→Execute→Verify→Ship 高度重叠
Phase 4: 生成报告 → 保存到 memory/moc/analysis-gstack-deep-dive.md
  → 发送报告 + Gate：
      [A] 立即采用：（无，C31 已有等效方案）
      [B] 短期补充：（无，功能重叠）
      [C] 中期探索：（无，架构理念相似）
      [D] 忽略：全部 — gstack 是完整 CLI 工具，与 C31 OpenClaw 架构不同，所有功能已有等效或更优方案
User: "都不做" / 不回
→ 不执行，报告已保存，流程自然结束
```

### Example 5: simota/agent-skills — 角色分析 + 多选执行

```
User: https://github.com/simota/agent-skills
[C31-adopt-project 触发]
Phase 1: fetch README → 提取目录结构（137 skills / 14 agents / Growth 4 角色）
Phase 2: 6 维度分析 → Lure 编排器 / Funnel 框架 / Crest 品牌 / Pulse KPI
Phase 3: Gap 分析 → 对比 C31：已有分发概念，但缺少 LP 设计、CTA 优化、社交证明层级
Phase 4: 生成报告 → 保存到 memory/moc/analysis-simota-deep-dive.md
  → 发送报告 + Gate：
      [A] 立即采用：Lure 9 阶段编排思想（映射到 C31-distribution）
      [B] 短期补充：Funnel 框架（AIDA/PAS/BAB/4Ps → C31-landing-page skill）
      [C] 中期探索：Growth SEO/SMO/CRO 技能矩阵
      [D] 忽略：Compete（竞争研究，C31 已有 C31-research 对比模式）
User: "全部"
Phase 5: 进入 C31-plan → C31-work Wave 执行
  → Wave 1: 创建 skills/C31-distribution/ + C31-landing-page/ + C31-growth-seo/（并行）
  → Wave 2: 更新 AGENTS.md 分发章节 + C31-compound 记录
  → Wave 3: C31-review 验证所有新 skills
```
