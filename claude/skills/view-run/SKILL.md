---
name: view-run
description: View a CI run by ID, URL, PR number, or branch (defaults to current branch)
argument-hint: "[run-id, run-url, pr-number, or branch]"
allowed-tools: Bash(gh run *), Bash(gh pr *), Bash(git branch *), mcp__gitea__actions_run_read, mcp__gitea__pull_request_read
---

# View Run

## Context

- Git remotes: !`git remote -v`
- Current branch: !`git branch --show-current`

## Platform detection

Check the git remotes above to determine the platform:
- If remote URLs contain `github.com` → use `gh` CLI
- Otherwise (Gitea, Forgejo, etc.) → use `mcp__gitea__actions_run_read`

## Your task

View and summarize a CI workflow run.

### GitHub

#### Determine the run to view

1. **No arguments**: View the most recent run for the current branch:
   ```
   gh run list --branch $(git branch --show-current) --limit 1
   ```
   Then view that run ID.

2. **GitHub Actions URL** (e.g. `https://github.com/owner/repo/actions/runs/123/job/456?pr=789`): Extract the run ID from the URL and view it. Use `--repo owner/repo` if it differs from the current repo.

3. **Run ID** (numeric): View it directly:
   ```
   gh run view $ID
   ```

4. **PR number** (e.g. `#784` or `784` when contextually a PR): Find the PR's head branch, then get the most recent run for that branch:
   ```
   gh pr view $PR --json headRefName -q .headRefName
   gh run list --branch $BRANCH --limit 1
   ```

5. **Branch name**: List the most recent run for that branch:
   ```
   gh run list --branch $BRANCH --limit 1
   ```

#### View the run

Once you have the run ID:
```
gh run view $RUN_ID
```

If a specific job failed, show its logs:
```
gh run view $RUN_ID --log-failed
```

### Gitea

Extract owner/repo from the remote URL.

1. **No arguments or branch name**: Use `mcp__gitea__actions_run_read` with method `list_runs` to find recent runs.
2. **Run ID**: Use method `get_run` with the run_id.
3. **PR number**: Use `mcp__gitea__pull_request_read` with method `get` to find the head branch, then `list_runs`.

For failed jobs, use `list_run_jobs` to find the failed job, then `get_job_log_preview` for error output.

### Summary

Summarize concisely: workflow name, status, conclusion, branch, triggering commit/PR, duration, and any failed steps with relevant error output.
