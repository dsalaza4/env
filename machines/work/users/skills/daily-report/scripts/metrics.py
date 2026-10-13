"""Print a conformant METRICS-LINE for one issue.

usage: metrics.py ISSUE_IID PROGRESS_DATE

Days elapsed are business days (weekdays) from the day of the issue's
first MR to the progress date, inclusive. The ETA is the progress date
plus ceil(days-left) business days, which reproduces the standard's
worked examples.
"""

import datetime
import math
import sys

import gl


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


def first_mr(iid):
    # Related MRs include ones that only mention the issue; a rejected first MR still marks the start.
    related = gl.get_all(f"projects/{gl.PROJECT}/issues/{iid}/related_merge_requests?per_page=100")
    own = [m for m in related if m["project_id"] == int(gl.PROJECT) and gl.mentions(m["title"], iid)]
    return min(own, key=lambda m: m["created_at"]) if own else None


def lines(iid, progress, issue=None):
    issue = issue or gl.get(f"projects/{gl.PROJECT}/issues/{iid}")
    tasks = issue.get("task_completion_status") or {}
    done, total = tasks.get("completed_count", 0), tasks.get("count", 0)
    first = first_mr(iid)
    start = datetime.date.fromisoformat(first["created_at"][:10]) if first else None
    head = f"# {iid} {issue['state']} tasks {done}/{total}"
    head += f" first MR {first['iid']} on {start}" if first else ""

    if issue["state"] != "opened":
        return [head, "# closed: omit the metrics line"]
    if not first:
        return [head, "# no MR yet: omit the metrics line"]
    if done == 0:
        return [head, "# nothing ticked: omit the metrics line"]

    days = business_days_between(start, progress)
    rate = done / days
    todo = total - done
    left = todo / rate
    eta = add_business_days(progress, math.ceil(left))
    return [head, (
        f"Speed: {done} / {days} = {round(rate, 2)} items/day, "
        f"TODO: {todo}, ETC: {todo} / {round(rate, 2)} = {round(left, 2)} days ({eta})"
    )]


def main():
    iid, progress = int(sys.argv[1]), datetime.date.fromisoformat(sys.argv[2])
    try:
        print("\n".join(lines(iid, progress)))
    except gl.ApiError as error:
        sys.exit(f"ERROR: {error}")


if __name__ == "__main__":
    main()
