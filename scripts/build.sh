#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
src="$repo_root/src"
build_root="${BUILD_OUTPUT_DIR:-$(mktemp -d)}"
app="$build_root/Clash Bridge for Codex.app"

rm -rf "$app"
mkdir -p "$build_root"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
/bin/cp -X "$src/Info.plist" "$app/Contents/Info.plist"
/bin/cp -X "$src/launcher.sh" "$app/Contents/MacOS/Clash Bridge for Codex"
/bin/cp -X "$src/ClashBridge.icns" "$app/Contents/Resources/ClashBridge.icns"
chmod 755 "$app/Contents/MacOS/Clash Bridge for Codex"

# Remove only signing-incompatible metadata from this newly generated build
# artifact; this is not a Gatekeeper bypass and never targets an installed app.
# Keep provenance metadata if macOS supplies it; clear the bundle's other
# inherited Finder/file-provider metadata before signing.
/usr/bin/plutil -lint "$app/Contents/Info.plist"
/bin/zsh -n "$src/launcher.sh"
/bin/zsh -n "$app/Contents/MacOS/Clash Bridge for Codex"
# Repeat immediately before signing because Finder/file-provider metadata can
# be reattached while a generated bundle is being inspected.
/usr/bin/xattr -c "$app" 2>/dev/null || true
if ! /usr/bin/codesign --force --deep --sign - "$app"; then
  /usr/bin/xattr -c "$app" 2>/dev/null || true
  /usr/bin/codesign --force --deep --sign - "$app"
fi
/usr/bin/codesign --verify --deep --strict --verbose=4 "$app"
print -r -- "Built: $app"
