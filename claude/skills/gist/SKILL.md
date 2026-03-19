---
name: gist
description: Publish the previous output or analysis as a secret GitHub gist
argument-hint: "[filename] [description]"
allowed-tools: Bash(gh gist *), Write
---

# Publish as Secret Gist

Publish the most recent substantial output or analysis from this conversation as a secret GitHub gist.

## Process

1. Identify the most recent output, analysis, code, or result worth publishing from the conversation
2. Write it to a temp file in `/tmp/` with a sensible filename:
   - If `$ARGUMENTS` specifies a filename, use it
   - Otherwise, infer from content type (e.g. `analysis.md`, `output.txt`, `snippet.py`)
3. Create the gist:
   ```
   gh gist create --secret <file> --desc "<description>"
   ```
   - If `$ARGUMENTS` includes a description (beyond the filename), use it
   - Otherwise, generate a short description from the content
4. Report the gist URL

## Notes

- Default to secret gists (not public)
- Use markdown formatting for prose/analysis, appropriate extension for code
- Clean up the temp file after successful gist creation
