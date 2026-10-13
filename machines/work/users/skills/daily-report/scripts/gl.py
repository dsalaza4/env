import datetime
import json
import os
import re
import subprocess

PROJECT = os.environ.get("REPORT_PROJECT", "20741933")
USER_ID = int(os.environ.get("REPORT_USER_ID", "2925119"))
GH_USER = os.environ.get("REPORT_GH_USER", "dsalaza4")
REPORT = os.path.expanduser(os.environ.get("REPORT_FILE", "~/report.txt"))
BASE = "https://gitlab.com/fluidattacks/universe/-"
TOKEN_HINT = "an expired GITLAB_TOKEN overrides stored credentials: check `type glab` and refresh it"


class ApiError(Exception):
    pass


def pages(text):
    decoder = json.JSONDecoder(strict=False)
    items, i = [], 0
    while i < len(text):
        if text[i].isspace():
            i += 1
            continue
        page, i = decoder.raw_decode(text, i)
        items.append(page)
    return items


def _run(cmd):
    for attempt in (1, 2):
        try:
            proc = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        except subprocess.TimeoutExpired:
            if attempt == 2:
                raise ApiError(f"timeout: {' '.join(cmd)}")
            continue
        found = pages(proc.stdout) if proc.stdout.strip() else []
        errors = [p for p in found if isinstance(p, dict) and ("message" in p or "error" in p)]
        if errors:
            message = str(errors[0].get("message") or errors[0].get("error"))
            raise ApiError(f"{message} ({TOKEN_HINT})" if "401" in message else message)
        if proc.returncode == 0:
            return found
        if attempt == 2:
            raise ApiError(proc.stderr.strip().splitlines()[-1] if proc.stderr.strip() else f"exit {proc.returncode}")


def get(path):
    return _run(["glab", "api", path])[0]


def get_all(path):
    items = []
    for page in _run(["glab", "api", "--paginate", path]):
        items.extend(page if isinstance(page, list) else [page])
    return items


def gh(path):
    return _run(["gh", "api", path])[0]


def window(day):
    lo = f"{day.isoformat()}T05:00:00Z"
    hi = f"{(day + datetime.timedelta(days=1)).isoformat()}T05:00:00Z"
    return lo, hi


def strip_component(title):
    return re.sub(r"^\[[^\]]+\]\s*", "", title)


def issue_refs(text):
    return [int(n) for n in re.findall(r"#(\d+)(?!\d)", text)]


def mentions(title, iid):
    return re.search(rf"#{iid}(?!\d)", title) is not None
