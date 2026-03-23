---
name: view-issue
description: View a GitHub/Gitea issue by number, URL, or search query
argument-hint: "<issue-number, URL, or search query>"
allowed-tools: Bash(gh issue *), mcp__gitea__issue_read, mcp__gitea__list_issues
---

# View Issue

## Context

- Git remotes: !`git remote -v`
- Current branch: !`git branch --show-current`

## Platform detection

Check the git remotes above to determine the platform:
- If remote URLs contain `github.com` → use `gh` CLI
- Otherwise (Gitea, Forgejo, etc.) → use Gitea MCP tools

## Your task

View and summarize the issue.

### GitHub

If `$ARGUMENTS` is a number, view that issue:
```
gh issue view $ARGUMENTS
gh issue view --comments $ARGUMENTS
```

If `$ARGUMENTS` is a URL, extract the issue number and view it:
```
gh issue view <number> --repo <owner/repo>
gh issue view --comments <number> --repo <owner/repo>
```

If `$ARGUMENTS` is text (not a number or URL), search for matching issues:
```
gh issue list --search "$ARGUMENTS"
```
Then let the user pick one, or if there's a single match, view it directly.

If no `$ARGUMENTS` is provided, list recent open issues:
```
gh issue list --limit 10
```

### Gitea

Extract owner/repo from the remote URL. If `$ARGUMENTS` is a number, use it as the index. Otherwise, use `mcp__gitea__list_issues` to find matching issues, then:
- `mcp__gitea__issue_read` with method `get` for details
- `mcp__gitea__issue_read` with method `get_comments` for comments

Summarize concisely: title, state, author, assignees, labels, a brief description, and any notable comments.
