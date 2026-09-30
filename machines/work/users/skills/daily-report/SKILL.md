---
name: daily-report
description: Write, sweep and validate the Engineering daily progress report in ~/report.txt from GitLab activity. Use when the user asks to start, prepare, update or re-sweep today's report, add collaborations to it, or validate the MRs it lists.
---

# Daily report

The report follows the Fluid Attacks "Daily Progress Report" standard
(ASD-STE100 output). The standard is the authority; this skill is how to
produce a conformant report from GitLab, and the mistakes already made.

## Workflow

1. **Sweep** the local day: `scripts/sweep_day.sh YYYY-MM-DD`.
2. **Read** every touched MR description and every issue that was
   opened, closed or advanced (milestone, task counts, closing note).
3. **Write** `~/report.txt` from scratch in the grammar below. Never
   carry yesterday's content forward.
4. **Compute** metrics with `scripts/metrics.py`.
5. **Build** the plan list with `scripts/plan.sh`.
6. **Validate** MR titles and descriptions with `scripts/validate_mrs.py`
   when asked, and report findings rather than editing MRs.
7. Leave `Collaborations:` as an empty heading. The user supplies them.

On "update", "again" or "sweep": re-run the sweep, diff against the
report, change only what moved, and say what moved. Re-check the
metrics task counts every time; they change without any MR.

## The local day

The user is at UTC-5. The report day `D` is
`D T05:00:00Z .. D+1 T05:00:00Z`. Filtering on the UTC date silently
drops everything after 19:00 local. Friday's report covers Friday only;
Monday's covers Monday only.

## Output grammar

```
Talent: dsalazar@fluidattacks.com
Team: Engineering
Progress Date: YYYY-MM-DD

What did I do today:

<milestone-url>: <milestone-name>
<issue-url>: <issue title> (OPEN|CLOSE)
[Speed: <done> / <days> = <rate> items/day, TODO: <n>, ETC: <n> / <rate> = <d> days (<yyyy-mm-dd>)]
<mr-url> (MERGED|PENDING|REJECTED)
* <bullet>
* <bullet>

<mr-url> (MERGED|PENDING|REJECTED)
* <bullet>

<next DONE-BLOCK, milestone line repeated even when identical>

Merge requests reviewed:
* <mr-url>

Collaborations:
* <what was done together> (<login>, <login>)

What will I do tomorrow:

Next issues, in priority order (highest first):
* <issue-url>: <issue title>

I would need help with:

These items block me, in priority order (highest first); they stay in every report until resolved:
* None.
```

Structural rules:

- Issue URLs use `/-/issues/`, not `/-/work_items/`.
- Issue state is `(OPEN)` or `(CLOSE)`. Not `(CLOSED)`.
- MR state is `(MERGED)`, `(PENDING)` for open or draft, `(REJECTED)` for
  closed unmerged. Never `(OPEN)`, `(DRAFT)` or `(CLOSED)` on an MR.
- No blank line between the issue line (or metrics line) and its first
  MR line. One blank line between MR blocks and between DONE-BLOCKs.
- Every bullet sits under an MR line. A closure summary goes as the last
  bullets of the issue's final MR, never as orphan bullets.
- Several MRs sharing one bullet set: stack their URL lines, then the
  bullets once (use it for batches of near-identical MRs).
- Priority is conveyed by order only. Never write `[HIGH]`, `[MEDIUM]`
  or any priority text (R9). The plan list has no action sub-bullets.
- Order MR blocks inside an issue by merge time, merged before pending,
  rejected last.

## Content rules

**Which issues get a DONE-BLOCK.** One per issue that had an MR today,
under that issue's **current** milestone (milestones move between days;
re-read them). An issue with no milestone, or with no MR, cannot form a
conformant block (R2). Leave it out and tell the user, naming the issue
and what it needs. This covers duplicates closed without work, and
issues closed on a decision alone.

**Titles.** Use the GitLab issue title verbatim, minus the leading
`[Component]` prefix. Do not paraphrase: the reader must be able to find
the issue. If a title reads badly, tell the user; they fix it in GitLab.

**Bullets.** Written for a manager with high-level context who never
opened the diff. Each bullet states an achievement, a gap or a
difficulty (R7). Test every bullet: would someone outside the change
understand it?

- Plain words. No internal identifiers, argument names, function names,
  version numbers or resource names. `prod_bridges` becomes "one of the
  six machine groups that run our applications"; "Batch pins" becomes
  "components that run batch jobs".
- Keep numbers that convey scale or impact (jobs, minutes, percentages,
  counts of things affected).
- Say what was possible or broken before, when that is the point.
- A rejected MR says why it was closed, from its closing note.
- STE100: impersonal voice, never "I" or "we" or a person as agent; one
  fact per sentence; 20 words or fewer; present tense; one term per
  concept, reused; general to specific; no figurative language; no em
  dashes.
- Three or four bullets per MR at most.

**Metrics line.** Optional; include it when the issue has a task list
and at least one item is ticked. Source: the issue's
`task_completion_status`, not your own count. Omit it for closed issues,
for zero ticked items, and when the rate is diluted into nonsense (an
issue open for months with work only starting now). Say why you omitted
it. `scripts/metrics.py` does the arithmetic: days elapsed are business
days from issue creation to the progress date inclusive, and the ETA is
the progress date plus `ceil(days-left)` business days (reverse-derived
from the standard's worked examples). Always pass today's progress date;
a stale date gives a wrong rate. If the rate looks wrong because ticked
items lag merged work, tell the user the checklist is behind.

**Reviewed list.** MRs whose approval note by the user is timestamped in
the local day, from the events feed (`action=approved`), deduplicated,
ascending. Do not use the `approved_by_ids` filter: it misses MRs whose
approval a later push reset, and includes MRs approved on earlier days
that merely updated today.

**Collaborations.** Rewrite the user's notes impersonally (§05 forbids a
person as agent): "He needed X" becomes the outcome; "We agreed" becomes
the decision; "I'm confident it looks awesome" becomes a neutral
expectation. Keep the substance and the reasoning. Plain terms: "RFC" is
"proposal", "edge" is "public entry point". Meeting items take the
meeting name as the login, e.g. `(engineering weekly meeting)`.

**Plan list.** Exactly the open issues assigned to the user, from
`scripts/plan.sh`. Not issues they opened but left unassigned, not
issues assigned to others. Keep the user's chosen order; place new
assigned issues by their `priority::` label and say where you put them.

**Help list.** `* None.` unless something blocks the user. A help item
needs a resolver's login; if a blocker appears in collaborations or a
closing note, ask for the resolver rather than inventing one.

## Validating MR titles and descriptions

`scripts/validate_mrs.py` checks, against rules read from trunk:

- Hard (CI-enforced): title matches `product\type(scope): #NNNN desc`,
  product from trunk's `.git-commit-template`, lowercase, no trailing
  dot, 82 characters or fewer, description first line equals the title,
  blank line after it, body 15+ characters, body lines 72 or fewer, no
  `Co-Authored-By`, no `#NNNN` in the body, template footer present.
- Soft (user conventions): title over 60 (skill target), prose budget
  (at most 2 prose lines and never more prose lines than bullets),
  double backticks, em dashes, gerund bullets.

Read the rule sources from trunk through the API, not the local
checkout: the checkout is often behind. The commit rules live in
`.memory/skills/pushing-code/SKILL.md` and the commitlint config under
`develops/`. A product that was valid when an MR merged but is gone now
(for example `common`) is a timing false alarm; say so.

## Gotchas already hit

- Issues get deleted and replaced by others; MRs get repurposed to a
  different issue. A vanished issue or an MR whose `#NNNN` changed
  means re-reading, not an error.
- MRs merge minutes after a sweep. Something created or merged after the
  last sweep of a day belongs to that day's report; mention it when it
  surfaces the next day instead of silently back-filling.
- Closing notes carry the best closure bullets (verification evidence,
  what was deliberately left unticked). Read them.
- An expired `GITLAB_TOKEN` in the environment makes every call return
  an error object, and `glab` prefers it over stored credentials. Tell
  the user to check `type glab` and refresh the token.
- The scratchpad is wiped between sessions. The scripts live with this
  skill for that reason.
- A worktree-isolated session refuses compound shell commands. Write
  multi-step logic to a script file and run it.
