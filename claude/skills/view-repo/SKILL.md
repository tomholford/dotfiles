---
name: view-repo
description: Gather and summarize information about a GitHub or Gitea repository — README, docs, examples, structure, and key stats. Use when user wants to learn about a repo, understand a project, or explore a library before using it.
argument-hint: "<owner/repo or URL>"
allowed-tools: Bash(gh repo *), Bash(gh api *), Agent, mcp__github__get_file_contents, mcp__github__search_code, mcp__github__list_releases, mcp__github__list_branches, mcp__gitea__*
---

# View Repo

Gather and summarize key information about a repository.

## Your Task

View the repository specified by `$ARGUMENTS` (an owner/repo string or full URL).

## Platform Detection

- If URL contains `github.com` or is just `owner/repo` → use `gh` CLI / GitHub MCP
- If URL contains another host → use Gitea MCP tools

## Workflow

### Step 1: Gather Repo Overview

#### GitHub
```bash
# Basic info
gh repo view $ARGUMENTS

# File tree (top-level + key dirs)
gh api repos/$ARGUMENTS/contents/ --jq '.[].name'
```

#### Gitea
Use equivalent Gitea MCP tools to fetch repo details and file listing.

### Step 2: Read Key Files (in parallel)

Fetch these if they exist:
- **README** (README.md, README.rst, etc.)
- **Documentation** — check for `docs/`, `doc/`, `documentation/` dirs
- **Examples** — check for `examples/`, `example/`, `_examples/` dirs
- **Getting started / quickstart** files
- **CHANGELOG** or **RELEASES** (latest entry only)
- **Contributing guide** (CONTRIBUTING.md)

For GitHub:
```bash
# Read a file
gh api repos/$ARGUMENTS/contents/README.md --jq '.content' | base64 -d

# List a directory
gh api repos/$ARGUMENTS/contents/docs --jq '.[].name'
```

Or use `mcp__github__get_file_contents` for individual files.

### Step 3: Gather Stats

```bash
# Recent releases
gh release list --repo $ARGUMENTS --limit 3

# Recent activity
gh api repos/$ARGUMENTS/commits --jq '.[0:3] | .[] | .commit.message'

# Stars, forks, issues
gh repo view $ARGUMENTS --json stargazerCount,forkCount,openIssues
```

### Step 4: Summarize

## [Repo Name]

**Description**: one-line summary
**Language**: primary language | **License**: license | **Stars**: count

### What It Does
2-3 sentences explaining the project's purpose and scope.

### Key Features
- Bulleted highlights from README/docs

### Quick Start
The shortest path to using this — from the README or examples.

### Project Structure
Brief description of how the repo is organized (key directories and their purpose).

### Documentation
Links or pointers to available docs, guides, and examples.

### Recent Activity
Latest release, recent commits, maintenance status.

### Notable
Anything surprising, important caveats, or useful context.
