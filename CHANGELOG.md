# Changelog

## 1.1.0

For macOS users experiencing Codex `Reconnecting 1/5 ... 5/5` behind Clash Verge System Proxy.

适用于 macOS + Clash Verge System Proxy 环境下 Codex 反复显示“重新连接 / Reconnecting 1/5 ... 5/5”的部分场景。

This release is an unofficial process-scoped launcher for Codex mode in the ChatGPT desktop app. It does not claim to fix every reconnecting or slow-connection cause.

- Self-contained macOS launcher for Codex mode in the ChatGPT desktop app.
- Dynamic macOS HTTP/HTTPS System Proxy discovery.
- Process-scoped `HTTP_PROXY` / `HTTPS_PROXY` environment injection.
- ChatGPT.app and legacy Codex.app discovery with strict `com.openai.codex` bundle validation.
- IPv4, hostname, and IPv6 proxy URL support.
- Clash Verge and Shadowrocket real regression validation.
- Portable macOS build using system tools only.
- Checksum verification and strict release-bundle verification.
- No global `launchctl` proxy mutation and no modification of Clash or the official OpenAI desktop app.
- Ad-hoc signed personal-use build; not notarized.
