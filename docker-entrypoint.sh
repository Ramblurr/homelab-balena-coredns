#!/usr/bin/env bash
set -euo pipefail

wait_for_handover() {
    echo [$(date "+%Y-%m-%d %H:%M:%S")] "Waiting for next handover"
    while [ ! -f /data/hand-over-waiting ]; do
        sleep 5
    done
    echo [$(date "+%Y-%m-%d %H:%M:%S")] "New sibling requested handover, acking"
    touch /data/hand-over-ack
    touch /data/resin-kill-me
}

if [ ! -f /data/hand-over-booted ]; then
    # this is our first boot so there is no sibling
    touch /data/hand-over-booted
else
    # signal sibling we are waiting for the handover
    touch /data/hand-over-waiting
    while [ ! -f /data/hand-over-ack ]; do
        echo [$(date "+%Y-%m-%d %H:%M:%S")] "Waiting for sibling to signal handover is ready"
        sleep 2
    done
    echo [$(date "+%Y-%m-%d %H:%M:%S")] "Sibling acked. Booting"

    # cleanup and prepare for next handover
    rm -f /data/hand-over-ack
    rm -f /data/hand-over-waiting
    rm -f /data/resin-kill-me

    # give time for sibling container to be killed
    sleep 2
fi


wait_for_handover &

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
