---
name: view-run
description: View a GitHub Actions run by ID, URL, PR number, or branch (defaults to current branch)
argument-hint: "[run-id, run-url, pr-number, or branch]"
disable-model-invocation: true
allowed-tools: Bash(gh run *), Bash(gh pr *), Bash(git branch *)
---

# View Run

## Context

- Current branch: !`git branch --show-current`

## Your task

View and summarize a GitHub Actions workflow run.

### Determine the run to view

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

### View the run

Once you have the run ID:
```
gh run view $RUN_ID
```

If a specific job failed, show its logs:
```
gh run view $RUN_ID --log-failed
```

Summarize concisely: workflow name, status, conclusion, branch, triggering commit/PR, duration, and any failed steps with relevant error output.
