tore the previous count of SSH connections
SSH_CONNECTIONS_FILE="/tmp/ssh_connections_count"

# Function to get current SSH connections (excluding tmux sessions)
get_ssh_connections() {
        last -a | grep 'still logged in' | grep -v 'tmux' | awk '{print $NF}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | sort | uniq | wc -l
    }

# Get the current number of SSH connections
current_connections=$(get_ssh_connections)

# If the file doesn't exist, create it and store the current connection count
if [ ! -f "$SSH_CONNECTIONS_FILE" ]; then
        echo "$current_connections" > "$SSH_CONNECTIONS_FILE"
fi

# Get the previous number of SSH connections
previous_connections=$(cat "$SSH_CONNECTIONS_FILE")

# If there are more current connections than previous, add a "warning"
if [ "$current_connections" -gt "$previous_connections" ]; then
        echo "SSH: $current_connections (warning)"
    else
            echo "SSH: $current_connections"
fi

# Update the stored connection count
echo "$current_connections" > "$SSH_CONNECTIONS_FILE"

