---
name: write-a-prd
description: Create a PRD through user interview, codebase exploration, and module design, then submit as a GitHub issue. Use when user wants to write a PRD, create a product requirements document, or plan a new feature.
allowed-tools: Bash(gh *), Bash(git *), Read, Grep, Glob, Agent
---

# Write a PRD

Create a PRD through user interview, codebase exploration, and module design, then submit as a GitHub issue. You may skip steps if not necessary.

## Process

### 1. Gather context

Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.

### 2. Explore the repo

Verify their assertions and understand the current state of the codebase.

### 3. Interview relentlessly

Interview the user about every aspect of this plan until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

### 4. Sketch modules

Sketch out the major modules you will need to build or modify. Look for opportunities to extract deep modules that can be tested in isolation.

A **deep module** encapsulates a lot of functionality behind a simple, testable interface which rarely changes.

Check with the user that these modules match their expectations. Check which modules they want tests written for.

### 5. Write the PRD

Once you have a complete understanding, use the template below to write the PRD. Submit as a GitHub issue using `gh issue create`.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

This list should be extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions made, including:

- Modules to build/modify
- Interfaces to modify
- Technical clarifications
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets — they may become outdated quickly.

## Testing Decisions

- What makes a good test (test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (similar types of tests in the codebase)

## Out of Scope

Things explicitly out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
