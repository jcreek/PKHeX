#!/usr/bin/env bash
# Checks that this fork changes only the paths listed in fork-boundary.txt, compared with upstream kwsch/PKHeX master.
#
# Reads changed paths (one per line, relative to the repository root) on stdin, normally the diff from the merge base with upstream.
# The diff must be made with --no-renames: otherwise a moved file is listed only at its new path, and moving an upstream file into an
# allowed folder would pass. core.quotePath=false keeps non-ASCII paths unquoted, so they match their patterns.
# Fails, naming each one, if a path matches no pattern in the list. Warns about a pattern that matches no changed path: for a carried patch,
# that usually means upstream now has the change and the entry should be removed.
#
# Usage: git -c core.quotePath=false diff --no-renames --name-only <upstream>...HEAD | PKHeX.Web/tools/fork-boundary.sh [list]
set -euo pipefail

list="${1:-$(dirname "$0")/fork-boundary.txt}"

patterns=()
while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    # Trim surrounding whitespace; a pattern may contain spaces (PKHeX.WinForms/Controls/PKM Editor/...).
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [ -n "$line" ] && patterns+=("$line")
done < "$list"

if [ "${#patterns[@]}" -eq 0 ]; then
    echo "::error::$list lists no paths."
    exit 1
fi

# used[i] is set once patterns[i] matches a path. An indexed array, so the script also runs on macOS's bash 3.2.
used=()
outside=()
while IFS= read -r path || [ -n "$path" ]; do
    [ -n "$path" ] || continue
    matched=false
    for i in "${!patterns[@]}"; do
        # Unquoted on the right, so the pattern is a glob; inside [[ ]] * also matches /.
        # shellcheck disable=SC2053
        if [[ "$path" == ${patterns[$i]} ]]; then
            matched=true
            used[i]=1
            break
        fi
    done
    if [ "$matched" = false ]; then
        outside+=("$path")
    fi
done

for i in "${!patterns[@]}"; do
    if [ -z "${used[i]:-}" ]; then
        echo "::warning::'${patterns[$i]}' in $list matches nothing that differs from upstream; remove it if upstream now has the change."
    fi
done

if [ "${#outside[@]}" -gt 0 ]; then
    for path in "${outside[@]}"; do
        echo "::error::$path differs from upstream but is not in $list."
    done
    echo "Change upstream files only as a carried patch: send the change upstream and list it in $list with the upstream pull request."
    exit 1
fi

echo "Every path that differs from upstream is listed in $list."
