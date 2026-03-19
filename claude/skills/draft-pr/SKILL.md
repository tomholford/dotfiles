---
name: draft-pr
description: Stage, commit, push, and open a draft PR
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(gh pr create:*), mcp__gitea__pull_request_write
---

## Context

- Git remotes: !`git remote -v`
- Current git status: !`git status`
- Current git diff (staged and unstaged): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits (for message style): !`git log --oneline -5`

## Platform detection

Check the git remotes above to determine the platform:
- If remote URLs contain `github.com` → use `gh` CLI
- Otherwise (Gitea, Forgejo, etc.) → use `mcp__gitea__pull_request_write` with method `create`

## Your task

Based on the changes above:

1. **Stage changes**: Review the unstaged changes and stage appropriate files using `git add`. Use your judgment - stage files that are part of logical changes, skip generated files or unintended changes.

2. **Commit**: Create a commit with an auto-generated message that:
   - Is concise (1-2 sentences)
   - Focuses mostly on "what" changed (~80%), with brief "why" context (~20%) when it's not obvious
   - Matches the style of recent commits
   - Use a HEREDOC for the message

3. **Push**: Push to remote. If no upstream is set, use `git push -u origin <branch>`.

4. **Create draft PR**:
   - **GitHub**: Use `gh pr create --draft`
   - **Gitea**: Use `mcp__gitea__pull_request_write` with method `create`, setting the owner/repo from the remote URL and head/base branches accordingly
   - A descriptive title
   - Reference any Linear (e.g., ENG-123) or Sentry issues mentioned in the code, commits, or branch name
   - Use a HEREDOC for the body (GitHub) or pass body directly (Gitea)
   - Body structure:

     Summary (prose): What the PR does.  This should also include a description of the motivation: what the problem was previously, and what effects it had.  If the motivation is obvious (e.g., "implements the new feature"), it can be left out.

     Changes (bullets): list of significant changes.  Use sub-bullets to reference parts of the motivation, if applicable.  Use sub-bullets to break down changes with substantial complexity, if applicable.  Reference file paths, endpoints, types, and fields as needed, using `code spans`.

     Validation (prose or bullets, as applicable): Anything the author did, beyond the standard running the tests and linter.  If there is nothing, this section can be left out.

     Post-Merge (bullets): checklist of action items needed after merge. If there are no post-merge steps, this section can be left out.

General notes:

- The PR description is for reviewers to understand the changes, not a journal of the development process.  Any temporary artifacts of the process should be left out: e.g., editing states, problems that were encountered, bugs that were introduced and then fixed, etc.
- All comments in the description should reference the PR diff, not intermediate states from developing it.
- Don't explain simple things that are easily understood by reading the code.  Focus on structure and relationships between program components.
- Keep it short.  One sentence is better than 3.
- Avoid over-use of markup.

Report the PR URL when done.
