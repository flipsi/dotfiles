#!/usr/bin/env bash
set -e

# Read AGY/Gemini payload from stdin
PAYLOAD=""
if [ ! -t 0 ]; then
    PAYLOAD=$(cat)
fi

WORKSPACE=""
ERR=""
REASON=""

if [[ -n "$PAYLOAD" ]]; then
    WORKSPACE=$(echo "$PAYLOAD" | jq -r '(.workspacePaths[0] // "")' 2>/dev/null || true)
    ERR=$(echo "$PAYLOAD" | jq -r '(.error // "")' 2>/dev/null || true)
    REASON=$(echo "$PAYLOAD" | jq -r '(.terminationReason // "")' 2>/dev/null || true)
fi

LOCATION="${WORKSPACE:-$PWD}"

if [[ -n "$ERR" || "$REASON" == "error" ]]; then
    notify-send -u critical "Gemini" "Task encountered an error in $LOCATION" || true
else
    notify-send -u low "Gemini" "Task completed in $LOCATION" || true
fi

# Antigravity/Gemini expects a valid JSON object on stdout
echo "{}"
