import json, os, pathlib, subprocess, sys, time

ME = "dsalazaratfluid"
URL = "https://gitlab.com/fluidattacks/universe/-/merge_requests/"
STALE_INFLIGHT = 90 * 60


def pages(text):
    dec = json.JSONDecoder(strict=False)
    items, i = [], 0
    while i < len(text):
        if text[i].isspace():
            i += 1
            continue
        page, i = dec.raw_decode(text, i)
        items.extend(page if isinstance(page, list) else [page])
    return items


def api(path):
    for attempt in (1, 2):
        try:
            out = subprocess.run(
                ["glab", "api", path, "--paginate"],
                capture_output=True, text=True, timeout=60, check=True,
            ).stdout
            return pages(out)
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
            if attempt == 2:
                raise
            time.sleep(5)


root = pathlib.Path.home() / ".local/state"
state = root / "mr-review"
inflight = state / "inflight"
inflight.mkdir(parents=True, exist_ok=True)
reported_file = root / "mr-review-reported.json"


GIT_ENV = {**os.environ, "GIT_TERMINAL_PROMPT": "0"}


def git(*args, stdin=None):
    try:
        return subprocess.run(
            ["git", *args], input=stdin, capture_output=True, text=True, timeout=120, env=GIT_ENV,
        ).stdout
    except subprocess.TimeoutExpired:
        return ""


def same_content(iid, s):
    refs = api(f"projects/:id/merge_requests/{iid}")[0]["diff_refs"]
    for sha in (s["reviewed_base"], s["reviewed_head"], refs["base_sha"], refs["head_sha"]):
        git("fetch", "-q", "origin", sha)
    pairs = git("range-diff", f"{s['reviewed_base']}..{s['reviewed_head']}", f"{refs['base_sha']}..{refs['head_sha']}").splitlines()
    if not pairs or not all(" = " in line for line in pairs if line[:1].isdigit() or line.startswith("-:")):
        return False
    s["reviewed_base"], s["reviewed_head"] = refs["base_sha"], refs["head_sha"]
    return True


def busy(iid):
    marker = inflight / str(iid)
    return marker.exists() and time.time() - marker.stat().st_mtime < STALE_INFLIGHT


mrs = api(f"projects/:id/merge_requests?reviewer_username={ME}&state=opened&per_page=100")
if not mrs:
    sys.exit("empty queue: run from the repo, or glab failed")
queue = {m["iid"]: m for m in mrs if m["author"]["username"] != ME}
print("open:", *sorted(queue), "| own (skipped):", *sorted(m["iid"] for m in mrs if m["author"]["username"] == ME))

review, verify, ready = [], [], {}
for iid in sorted(queue):
    if not (state / f"{iid}.json").exists() and not busy(iid):
        review.append(iid)
for f in sorted(state.glob("*.json")):
    iid = int(f.stem)
    if iid not in queue:
        f.unlink()
        (inflight / str(iid)).unlink(missing_ok=True)
        print(iid, "closed or left the queue: state dropped")
        continue
    s = json.loads(f.read_text())
    moved = s["reviewed_head"] != queue[iid]["sha"]
    if moved and not busy(iid) and same_content(iid, s):
        f.write_text(json.dumps(s))
        moved = False
    tracked = {k for k, v in s["threads"].items() if v == "open"}
    unresolved = [
        t["id"] for t in api(f"projects/:id/merge_requests/{iid}/discussions?per_page=100")
        if t["id"] in tracked and not t["notes"][0].get("resolved")
    ] if tracked else []
    if busy(iid):
        print(iid, "agent in flight")
    elif tracked and not unresolved:
        verify.append(iid)
    elif moved and not tracked:
        verify.append(iid)
    elif s.get("ready") and not moved:
        approvers = {a["user"]["username"] for a in api(f"projects/:id/merge_requests/{iid}/approvals")[0].get("approved_by", [])}
        if ME not in approvers:
            ready[str(iid)] = f"{URL}{iid} {queue[iid]['title']}"

try:
    reported = set(json.loads(reported_file.read_text()))
except (OSError, ValueError):
    reported = set()
newly = sorted(set(ready) - reported)
reported_file.write_text(json.dumps(sorted(ready)))

print("TO_REVIEW:", *review)
print("TO_VERIFY:", *verify)
print("NEWLY_READY:", *newly)
print("READY FOR APPROVAL:")
for r in ready.values() or ["(none)"]:
    print(" ", r)
