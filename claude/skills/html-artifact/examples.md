# patterns

Sourced from github.com/ThariqS/html-effectiveness. Pick the closest fit for the user's request. If nothing fits, compose from these primitives.

## Exploration
- **code approaches** — side-by-side comparison of 2-3 implementations of the same task: prompt box up top, code panes, tradeoffs panel below.
- **visual designs** — side-by-side mocks of 2-4 design options for the same UI surface, annotated with notes/rationale.

## Code review / understanding
- **PR review** — diff view with inline comments, severity badges (nit/question/blocker), summary header.
- **code understanding** — call graph + annotated source excerpts + plain-language explanation, organized by entry point.
- **PR writeup** — "ship it" announcement: what changed, screenshots/diagrams, follow-ups, risks, rollback plan.

## Design
- **design system** — token table (colors/type/spacing) + component sampler (buttons, inputs, cards) + usage notes.
- **component variants** — one component, all states/sizes/themes shown together, props matrix.

## Prototype
- **animation** — interactive demo of an animation idea (CSS transitions/keyframes) with controls to scrub speed/easing.
- **interaction** — minimal interactive UI to validate a flow (drag, drop, hover, keyboard) with state inspector.

## Communication
- **slide deck** — 16:9 slides as `<section>` per slide, keyboard nav (←/→), slide counter.
- **SVG illustrations** — diagram or hero illustration done in inline SVG, annotated.
- **status report** — period summary: shipped / in-progress / blocked, metrics, links. Card grid.
- **incident report** — timeline + impact + root cause + remediation + follow-ups. Mono timestamps.
- **flowchart / diagram** — boxes and arrows in inline SVG (or styled divs for simple cases), with legend.

## Research
- **feature explainer** — what it is, why it exists, how to use it, FAQ.
- **concept explainer** — visual analogy + step-through animation + glossary.

## Planning
- **implementation plan** — phases (tracer-bullet vertical slices), per-phase goals/tests/risks, gantt or kanban view.

## Throwaway editors (the novel pattern)
A purpose-built single-file UI to do one task, with an export button that turns the result back into pasteable text.

- **triage board** — drag cards across columns (Now/Next/Later/Cut), live counts, tag filters, "copy as markdown" export.
- **feature flags** — form-based toggles with grouped sections, dependency warnings, diff sidebar, "copy diff" export.
- **prompt tuner** — side-by-side template editor with `{{slot}}` highlighting, live sample previews, "copy prompt" export.

Throwaway-editor checklist:
1. Pre-populate state from arguments / pasted JSON in a `<details>` block at the top.
2. Single, obvious export button (top-right or sticky footer).
3. Use `navigator.clipboard.writeText()` and show a transient "copied" confirmation.
4. State lives in JS objects, not the DOM. Re-render on change.

## Composition primitives

When no pattern matches, build from:
- masthead (eyebrow + h1 + intro)
- pill TOC
- section with rule
- card grid (`grid-template-columns: repeat(auto-fill, minmax(280px, 1fr))`)
- inline SVG diagram
- mono code block (paper bg, oat border)
- (if interactive) controls panel + export button
