#!/bin/bash
# Resolves city and timezone from SSH client IP using ~/.weather_locations config
# Usage: resolve_location.sh [city|timezone]
# Outputs the city name or timezone based on the argument

CONFIG="$HOME/.weather_locations"
FIELD="${1:-city}"  # "city" or "timezone"

# Get SSH client IP from tmux environment
ssh_client_ip=""
if command -v tmux &>/dev/null && tmux info &>/dev/null; then
    ssh_info=$(tmux show-environment SSH_CONNECTION 2>/dev/null | cut -d= -f2-)
    ssh_client_ip=$(echo "$ssh_info" | awk '{print $1}')
fi
# Fallback to current shell's SSH_CONNECTION
if [ -z "$ssh_client_ip" ]; then
    ssh_client_ip=$(echo "$SSH_CONNECTION" | awk '{print $1}')
fi

# Find location from config
default_value="Paris|Europe/Paris"
location="$default_value"

if [ -f "$CONFIG" ]; then
    best_match=""
    best_len=0
    while IFS='=' read -r prefix loc; do
        [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue
        prefix=$(echo "$prefix" | xargs)
        loc=$(echo "$loc" | xargs)

        if [ "$prefix" = "DEFAULT" ]; then
            default_value="$loc"
            continue
        fi

        if [[ "$ssh_client_ip" == "$prefix"* ]]; then
            if [ ${#prefix} -gt "$best_len" ]; then
                best_match="$loc"
                best_len=${#prefix}
            fi
        fi
    done < "$CONFIG"

    if [ -n "$best_match" ]; then
        location="$best_match"
    else
        location="$default_value"
    fi
fi

# Extract city or timezone
if [ "$FIELD" = "timezone" ]; then
    echo "$location" | cut -d'|' -f2
else
    echo "$location" | cut -d'|' -f1
fi
