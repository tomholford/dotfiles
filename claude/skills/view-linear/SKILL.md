---
name: view-linear
description: View a Linear issue by ID, identifier (e.g. ENG-123), or URL. Shows details, status, comments, and relations. Use when user wants to view, check, or look up a Linear issue or ticket.
argument-hint: "<issue-id, identifier, or URL>"
allowed-tools: mcp__linear-server__get_issue, mcp__linear-server__list_comments, mcp__linear-server__list_issues
---

# View Linear Issue

## Your Task

View and summarize the Linear issue specified by `$ARGUMENTS`.

## Workflow

### Step 1: Parse the Argument

- If `$ARGUMENTS` is a URL like `https://linear.app/.../issue/ENG-123/...` → extract the identifier (e.g. `ENG-123`)
- If `$ARGUMENTS` is an identifier like `ENG-123` → use directly
- If `$ARGUMENTS` is a UUID → use directly
- If no argument provided → ask the user

### Step 2: Fetch Issue Details

Use `mcp__linear-server__get_issue` with the ID/identifier. Include relations:

- `id`: the parsed identifier
- `includeRelations`: true

### Step 3: Fetch Comments

Use `mcp__linear-server__list_comments` with the issue ID to get discussion context.

### Step 4: Summarize

## [Identifier]: [Title]

**Status**: status | **Priority**: priority | **Assignee**: name
**Project**: project | **Cycle**: cycle (if any)
**Labels**: labels

### Description
Brief summary of the issue description.

### Relations
- Blocked by: ...
- Blocking: ...
- Related: ...
(Omit if none.)

### Comments
Summarize notable comments — key decisions, questions, or updates. Skip bot/automated comments unless relevant.

### Attachments / Branch
Note any linked branches or attachments.
