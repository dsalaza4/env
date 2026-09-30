"""Print a conformant METRICS-LINE for one issue.

usage: metrics.py ISSUE_IID PROGRESS_DATE

Reads task_completion_status and created_at from GitLab through glab.
Days elapsed are business days from creation to the progress date,
inclusive. The ETA is the progress date plus ceil(days-left) business
days, which is what reproduces the standard's worked examples.
"""

import datetime
import json
import math
import os
import subprocess
import sys

PROJECT = os.environ.get("REPORT_PROJECT", "20741933")


def business_days_between(start, end):
    days = 0
    current = start
    while current <= end:
        if current.weekday() < 5:
            days += 1
        current += datetime.timedelta(days=1)
    return days


def add_business_days(start, count):
    current, added = start, 0
    while added < count:
        current += datetime.timedelta(days=1)
        if current.weekday() < 5:
            added += 1
    return current


def main():
    iid, progress = sys.argv[1], datetime.date.fromisoformat(sys.argv[2])
    raw = subprocess.run(
        ["glab", "api", f"projects/{PROJECT}/issues/{iid}"],
        capture_output=True, text=True, check=True,
    ).stdout
    issue = json.loads(raw)
    tasks = issue.get("task_completion_status") or {}
    done, total = tasks.get("completed_count", 0), tasks.get("count", 0)
    created = datetime.date.fromisoformat(issue["created_at"][:10])

    print(f"# {iid} {issue['state']} tasks {done}/{total} created {created}")
    if issue["state"] != "opened":
        print("# closed: omit the metrics line")
        return
    if done == 0:
        print("# nothing ticked: omit the metrics line")
        return

    days = business_days_between(created, progress)
    rate = done / days
    todo = total - done
    left = todo / rate
    eta = add_business_days(progress, math.ceil(left))
    if days > 20 and left > 60:
        print("# rate diluted over a long-open issue: consider omitting")
    print(
        f"Speed: {done} / {days} = {round(rate, 2)} items/day, "
        f"TODO: {todo}, ETC: {todo} / {round(rate, 2)} = {round(left, 2)} days ({eta})"
    )


if __name__ == "__main__":
    main()
