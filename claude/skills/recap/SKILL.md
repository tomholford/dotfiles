---
name: recap
description: Summarize what shipped over a date range, commit range, or release tag — synthesizes git log, GitHub PRs, and Linear issues into a single markdown brief.
when_to_use: Weekly demo-day reviews, monthly or quarterly release blog drafts, OOO catch-up briefs, or any "what's shipped lately" question. Trigger phrases include "recap", "what shipped", "catch me up", "weekly summary", "release notes draft", "what did the team do this month".
argument-hint: [range] [+repo …] — e.g. "last week", "2026-04-01..2026-04-30 +../sso +../milady-maxxer", "v1.2.3..v1.2.4"
allowed-tools: Bash(git log:*) Bash(git tag:*) Bash(git rev-parse:*) Bash(git show:*) Bash(git remote:*) Bash(ls:*) Bash(jq:*) Bash(grep:*) Bash(awk:*) Bash(gh pr list:*) Bash(gh pr view:*) Bash(gh search prs:*) Read Write WebFetch
---

# Recap

Produce a markdown brief covering everything shipped (and the notable in‑flight work) for the given range. The output should be a usable starting point for: a weekly demo‑day review, a monthly/quarterly release blog draft, **and** an OOO catch‑up. One file, three audiences — the user does the final tone pass.

## 1. Resolve the range

Interpret `$ARGUMENTS`:

- **Phrase** ("last week", "this week", "last month", "this quarter", "yesterday") — resolve against today's date to absolute ISO dates.
- **Date range** — `YYYY-MM-DD..YYYY-MM-DD`, or "since YYYY-MM-DD" (end = today).
- **Tag** — `v1.2.3..v1.2.4`; a single tag means "since that tag" (end = HEAD).
- **Commit range** — `<sha>..<sha>` or `<sha>..HEAD`.
- **Empty** — default to the last 7 days.

Compute and remember:
- `START`, `END` (absolute ISO dates, for GitHub/Linear date filters)
- `FROM_REF`, `TO_REF` (git refs, when available)

State the resolved window in one short line before gathering data so the user can interrupt if it's wrong. Example: `Recap window: 2026-04-23 → 2026-04-30 (7 days, FROM_REF=v1.4.0, TO_REF=HEAD).`

### Resolve the repository set

Most recaps cover a single repo (the one you're standing in), but a release frequently spans multiple. Decide which repos to include:

- **Explicit**: arguments like `+../sso +../other-repo` or a trailing comma‑separated list — use exactly those plus the current repo.
- **Implicit**: if the input is a release‑sized range (a tag like `v0.7`, a multi‑week date span, or a free‑text mention of related repos like *"also consult ../sso"*), peek at sibling directories under `..` for git repos. List candidates with one line each (`name · last‑commit date · remote`) and ask the user which to include before gathering. For weekly/demo cadence, default to the current repo only.
- **Single‑repo default**: skip the prompt entirely.

For each included repo, remember its label (use the directory name, e.g. `reminet`, `sso`) — these become section headers and the stats line in the output.

## 2. Gather data — in parallel

Issue these calls in a single message. When multiple repos are in scope, fan out — fire the per‑repo calls together rather than serially.

**Git, per repo** (skip a repo if it's not a git checkout):
- `git -C <repo-path> log --no-merges --pretty=format:'%h|%an|%ad|%s' --date=short FROM_REF..TO_REF`
- Or `--since=START --until=END` if no refs are available.
- For commits whose subject is terse, fetch the body with `git -C <repo-path> show --no-patch --format=%B <sha>`.
- For PR coverage: derive `owner/repo` from `git -C <repo-path> remote get-url origin`.

**GitHub PRs, per repo** (use `gh` CLI — works without MCP auth):
- Merged: `gh pr list -R <owner/repo> --state merged --search "merged:START..END" --limit 200 --json number,title,author,mergedAt,labels,url,body`
- Closed unmerged: `gh pr list -R <owner/repo> --state closed --search "closed:START..END -is:merged" --limit 100 --json number,title,author,closedAt,url`
- Open & active in the window: `gh pr list -R <owner/repo> --state open --search "updated:>=START" --limit 50 --json number,title,author,updatedAt,isDraft,url`
- For long ranges (≳ 1 month) the merged list can exceed the default cap; raise `--limit` and check whether the result is truncated. If a single repo dominates volume (e.g. 200/200 returned), the rest of the data is likely missing — bump the limit before composing.
- **Merged ≠ shipped to prod.** For release‑sized recaps, also pull deploy/release PRs (titles matching `release: master → prod`, `Production deploy …`, `Deploy: …`) and read their bodies. They reveal what actually reached production vs. what only merged to master — these can differ by weeks. Features behind staging‑only feature flags will show as "merged" but are not yet user‑facing.

**Linear** (only if `mcp__linear-server__*` tools are available — load via ToolSearch if listed as deferred):
- `mcp__linear-server__list_issues` filtered to issues completed/updated in `[START, END]`. Across teams unless one is obvious from the working directory. Pull title, identifier, state, project, and labels.
- Capture in‑progress issues that moved during the window — useful for the OOO and demo framings.

If Linear isn't available, skip silently and add one line at the bottom of the file: `_Linear data unavailable — recap is based on git + GitHub only._`

## 3. Cross‑reference and discover topics

Merge the streams so each piece of work appears once, not three times:
- Linear identifiers (e.g. `ENG-123`, `INF-45`) often appear in PR titles, branch names, and commit subjects.
- PR numbers appear in merge‑commit subjects (`#1083`).
- Group commits, the PR that landed them, and the Linear issue they belong to into a single logical entry.

Then **discover topics** — single‑title reads miss themes that span dozens of PRs. For ranges longer than a couple of weeks this matters most:

- **Dump titles to a flat file**: `jq -r '.[] | "\(.mergedAt[0:10]) #\(.number) \(.title)"' /tmp/recap-merged.json | sort > /tmp/recap-titles.txt`. Easier to grep than JSON.
- **Bucket by area prefix**: `grep -oE '#[0-9]+ [a-zA-Z]+:' /tmp/recap-titles.txt | awk '{print $2}' | sort | uniq -c | sort -rn`. Surfaces the dominant areas (`fix:`, `server:`, `db:`, `web:`, `ui:`).
- **Keyword sweep**: loop a list of likely product/feature/system keywords against the title file and print matches per keyword. Tune the list to the project. This is the workhorse — it catches multi‑PR initiatives split across many area prefixes that a chronological read misses entirely. Repeat with a second wave of keywords once the first wave's themes hint at adjacent ones.
- **Cross‑check Linear**: for each big keyword cluster, scan the Linear issue titles for the same theme. Linear often names the *initiative* where PRs name the *change*, so the two together describe scope better than either alone.
- **For released features, dig past PR titles to concrete content**. PR titles like "server: gate new beetles behind CRAFTING_2 flag" hide what's actually in the drop. Use `gh pr view <num> --json body` for the umbrella PR, and grep the codebase (enum files, asset directories, recipe data) for names and counts. The audience wants "six new beetles: Cucumber, Bumblebee, …", not "previously gated behind `CRAFTING_2`".

Drop pure noise from the entry list: dependabot bumps with no behavior change, lint‑only commits, typo fixes — unless that's literally all there is.

## 4. Compose the markdown

**File path**: `recap-<start>-to-<end>.md` in the current working directory. For tag inputs use `recap-<tag>.md`. **Never overwrite an existing file** — if it exists, ask the user whether to overwrite or pick a new name.

**Skeleton**:

```markdown
# Recap: <human range>

<one‑line stats. With multiple repos, list each: "2026-04-23 → 2026-04-30 · 7 days · `reminet` 14 PRs · `sso` 6 commits · 9 Linear issues completed">

## Summary

<2–3 sentences in prose. The headline ship, the dominant area of focus, anything notable like an incident, rollback, or migration milestone. No bullets here.>

## At a glance     ← include for release / quarterly / >1 month recaps; skip for weekly/demo

<TOC: bolded link per top‑level section, each followed by a one‑line keyword digest of the items inside (e.g. "Shopify points, friends/social upgrades, NYFW achievements, smart‑contract wallets"). Indented sub‑section links beneath. Functions as a secondary executive summary — a reader skims it in 15 seconds and jumps to whatever interests them.>

## Highlights

<Body — see formatting rules below. With multi-repo recaps, the secondary repo usually gets its own subsection (e.g. "### SSO platform (`sso` repo)") rather than being interleaved with the primary repo, so each repo's story reads cleanly.>

## In flight   ← OOO / demo cadence
## Feature‑complete but not yet released   ← release‑draft cadence (use this name when the recap is being written for a release announcement)

<Notable open PRs and in‑progress / gated work. For release drafts, group these by feature with a per‑feature status blockquote (see formatting rules).>
```

### Formatting rules for Highlights

- **≤ 6 entries**: flat bulleted list, no subsections.
- **> 6 entries**: pick whichever grouping fits the content best:
  - **By area** (Features / Performance / Infrastructure / Fixes / Docs) when the period is mixed.
  - **By feature or epic** (e.g. "Notification grouping", "Auth migration") when one initiative dominates; remaining items go under "Other".
- Each entry uses a title bullet with a sub‑bullet for the blurb:

  ```markdown
  - **Short title**
    - One‑sentence blurb explaining what changed and why it matters.
  ```

  - Title: 3–6 words, plain English. Don't copy the PR title verbatim if it's noisy.
  - Blurb: what changed and why it matters to a reader who didn't watch the PR. Skip if the title is fully self‑explanatory.
  - **No refs in the output** — the audience doesn't need PR numbers or Linear IDs. Use the cross‑referenced data internally to write better blurbs and dedupe entries, then drop the identifiers.
- Sort within a group by impact, then recency.

### Released vs. unreleased: different rules

- **Released features** — drop feature‑flag names from the prose and write concrete content instead. "Six new beetles: Cucumber, Bumblebee, Blue Longicorn, Golden Tiger, Pondhawk, Death Feigning" beats "previously gated behind `CRAFTING_2` flag". Counts and names are what an external reader cares about; flags are plumbing. Pull names from PR bodies, code (enum files, asset directories), or recipe data.
- **Unreleased / gated features** — flag names *are* useful here, since they document the gating. Each gated feature deserves a per‑feature status blockquote rather than a single blanket warning. Different states call for different framing:

  ```markdown
  ### Cheese Streak Shields

  > _Status: v0 ready and gated behind `FFLAG_CHEESE_SHIELDS`. Product wants to iterate before release._

  - **Streak protection**
    - …
  ```

  Common states: `v0 ready, Product iterating`, `ready for internal dogfood`, `still in active development — see open PRs`, `staging only, not yet in prod`. **If status is unclear, ask the user** before composing — guessing turns "unreleased" into "shipped" and creates rework.

### Platform sections

For non‑user‑facing platform work (deprecations, migrations, new internal infra), use the section name **`Platform: Deprecation, Consolidation, Optimization`** with three `###` sub‑buckets matching the title and individual systems as `####`:

```markdown
## Platform: Deprecation, Consolidation, Optimization

### Deprecation
#### MongoDB retired
…
#### Identity service retired
…

### Consolidation
#### Profile server evaporation
…

### Optimization
#### Email infrastructure
…
#### Blob storage and image processing
…
```

Avoid `Internal:` prefixes and blanket `REMOVE from public post` warnings. Even non‑user‑facing items often have parts (paginated lists, signed URLs, new email pipeline, observability) that read well in a "Behind the scenes" footer for a public post — let the editor decide what makes the cut.

### Editor's notes footer

End the file with a single italicized **Editor's notes** paragraph that calls out:
- which sections are the front‑and‑center material,
- which sections to cut entirely,
- which sections are mostly internal but contain *specific items* worth surfacing publicly (name them — e.g. "paginated friends, signed PFP URLs, the new email pipeline").

This gives the editor a punch list rather than a delete‑everything warning.

### Tone

Neutral and concrete. No marketing adjectives ("blazing‑fast", "delightful"). The user will tone‑shift it for whichever audience they're publishing to.

For public release blog drafts: fetch the project's previous release post (e.g. via `WebFetch` on the prior post URL — ask the user for it) before composing. The recap voice is dense and bullet‑heavy by design; the public post is narrative. Modeling on the prior post avoids producing copy that has to be entirely rewritten.

## 5. Hand off

Write the file, print the path, and end with one line: what the user should tweak before publishing — typically tightening the Summary and trimming **In flight** for a public post, or keeping it for an OOO brief.

## Notes

- Treat memory and `CLAUDE.md` context as background — don't restate it in the recap.
- If the working directory isn't a git repo, ask which `owner/repo` to query and proceed with GitHub‑only data.
- This skill produces a *starting point*, not finished copy. **Expect 2–4 review passes with the user before the doc settles** — the first pass will be lossy and miscategorize some items as released vs. unreleased. Don't aim for one‑shot perfection; aim for a draft the user can quickly correct.
- **Merged ≠ shipped to prod.** For release recaps, verify what actually reached production via deploy/release PR bodies. PR titles can also lie about timing — e.g. "crafting update 2026‑03" merged in April. Cross‑check titles against `mergedAt` dates.
- **When in doubt about released status, ask.** PRs that mention feature flags, `gate:`, `Deploy: enable …`, or staging‑only changes are signals — confirm with the user whether the feature is part of the announce before placing it in a Headline section.
