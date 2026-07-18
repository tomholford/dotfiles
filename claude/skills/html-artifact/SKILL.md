---
name: html-artifact
description: Generate a single-file HTML artifact (status report, slide deck, prototype, throwaway editor, flowchart, etc.) and open it in the browser. Use when the user wants a one-off visual artifact instead of markdown — for sharing, reference, or interactive exploration.
when_to_use: Trigger phrases include "make a status report", "draft a slide deck", "build a throwaway editor for X", "visualize Y as HTML", "design system snapshot", "PR writeup". Anything one-off that benefits from layout, color, or interaction beyond what markdown provides.
argument-hint: <what the artifact should show>
allowed-tools: Bash(open *) Bash(mkdir -p *)
---

# HTML artifact

Generate a single self-contained HTML file for the user's stated purpose, save it to `~/claude-html/`, and open it in the default browser.

## Output

- Path: `~/claude-html/$(date +%F)-<slug>.html` where `<slug>` is a short kebab-case summary (e.g. `q1-status-report`, `auth-flow-flowchart`).
- Run `mkdir -p ~/claude-html` before writing.
- After writing, run `open <path>` and print the absolute path so the user can `scp` / share it later.

## Hard rules

- One file. No external CSS, JS, fonts, or images.
- All styles inline in a single `<style>` block.
- System font stack only (see `style-guide.md`).
- No build step, no bundler, no JS framework. Vanilla HTML/CSS/JS only.
- Looks correct in modern Chrome/Safari at default zoom; mobile-friendly via `viewport` meta + responsive layout.

## Pattern selection

Match the user's request to a pattern in `examples.md`. If nothing fits, compose from the primitives there. Always prefer an existing pattern over improvising — they are battle-tested and produce coherent results across a folder of artifacts.

## Throwaway-editor pattern

If the artifact is *interactive* (the user is going to edit/configure something), include a "Copy as markdown / Copy as JSON / Copy diff" button that serializes the result to the clipboard. This is the highest-leverage form of an artifact: it does work the chat can't, then exports back to chat.

## Reference

- Patterns: see [examples.md](examples.md)
- Visual conventions: see [style-guide.md](style-guide.md)
- Inspiration: github.com/ThariqS/html-effectiveness
