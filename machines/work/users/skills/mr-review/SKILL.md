---
name: mr-review
description: Review every open fluidattacks/universe MR that lists the user as reviewer — check out the branch, read the whole change, post review threads, then track them and report whether the author's fixes hold up so the user can give final approval. Use when the user asks to review their MR queue.
disable-model-invocation: true
---

# MR Review

Run from inside `~/fluidattacks/universe`, using only the `glab` channel of
each repository skill. This skill only adds the queue, the threads and the
follow-up; read these first and follow them for how to review:

- `.memory/skills/reviewing-mr/SKILL.md`
- `.memory/skills/code-review/SKILL.md`, for its Spec axis only

Where they conflict with this skill, they win, except for one deliberate
override: post the findings without asking.

Never approve, unapprove, or merge. Final approval belongs to the user.

Each run is one idempotent pass over the queue. To keep tracking, run it
under `/loop` (e.g. `/loop 15m /mr-review`).

## State

Keep one file per MR in `~/.local/state/mr-review/<iid>.json`:

```json
{
  "reviewed_head": "<sha>",
  "reviewed_base": "<sha>",
  "threads": { "<discussion_id>": "open | reported" }
}
```

GitLab is the source of truth for threads. The file only remembers what was
reviewed and reported, so a pass never repeats work or notifications.
Delete it once the MR is merged or closed.

## 1. Queue

```bash
me=$(glab api user | jq -r .username)
glab api "projects/:id/merge_requests?reviewer_username=$me&state=opened&per_page=100" --paginate
```

Do not skip drafts: FluidBot toggles draft while pipelines run. For each MR,
read `diff_refs` from `glab api "projects/:id/merge_requests/<iid>"`, then:

- No state file: **review** (step 2).
- Tracked threads newly resolved: **verify** (step 4).
- Otherwise: nothing to do; the author is still working.

## 2. Review

Check out the MR in a worktree, so the user's checkout is untouched:

```bash
git fetch origin <source_branch> trunk
git worktree add --detach .claude/worktrees/review-<iid> <head_sha>
```

Review it there following `reviewing-mr` steps 3–4, reading the whole
change (`git diff <base_sha>...<head_sha>`), plus the Spec axis of
`code-review` against the issue in the commit title. Drop any finding that
FluidBot or another reviewer already raised in the MR's discussions.

## 3. Post threads

One thread per finding, anchored to its line: the problem, why it matters,
what would fix it. Mark optional suggestions as non-blocking.

```bash
glab api -X POST "projects/:id/merge_requests/<iid>/discussions" \
  -f body="<finding>" \
  -f "position[position_type]=text" \
  -f "position[base_sha]=<base_sha>" \
  -f "position[start_sha]=<start_sha>" \
  -f "position[head_sha]=<head_sha>" \
  -f "position[old_path]=<path>" \
  -f "position[new_path]=<path>" \
  -F "position[new_line]=<line>"
```

For a removed line use `position[old_line]` instead; for an MR-wide finding
omit `position`. Record each returned discussion `id` as `open`, plus
`reviewed_head` and `reviewed_base`, then remove the worktree.

With no findings, post nothing and tell the user it is ready for approval.

## 4. Verify fixes

MRs are rebased onto trunk, so compare the commit itself, not branch tips:

```bash
git fetch origin <source_branch> trunk
git range-diff <reviewed_base>..<reviewed_head> <base_sha>..<head_sha>
```

For each newly resolved thread, read the author's replies and the current
code there, then decide **agree** (fixed, or the pushback holds) or
**disagree** (what is still wrong). Never reopen or reply: the user decides.
Review anything else the range-diff shows the same way as step 2, and report
it rather than posting it. Mark the threads `reported` and update
`reviewed_head` and `reviewed_base`.

## 5. Notify

Once per MR with news, notify the user (PushNotification when available),
then give the details in chat:

- MR link, title, author, threads resolved vs. still open
- Per resolved thread: finding, fix, **agree / disagree** and why
- Anything new found in the latest changes
- **Ready for approval** when every thread is resolved and you agree with
  every fix, otherwise what still blocks it
