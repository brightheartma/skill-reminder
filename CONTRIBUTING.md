# Contributing to Skill Reminder

## 中文

感谢你帮助改进 Skill Reminder。最有价值的反馈通常来自真实任务，而不是抽象的偏好。

提交 Issue 或 Pull Request 时，请尽量包含：

- 任务原文或经过脱敏的最小复现；
- 当时可用的 Skill 名称和描述；
- 期望被提醒的 Skill；
- 实际行为：漏报、误报，还是提醒过于频繁；
- 你建议的最小改动。

请保持 Skill 的平台无关性。不要把某个平台的安装路径、内部 API 或自动化行为写成所有 Agent 都必须遵守的规则。

## English

Thank you for improving Skill Reminder. The most useful feedback comes from realistic tasks rather than abstract preferences.

When opening an issue or pull request, please include, when possible:

- the original task or a minimal redacted reproduction;
- the skill names and descriptions visible at the time;
- the skill that should have been suggested;
- whether the behavior was a miss, a false positive, or too frequent;
- the smallest change you propose.

Keep the skill agent-agnostic. Do not turn one platform's installation paths, internal APIs, or automation behavior into universal requirements.

## Validation

Run the repository checks before submitting changes:

```bash
./scripts/check_skill.sh
```

If your agent environment includes the skill-creator validator, you may also run its `quick_validate.py` script. If that optional validator cannot run because a local dependency is missing, report that in the pull request and include the repository check output.
