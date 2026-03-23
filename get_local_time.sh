#!/bin/bash
# Display local time based on SSH client IP timezone
tz=$(~/.resolve_location.sh timezone)
TZ="$tz" date +%R
