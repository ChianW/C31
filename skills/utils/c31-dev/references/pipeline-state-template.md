# Pipeline 状态文件模板

复制此模板，替换 `{project_name}` 和占位符。

```markdown
# Pipeline 状态 | {project_name}

## 当前阶段
grill | spec | plan | work | done

## 项目信息
- 启动日期：YYYY-MM-DD
- 评估复杂度：小型 | 中型 | 大型
- 选择模式：快速 | 标准 | 深度

## 已产出文档
- 共识文档：`memory/grill-sessions/YYYY-MM-DD-{topic}.md`
- PRD：`memory/.planning/phases/XX-PRD.md`
- Plan：`memory/.planning/phases/XX-YY-PLAN.md`

## 用户确认记录
- [ ] Grill 共识：confirmed | skipped | pending
- [ ] PRD 确认：confirmed | skipped | pending
- [ ] Plan 确认：confirmed | skipped | pending
- [ ] Work 启动：confirmed | skipped | pending

## 跳过/降级记录
| 阶段 | 操作 | 原因 | 风险评估 |
|------|------|------|---------|
| Grill | 跳过/降级 | {原因} | {风险} |
| Spec | 跳过/降级 | {原因} | {风险} |
| Plan | 跳过/降级 | {原因} | {风险} |

## 备注
{任何需要记录的额外信息}
```
