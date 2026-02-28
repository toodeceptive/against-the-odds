#!/usr/bin/env bash
# No-op session-start: outputs empty JSON. Use to disable superpowers context injection.
# Copy to: $USERPROFILE\.cursor\plugins\cache\cursor-public\superpowers\<hash>\hooks\session-start.sh
set -euo pipefail
echo '{"additional_context":"","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'
exit 0
