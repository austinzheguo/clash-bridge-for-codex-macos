# Changelog

## v1.1.0 release notes

For macOS users experiencing Codex `Reconnecting 1/5 ... 5/5` behind Clash Verge System Proxy.

适用于 macOS + Clash Verge System Proxy 环境下 Codex 反复显示“重新连接 / Reconnecting 1/5 ... 5/5”的部分场景。

This release is an unofficial process-scoped launcher for Codex mode in the ChatGPT desktop app. It does not claim to fix every reconnecting or slow-connection cause.

## 1.1.0 RC2

- Renamed the installed app display name to `Clash Bridge` while retaining the project name `Clash Bridge for Codex`.
- Added ChatGPT.app/Codex.app bundle discovery with strict `com.openai.codex` validation.
- Added IPv4, hostname, and IPv6 proxy URL handling.
- Added process-scoped environment integration coverage and a release checksum self-check.
- Removed the portability test's ripgrep dependency.

## 1.1.0

- First public release candidate.
- Self-contained macOS launcher bundle.
- Dynamic HTTP/HTTPS System Proxy discovery.
- Official Codex executable discovery through standard path and bundle identifier metadata.
- Ad-hoc signed personal-use build.
