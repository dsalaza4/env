"""Plan list: the previous report's order, minus issues no longer open and
assigned, plus newly assigned issues placed by their priority:: label.

usage: plan.py
"""

import os
import re
import sys

import gl

RANK = {"critical": 0, "high": 1, "medium": 2, "low": 3, "none": 4}


def priority(item):
    return next((l.split("::")[1] for l in item["labels"] if l.startswith("priority::")), "none")


def previous_order():
    if not os.path.exists(gl.REPORT):
        return []
    text = open(gl.REPORT).read()
    block = text.split("Next issues", 1)[1].split("\n\n", 1)[0] if "Next issues" in text else ""
    return [int(n) for n in re.findall(r"^\* \S+/issues/(\d+):", block, re.M)]


def main():
    assigned = {
        i["iid"]: i for i in gl.get_all(
            f"projects/{gl.PROJECT}/issues?assignee_id={gl.USER_ID}&state=opened&per_page=100"
        )
    }
    order, notes = [], []
    for iid in previous_order():
        if iid in assigned:
            order.append(iid)
        else:
            state = gl.get(f"projects/{gl.PROJECT}/issues/{iid}")["state"]
            notes.append(f"# dropped: {iid} {'closed' if state == 'closed' else 'unassigned'}")

    for iid in sorted(set(assigned) - set(order)):
        rank = RANK.get(priority(assigned[iid]), 4)
        at = max((n + 1 for n, kept in enumerate(order) if RANK.get(priority(assigned[kept]), 4) <= rank), default=0)
        order.insert(at, iid)
        notes.append(f"# NEW ({priority(assigned[iid])}): {iid} at position {at + 1}")

    print("\n".join(notes))
    for iid in order:
        print(f"* {gl.BASE}/issues/{iid}: {gl.strip_component(assigned[iid]['title'])}")


if __name__ == "__main__":
    try:
        main()
    except gl.ApiError as error:
        sys.exit(f"ERROR: {error}")
