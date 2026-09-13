# Release Candidate Report

Status: **READY FOR PUBLIC-003 REVIEW**

## Identity

- Project: Clash Bridge for Codex
- Chinese name: Codex Clash 代理桥
- Repository slug: `clash-bridge-for-codex-macos`
- App: `Clash Bridge.app`
- Version: `1.1.0`
- Candidate archive: `dist/Clash-Bridge-for-Codex-v1.1.0-macOS.zip`
- SHA256: `75a0c0bf052b080d5f63f2dfd5d119602a00a05968cc7cdb440afc2e36de63bd`

## Build and verification

- `scripts/build.sh` builds from `src/` using macOS system tools and signs the newly generated app ad hoc.
- Builds use an isolated temporary output directory so Finder/file-provider metadata cannot invalidate signing in a managed Documents folder.
- `scripts/test.sh`: PASS.
- Portability checks: PASS for dynamic ports, IPv4/hostname/IPv6 URL construction, proxy disabled, dead listener, ChatGPT.app and Codex.app discovery, wrong bundle rejection, arbitrary app location, process-scoped environment, and unchanged global `launchctl` proxy environment.
- The test suite uses only macOS system tools; its prior ripgrep dependency was removed.
- `scripts/package-release.sh` runs the full test suite, builds, generates the checksum, runs `shasum -a 256 -c`, extracts the ZIP, lints the plist, and performs strict deep signature verification.
- Release ZIP: extracted plist lint and deep strict signature verification passed.
- The ZIP contains only the app bundle; it contains no project history, private evidence, configuration backup, credentials, or subscription data.

## Privacy and scope audit

- No private absolute paths, user names, node addresses, credentials, UUIDs, tokens, or subscription URLs are present in tracked public source or documentation.
- The launcher does not hardcode Clash or Shadowrocket ports and does not use vendor-specific paths.
- The launcher does not modify the official OpenAI desktop app and does not use global `launchctl setenv` or `unsetenv`.
- RC2 real regression `PUBLIC-RC2-CLASH-01`: approximately 10 seconds, zero reconnects, no error, normal ChatGPT/web/Clash, global environment unset.
- RC2 real regression `PUBLIC-RC2-SHADOWROCKET-01`: approximately 6 seconds, zero reconnects, no error, normal ChatGPT/web/Shadowrocket, global environment unset.
- No remote repository was configured or contacted, and nothing was pushed.

## Known limitations

- The launcher depends on macOS `scutil`, `nc`, `PlistBuddy`, `osascript`, and LaunchServices behavior.
- A usable HTTP and HTTPS System Proxy must be enabled and reachable at launch time.
- System Proxy discovery is not a substitute for TUN; traffic outside applications honoring the macOS System Proxy remains outside this tool's scope.
- The app is ad-hoc signed, not notarized. Gatekeeper may require the normal macOS user-approved open flow for an app downloaded from another machine.
- The current public candidate has passed the required RC2 regressions; final user/planner review is still required before any public publication.

## Local Git history

Fresh local history was created with these commits:

1. `Initial public launcher source`
2. `Add bilingual public documentation`
3. `Add reproducible build and portability tests`
4. `Prepare v1.1.0 release candidate` (RC1)
5. `Harden RC2 launcher and release pipeline`

Generated ZIP and SHA256 files are intentionally ignored by Git and remain local Release Asset candidates.

## RC2 hardening results

- `rg` dependency: eliminated from the test suite; plain macOS system tools are sufficient.
- SHA256 self-check: PASS; checksum file contains the ZIP basename and `shasum -a 256 -c` returned `OK`.
- IPv6 test: PASS; `::1` becomes `http://[::1]:PORT`, alongside IPv4 and hostname coverage.
- App discovery: PASS for ChatGPT.app and legacy Codex.app candidates with `com.openai.codex`; wrong bundle IDs and arbitrary same-name apps are rejected.
- Process-scoped environment integration: PASS for all six proxy variables; global launchctl environment unchanged.
- App display name: `Clash Bridge`; project/repository identity remains `Clash Bridge for Codex` / `clash-bridge-for-codex-macos`.
- Git generated artifact policy: `dist/*.app`, `dist/*.zip`, and `dist/*.sha256` are ignored; the ZIP and checksum remain local release outputs.
- Privacy scan: PASS for tracked public files and decompressed release ZIP, with documentation references distinguished from runtime literals.
- Remote/push: none; no GitHub repository, remote, or release was created.

## Search / AI discoverability preparation

- README and Chinese README now put the real symptoms in the first screen: Codex Reconnecting 1/5 ... 5/5, slow new sessions, browser/ChatGPT working, Clash Verge System Proxy enabled, and TUN disabled.
- Natural English coverage includes Codex Clash Verge, Codex reconnecting, Codex System Proxy, Codex macOS proxy, HTTP_PROXY/HTTPS_PROXY, WebSocket proxy, and related user descriptions. Natural Chinese coverage includes Codex 重新连接, Codex Clash Verge, Codex 系统代理, Codex 连接慢, and related user descriptions.
- Added bilingual FAQ pages, search-oriented troubleshooting headings, a bilingual static Pages landing page, release-note wording, and a privacy-safe bug report template.
- Linked relevant upstream `openai/codex` issues as context; the project is explicitly described as an independent third-party workaround, not an OpenAI fix.
- Added proposed repository description and topics in `docs/publication-metadata.md`; no GitHub repository or API action was performed.
- No `llms.txt` dependency was introduced and no search-engine or AI ranking guarantee is claimed.

## PUBLIC-003 readiness

The repository is ready for a separate PUBLIC-003 decision covering GitHub repository creation, remote configuration, push, topics, GitHub Pages activation, Release Assets, and post-publication download verification. Those actions have not been performed in this phase.
