# Component pitfalls

Learned 2026-09-30 to 2026-10-13. Claims to verify, not facts; drop entries
that stop matching the code.

**Docs STE100 series.** See `ste.md`.

**sifts.** Versioned run artifacts go to `sifts-data`, SARIF to
`machine.data/sifts/results/`. Voyage embeddings are the classifier input,
cached. Production prediction is a fallback (saved prediction first).
Advanced plan only. smells no longer calls sifts (#30714). Customer code
reaches Logfire (`instrument_pydantic_ai`) and Snowflake (candidate
training). Wrong privacy claims are blocking.

**signals (Rust, #30848 series).** A clone exception is declared for
`roots.rs` paging and the panel clone gate. `logging::failure!` keeps the
caller's target. Refactors in this series hid visible changes (column
width, logging targets, banner severity): diff for behavior, not only
moves. Run tests from the component flake dir; on macOS set
`LIBRARY_PATH` for libiconv. `gpui::screens::documentation::tests` (3
tests) fail locally only; not a regression.

**CRM docs.** Zoho is external: say what cannot be checked. Watch for
fields removed by earlier CRM MRs coming back.

**Infra (`runs/*`).** Read the plan action list, not the job color. Known
noise: perpetual drift in `runs/vpn/infra` (~290 logpush and gateway
changes), `gitlab_bot null_resource.build`,
`batch_integrates_unreachable_commits` replaced every plan in observes.
`aarch64-on-demand` is the deploy tag and must move last. A temporary
unlock or flag needs a tracked removal. Cloudflare DLP regexes: check
length and match-size limits, not only escaping.

**rotates-bot proposals.** The commit body must name every changed key
with a `- Rotate <KEY>` bullet. A carried key listed as a bare bullet
fails `develops-hooks-secrets` (root cause:
`develops/rotates/crates/shell/src/output.rs` `proposal_body`).

**GitLab.** The ghost user on gitlab.com is `ghost1`; `ghost` is a real
account.

**Pipelines.** Ignore `forces`/`forces-rs` and `docs lint:links:external`
(allow_failure). Runner system failures need a retry, not a finding.
