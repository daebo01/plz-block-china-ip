#!/bin/sh -e

SETNAME="chinaip"
IPLISTFILE="cn-aggregated.zone"

# 이미 있는지 확인
if ! ipset list ${SETNAME} > /dev/null 2>&1; then
    ipset create ${SETNAME} hash:net
fi

# -! option -> ignore already added error
xargs -a ${IPLISTFILE} -n 1 ipset add -! ${SETNAME}

if ! iptables -C INPUT -m set --match-set ${SETNAME} src -j DROP 2> /dev/null; then
    iptables -I INPUT -m set --match-set ${SETNAME} src -j DROP
fi

if ! iptables -C FORWARD -m set --match-set ${SETNAME} src -j DROP 2> /dev/null; then
    iptables -I FORWARD -m set --match-set ${SETNAME} src -j DROP
fi

if ! iptables -t nat -C PREROUTING -m set --match-set ${SETNAME} src -j RETURN 2> /dev/null; then
    iptables -t nat -I PREROUTING -m set --match-set ${SETNAME} src -j RETURN
fi

echo done

sleep 100000000000