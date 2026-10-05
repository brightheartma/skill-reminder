# Skill Reminder

[![skills.sh](https://skills.sh/b/brightheartma/skill-reminder)](https://skills.sh/brightheartma/skill-reminder)
[![Validate skills](https://github.com/brightheartma/skill-reminder/actions/workflows/validate.yml/badge.svg)](https://github.com/brightheartma/skill-reminder/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**A small, agent-agnostic skill that suggests relevant installed skills at task start and development phase transitions, including manual skills discoverable through local metadata.**

[中文](#中文) · [English](#english)

---

## 中文

### 这是什么？

Skill Reminder 是一个面向 AI Agent 的轻量级路由 Skill。它会在任务开始，以及进入实现、准备 PR、结束开发或复盘等阶段时，提醒用户考虑相关的已安装 Skill。

它解决的是一个很常见的问题：很多有价值的 Skill 已经安装了，但只有在用户记得它们的名字、并主动调用它们时，才会发挥作用。Skill Reminder 会根据当前任务做一次小范围匹配；除了运行时展示的清单，也会检查可访问的本地技能目录或注册表中的元数据，以发现未出现在清单里的手动 Skill。

它不是 Skill 管理器，也不是后台通知系统。它不会自动安装 Skill、偷偷调用手动 Skill、修改项目配置，或替用户扩大任务范围。

### 核心特性

- **通用**：不绑定 Codex、Claude Code、Hermes Agent 或其他单一 Agent 产品。
- **低打扰**：通常只推荐一到三个高相关 Skill；没有明显匹配时保持安静。
- **尊重手动调用**：提醒不等于自动执行，用户可以决定是否调用。
- **优先使用真实清单**：只推荐当前环境中确实可用的 Skill，不凭记忆编造名称。
- **渐进式发现**：先读取名称、描述和调用策略等元数据，不为了一次提醒加载所有完整文档。
- **阶段提醒**：在进入实现、准备 PR、结束开发或复盘时重新判断；不会每轮重复提醒。
- **补充发现手动 Skill**：检查运行环境提供的本地目录或注册表，发现自动清单中遗漏的手动 Skill；当前任务内缓存元数据，安装或更新后刷新。
- **保持权限边界**：不会绕过项目规则、用户确认、平台安全策略或外部操作审批。

### 它如何工作？

1. 判断当前请求是否属于值得提醒的任务，例如复杂开发、调试、测试、代码审查、架构设计、研究或冲突解决。
2. 读取 Agent 当前暴露的 Skill 名称、描述和调用策略，并检查可访问的本地技能目录或注册表，补充相关手动 Skill；没有可用元数据时不猜测。
3. 将任务信号与已安装 Skill 做轻量匹配。
4. 选择最相关的一到三个 Skill，并说明为什么匹配。
5. 继续处理用户任务，在上述阶段转换时重新判断是否有新的匹配，不把提醒变成额外的阻塞步骤。

典型提醒会类似这样：

> 可能相关的已安装 Skill：
> - `$diagnosing-bugs`：当前请求包含明确的失败现象，适合先收集证据再提出修复方案。
> - `$code-review`：如果你希望最终检查同时覆盖项目规范和需求符合度，可以调用它。

### 什么时候会提醒？

适合提醒的任务包括：

- 实现非 trivial 的功能或重构；
- 诊断 Bug、异常、性能回归或构建失败；
- 编写测试或采用 TDD；
- 代码审查、架构设计、领域建模或解决 Merge Conflict；
- 研究资料、编写 Agent 规则或准备任务交接；
- 用户明确询问应该使用哪些 Skill 或工作流。

对于问候、简单事实问题、一次性小改动或没有明显 Skill 匹配的任务，它应保持安静。

长时间开发过程中，也会在以下阶段重新检查。以下 Skill 名称只是匹配示例，只有实际安装且适用时才会推荐：

| 阶段 | 示例 Skill | 提醒目的 |
| --- | --- | --- |
| 需求和任务已准备好，开始实现 | `$implement-spec` | 考虑按任务依赖关系组织多个 Agent 完成整份需求。 |
| 准备编写 PR 描述 | `$pr` | 整理改动说明、修改前后证据和合并风险。 |
| 开发结束，或准备复盘一次困难的开发过程 | `$retro` | 从会话中找出可改善的文档入口、自动检查、规范和工具使用方式。 |

阶段转换触发的是重新判断，不代表自动执行。已调用、已提醒或本任务中已被用户拒绝的建议不会反复提出。

### 安装

使用兼容的 `skills` CLI：

```bash
npx skills add brightheartma/skill-reminder --skill skill-reminder -g
```

不同 Agent 对 Skill 的发现和安装位置可能不同。请以目标 Agent 的文档为准；本仓库的核心内容是标准 `SKILL.md`，`agents/openai.yaml` 只是可选的产品元数据，不应被视为所有 Agent 都必须支持的配置。

### 使用

安装后通常不需要每次手动调用，兼容的 Agent 可以在相关任务中自动发现它。也可以显式调用：

```text
Use $skill-reminder to identify which installed skills are relevant to this task.
```

Skill Reminder 只负责提示。是否调用 `$tdd`、`$code-review` 或其他手动 Skill，仍由用户或当前 Agent 按各自的调用规则决定。

### 验证与评测

运行仓库自带的结构检查：

```bash
./scripts/check_skill.sh
```

行为评测用例和预期结果见 [EVALS.md](EVALS.md)。它覆盖应该提醒、应该保持安静、避免重复提醒以及 Skill 清单不可见等情况。

### 兼容性

| Agent / Runtime | 预期支持方式 | 说明 |
| --- | --- | --- |
| Codex | `SKILL.md` + 可选 `agents/openai.yaml` | `openai.yaml` 提供界面元数据和隐式调用策略。 |
| Claude Code | `SKILL.md` 或其兼容的 Skill 安装机制 | 具体安装目录和自动发现行为由 Claude Code 决定。 |
| Hermes Agent | 取决于其 Skill 加载器 | 可使用核心 `SKILL.md`，平台适配不应改变提醒规则。 |
| 其他 Agent | 只要能加载 `SKILL.md` 即可尝试 | 如果运行时不暴露已安装 Skill 清单，提醒能力会受到限制。 |

“兼容”表示能够读取并执行 Skill 指令，并不保证所有 Agent 都支持相同的元数据字段、自动调用策略或安装命令。阶段提醒依赖 Agent 识别当前阶段并遵循指令，不是后台监控或强制弹窗；如果自动清单和本地元数据都不可访问，则无法发现相关 Skill。

### 安全与隐私

Skill Reminder 不需要外部 API、MCP 服务、密钥或遥测数据。它只使用当前 Agent 已经能够访问的任务上下文和 Skill 元数据。

安装任何第三方 Skill 前，都应检查其 `SKILL.md`、脚本、依赖和外部操作权限。Skill Reminder 本身不会替用户审核或信任其他 Skill，也不会因为某个 Skill 被推荐就自动安装它。

### 开发与贡献

本仓库的核心文件位于：

```text
skills/skill-reminder/
├── SKILL.md
└── agents/
    └── openai.yaml
```

如果要改进提醒行为，请优先提供一个真实的任务场景，并说明：

- 哪个 Skill 应该被提醒；
- 当前提醒是漏报、误报还是过于频繁；
- Agent 当时能看到哪些 Skill 元数据；
- 期望的最小修复是什么。

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。欢迎通过 Issue 或 Pull Request 提交反馈。

### 设计边界

Skill Reminder 不承诺：

- 在 Agent 对话之外发送后台通知；
- 发现运行时完全隐藏的 Skill；
- 替用户执行手动 Skill；
- 统一不同 Agent 的安装目录和调用语法；
- 取代项目级规则、代码审查或 CI 检查。

它的目标很简单：在一个有价值的 Skill 可能被遗忘时，及时、简洁地提醒一次。

---

## English

### What is it?

Skill Reminder is a lightweight routing skill for AI agents. It suggests relevant installed skills at task start and when development moves into implementation, PR preparation, completion, or retrospective.

It addresses a common problem: useful skills are often installed but forgotten because they only help when someone remembers their names and invokes them explicitly. Skill Reminder performs a small, task-aware match against the exposed inventory and accessible local skill metadata, including manual skills omitted from the inventory.

It is not a skill manager or a background notification service. It does not install skills, silently invoke manual skills, change project configuration, or expand the user's authorization.

### Core features

- **Agent-agnostic**: no dependency on Codex, Claude Code, Hermes Agent, or one specific product.
- **Low noise**: normally suggests one to three high-confidence skills and stays quiet when there is no meaningful match.
- **Manual invocation aware**: a reminder is a suggestion, not an automatic execution request.
- **Inventory-based**: recommends only skills that are actually available in the current environment.
- **Progressive discovery**: inspects names, descriptions, and invocation metadata before reading full skill bodies.
- **Phase-aware reminders**: reassesses at implementation, PR preparation, completion, or retrospective without repeating reminders every turn.
- **Manual-skill discovery**: checks the host's accessible local directory or registry for manual skills omitted from the exposed inventory; caches metadata for the current task and refreshes after installation or updates.
- **Permission preserving**: never overrides project instructions, user approval, host safety rules, or external-action boundaries.

### How it works

1. Decide whether the request is a task where a reminder could materially help, such as substantial development, debugging, testing, review, architecture, research, or conflict resolution.
2. Read the exposed skill names, descriptions, and invocation policies, and check accessible local skill directories or registries for relevant manual skills. If no metadata is available, do not guess.
3. Match the task signals against the available skills.
4. Select the one to three strongest candidates and explain the match.
5. Continue with the user's task and reassess at the phase transitions above, keeping reminders non-blocking.

A typical reminder looks like this:

> Relevant installed skills:
> - `$diagnosing-bugs` — the request reports a failure, so it can structure evidence gathering before a fix is proposed.
> - `$code-review` — use it if you want the final change checked against both project standards and the requested behavior.

### When should it speak?

Good candidates include:

- implementing a non-trivial feature or refactor;
- diagnosing a bug, exception, performance regression, or build failure;
- writing tests or asking for test-first development;
- code review, architecture, domain modeling, or merge-conflict resolution;
- research, agent-instruction authoring, or task handoff;
- a direct question about which skills or workflows would help.

It should stay quiet for greetings, simple factual questions, trivial edits, and tasks with no meaningful skill match.

During a long-running development session, reassess at these transitions. The skill names below are examples, recommended only when installed and applicable:

| Phase | Example skill | Purpose |
| --- | --- | --- |
| A spec and its tickets are ready for implementation | `$implement-spec` | Consider coordinating parallel agents around ticket dependencies to implement the whole spec. |
| Writing a PR body | `$pr` | Explain the change, before/after evidence, and merge risk. |
| Development ends or a difficult run is being wrapped up | `$retro` | Identify improvements to navigation, automated checks, standards, and tooling from the session. |

A phase transition triggers reassessment, not automatic execution. Suggestions already invoked, surfaced, or declined for the current task are not repeated.

### Installation

Use a compatible `skills` CLI:

```bash
npx skills add brightheartma/skill-reminder --skill skill-reminder -g
```

Installation locations and discovery behavior vary by agent. Follow the target agent's documentation. The portable core of this repository is `SKILL.md`; `agents/openai.yaml` is optional product metadata and is not required by every runtime.

### Usage

After installation, a compatible agent can usually discover the skill automatically when it is relevant. You can also invoke it explicitly:

```text
Use $skill-reminder to identify which installed skills are relevant to this task.
```

Skill Reminder only surfaces candidates. The user or the current agent still decides whether to invoke `$tdd`, `$code-review`, or another manual skill according to that skill's own policy.

### Validation and evaluation

Run the repository's structural checks:

```bash
./scripts/check_skill.sh
```

See [EVALS.md](EVALS.md) for behavioral evaluation prompts and expected outcomes. The cases cover positive reminders, quiet cases, duplicate suppression, and runtimes that cannot expose a skill inventory.

### Compatibility

| Agent / Runtime | Expected support | Notes |
| --- | --- | --- |
| Codex | `SKILL.md` plus optional `agents/openai.yaml` | `openai.yaml` supplies UI metadata and implicit-invocation policy. |
| Claude Code | `SKILL.md` or its compatible skill installer | Installation paths and automatic discovery are controlled by Claude Code. |
| Hermes Agent | Depends on its skill loader | The core `SKILL.md` can be used without changing the reminder rules. |
| Other agents | Usable when they can load `SKILL.md` | Reminders are limited when a runtime hides its installed-skill inventory. |

“Compatible” means that an agent can load and follow the skill instructions. It does not guarantee identical metadata fields, invocation policies, or installation commands across runtimes. Phase reminders depend on the agent recognizing the phase and following the instructions; they are not a background monitor or a forced notification. Skills cannot be discovered when neither the exposed inventory nor local metadata is accessible.

### Security and privacy

Skill Reminder requires no external API, MCP server, secret, or telemetry. It uses only the task context and skill metadata already available to the current agent.

Review any third-party skill before installing it, including its `SKILL.md`, scripts, dependencies, and external-action permissions. Skill Reminder does not audit or implicitly trust recommended skills, and it never installs a skill merely because it was suggested.

### Development and contribution

The core files are organized as follows:

```text
skills/skill-reminder/
├── SKILL.md
└── agents/
    └── openai.yaml
```

When proposing a behavior improvement, please include a realistic task and explain:

- which skill should have been suggested;
- whether the current behavior was a miss, a false positive, or too frequent;
- which skill metadata the agent could see;
- the smallest useful change.

See [CONTRIBUTING.md](CONTRIBUTING.md). Issues and pull requests are welcome.

### Boundaries

Skill Reminder does not promise to:

- send notifications outside the agent interaction;
- discover skills that the runtime hides completely;
- execute a manual skill for the user;
- unify installation paths and invocation syntax across agents;
- replace project rules, code review, or CI enforcement.

Its goal is simple: give a timely, concise reminder when a useful installed skill might otherwise be forgotten.

## Reference projects and standards

- [Agent Skills specification](https://agentskills.io/)
- [Anthropic Skills repository](https://github.com/anthropics/skills)
- [skills.sh documentation](https://www.skills.sh/docs)
- [Vercel Skills CLI](https://github.com/vercel-labs/skills)

## License

This project is licensed under the [MIT License](LICENSE).
