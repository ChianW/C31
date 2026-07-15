# docs/solutions — Knowledge Base Index

> 每个解决方案文档均含 YAML frontmatter，支持按 `module`、`tags`、`problem_type` 搜索。
> **召回协议**：开始任何非平凡任务前，先在此 INDEX 查找相关历史记录。

---

## architecture-patterns/

架构和设计模式决策 — agent 系统结构、workflow 设计、skill 体系。

| 日期 | 文档 | 摘要 | Tags |
|------|------|------|------|
| 2026-07-15 | [loop-engineering-integration-2026-07-15.md](architecture-patterns/loop-engineering-integration-2026-07-15.md) | Loop Engineering 框架整合：autonomy_level 字段、CONSTRAINTS.md 加载、5 个失败模式、C31-loop 新 skill；C31 升级为 Loop-Ready Agent Harness | `loop-engineering` `autonomy-level` `constraints` `failure-modes` `c31-loop` `scheduling` |
| 2026-07-15 | [readme-skill-index-rewrite-2026-07-15.md](architecture-patterns/readme-skill-index-rewrite-2026-07-15.md) | README Skill Index 从无描述占位符重写为 6 分类 43 技能完整导航目录，每条目含链接 + 用途描述；维护规则和描述原则 | `readme` `skill-index` `documentation` `categorization` `navigation` |

---

## runtime-errors/

运行时错误、工具行为异常、文件操作失败。

| 日期 | 文档 | 摘要 | Tags |
|------|------|------|------|
| 2026-07-15 | [powershell-regex-utf8-markdown-corruption-2026-07-15.md](runtime-errors/powershell-regex-utf8-markdown-corruption-2026-07-15.md) | PowerShell `-replace` 配合 `\|` 模式操作 Markdown 表格导致 UTF-8 文件灾难性损坏（分隔符插入每个字符之间）；修复：`git checkout` 回滚 + Python 逐行处理 | `powershell` `regex` `utf-8` `markdown` `pipe-character` `git-checkout` `python-re` |

---

## 目录说明

| 目录 | 内容类型 |
|------|---------|
| `architecture-patterns/` | agent 架构、workflow 设计、skill 体系结构决策 |
| `runtime-errors/` | 运行时错误、工具异常、文件操作失败 |

*更多分类将随知识积累自动创建。*

---

*最后更新：2026-07-15 | 由 ce-compound 维护*
