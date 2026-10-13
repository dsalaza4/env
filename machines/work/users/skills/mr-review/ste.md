STE100 docs review guidance (mmoyaatfluid series). Use with brief.md or verify.md.

Spec axis:
- Meaning preserved.
- Facts correct against the CURRENT code and infra the pages describe. When the MR is old, check it against current trunk, not only its base.
- No broken links or anchors: grep all of docs/src for links to every changed heading slug.
- Code blocks, commands, diagrams and front matter byte-identical unless the MR body says otherwise.
- Headings and table cells change only for the reasons the issue states.
- DocAlert bodies rewritten.
- The issue's file list covered.
- Any fact correction claimed in the MR body verified against code.

Earlier reviews in this series kept finding facts that were already wrong but sit on rewritten lines: wrong file or module paths, renamed tools or commands (benchmark -> gym), wrong test runner (Jest vs Vitest), wrong counts, wrong behavior (truncate vs reject, restart vs quit), wrong bucket, wrong event handling, removed UI, wrong button labels. Hunt for that class.

Only real, verified findings; no style nitpicks. If the fix would touch a heading, table or code block the issue keeps out of scope, still post it and suggest a follow-up issue.
