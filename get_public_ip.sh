#!/bin/bash
# Get public IP with cache (refreshed every 10 minutes)
CACHE="/tmp/tmux_public_ip_cache"
CACHE_TTL=600

if [ -f "$CACHE" ]; then
    cache_age=$(( $(date +%s) - $(stat -c %Y "$CACHE" 2>/dev/null || echo 0) ))
    if [ "$cache_age" -lt "$CACHE_TTL" ]; then
        cat "$CACHE"
        exit 0
    fi
fi

ip=$(dig +short +time=2 myip.opendns.com @resolver1.opendns.com 2>/dev/null)
if [ -n "$ip" ]; then
    echo "$ip" > "$CACHE"
    echo "$ip"
else
    [ -f "$CACHE" ] && cat "$CACHE" || printf '?'
fi
