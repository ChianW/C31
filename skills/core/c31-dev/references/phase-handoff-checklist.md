# 阶段交接检查清单

每个阶段结束时，C31 必须完成以下检查后才能提示用户进入下一阶段。

## Grill → Spec 交接

- [ ] 共识文档已写入 `memory/grill-sessions/`
- [ ] 新术语已录入 `memory/glossary.md`
- [ ] 关键决策已录入 `memory/decisions/`
- [ ] 与现有记忆的冲突已解决
- [ ] 用户明确确认"共识达成"或"跳过"

## Spec → Plan 交接

- [ ] PRD 已写入 `memory/.planning/phases/XX-PRD.md`
- [ ] PRD 验证门通过（可验证的成功标准 + 非空边界）
- [ ] 无与其他计划的冲突
- [ ] 用户明确确认"PRD OK"或"跳过"

## Plan → Work 交接

- [ ] Plan 已写入 `memory/.planning/phases/XX-YY-PLAN.md`
- [ ] Wave 分析完成
- [ ] Nyquist 验证完成（每个需求有测试覆盖）
- [ ] Plan-Checker 通过（或标记未解决项）
- [ ] 用户明确确认"Plan OK"或"跳过"

## Work → Done 交接

- [ ] 所有 Wave 完成
- [ ] 全量测试通过
- [ ] 最终 review 完成
- [ ] STATE.md 标记完成
- [ ] 总结输出
