#!/bin/bash

# Codex passes the completion event as the last command-line argument.
if [[ "${1:-}" != "--test" ]]; then
    if ! command -v jq >/dev/null 2>&1; then
        printf 'codex-stop-voice: jq is required\n' >&2
        exit 0
    fi
    [[ $# -gt 0 ]] || exit 0
    printf '%s' "${!#}" | jq -es '
        length == 1 and (.[0] |
            type == "object" and
            (.type == "agent-turn-complete" or .type == "assistant-turn-complete")
        )
    ' >/dev/null 2>&1 || exit 0
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)" || exit 0
shopt -s nullglob nocaseglob dotglob
voices=()
for voice in "$script_dir/../voices/codex/"*.{wav,mp3,m4a,aac,flac,aiff}; do
    [[ -f "$voice" ]] && voices+=("$voice")
done
[[ ${#voices[@]} -gt 0 ]] || exit 0

nohup afplay "${voices[$((RANDOM % ${#voices[@]}))]}" </dev/null >/dev/null 2>&1 &
exit 0
