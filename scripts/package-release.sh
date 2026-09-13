#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
release_build_root="$(mktemp -d)"
BUILD_OUTPUT_DIR="$release_build_root" "$repo_root/scripts/build.sh"
app="$release_build_root/Clash Bridge for Codex.app"
version="$(/usr/bin/plutil -extract CFBundleShortVersionString raw "$app/Contents/Info.plist")"
zip_path="$repo_root/dist/Clash-Bridge-for-Codex-v${version}-macOS.zip"
checksum_path="$zip_path.sha256"
rm -f "$zip_path" "$checksum_path"
/usr/bin/ditto -c -k --norsrc --keepParent "$app" "$zip_path"
/usr/bin/shasum -a 256 "$zip_path" | /usr/bin/awk '{print $1 "  " FILENAME}' FILENAME="$(basename "$zip_path")" > "$checksum_path"
print -r -- "Release: $zip_path"
print -r -- "Checksum: $checksum_path"
