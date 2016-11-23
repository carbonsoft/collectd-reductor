#!/usr/bin/env bash

set -eu

PLUGIN_NAME='xt_snimatch'
FILE=/proc/net/${PLUGIN_NAME/xt/ipt}/block_list

replace_regex="s/Registration statement:/activated /;
	s/URL count in database:/entries_load/;
	s/Matched packets:/matched/;
	s/Total packets checked:/checked/;
	s/Elements count:/db_elements/;
"

inline() {
	sed -E 's/ +/=/g' | tr '\n' , | sed 's/,$//'
}

blacklist='Install number|Dont match counter'

echo $PLUGIN_NAME "$(egrep -v "$blacklist" $FILE | sed -E "$replace_regex" | inline)"
