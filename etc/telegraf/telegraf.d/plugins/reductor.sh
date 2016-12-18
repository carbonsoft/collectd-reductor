#!/usr/bin/env bash

set -eu

for module in ipt_reductor ipt_dnsmatch ipt_snimatch; do
        sed -E "s/^/$module./; s/ +/=/g" /proc/net/$module/block_list
done
echo "ipt_reductor.signatures.cache=$(wc -l </app/reductor/var/lib/reductor/cache/signatures.cache)"
find /app/reductor/var/lib/reductor/lists/{rkn,load}/ -type f -exec wc -l {} \; | awk '{print $2"="$1}' | sed 's|.*/||; s|^|lists.|'
