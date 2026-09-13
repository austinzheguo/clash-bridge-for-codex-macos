# Clash Bridge for Codex v1.1.0

For macOS users experiencing Codex `Reconnecting 1/5 ... 5/5` behind Clash Verge / Clash Verge Rev System Proxy.

适用于 macOS + Clash Verge / Clash Verge Rev System Proxy 环境下 Codex 反复显示“重新连接 / Reconnecting 1/5 ... 5/5”的部分场景。

Clash Bridge is an unofficial third-party launcher for Codex mode in the ChatGPT desktop app.

Clash Bridge 是 ChatGPT Desktop App 中 Codex mode 的非官方第三方启动器。

## What it does

- Dynamically reads the active macOS HTTP/HTTPS System Proxy.
- Passes proxy variables only to the Codex process tree.
- Does not modify global `launchctl` proxy environment.
- Does not modify Clash, Shadowrocket, or the official OpenAI desktop app.
- Does not hardcode a Clash port.
- Supports current ChatGPT.app Codex mode and legacy Codex.app installations.
- Was validated with Clash Verge and Shadowrocket.

## 作用

- 动态读取当前 macOS HTTP/HTTPS System Proxy。
- 只把代理环境传递给 Codex 进程树。
- 不修改全局 `launchctl` 代理环境。
- 不修改 Clash、Shadowrocket 或官方 OpenAI Desktop App。
- 不写死 Clash 端口。
- 支持当前 ChatGPT.app 的 Codex mode 和旧版 Codex.app 安装。
- 已使用 Clash Verge 和 Shadowrocket 完成实际回归。

## Notes

The app is ad-hoc signed for personal use and is not notarized. macOS Gatekeeper may require manual approval. This release does not claim to fix every Codex reconnecting or slow-connection cause.

当前 App 是个人使用的 ad-hoc 签名版本，没有 notarization；macOS Gatekeeper 可能要求手动批准。本版本不声称解决所有 Codex 重新连接或连接慢的根因。

