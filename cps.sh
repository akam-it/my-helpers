#!/bin/bash

# Fetch initial stats
stats_pre=$(sudo /usr/sbin/kamctl stats)

# Function to extract values safely
extract_value() {
    local value
    value=$(echo "$1" | grep "$2" | awk -F '=' '{print $2}' | tr -dc '0-9')
    echo "${value:-0}"  # Ensure the value is never empty
}

while true; do
    stats=$(sudo /usr/sbin/kamctl stats)

    # Extract values safely
    dialogs=$(extract_value "$stats" "rcv_requests_invite")
    dialogs_pre=$(extract_value "$stats_pre" "rcv_requests_invite")
    active_calls=$(extract_value "$stats" "dialog:active_dialogs")
    early_calls=$(extract_value "$stats" "dialog:early_dialogs")

    # Ensure valid numbers
    dialogs=${dialogs:-0}
    dialogs_pre=${dialogs_pre:-0}

    # Calculate CPS and prevent negative values
    dialogs_diff=$(( dialogs >= dialogs_pre ? dialogs - dialogs_pre : 0 ))

    # Clear line properly and print new output
    printf "\r%-50s" "CPS: $dialogs_diff, Active calls: $active_calls, Early calls: $early_calls"

    # Update previous stats before next iteration
    stats_pre=$stats

    # Sleep before next iteration
    sleep 1
done
