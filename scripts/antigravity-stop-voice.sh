#!/bin/bash

# Antigravity sends the Stop event on stdin.
if [[ "${1:-}" != "--test" ]]; then
    printf '{"decision":"stop"}\n'
    if ! command -v jq >/dev/null 2>&1; then
        printf 'antigravity-stop-voice: jq is required\n' >&2
        exit 0
    fi
    jq -es '
        length == 1 and (.[0] | type == "object" and .fullyIdle != false)
    ' >/dev/null 2>&1 || exit 0
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)" || exit 0
shopt -s nullglob nocaseglob dotglob
voices=()
for voice in "$script_dir/../voices/antigravity/"*.{wav,mp3,m4a,aac,flac,aiff}; do
    [[ -f "$voice" ]] && voices+=("$voice")
done
[[ ${#voices[@]} -gt 0 ]] || exit 0

nohup afplay "${voices[$((RANDOM % ${#voices[@]}))]}" </dev/null >/dev/null 2>&1 &
exit 0
