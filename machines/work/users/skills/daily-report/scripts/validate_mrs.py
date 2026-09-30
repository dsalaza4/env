"""Validate the titles and descriptions of the user's MRs touched in a local day.

usage: validate_mrs.py YYYY-MM-DD

HARD findings break a CI gate. soft findings break the user's own
conventions (60-character titles, the prose budget).
"""

import datetime
import json
import os
import re
import subprocess
import sys

PROJECT = os.environ.get("REPORT_PROJECT", "20741933")
USER_ID = os.environ.get("REPORT_USER_ID", "2925119")
TITLE_RE = re.compile(r"^([a-z]+)\\([a-z]+)\(([a-z]+)\): (#\d+) (.+)$")
FOOTER = "\n---\nThese checklists"
STATE = {"merged": "MERGED", "opened": "PENDING", "closed": "REJECTED"}


def glab(path):
    out = subprocess.run(["glab", "api", path], capture_output=True, text=True, check=True).stdout
    return out


def template_values():
    template = glab(f"projects/{PROJECT}/repository/files/.git-commit-template/raw?ref=trunk")
    values = {}
    for key in ("product", "type", "scope"):
        line = next(l for l in template.splitlines() if l.startswith(f"# {key}:"))
        values[key] = {v.strip() for v in line.split(":", 1)[1].split("|")}
    return values


def check(mr, valid):
    title = re.sub(r"^Draft:\s*", "", mr["title"])
    hard, soft = [], []

    match = TITLE_RE.match(title)
    if not match:
        hard.append("title does not match product\\type(scope): #NNNN desc")
    else:
        product, kind, scope, _, desc = match.groups()
        if product not in valid["product"]:
            hard.append(f"product '{product}' not in trunk's product list (check if it existed at merge time)")
        if kind not in valid["type"]:
            hard.append(f"type '{kind}' invalid")
        if scope not in valid["scope"]:
            hard.append(f"scope '{scope}' invalid")
        if ":" in desc:
            hard.append("title description contains ':'")
    if title != title.lower():
        hard.append("title not lowercase")
    if title.endswith("."):
        hard.append("title ends with '.'")
    if len(title) > 82:
        hard.append(f"title {len(title)} chars > 82")
    elif len(title) > 60:
        soft.append(f"title {len(title)} chars > 60")

    description = (mr["description"] or "").replace("\r\n", "\n")
    if FOOTER not in description:
        hard.append("template footer missing")
        message = description
    else:
        message = description.split(FOOTER, 1)[0]
    lines = message.rstrip("\n").split("\n")

    if not lines or lines[0].strip() != title:
        hard.append("description first line != title")
    if len(lines) < 2 or lines[1].strip():
        hard.append("no blank line after title")
    body = lines[2:]
    body_text = "\n".join(body).strip()
    if len(body_text) < 15:
        hard.append("body empty or < 15 chars")
    long_lines = [n + 3 for n, line in enumerate(body) if len(line) > 72]
    if long_lines:
        hard.append(f"body lines > 72 at {long_lines}")
    if re.search(r"co-authored-by", body_text, re.I):
        hard.append("Co-Authored-By trailer")
    refs = sorted(set(re.findall(r"(?<![\w/!])#\d+", body_text)))
    if refs:
        hard.append(f"issue refs in body: {refs}")

    if "``" in body_text:
        soft.append("double backticks")
    if "—" in message:
        soft.append("em dash")
    bullets = [l for l in body if l.startswith("- ")]
    prose = [l for l in body if l.strip() and not l.startswith("- ") and not l.startswith("  ")]
    if len(prose) > 2 or len(prose) > len(bullets):
        soft.append(f"prose budget: {len(prose)} prose lines vs {len(bullets)} bullets")
    for bullet in bullets:
        words = bullet[2:].split()
        if words and words[0].lower().endswith("ing") and len(words[0]) > 4:
            soft.append(f"bullet not infinitive: {bullet[:50]!r}")

    return title, hard, soft


def main():
    day = datetime.date.fromisoformat(sys.argv[1])
    after = f"{day.isoformat()}T05:00:00Z"
    mrs = json.loads(glab(
        f"projects/{PROJECT}/merge_requests?author_id={USER_ID}"
        f"&updated_after={after}&per_page=100&scope=all"
    ))
    valid = template_values()
    for mr in sorted(mrs, key=lambda m: m["iid"]):
        title, hard, soft = check(mr, valid)
        verdict = "FAIL" if hard else ("WARN" if soft else "OK")
        print(f"{mr['iid']} {STATE[mr['state']]:8s} {verdict:4s} | {title}")
        for finding in hard:
            print(f"      HARD  {finding}")
        for finding in soft:
            print(f"      soft  {finding}")


if __name__ == "__main__":
    main()
