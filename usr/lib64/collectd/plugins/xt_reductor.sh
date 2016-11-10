#!/usr/bin/env bash

PLUGIN_NAME='xt_reductor'
HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname)}"
INTERVAL="${COLLECTD_INTERVAL:-10}"
FILE=/proc/net/${PLUGIN_NAME/xt/ipt}/block_list

replace_regex="s/Registration statement:/gauge-activated /;
	 s/URL count in database:/gauge-entries_load/;
	 s/Matched packets:/gauge-matched/;
	 s/Total packets checked:/gauge-checked/;
	 s/Elements count:/gauge-db_elements/;
"
while sleep $INTERVAL; do
	egrep -v 'Install number|Dont match counter' $FILE | sed -E "$replace_regex" > /tmp/$PLUGIN_NAME
	current_date=$(date +%s)
       	while read var val; do
		echo PUTVAL $HOSTNAME/$PLUGIN_NAME/$var $current_date:$val
	done < /tmp/$PLUGIN_NAME
	rm -f /tmp/$PLUGIN_NAME
done
