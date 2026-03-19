---
name: push
description: Stage, commit, and push changes
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*)
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits (for message style): !`git log --oneline -5`

## Your task

Based on the changes above:

1. **Stage changes**: Review the unstaged changes and stage appropriate files using `git add`. Use your judgment - stage files that are part of logical changes, skip generated files or unintended changes.

2. **Commit**: Create a commit with an auto-generated message that:
   - Is concise (1-2 sentences)
   - Focuses on the "why" not the "what"
   - Matches the style of recent commits
   - Use a HEREDOC for the message

3. **Push**: Push to remote. If no upstream is set, use `git push -u origin <branch>`.

Report the commit hash when done.
