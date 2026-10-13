---
name: mr-review
description: Review every open fluidattacks/universe MR that lists the user as reviewer. Poll the queue, launch background agents that review in worktrees and post threads, verify the authors' fixes, and keep a list of MRs ready for the user's approval. Use when the user asks to review their MR queue, do a round, or review one MR URL.
disable-model-invocation: true
---

# MR Review

Run from inside a universe checkout (cwd), so `:id` resolves in `glab api`.
Use only the `glab` channel of each repository skill. How to review comes
from the repo skills; this skill adds the queue, the agents, the threads
and the follow-up:

- `.memory/skills/reviewing-mr/SKILL.md`
- `.memory/skills/code-review/SKILL.md`, for its Spec axis only

Where they conflict with this skill, they win, except for one deliberate
override: post the findings without asking.

Never approve, unapprove or merge. On existing threads, the user decides.

## Files

Skill dir `/Users/dsalazar/.claude/skills/mr-review/` (read-only):

- `poll.py`: one queue pass; prints `TO_REVIEW`, `TO_VERIFY`,
  `NEWLY_READY`, `READY FOR APPROVAL`.
- `brief.md`: first-review agent prompt. `verify.md`: verify agent prompt.
- `ste.md`: add for docs STE100 series MRs.
- `pitfalls.md`: per-component lessons; paste the relevant ones into prompts.

State in `~/.local/state/`:

- `mr-review/<iid>.json`: per-MR state (schema below).
- `mr-review/inflight/<iid>`: marker while an agent works on the MR.
- `mr-review-reported.json`: MRs already announced as ready.

## Modes

1. **Loop** (`/loop 15m /mr-review`): silent. Speak only for
   `NEWLY_READY` (PushNotification, links, one-line why per MR), a
   blocked post, a hook workaround, or a disagreement with an author.
   Otherwise end with `quiet`.
2. **Round** ("do a round"): one pass, a short table of what is running,
   then one summary when every agent finishes.
3. **Single URL** ("review <url>"): review that MR even if the user is not
   a reviewer or it is merged. For a merged MR, phrase findings as
   follow-ups for a new MR; post only when the user asks.

Every run ends with the `READY FOR APPROVAL` links. Background-task
completion notices repeat agent reports: acknowledge in one line, do not
re-summarize.

## Pass

1. `python3 /Users/dsalazar/.claude/skills/mr-review/poll.py` from the
   repo. It skips the user's own MRs, absorbs pure rebases (range-diff all
   `=`), skips MRs in flight, drops state for MRs that left the queue, and
   fails closed on an empty queue.
2. `TO_REVIEW`: group up to 3 small related docs MRs per agent; one agent
   per code or infra MR. `TO_VERIFY`: one agent for several MRs.
3. Per agent: `touch` each MR's inflight marker, then launch a background
   agent with `brief.md` or `verify.md` (plus `ste.md` for docs series)
   and MR context: the issue, the series, relevant `pitfalls.md` entries,
   and what earlier MRs of the same issue changed. State premises as
   things to verify, not facts.
4. When an agent returns: delete its markers, relay the report, rerun the
   poll, print the ready links.

The orchestrator does not review; it polls, groups, launches and relays.

## Agent contract

Every brief must keep these; edit `brief.md`/`verify.md` rather than
dropping them.

- **Worktree**: `<repo>/.claude/worktrees/review-<iid>`, detached at the
  head SHA; remove with `git -C <repo> worktree remove --force`.
- **No hangs**: `GIT_TERMINAL_PROMPT=0`; `timeout` on every network or
  test command; `< /dev/null` for anything that can read stdin; fetch
  each SHA separately; on SSH failure, read through the glab API and say
  so.
- **Hooks**: if a hook blocks a command, stop that check and report what
  it would have verified. Never rerun it reworded, split, via globs, with
  the word in a file or payload, or through another tool. Copy this rule
  verbatim into any sub-agent prompt. A Read tool read is not a
  workaround.
- **Posting**: one anchored thread per finding (problem, why, fix;
  non-blocking marked). `glab api -X POST ... --input file.json -H
  'Content-Type: application/json'`; confirm the returned note has a
  `position`. Anchor on changed lines only; on rejection retry the
  nearest changed line; a file outside the diff gets an MR-wide thread.
  Drop findings FluidBot, another reviewer or our earlier threads already
  raised.
- **Blocked post**: record `unposted`, return the full thread text and
  anchor (path, line, base/start/head SHA). The orchestrator asks the user
  to allow the post once or post it by hand.
- **State**:
  ```json
  {
    "reviewed_head": "<sha>",
    "reviewed_base": "<sha>",
    "threads": { "<discussion_id>": "open | reported" },
    "ready": true,
    "unposted": "<only when a finding could not be posted>"
  }
  ```
- **Return**: per MR, link, title, author, findings with file:line and
  discussion id, ready yes/no, anything blocked.

## Verify and readiness

- New findings during verify are posted as new threads, tracked `open`.
- Existing threads: never reply, resolve or reopen. Report disagreement;
  if the user says yes, reply on that discussion
  (`.../discussions/<id>/notes`) and give the note link
  (`<mr_url>#note_<note_id>`).
- Check the code even when a thread was resolved with no reply. Verify
  fixes that came from our own suggestion. Pushback holds if it is an
  editorial choice, an exception declared in the issue, or a linked
  follow-up issue that exists and is open.
- Not ready while any of our threads is open, even non-blocking.
  Unposted non-blocking nits do not block.
- A skipped push pipeline on the head means CI is unconfirmed; ready
  needs a passing push pipeline on the final head.
- An approved MR rebased to identical content is ready again: say
  "approval reset by rebase, content unchanged".
- For provider-backed config (Cloudflare, AWS, GitLab), check provider
  limits and the post-merge apply, not only syntax.

## Reporting

Lead with the verdict. Findings as a numbered list: file:line, what is
wrong, why, fix. Then "checked and correct" as a compact list. Then the
queue: ready, waiting on authors, your call. No em dashes.

Once, recommend the user narrow hooks to block running `aws`,
`terraform` and `sops` rather than the substring. Never change hook
config.

## Do not

- Post on the user's own MRs; offer a chat-only review instead.
- Retry CI jobs, reply to threads or open issues without the user's yes.
- Re-review an MR whose head moved by a pure rebase.
- Repeat findings the user already dropped.
