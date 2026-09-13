#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
dist="$repo_root/dist"
release_ok=0
release_build_root="$(mktemp -d)"
zip_path=''
checksum_path=''

cleanup() {
  rm -rf "$release_build_root"
  if [[ "$release_ok" != '1' ]]; then
    [[ -z "$zip_path" ]] || rm -f "$zip_path"
    [[ -z "$checksum_path" ]] || rm -f "$checksum_path"
  fi
}
trap cleanup EXIT

# Do not leave stale artifacts that could look like a successful build.
/usr/bin/find "$dist" -maxdepth 1 -type f -name 'Clash-Bridge-for-Codex-v*.zip' -delete
/usr/bin/find "$dist" -maxdepth 1 -type f -name 'Clash-Bridge-for-Codex-v*.zip.sha256' -delete

"$repo_root/scripts/test.sh"
BUILD_OUTPUT_DIR="$release_build_root" "$repo_root/scripts/build.sh"
app="$release_build_root/Clash Bridge.app"
version="$(/usr/bin/plutil -extract CFBundleShortVersionString raw "$app/Contents/Info.plist")"
zip_path="$dist/Clash-Bridge-for-Codex-v${version}-macOS.zip"
checksum_path="$zip_path.sha256"

/usr/bin/ditto -c -k --norsrc --keepParent "$app" "$zip_path"
/usr/bin/shasum -a 256 "$zip_path" | /usr/bin/awk -v name="$(basename "$zip_path")" '{print $1 "  " name}' > "$checksum_path"

(
  cd "$dist"
  /usr/bin/shasum -a 256 -c "$(basename "$checksum_path")"
)

verify_root="$(mktemp -d)"
trap 'rm -rf "$verify_root"; cleanup' EXIT
/usr/bin/unzip -q "$zip_path" -d "$verify_root"
/usr/bin/plutil -lint "$verify_root/Clash Bridge.app/Contents/Info.plist"
/usr/bin/codesign --verify --deep --strict --verbose=4 "$verify_root/Clash Bridge.app"
rm -rf "$verify_root"
release_ok=1
print -r -- "Release: $zip_path"
print -r -- "Checksum: $checksum_path"
