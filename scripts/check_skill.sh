#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
skill_count=0

for skill_md in "$repo_root"/skills/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  skill_count=$((skill_count + 1))
  skill_dir=$(basename "$(dirname "$skill_md")")
  frontmatter=$(awk '
    NR == 1 && $0 == "---" { inside = 1; next }
    inside && $0 == "---" { exit }
    inside { print }
  ' "$skill_md")

  name=$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p' | head -n 1 | tr -d '"')
  if [ -z "$name" ]; then
    printf 'Missing name in %s\n' "$skill_md" >&2
    exit 1
  fi
  if [ "$name" != "$skill_dir" ]; then
    printf 'Skill name "%s" does not match directory "%s"\n' "$name" "$skill_dir" >&2
    exit 1
  fi
  if ! printf '%s\n' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    printf 'Invalid skill name "%s" in %s\n' "$name" "$skill_md" >&2
    exit 1
  fi
  if ! printf '%s\n' "$frontmatter" | grep -Eq '^description:[[:space:]]*[^[:space:]].*'; then
    printf 'Missing description in %s\n' "$skill_md" >&2
    exit 1
  fi
  if grep -Eq 'TODO|<<<<<<<|=======|>>>>>>>' "$skill_md"; then
    printf 'Scaffold placeholder or conflict marker in %s\n' "$skill_md" >&2
    exit 1
  fi
done

if [ "$skill_count" -eq 0 ]; then
  printf 'No skills found under %s/skills\n' "$repo_root" >&2
  exit 1
fi

printf 'Validated %s skill(s)\n' "$skill_count"
