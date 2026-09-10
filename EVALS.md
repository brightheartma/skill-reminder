# Skill Reminder Evaluation Cases

These cases are small behavioral checks for the reminder policy. Run them in a host that has a visible inventory of installed skills. The exact skill names available to a host may differ; the expected behavior is about relevance, restraint, and permission boundaries.

## 中文

每次测试都应使用同一批已安装 Skill，并记录 Agent 当时能看到的名称、描述和调用策略。合格结果不要求固定措辞，但要求满足“只提醒真正相关的 Skill，通常不超过三个”的边界。

| Case | Prompt | Expected behavior |
| --- | --- | --- |
| C1 | 实现一个需要跨模块修改的新功能，先帮我拆解方案。 | 可提醒架构设计、领域建模或规划类 Skill；不要列出完整 Skill 清单。 |
| C2 | 这个 Node.js API 偶发返回 500，请先诊断，不要改代码。 | 提醒调试/故障诊断类 Skill，例如 `$diagnosing-bugs`。 |
| C3 | 请审查这次提交，重点检查需求符合度和项目规范。 | 提醒代码审查类 Skill，例如 `$code-review`。 |
| C4 | 当前分支有一个复杂的 Merge Conflict，请帮我处理。 | 提醒冲突解决类 Skill，例如 `$resolving-merge-conflicts`。 |
| C5 | 2 + 2 等于多少？ | 保持安静；不应因为存在 Skill Reminder 就强行提醒。 |
| C6 | 把这句话里的拼写错误改掉。 | 保持安静；这是一次简单编辑。 |
| C7 | 我已经明确调用了 `$tdd`，现在请按它执行。 | 不要重复推荐 `$tdd`；可以继续执行已调用的 Skill。 |
| C8 | 当前运行环境没有提供已安装 Skill 的名称或描述。 | 不要猜测 Skill 名称；可以说明无法可靠匹配，但不要编造候选。 |

## English

Run each case with the same installed-skill inventory and record the names, descriptions, and invocation policies visible to the agent. Wording may vary, but a passing result should recommend only materially relevant skills and normally no more than three.

| Case | Prompt | Expected behavior |
| --- | --- | --- |
| E1 | Plan a new feature that requires changes across several modules before editing code. | It may suggest architecture, domain-modeling, or planning skills without dumping the full inventory. |
| E2 | This Node.js API intermittently returns 500. Diagnose it first and do not change code yet. | Suggest a debugging or diagnosis skill such as `$diagnosing-bugs`. |
| E3 | Review this change for both requirement fit and project standards. | Suggest a code-review skill such as `$code-review`. |
| E4 | There is a difficult merge conflict on the current branch. Help resolve it. | Suggest a merge-conflict skill such as `$resolving-merge-conflicts`. |
| E5 | What is 2 + 2? | Stay quiet; do not force a reminder merely because Skill Reminder is installed. |
| E6 | Fix the typo in this sentence. | Stay quiet; this is a trivial edit. |
| E7 | I explicitly invoked `$tdd`; follow it now. | Do not recommend `$tdd` again; continue with the already invoked skill. |
| E8 | The runtime does not expose installed skill names or descriptions. | Do not guess skill names; state that reliable matching is unavailable if needed. |

## Review checklist

- Does the reminder appear only when the task has a meaningful match?
- Are the suggestions limited to skills that are actually available?
- Are manual or explicit-only skills presented as suggestions rather than silently invoked?
- Does the response stay concise and continue the user's task?
- Does the skill remain quiet for C5/C6 and E5/E6?
