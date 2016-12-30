#!/usr/bin/env bash

set -eu

PLUGIN=/usr/local/Reductor/bin/collectd_plugin
INTERVAL="${1:-10s}"

while sleep $INTERVAL; do
	if [ -x /app/reductor/$PLUGIN ]; then
		sudo chroot /app/reductor/ "$PLUGIN" "$INTERVAL"
	elif [ -x "$PLUGIN" ]; then
		"$PLUGIN" "$INTERVAL"
	else
		echo "No plugin available"
		exit 1
	fi
done
