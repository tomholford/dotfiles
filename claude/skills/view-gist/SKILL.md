---
name: view-gist
description: View a GitHub gist by ID or URL
argument-hint: "<gist-id or url>"
disable-model-invocation: true
allowed-tools: Bash(gh gist *)
---

# View Gist

## Your task

View and summarize a GitHub gist.

1. If `$ARGUMENTS` is provided, use it as the gist ID or URL:
   ```
   gh gist view $ARGUMENTS
   ```
2. If no arguments are provided, list recent gists:
   ```
   gh gist list --limit 10
   ```

Summarize the gist concisely: description, files, visibility, and a brief summary of the contents.
