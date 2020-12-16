#!/usr/bin/env bash
set -euo pipefail

DNS_BIND_IFACE=${DNS_BIND_IFACE:-eth0}
echo [$(date "+%Y-%m-%d %H:%M:%S")] "DNS service starting, fetching ip for ${DNS_BIND_IFACE}"
export DNS_IP=$(ip -f inet addr show ${DNS_BIND_IFACE} | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
echo [$(date "+%Y-%m-%d %H:%M:%S")] "Starting coredns with DNS_IP=${DNS_IP}, DNS_UPSTREAM1=${DNS_UPSTREAM1}, , DNS_UPSTREAM2=${DNS_UPSTREAM1}, DNS_UPSTREAM_NAME=$DNS_UPSTREAM_NAME"

if [ "$(id -u)" = '0' ]; then
    mkdir -p /data/zones
    chown -R coredns:coredns /data
    exec gosu coredns "$BASH_SOURCE" "$@"
fi

exec "$@"
