#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
test_build_root="$(mktemp -d)"
BUILD_OUTPUT_DIR="$test_build_root" "$repo_root/scripts/build.sh"
/bin/zsh -n "$repo_root/src/launcher.sh"
/bin/zsh -n "$repo_root/tests/portability.sh"
CODEX_BRIDGE_TEST_SOURCE_APP="$test_build_root/Clash Bridge for Codex.app" "$repo_root/tests/portability.sh"
print -r -- 'PUBLIC_TEST=PASS'
