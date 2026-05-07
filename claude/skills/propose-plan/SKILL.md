---
name: propose-plan
description: Propose a concrete plan to cut a branch and implement a change as one or more atomic commits, grounded in the current codebase and (optionally) outside research. Use when user wants a step-by-step implementation plan, asks "propose a plan" / "how would you implement this", or is ready to move from discussion to execution.
argument-hint: "<feature, fix, or change to plan>"
allowed-tools: Read, Grep, Glob, Bash, Agent, Skill
---

# Propose Plan

Turn a decision into an executable plan: branch name, ordered atomic commits, verification steps. The plan should be specific enough that someone could pick it up and implement it without further questions.

## Process

### 1. Anchor the work

Parse `$ARGUMENTS` (or the recent conversation) to extract what's being implemented. If a decision among options has already been made earlier in the conversation, treat that as the starting point. If not, ask the user which approach to plan for — do not pick for them.

### 2. Read the current state

Before proposing commits, understand what already exists:

- `git status` and `git log --oneline -20` to see the working tree and recent history
- Read the files that will be touched
- Identify the conventions (test framework, lint rules, commit style) the plan must follow
- Use `Agent` with `subagent_type=Explore` for broad sweeps; `Grep`/`Glob`/`Read` for targeted lookups

### 3. (Optional) Research idiomatic approaches

If the implementation hinges on a library or pattern where outside research would meaningfully shape the plan, invoke `lookup` via `Skill`:

```
Skill(skill="lookup", args="<focused implementation question>")
```

Skip when the implementation is straightforward or purely internal.

### 4. Slice into atomic commits

Break the work into atomic commits. Each commit should:

- **Compile and pass tests on its own** — no broken intermediate states
- **Do one thing** — a single logical change with a focused message
- **Be reviewable in isolation** — small enough to read in one sitting
- **Land in dependency order** — schema/types before usage; refactors before features built on them

Prefer many small commits over one large commit. If the work is genuinely a single atomic change, one commit is fine — say so.

### 5. Name the branch

Follow the project's existing branch naming convention (check `git branch -a` if unsure). Default shape: `<type>/<short-kebab-summary>` (e.g. `feat/draft-autosave`, `fix/siwe-nonce-expiry`).

### 6. Present the plan

Use this format:

```markdown
## Plan: <change summary>

### Branch
`<branch-name>` off `<base-branch>`

### Context observed
- <key file or pattern found>
- <relevant constraint or convention>

### Research notes (if applicable)
- <one-line synthesis>

### Commits

#### 1. <commit subject>
**Touches:** `path/to/file.ext`, `path/to/other.ext`
**What:** <one or two sentences on the change>
**Why atomic:** <what makes this independently shippable>
**Verify:** <command(s) or check that proves it works — e.g. `cd packages/server && ./ops/gauntlet.sh`>

#### 2. <commit subject>
...

### Out of scope
- <thing the user might expect but the plan deliberately defers, with reason>

### Open questions
- <anything that requires the user's input before starting; omit section if none>
```

### 7. Stop

Present the plan and **wait for approval** before cutting the branch or writing code. The user may want to revise the slicing, branch name, or scope.

## Principles

- **Atomic means atomic** — if a commit needs "and also" to describe it, split it.
- **Order matters** — sequence commits so the tree is always green.
- **Respect the project** — branch names, commit style, and verification commands must match what the repo already uses (check `CLAUDE.md`, `ops/`, recent `git log`).
- **Be specific** — "update tests" is not a plan; name which tests and what they assert.
- **Don't start coding** — proposing a plan stops at the proposal.
- **Right-size the research** — a one-line fix doesn't need a /lookup.
