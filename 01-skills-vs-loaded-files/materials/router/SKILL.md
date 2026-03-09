---
name: group-alpha
description: Router for group-alpha skills. Trigger when user says "zap alpha one", "zap alpha two", or "zap alpha three"
---

Based on the trigger phrase used, read and follow ONLY the matching sub-skill. Do not reference or load any other sub-skills.

- **"zap alpha one"** → read and follow: ~/.claude/skills/group-alpha/skill-one/SKILL.md
- **"zap alpha two"** → read and follow: ~/.claude/skills/group-alpha/skill-two/SKILL.md
- **"zap alpha three"** → read and follow: ~/.claude/skills/group-alpha/skill-three/SKILL.md
