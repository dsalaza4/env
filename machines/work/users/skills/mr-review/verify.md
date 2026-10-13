Verify the author's fixes on the fluidattacks/universe MRs named below. Read /Users/dsalazar/.claude/skills/mr-review/SKILL.md and /Users/dsalazar/.claude/skills/mr-review/brief.md first and follow the brief's rules (worktree, timeouts, hook rule, posting, state), EXCEPT: do not reply to, resolve or reopen any thread. NEW findings you verify (in the range-diff or caused by a fix) are posted as new anchored threads, following the brief's posting rules, and recorded as "open" in the state file.

Per MR:
- The state file `~/.local/state/mr-review/<iid>.json` has reviewed_head, reviewed_base and our thread ids.
- Get current diff_refs (`glab api "projects/:id/merge_requests/<iid>"`, json.loads strict=False). Fetch each SHA separately: `timeout 90 git fetch origin <sha>` for the source branch, reviewed_head and reviewed_base (one fetch of several SHAs fails as a whole).
- `git range-diff <reviewed_base>..<reviewed_head> <base>..<head>`. An unpaired commit means it was rewritten: diff old head vs new head on the touched files and review the rewrite fully.
- Read every one of our threads in full (our original note plus the author's replies; skip system notes). "Resolved with no reply" is common: always check the code.
- Per thread decide AGREE (fixed correctly, pushback holds, or a cited follow-up issue exists, is open, and covers it) or DISAGREE (what is still wrong). Verify against the code or config at the new base, not the reply. Confirm any cited issue exists and is open.
- Verify the fix itself, not only that the author applied our suggestion: our suggested wording or code can be wrong too.
- Review any other prose or code the range-diff shows changed.
- Update the state file: reviewed_head/base to current, threads "reported", `"ready": true` only if every thread is AGREE and no new blocking finding, posted or unposted (non-blocking nits do not block). Record any finding a hook kept from posting in `unposted`. Delete `~/.local/state/mr-review/inflight/<iid>`.

Return per MR: link, per thread AGREE/DISAGREE with one-line evidence, new findings (file:line, blocking or not), ready yes/no, and anything a hook blocked (do not work around hooks).
