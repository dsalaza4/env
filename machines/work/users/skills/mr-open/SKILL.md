---
name: mr-open
description: Open a merge request for the current branch in fluidattacks/universe and drive it to green — track the latest push pipeline, fix failed jobs, and address every FluidBot review thread, amending and force-pushing until nothing is left. Use when the user asks to open an MR and babysit it.
disable-model-invocation: true
---

# MR Open

Run from inside `~/fluidattacks/universe`, using only the `glab` channel of
each repository skill. This skill only chains them into a loop; read them
first and follow them for every step they cover:

- `.memory/skills/pushing-code/SKILL.md`
- `.memory/skills/opening-mr/SKILL.md`
- `.memory/skills/retrieving-failed-jobs/SKILL.md`
- `.memory/skills/addressing-mr-comments/SKILL.md`

Where they conflict with this skill, they win, except for these deliberate
overrides: fix failures and accepted findings without asking, commit and
push them without asking, and retry an infrastructure failure once.

## 1. Push and open

Push following `pushing-code`, then record what defines the pipeline and
review that matter until the next push:

```bash
pushed_sha=$(git rev-parse HEAD)
pushed_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
```

If the branch has no open MR
(`glab mr list --source-branch "$(git branch --show-current)"`), open one
following `opening-mr`.

## 2. Watch the push pipeline

GitLab rebases MRs and creates `skipped` pipelines for the rebased SHAs.
Ignore them and any pipeline whose SHA is not `pushed_sha`. The one that
matters is:

```bash
glab api "projects/:id/pipelines?sha=$pushed_sha&source=push&per_page=1"
```

Wait for a final status with a background until-loop (the Monitor tool),
never a foreground sleep. On `canceled`, ask before continuing. On
`failed`, inspect it following `retrieving-failed-jobs` from step 2 with
this pipeline's ID, ignoring jobs with `allow_failure: true`. Fix
code-related failures; retry an infrastructure failure once with
`glab ci retry <job_id>` and report it if it fails again.

## 3. Watch the FluidBot review

Every push triggers a FluidBot review
(`project_20741933_bot_4cc04bdace09f17f4f8ad9eb0f6dfff1`), in parallel with
the pipeline, so watch both.

- Its summary note (`🤖 **_FluidBot_** completed the review`, then
  `No findings ✅` or `🔍 N finding(s)`) is edited in place per review. The
  latest push is reviewed once its `updated_at` is after `pushed_at`.
- The N findings arrive as `DiffNote` threads up to a couple of minutes
  later. Wait for all of them.
- On a new push FluidBot usually resolves its earlier threads. Do not rely
  on it: you own making sure no thread is left unresolved.

Address threads following `addressing-mr-comments`, but on every
unresolved resolvable thread of this MR, whatever review or author it came
from.

Decide per thread whether the finding is right:

- **Accepted**: fix it, reply with what changed, resolve once pushed.
- **Rejected**: reply with a concrete reason grounded in the code, then
  resolve. For a human reviewer's thread, ask the user instead.

```bash
glab api -X POST "projects/:id/merge_requests/<iid>/discussions/<discussion_id>/notes" -f body="<reply>"
glab api -X PUT "projects/:id/merge_requests/<iid>/discussions/<discussion_id>" -f resolved=true
```

## 4. Amend, push, repeat

Put every fix of the round into one amend, pushed following `pushing-code`,
so each round costs one pipeline and one review. Then update `pushed_sha`
and `pushed_at`, resolve the accepted threads FluidBot has not already
closed, and go back to step 2. Stop and ask the user if the same failure or
finding survives three rounds.

## 5. Done

Stop when the pipeline for `pushed_sha` succeeded, FluidBot reviewed
`pushed_sha`, and a final fetch of the discussions shows no resolvable
thread unresolved, from any review, bot or human. Report the MR URL, rounds
taken, what was fixed, and every rejected thread with its reason.
