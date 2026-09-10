---
name: skill-reminder
description: Remind an AI agent about installed manual skills that are relevant to the current task without automatically invoking or installing them. Use at the start of substantial development, debugging, review, planning, research, documentation, or workflow tasks when the runtime exposes a skill inventory.
---

# Skill Reminder

Help the user notice relevant skills that are already available in the current agent environment. This is a lightweight routing aid, not a skill installer, background monitor, or replacement for the user's request.

## When to speak

Stay quiet for greetings, simple factual questions, trivial edits, or tasks with no meaningful skill match. Consider a reminder when the task involves one or more of these signals:

- planning or implementing a non-trivial feature;
- debugging, diagnosing a failure, or investigating a performance problem;
- writing tests or asking for test-first development;
- reviewing code, refactoring, architecture, domain modeling, or merge conflicts;
- researching a topic, writing agent instructions, or handing work to another agent;
- a user explicitly asks which skills, workflows, or tools would help.

Do not treat a reminder as a reason to delay the task or ask a new question. If there is no strong match, continue normally.

## How to find candidates

1. Use the skill names and descriptions already exposed by the host when available.
2. If the host exposes an installed-skill directory or registry, inspect metadata/frontmatter first. Do not read every full skill body just to decide whether a reminder is useful.
3. Recommend only skills that are actually available. Never invent a skill name from memory.
4. Identify skills that are manual or explicit-only from the host's metadata, frontmatter, or invocation policy. If the host does not expose that distinction, describe the recommendation as optional and ask the user to invoke it explicitly.
5. Prefer the smallest useful set: normally one to three skills, ordered by confidence.

## How to report a reminder

Keep the reminder compact and actionable. Name the skill, explain the match in one sentence, and show the explicit invocation form when the host supports it. For example:

> Relevant installed skills:
> - `$diagnosing-bugs` — this is a reported failure, so it can structure evidence gathering before proposing a fix.
> - `$code-review` — use it if you want the final diff checked against both project standards and the requested behavior.

If the user has already invoked a skill or it is already active, do not repeat it. If a skill is only a weak match, omit it or label it optional. Do not produce a long catalog of unrelated skills.

## Boundaries

- A reminder is not authorization to invoke, install, update, or publish anything.
- Never silently invoke an explicit-only/manual skill.
- Do not override the host agent's safety rules, project instructions, user permissions, or approval requirements.
- Do not claim that the skill will run in the background or create notifications outside the current agent interaction.
- Do not recommend platform-specific features as universally available. Mention host-specific behavior only when the runtime confirms it.
- If the user declines a reminder, respect that for the current task and continue.

The goal is timely awareness with minimal interruption: mention a skill when it can materially improve the next decision, and otherwise get out of the way.
