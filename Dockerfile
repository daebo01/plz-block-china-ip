FROM alpine:3.21

RUN apk add --no-cache iptables ipset

WORKDIR /app

COPY script.sh .

RUN wget https://www.ipdeny.com/ipblocks/data/aggregated/cn-aggregated.zone

# docker escape
CMD ["/usr/bin/nsenter", "-t", "1", "-n", "/bin/sh", "script.sh"]