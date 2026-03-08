---
name: rebase
description: Rebase current branch onto a target branch (default master), resolve merge conflicts, and summarize resolutions
argument-hint: "[target-branch]"
disable-model-invocation: true
---

# Rebase and Resolve

Rebase the current branch onto `$ARGUMENTS` (default: `master` if no argument given). Resolve any merge conflicts and summarize all resolutions.

## Process

1. **Pre-flight checks**
   - Run `git status` to confirm the working tree is clean (no uncommitted changes). If dirty, stop and ask the user to commit or stash first.
   - Identify the current branch name and the target branch.
   - If the target branch argument is empty, use `master`. If `master` doesn't exist, try `main`.

2. **Fetch and rebase**
   - Run `git fetch origin` to ensure the target branch is up to date.
   - Run `git rebase origin/<target>` (prefer the remote tracking branch).
   - If the rebase completes cleanly with no conflicts, report success and stop.

3. **Conflict resolution loop**
   - When conflicts occur, for each conflicted file:
     - Read the file and understand both sides of the conflict (`ours` = current branch, `theirs` = target branch).
     - Read the surrounding code context and the commit messages involved to understand intent.
     - Resolve the conflict by merging both changes correctly, preserving the intent of both sides. Prefer keeping both changes when they don't contradict. When they contradict, prefer the current branch's intent but incorporate any necessary updates from the target.
     - Stage the resolved file with `git add`.
   - Run `git rebase --continue` after resolving all conflicts in the current commit.
   - Repeat until the rebase finishes. Track every resolution made.

4. **Summary report**
   - After the rebase completes, print a summary of all conflict resolutions:
     - Which commits had conflicts
     - Which files were conflicted
     - What each resolution was (brief description of what was kept/merged/changed)
     - Any files where manual review is recommended (e.g. complex logic merges)

## Guidelines

- **Never** use `--skip` or `--abort` without explicit user approval.
- **Never** use `git rebase --continue` with `--no-verify`.
- If a conflict is too ambiguous to resolve confidently, stop the rebase, explain the conflict, and ask the user how to proceed.
- After 3 failed resolution attempts on the same file, stop and ask for help.
- Preserve formatting, whitespace conventions, and code style of the current branch.
