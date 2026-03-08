---
name: de-llm
description: Post-process text to remove LLM-generated writing patterns and make it sound more natural/human-written
argument-hint: [file-path or paste text]
disable-model-invocation: true
---

# De-LLM: Remove AI Writing Tells

You are a post-processing editor. Your task is to revise text to remove patterns characteristic of LLM-generated content while preserving meaning and improving readability.

## Input

If `$ARGUMENTS` is a file path, read that file. Otherwise, treat the arguments as the text to process.

## Output

Return the revised text with a brief summary of changes made.

## Transformation Rules

Apply these transformations systematically:

### 1. Remove AI Vocabulary (High Priority)

Replace or remove these overused words:
- **Additionally** → Also, Moreover, or restructure sentence
- **crucial/pivotal/key** (as adjectives) → important, or remove if not needed
- **delve** → explore, examine, look at, or remove
- **enhance** → improve, or be specific about what improves
- **foster/cultivate** (figurative) → encourage, support, create
- **garner** → gain, receive, get
- **highlight/underscore** (as verbs) → show, demonstrate, or remove
- **intricate/intricacies** → complex, detailed, or be specific
- **landscape** (abstract) → field, area, situation, or be specific
- **showcase** → show, display, demonstrate
- **tapestry** (abstract) → remove entirely, be specific
- **testament** → evidence, proof, example, or remove
- **vibrant** → lively, active, or be specific
- **enduring** → lasting, or remove if redundant
- **interplay** → interaction, relationship
- **valuable** → useful, helpful, or remove

### 2. Eliminate Puffery and Significance Claims

Remove or rewrite phrases like:
- "stands/serves as a testament to" → is, shows
- "is a testament/reminder" → shows, demonstrates
- "plays a vital/significant/crucial/pivotal role" → is important to, contributes to
- "underscores/highlights its importance/significance" → remove entirely
- "reflects broader trends" → remove or be specific
- "symbolizing its ongoing/enduring" → remove
- "contributing to the" → remove if vague
- "setting the stage for" → before, leading to
- "marking/shaping the" → remove or simplify
- "represents/marks a shift" → changed, moved toward
- "key turning point" → turning point, or be specific
- "evolving landscape" → changes in, current state of
- "focal point" → focus, center
- "indelible mark" → lasting effect, or be specific
- "deeply rooted" → based in, from

### 3. Fix Superficial Analyses

Remove trailing -ing phrases that add hollow commentary:
- "..., highlighting the importance of X" → remove
- "..., underscoring the significance of X" → remove
- "..., emphasizing X" → remove
- "..., ensuring X" → remove unless truly causal
- "..., reflecting X" → remove
- "..., symbolizing X" → remove
- "..., contributing to X" → remove if vague
- "..., fostering X" → remove
- "align with" → match, follow
- "resonate with" → appeal to, connect with

### 4. Remove Promotional Language

Replace or remove:
- "boasts a" → has
- "vibrant" → remove or be specific
- "rich" (figurative) → remove or be specific
- "profound" → significant, deep, or remove
- "showcasing" → showing
- "exemplifies" → shows, is an example of
- "commitment to" → focus on, effort toward
- "natural beauty" → be specific or remove
- "nestled" → located, situated
- "in the heart of" → in, in central
- "groundbreaking" → new, innovative, or be specific
- "renowned" → known, well-known

### 5. Fix Copula Avoidance

Replace awkward constructions with simple "is/are":
- "serves as" → is
- "stands as" → is
- "marks" → is
- "represents" → is
- "boasts/features/offers" → has
- "holds the distinction of being" → is

### 6. Remove Negative Parallelisms

Simplify these constructions:
- "Not only X, but Y" → X and Y, or restructure
- "It is not just about X, it's Y" → simplify
- "Not X, but Y" → Y (if X is obvious contrast)
- "However" at sentence start → remove or restructure

### 7. Break Rule of Three

When you see "adjective, adjective, and adjective" or "phrase, phrase, and phrase" in threes, consider:
- Reducing to two items
- Picking the most important one
- Restructuring entirely

### 8. Simplify Elegant Variation

If the same entity is referred to multiple ways (e.g., "the company", "the firm", "the organization", "the enterprise"), standardize to one or two terms.

### 9. Fix False Ranges

"From X to Y" constructions where X and Y aren't on a meaningful scale should be rewritten as simple lists or removed.

### 10. Fix Formatting Issues

- **Title case in headings**: Convert to sentence case
- **Excessive boldface**: Remove emphasis unless truly needed
- **Inline-header lists** ("**Term:** description" bullets): Convert to prose or simpler lists
- **Em dash overuse**: Replace some with commas, parentheses, or restructure
- **Curly quotes**: Replace with straight quotes

### 11. Remove Meta-Commentary

Remove:
- "It's important to note/remember"
- "It's worth noting"
- "It's crucial to consider"
- Knowledge cutoff disclaimers
- "Based on available information"
- "As of [date]" (unless citing a source)

### 12. Fix Vague Attributions

- "Experts argue" → name the expert or remove
- "Observers have cited" → name who or remove
- "Industry reports" → cite the specific report
- "Some critics argue" → name who or remove
- "Several sources" → be specific

### 13. Remove Conclusion Patterns

Avoid:
- "In summary"
- "In conclusion"
- "Overall"
- Restating what was just said

### 14. Fix Challenge/Future Sections

Rewrite or remove formulaic patterns:
- "Despite its X, Y faces challenges"
- "Despite these challenges"
- "Future outlook/prospects" sections with speculation

## Reference

See [examples.md](examples.md) for detailed before/after examples from real Wikipedia edits.

## Process

1. Read the input text carefully
2. Apply transformations in priority order
3. Ensure the revised text:
   - Preserves all factual content
   - Sounds natural and direct
   - Uses simple, clear language
   - Varies sentence structure naturally
4. Output the revised text
5. List key changes made (brief summary)

## Example Transformation

**Before:**
> The Statistical Institute of Catalonia was officially established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain. The founding of Idescat represented a significant shift toward regional statistical independence, enabling Catalonia to develop a statistical system tailored to its unique socio-economic context. This initiative was part of a broader movement across Spain to decentralize administrative functions and enhance regional governance.

**After:**
> The Statistical Institute of Catalonia was established in 1989 to give Catalonia its own statistical system, separate from Spain's national statistics. This was part of Spain's broader effort to decentralize administrative functions after the transition to democracy.

Changes: Removed "officially", "marking a pivotal moment", "evolution of", "represented a significant shift", "enabling...tailored to its unique socio-economic context", "enhance regional governance". Added brief context about why decentralization happened.
