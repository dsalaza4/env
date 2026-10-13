"""Everything the report needs for one local day (UTC-5).

usage: sweep_day.py YYYY-MM-DD [--details]

--details adds MR DETAILS and ISSUES TOUCHED (descriptions, milestones,
task counts, metrics, closing notes).
"""

import datetime
import os
import re
import sys
from concurrent.futures import ThreadPoolExecutor

import gl
import metrics

NOISE = {"pushed to", "pushed new", "deleted", "commented on"}
STATE = {"merged": "MERGED", "opened": "PENDING", "closed": "REJECTED"}
FOOTER = re.compile(r"\n---\n|\nThese checklists")


def section(name):
    def wrap(fn):
        def run(*args):
            print(f"\n########## {name}")
            try:
                return fn(*args)
            except gl.ApiError as error:
                print(f"ERROR: {error}")
        return run
    return wrap


def fetch_many(fn, keys):
    with ThreadPoolExecutor(8) as pool:
        return dict(zip(keys, pool.map(fn, keys)))


def issue(iid):
    return gl.get(f"projects/{gl.PROJECT}/issues/{iid}")


def mr(iid):
    return gl.get(f"projects/{gl.PROJECT}/merge_requests/{iid}")


def milestone(item):
    m = item.get("milestone")
    return f"{m['id']} {m['title']}" if m else "NO MILESTONE"


class Sweep:
    def __init__(self, day):
        self.day = day
        self.lo, self.hi = gl.window(day)
        self.events = []
        self.mine = []

    def in_day(self, stamp):
        return self.lo <= stamp < self.hi

    def project_events(self, types):
        return [
            e for e in self.events
            if e["project_id"] == int(gl.PROJECT) and e.get("target_type") in types
        ]

    @section("EVENTS")
    def events_section(self):
        before = (self.day + datetime.timedelta(days=2)).isoformat()
        after = (self.day - datetime.timedelta(days=1)).isoformat()
        fetched = gl.get_all(f"users/{gl.USER_ID}/events?after={after}&before={before}&per_page=100")
        if fetched and len(fetched) % 100 == 0 and min(e["created_at"] for e in fetched) > self.lo:
            print("WARNING: events may be truncated")
        self.events = sorted((e for e in fetched if self.in_day(e["created_at"])), key=lambda e: e["created_at"])
        for e in self.events:
            if e["action_name"] in NOISE:
                continue
            where = "" if e["project_id"] == int(gl.PROJECT) else f" [project {e['project_id']}]"
            print(e["created_at"][:19], e["action_name"], e.get("target_type"), e.get("target_iid") or "",
                  "|", (e.get("target_title") or "")[:62] + where)

    @section("MY MRs TOUCHED")
    def mine_section(self):
        self.mine = sorted(gl.get_all(
            f"projects/{gl.PROJECT}/merge_requests?author_id={gl.USER_ID}"
            f"&updated_after={self.lo}&per_page=100&scope=all"
        ), key=lambda m: m["iid"])
        for m in self.mine:
            print(m["iid"], STATE[m["state"]], "| created", m["created_at"][:19], "| merged", str(m["merged_at"])[:19])
            print("   ", m["title"])

    def issue_moves(self):
        moves = {}
        for e in self.project_events({"Issue", "WorkItem"}):
            if e["action_name"] in ("opened", "closed", "reopened"):
                moves.setdefault(e["target_iid"], []).append(e["action_name"])
        return moves

    @section("ISSUES OPENED/CLOSED TODAY")
    def issues_section(self):
        moves = self.issue_moves()
        for iid, item in fetch_many(issue, sorted(moves)).items():
            who = ",".join(a["username"] for a in item["assignees"]) or "UNASSIGNED"
            print(iid, "/".join(moves[iid]), "| now", item["state"], "|", milestone(item), "|", who)
            print("   ", gl.strip_component(item["title"]))

    @section("REVIEWED TODAY (excluding own MRs)")
    def reviewed_section(self):
        own = {m["iid"] for m in self.mine}
        approved = sorted({
            e["target_iid"] for e in self.project_events({"MergeRequest"})
            if e["action_name"] == "approved" and e["target_iid"] not in own
        })
        authors = {iid: m["author"] for iid, m in fetch_many(mr, approved).items()}
        kept = [iid for iid in approved if authors[iid]["id"] != gl.USER_ID]
        for iid in kept:
            print(iid, authors[iid]["username"])
        print("count:", len(kept))

    @section("GITHUB")
    def github_section(self):
        tomorrow = (self.day + datetime.timedelta(days=1)).isoformat()
        found = gl.gh(f"search/issues?q=author:{gl.GH_USER}+created:{self.day}..{tomorrow}&per_page=100")
        items = [i for i in found.get("items", []) if self.in_day(i["created_at"])]
        print("count:", len(items))
        for i in items:
            print(i["created_at"], i["state"], i["html_url"], "|", i["title"][:85])

    @section("STALE IN PREVIOUS REPORT")
    def stale_section(self):
        if not os.path.exists(gl.REPORT):
            print(f"no {gl.REPORT}")
            return
        text = open(gl.REPORT).read()
        date = re.search(r"^Progress Date: (\S+)", text, re.M)
        print("report date:", date.group(1) if date else "unknown")
        pending = [int(n) for n in re.findall(r"^\S+/merge_requests/(\d+) \(PENDING\)$", text, re.M)]
        opened = [int(n) for n in re.findall(r"^\S+/issues/(\d+): .* \(OPEN\)$", text, re.M)]
        for iid, m in fetch_many(mr, pending).items():
            if m["state"] != "opened":
                print("MR", iid, m["state"], m["merged_at"] or m["closed_at"])
        for iid, item in fetch_many(issue, opened).items():
            if item["state"] != "opened":
                print("issue", iid, "closed", item["closed_at"])

    @section("MR DETAILS")
    def mr_details_section(self):
        for m in self.mine:
            body = FOOTER.split((m["description"] or "").replace("\r\n", "\n"), 1)[0].strip()
            print(f"--- {m['iid']} {STATE[m['state']]} merged {m['merged_at']}")
            print(body)

    @section("ISSUES TOUCHED")
    def issues_touched_section(self):
        merged_today = {}
        refs = set(self.issue_moves())
        for m in self.mine:
            for ref in gl.issue_refs(m["title"]):
                refs.add(ref)
                if m["merged_at"] and self.in_day(m["merged_at"]):
                    merged_today[ref] = merged_today.get(ref, 0) + 1
        closed_today = {
            e["target_iid"] for e in self.project_events({"Issue", "WorkItem"}) if e["action_name"] == "closed"
        }
        for iid, item in fetch_many(issue, sorted(refs)).items():
            tasks = item.get("task_completion_status") or {}
            who = ",".join(a["username"] for a in item["assignees"]) or "UNASSIGNED"
            print(f"--- {iid} {item['state']} | {milestone(item)} | {who}")
            print("   ", gl.strip_component(item["title"]))
            for line in metrics.lines(iid, self.day, item):
                print("   ", line)
            if merged_today.get(iid) and tasks.get("count") and not tasks.get("completed_count"):
                print(f"    CHECKLIST BEHIND? {merged_today[iid]} MR(s) merged today, 0 ticked")
            if iid in closed_today:
                notes = gl.get(f"projects/{gl.PROJECT}/issues/{iid}/notes?sort=desc&order_by=created_at&per_page=20")
                note = next((n for n in notes if not n["system"]), None)
                print("    closing note:", note["body"] if note else "(none)")


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if len(args) != 1:
        sys.exit("usage: sweep_day.py YYYY-MM-DD [--details]")
    sweep = Sweep(datetime.date.fromisoformat(args[0]))
    print(f"########## WINDOW {sweep.lo} .. {sweep.hi}  (now {datetime.datetime.now(datetime.UTC):%Y-%m-%dT%H:%M:%SZ} utc)")
    sweep.events_section()
    sweep.mine_section()
    sweep.issues_section()
    sweep.reviewed_section()
    sweep.github_section()
    sweep.stale_section()
    if "--details" in sys.argv:
        sweep.mr_details_section()
        sweep.issues_touched_section()


if __name__ == "__main__":
    main()
