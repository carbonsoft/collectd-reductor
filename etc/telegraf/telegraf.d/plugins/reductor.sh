#!/usr/bin/env bash

set -eu

prepare() {
	TMPDIR=/tmp/telegraf/reductor/
	mkdir -p $TMPDIR
}

read_module() {
	local module="$1"
	local tmpfile=$TMPDIR/module
	local state=0
	sed -E "s/ +/=/g" /proc/net/$module/block_list > $tmpfile
	while IFS='.=' read metric db type value; do
		echo $metric,db=$db,type=$type,module=$module value=$value
	done <<< "$(grep database $tmpfile)"
	while IFS='.=' read metric db type value; do
		echo $metric,type=$db,module=$module value=$type
	done <<< "$(grep packets $tmpfile)"
	chroot /app/reductor/ /usr/local/Reductor/bin/modules_ctl get_state $module || state=$?
	echo activation_error,module=$module value=$state
}

modules() {
	read_module ipt_reductor

	if chroot /app/reductor/ /usr/local/Reductor/bin/dnsenabled; then
		read_module ipt_dnsmatch
	fi

	if chroot /app/reductor/ /usr/local/Reductor/bin/dnsenabled --sni; then
		read_module ipt_snimatch
	fi
}

signatures_cache() {
	echo "ipt_reductor.signatures.cache=$(wc -l </app/reductor/var/lib/reductor/cache/signatures.cache)"
}

lists_sizes() {
	find /app/reductor/var/lib/reductor/lists/{rkn,load}/ -type f -exec wc -l {} \; | awk '{print $2"="$1}' | sed 's|.*/||; s|^|lists.|'
}

main() {
	prepare
	modules
	signatures_cache
	lists_sizes
}

"${@:-main}"
