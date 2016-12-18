#!/usr/bin/env bash

set -eu

PLUGIN=/usr/local/Reductor/bin/telegraf_plugin

if [ -x /app/reductor/$PLUGIN ]; then
	sudo chroot /app/reductor/ $PLUGIN
elif [ -x $PLUGIN ]; then
	$PLUGIN
else
	echo "No plugin available"
	exit 1
fi
