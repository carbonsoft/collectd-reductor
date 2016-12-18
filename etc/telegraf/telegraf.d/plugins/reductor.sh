#!/usr/bin/env bash

set -eu

read_module() {
	local module="$1"
	sed -E "s/^/$module./; s/ +/=/g" /proc/net/$module/block_list
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
	modules
	signatures_cache
	lists_sizes
}

main "$@"
