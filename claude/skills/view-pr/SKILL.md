---
name: view-pr
description: View the PR associated with the current branch or a specified PR number/branch
argument-hint: "[pr-number or branch]"
disable-model-invocation: true
allowed-tools: Bash(gh pr *)
---

# View Pull Request

## Context

- Current branch: !`git branch --show-current`

## Your task

View and summarize the pull request details.

1. If `$ARGUMENTS` is provided, use it as the PR number or branch name:
   ```
   gh pr view $ARGUMENTS
   ```
2. Otherwise, view the PR for the current branch:
   ```
   gh pr view
   ```

Summarize the PR concisely: title, state, author, reviewers, checks status, and a brief description of the changes.
