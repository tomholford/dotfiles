---
name: view-sentry
description: View a Sentry issue by short ID (e.g. PROJECT-123) or URL. Shows details, status, latest event, and tag distribution. Use when user wants to view, check, or look up a Sentry issue, error, or event.
argument-hint: "<issue short ID or URL>"
allowed-tools: mcp__sentry__get_sentry_resource, mcp__sentry__search_issue_events, mcp__sentry__get_issue_tag_values, mcp__sentry__find_organizations
---

# View Sentry Issue

## Your Task

View and summarize the Sentry issue specified by `$ARGUMENTS`.

## Workflow

### Step 0: Default Organization

Default `organizationSlug` is **`remilia-corporation`** (region URL `https://us.sentry.io`). Use this without calling `find_organizations`. Only fall back to `find_organizations` if the user explicitly references a different org or this default fails.

### Step 1: Parse the Argument

- If `$ARGUMENTS` is a Sentry URL (e.g. `https://<org>.sentry.io/issues/PROJECT-123/` or `https://sentry.io/organizations/<org>/issues/...`) → pass it through as `url` to `get_sentry_resource` (org is encoded in the URL)
- If `$ARGUMENTS` is a short ID like `PROJECT-123` → use as `resourceId` with `resourceType='issue'` and the default org slug above
- If `$ARGUMENTS` is an event ID (32-char hex) → use `resourceType='event'` with the default org slug
- If no argument provided → ask the user

### Step 2: Fetch Issue Details

Use `mcp__sentry__get_sentry_resource`:
- With a URL: `url=<the URL>` (resource type auto-detected)
- With a short ID: `resourceType='issue'`, `organizationSlug=<slug>`, `resourceId='PROJECT-123'`

### Step 3: Fetch Latest Events (optional but recommended)

Use `mcp__sentry__search_issue_events` to get recent occurrences:
- `issueUrl=<URL>` OR `issueId='PROJECT-123' organizationSlug=<slug>`
- `query=''` (or a filter like `environment:production`)
- `limit=5`

This surfaces stack traces, environments, and timestamps for the most recent events.

### Step 4: Fetch Tag Distribution (optional)

If the issue is widespread or the user wants impact analysis, use `mcp__sentry__get_issue_tag_values` for relevant tags:
- `tagKey='environment'` — which envs are affected
- `tagKey='release'` — which releases
- `tagKey='url'` or `tagKey='browser'` — for frontend issues

Skip this for trivial or single-event issues.

### Step 5: Summarize

## [Short ID]: [Title]

**Status**: status | **Level**: level | **Assignee**: name (if any)
**Project**: project | **Platform**: platform
**First seen**: timestamp | **Last seen**: timestamp
**Events**: count | **Users affected**: count

### Description
Brief summary of the error message and culprit (file:line or transaction).

### Latest Event
- Timestamp, environment, release
- Top frame from the stack trace (file:line, function)
- Key context (browser, OS, user, etc. — only if notable)

### Distribution
(Only if fetched in Step 4.)
- Environments: production (80%), staging (20%)
- Top releases / browsers / URLs

### Link
The Sentry URL for quick navigation.
