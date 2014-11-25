#!/bin/bash

#genereate export to hive hql for "hive -f '$file'"

DOMAIN=XXX #
TABLE=data_common
ACTION=(
backend.approve_fakecheck #partitions
)
start_ts="$1";
end_ts="$2";
#local i d;
if ! echo $start_ts | grep -qE '^[0-9]+$'; then
start_ts=$(date -d "$start_ts 23:59:59" +%s);
fi
if ! echo $end_ts | grep -qE '^[0-9]+$'; then
end_ts=$(date -d "$end_ts 23:59:59" +%s);
fi
for ((i=$start_ts; i >= $end_ts; i -= 86400)); do
	for action in "${ACTION[@]}"; do
		d=$(date -d @$i +%Y-%m-%d)
		echo "ALTER TABLE $TABLE add if not exists partition (site_domain='$DOMAIN', action='$action', day='$d') location '/data/rawdata/$DOMAIN/userlog/$action/$(echo $d | tr - / )';"
	done
done
