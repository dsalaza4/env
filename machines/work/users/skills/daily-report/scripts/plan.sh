#!/usr/bin/env bash
# Open issues assigned to the user, as PLAN-ITEM lines with GitLab titles.
set -uo pipefail
PROJECT=${REPORT_PROJECT:-20741933}
USER_ID=${REPORT_USER_ID:-2925119}

glab api "projects/$PROJECT/issues?assignee_id=$USER_ID&state=opened&per_page=100" 2>/dev/null |
  python3 -c "
import sys, json, re
for d in json.load(sys.stdin):
    title = re.sub(r'^\[[^\]]+\]\s*', '', d['title'])
    prio = next((l.split('::')[1] for l in d.get('labels', []) if l.startswith('priority::')), 'none')
    print(f\"* https://gitlab.com/fluidattacks/universe/-/issues/{d['iid']}: {title}    # {prio}\")
"
