---
name: lookup
description: Look up idiomatic approaches, best practices, and common patterns for a given scenario using Exa web search and GitHub code search. Use when user wants to know what's idiomatic, recommended, or common for a bug, architecture decision, library usage, or design pattern.
argument-hint: "<question or scenario to lookup>"
allowed-tools: Bash(gh search *), Bash(gh api *), Agent, mcp__exa__web_search_exa, mcp__exa__crawling_exa, mcp__github__search_code, mcp__github__search_repositories, mcp__github__search_issues, mcp__github__get_file_contents
---

# Research

Find idiomatic, recommended, and common approaches for a given scenario by searching the web and real-world codebases.

## Context

- Working directory: !`pwd`
- Languages/frameworks in use: !`ls package.json go.mod Cargo.toml pyproject.toml requirements.txt Gemfile mix.exs build.gradle pom.xml 2>/dev/null | head -5`

## Your Task

Research the scenario described in `$ARGUMENTS`. Your goal is to find **what real projects actually do** — not just what docs say.

## Workflow

### Step 1: Understand the Question

Parse the user's query to identify:
- The specific technology/library/framework involved
- The problem or decision (bug fix, architecture, pattern choice, config)
- Any constraints mentioned

### Step 2: Search in Parallel

Launch parallel searches across multiple sources:

#### Exa Web Search
Use `mcp__exa__web_search_exa` to find:
- Blog posts, guides, and discussions about the approach
- Official documentation and recommendations
- Stack Overflow / GitHub Discussions with high-quality answers

Search with 2-3 varied queries to cover different angles (e.g. "idiomatic X pattern", "X best practice", "X vs Y tradeoffs").

#### GitHub Code Search
Use `gh search code` or `mcp__github__search_code` to find:
- How popular/well-maintained repos solve this problem
- Common patterns in production codebases
- Real usage examples (not toy demos)

Target repos with stars/activity. Use language filters.

```bash
# Example searches
gh search code "pattern query" --language=go --sort=indexed -- -test -example
gh search code "pattern query" --language=go -- -test -vendor
```

#### GitHub Issues/Discussions (if relevant)
Search for related issues or discussions:
```bash
gh search issues "query" --sort=comments --limit=5
```

### Step 3: Crawl Key Sources

If Exa search surfaces particularly relevant pages, use `mcp__exa__crawling_exa` to read the full content of the top 2-3 results.

### Step 4: Synthesize

Present findings as:

## Research: [Topic]

### Consensus
What most sources agree on — the dominant/idiomatic approach.

### Approaches Found
| Approach | Used By | Pros | Cons |
|----------|---------|------|------|
| ... | [real repos/authors] | ... | ... |

### Key Examples
Show 2-3 concrete code snippets from real repos (with attribution).

### Recommendation
Your recommendation for the user's specific context, considering their codebase and constraints.

### Sources
Bulleted list of the most useful links found.

## Principles

- **Real code over theory** — prioritize what production repos actually do
- **Recency matters** — prefer recent sources, note if patterns are dated
- **Attribution** — always cite where you found things
- **Multiple angles** — search from different perspectives to avoid confirmation bias
- **Be honest about uncertainty** — if there's no clear consensus, say so
