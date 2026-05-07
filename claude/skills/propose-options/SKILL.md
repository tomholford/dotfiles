---
name: propose-options
description: Gather context from the codebase and (optionally) the web, then propose multiple ways to move forward with tradeoffs, relative impact, and effort. Use when user wants to explore options, weigh approaches, or asks "what are my options" / "how should I tackle this" before committing to a plan.
argument-hint: "<problem or decision to explore>"
allowed-tools: Read, Grep, Glob, Bash, Agent, Skill
---

# Propose Options

Surface 2-4 viable ways to move forward on the user's problem. Each option must come with honest tradeoffs so the user can choose — do not pick for them.

## Process

### 1. Understand the problem

Parse `$ARGUMENTS` (or the recent conversation if empty) to extract:

- The concrete decision or problem
- Any constraints the user has stated (deadlines, stack, scope, must/must-not)
- What's already been ruled out

If the problem is ambiguous, ask **one** clarifying question before proceeding. Otherwise dive in.

### 2. Gather codebase context

Before proposing anything, look at the actual code. Skipping this step produces generic options that ignore the project's reality.

- Read the files most relevant to the decision
- Note existing patterns, libraries, and conventions in use
- Identify integration points the options will need to respect
- Use the `Agent` tool with `subagent_type=Explore` for broad exploration; use `Grep`/`Glob`/`Read` directly for targeted lookups

### 3. (Optional) Research idiomatic approaches

If the decision involves a library, framework, or pattern where outside research would meaningfully inform the recommendation, invoke the `lookup` skill via `Skill`:

```
Skill(skill="lookup", args="<focused research question>")
```

Skip this step when the decision is purely internal (naming, where to put a file, refactor shape) — research won't help.

### 4. Generate options

Draft 2-4 distinct options. Each option should be a meaningfully different approach, not minor variations of the same idea. If you can only think of one viable approach, say so explicitly rather than padding with strawmen.

For each option, capture:

- **Name**: short, descriptive
- **What it is**: one or two sentences on the approach
- **Impact**: what it unlocks, who/what it affects, blast radius
- **Effort**: rough size — XS / S / M / L / XL — and what drives it
- **Tradeoffs**: honest pros and cons, including reversibility
- **Idiomatic?**: per the research (if done), is this what others do? Note divergence from the project's existing patterns.

### 5. Present

Use this format:

```markdown
## Options for: <problem>

### Context observed
- <bullet on what you found in the codebase>
- <bullet on relevant constraint>

### Research notes (if applicable)
- <one-line summary of consensus from /lookup>

### Option A — <name>
**What:** ...
**Impact:** ...
**Effort:** S — <driver>
**Tradeoffs:**
- + <pro>
- − <con>
**Idiomatic:** yes / no / mixed — <one line>

### Option B — <name>
...

### Comparison
| | A | B | C |
|---|---|---|---|
| Effort | S | M | L |
| Reversibility | easy | medium | hard |
| Fits existing patterns | ✓ | ✗ | ✓ |
| Idiomatic | ✓ | ✓ | ✗ |

### Lean
One sentence on which option you'd lean toward and **why**, framed as a recommendation the user can override. Do not commit to implementing — wait for the user to choose.
```

## Principles

- **No strawmen** — every option must be defensible. If an option is bad, omit it.
- **Honest tradeoffs** — every option has downsides. Surface them.
- **Stop at proposing** — do not start implementing. The user picks next.
- **Fit the project** — options must respect the codebase's existing conventions unless explicitly diverging (and called out).
- **Right-size the research** — a 5-minute decision doesn't need a /lookup.
