# Release Candidate Report

Status: **READY FOR USER REVIEW**

## Identity

- Project: Clash Bridge for Codex
- Chinese name: Codex Clash 代理桥
- Repository slug: `clash-bridge-for-codex-macos`
- App: `Clash Bridge for Codex.app`
- Version: `1.1.0`
- Candidate archive: `dist/Clash-Bridge-for-Codex-v1.1.0-macOS.zip`
- SHA256: `3b59768ea9016d1ad49a5a270945d81f7bf3d7eed2bfafb4a97bda91bb611aac`

## Build and verification

- `scripts/build.sh` builds from `src/` using macOS system tools and signs the newly generated app ad hoc.
- Builds use an isolated temporary output directory so Finder/file-provider metadata cannot invalidate signing in a managed Documents folder.
- `scripts/test.sh`: PASS.
- Portability checks: PASS for dynamic ports, proxy disabled, dead listener, missing Codex, arbitrary app location, process-scoped environment, and unchanged global `launchctl` proxy environment.
- Release ZIP: extracted plist lint and deep strict signature verification passed.
- The ZIP contains only the app bundle; it contains no project history, private evidence, configuration backup, credentials, or subscription data.

## Privacy and scope audit

- No private absolute paths, user names, node addresses, credentials, UUIDs, tokens, or subscription URLs are present in tracked public source or documentation.
- The launcher does not hardcode Clash or Shadowrocket ports and does not use vendor-specific paths.
- The launcher does not modify the official `/Applications/Codex.app` and does not use global `launchctl setenv` or `unsetenv`.
- No public network experiment was run during this release-candidate preparation.
- No remote repository was configured or contacted, and nothing was pushed.

## Known limitations

- The launcher depends on macOS `scutil`, `nc`, `PlistBuddy`, `osascript`, and LaunchServices behavior.
- A usable HTTP and HTTPS System Proxy must be enabled and reachable at launch time.
- System Proxy discovery is not a substitute for TUN; traffic outside applications honoring the macOS System Proxy remains outside this tool's scope.
- The app is ad-hoc signed, not notarized. Gatekeeper may require the normal macOS user-approved open flow for an app downloaded from another machine.
- The current public candidate has been prepared from the already validated Clash Verge and Shadowrocket behavior, but user review is still required before any public publication.

## Local Git history

Fresh local history was created with these commits:

1. `Initial public launcher source`
2. `Add bilingual public documentation`
3. `Add reproducible build and portability tests`
4. This release-candidate report and release artifacts are pending in the final local commit.

