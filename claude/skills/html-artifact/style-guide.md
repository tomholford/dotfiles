# style guide

Distilled from github.com/ThariqS/html-effectiveness. Apply consistently so a folder of artifacts feels coherent.

## Palette (CSS variables)

```css
:root {
  --ivory:  #FAF9F5;  /* page background */
  --paper:  #FFFFFF;  /* cards on top of ivory */
  --slate:  #141413;  /* primary text + emphasis */
  --clay:   #D97757;  /* accent (links, highlights, italic emphasis) */
  --clay-d: #B85C3E;  /* accent darker, hover */
  --oat:    #E3DACC;  /* warm neutral for cards / underline color */
  --olive:  #788C5D;  /* secondary accent / status: good */
  --g100:   #F0EEE6;
  --g200:   #E6E3DA;
  --g300:   #D1CFC5;  /* default border */
  --g500:   #87867F;  /* muted text */
  --g700:   #3D3D3A;  /* body text */
}
```

## Type stack

```css
--serif: ui-serif, Georgia, "Times New Roman", Times, serif;
--sans:  system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
--mono:  ui-monospace, "SF Mono", Menlo, Monaco, Consolas, monospace;
```

- **Headings**: serif, weight 500. h1 uses `clamp(38px, 5.4vw, 62px)`, `letter-spacing: -0.018em`. Italics in `--clay` for emphasis (`<em>`).
- **Body**: sans, 16-16.5px, line-height 1.55, color `--g700`.
- **Eyebrows / labels / metadata**: mono, 11-12px, uppercase, `letter-spacing: 0.08-0.12em`, color `--g500`.

## Layout

- `body` background `--ivory`. `.wrap` max-width 1120px, gutter 32px, bottom padding 140px.
- **Masthead** pattern: eyebrow → h1 (with optional clay italic) → intro paragraph in `--g700`. Clay underline-rule (24×1.5px) before eyebrow text via `::before`.
- **Cards**: `--paper` bg, `1.5px solid var(--g300)` border, 10-12px border radius. Hover/emphasis: border `--slate` + `box-shadow: 0 12px 32px rgba(20,20,19,.10)`.
- **Pills** (TOC, tags): 12.5px sans, 7×14 padding, 999px radius, 1.5px g300 border, paper bg. Hover: border slate.
- **Borders are 1.5px**, not 1px — thicker borders are a load-bearing visual signal.
- `scroll-behavior: smooth`. `scroll-margin-top: 28px` on sections.

## Status colors

- Good / shipped: `--olive`
- Caution / pending: `--clay`
- Bad / blocked: `#A94A3A`
- Neutral / muted: `--g500`

## Accessibility

- Body text on ivory: `--g700` gives ~9.2:1 contrast — fine. Don't use `--g500` for body, only meta.
- Don't rely on color alone for status — pair with text or an icon.
- Use semantic HTML: `<header>`, `<section>`, `<article>`, `<nav>`, `<main>`, `<footer>`. Heading levels in order.
- Interactive controls must be `<button>`/`<a>`, never `<div>`. Add `:focus-visible` outlines.
- Respect `prefers-reduced-motion` if you add animations.
