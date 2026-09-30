#!/usr/bin/env bash
# Everything the report needs for one local day (UTC-5).
# usage: sweep_day.sh YYYY-MM-DD
set -uo pipefail
D=${1:?usage: sweep_day.sh YYYY-MM-DD}
PROJECT=${REPORT_PROJECT:-20741933}
USER_ID=${REPORT_USER_ID:-2925119}
GH_USER=${REPORT_GH_USER:-dsalaza4}

day() { python3 -c "import datetime as d; print((d.date.fromisoformat('$D') + d.timedelta(days=$1)).isoformat())"; }
LO=${D}T05:00:00Z
HI=$(day 1)T05:00:00Z
PREV=$(day -1)

echo "########## WINDOW $LO .. $HI  (now $(date -u +%FT%TZ) utc)"

echo
echo "########## EVENTS"
glab api "users/$USER_ID/events?after=$PREV&per_page=300" 2>/dev/null |
  python3 -c "
import sys, json
for e in sorted(json.load(sys.stdin), key=lambda x: x['created_at']):
    c = e['created_at']
    if not ('$LO' <= c < '$HI') or e['action_name'] in ('pushed to', 'pushed new', 'deleted', 'commented on'):
        continue
    print(c[:19], e['action_name'], e.get('target_type'), e.get('target_iid') or '', '|', (e.get('target_title') or '')[:62])
"

echo
echo "########## MY MRs TOUCHED"
glab api "projects/$PROJECT/merge_requests?author_id=$USER_ID&updated_after=$LO&per_page=100&scope=all" 2>/dev/null |
  python3 -c "
import sys, json
tag = {'merged': 'MERGED', 'opened': 'PENDING', 'closed': 'REJECTED'}
for m in sorted(json.load(sys.stdin), key=lambda x: x['iid']):
    print(m['iid'], tag[m['state']], '| created', m['created_at'][:19], '| merged', str(m['merged_at'])[:19])
    print('   ', m['title'])
"

echo
echo "########## ISSUE OPEN/CLOSE EVENTS"
glab api "users/$USER_ID/events?after=$PREV&per_page=300" 2>/dev/null |
  python3 -c "
import sys, json
for e in sorted(json.load(sys.stdin), key=lambda x: x['created_at']):
    c = e['created_at']
    if not ('$LO' <= c < '$HI') or e.get('target_type') not in ('Issue', 'WorkItem'):
        continue
    if e['action_name'] == 'commented on':
        continue
    print(c[:19], e['action_name'], e.get('target_iid'), '|', (e.get('target_title') or '')[:66])
"

echo
echo "########## APPROVED TODAY"
glab api "users/$USER_ID/events?after=$PREV&per_page=300&action=approved" 2>/dev/null |
  python3 -c "
import sys, json
seen = []
for e in sorted(json.load(sys.stdin), key=lambda x: x['created_at']):
    if '$LO' <= e['created_at'] < '$HI' and e.get('target_iid') not in seen:
        seen.append(e.get('target_iid'))
for iid in sorted(seen):
    print(iid)
print('count:', len(seen))
"

echo
echo "########## GITHUB"
gh api "search/issues?q=author:$GH_USER+created:$D..$(day 1)&per_page=50" 2>/dev/null |
  python3 -c "
import sys, json
d = json.load(sys.stdin)
print('count:', d.get('total_count'))
for i in d.get('items', []):
    print(i['created_at'], i['state'], i['html_url'], '|', i['title'][:85])
"
