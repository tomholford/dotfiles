---
name: view-pr
description: View the PR associated with the current branch or a specified PR number/branch
argument-hint: "[pr-number or branch]"
allowed-tools: Bash(gh pr *), mcp__gitea__pull_request_read, mcp__gitea__list_pull_requests
---

# View Pull Request

## Context

- Git remotes: !`git remote -v`
- Current branch: !`git branch --show-current`

## Platform detection

Check the git remotes above to determine the platform:
- If remote URLs contain `github.com` → use `gh` CLI
- Otherwise (Gitea, Forgejo, etc.) → use `mcp__gitea__pull_request_read` and `mcp__gitea__list_pull_requests`

## Your task

View and summarize the pull request.

### GitHub

If `$ARGUMENTS` is provided, use it as the PR number or branch:
```
gh pr view $ARGUMENTS
gh pr diff $ARGUMENTS
gh pr view --comments $ARGUMENTS
```
Otherwise, view the PR for the current branch:
```
gh pr view
gh pr diff
gh pr view --comments
```

### Gitea

Extract owner/repo from the remote URL. If `$ARGUMENTS` is a PR number, use it as the index. Otherwise, use `mcp__gitea__list_pull_requests` to find the PR for the current branch, then:
- `mcp__gitea__pull_request_read` with method `get` for details
- `mcp__gitea__pull_request_read` with method `get_diff` for the diff
- `mcp__gitea__pull_request_read` with method `get_reviews` for review data

Summarize concisely: title, state, author, reviewers, checks status, a brief description of the changes, and any notable review comments.
