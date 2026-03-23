#!/bin/bash
# Weather script for tmux status bar

CACHE="/tmp/tmux_weather_cache"
CACHE_TTL=900  # 15 minutes

# Use cache if fresh enough
if [ -f "$CACHE" ]; then
    cache_age=$(( $(date +%s) - $(stat -c %Y "$CACHE" 2>/dev/null || echo 0) ))
    if [ "$cache_age" -lt "$CACHE_TTL" ]; then
        cat "$CACHE"
        exit 0
    fi
fi

city=$(~/.resolve_location.sh city)

result=$(curl -f -s -m 3 "wttr.in/${city}?format=3" 2>/dev/null)
if [ -n "$result" ]; then
    echo "$result" > "$CACHE"
    echo "$result"
else
    [ -f "$CACHE" ] && cat "$CACHE" || printf '\n'
fi
