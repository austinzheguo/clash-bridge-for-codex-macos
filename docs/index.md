---
layout: default
title: "Clash Bridge for Codex — Fix Codex Reconnecting with Clash Verge on macOS"
description: "Codex Reconnecting / 重新连接 with Clash Verge System Proxy on macOS"
---

# Clash Bridge for Codex

## Codex Reconnecting 1/5 ... 5/5 with Clash Verge System Proxy on macOS

Clash Bridge is an unofficial launcher for Codex mode in the ChatGPT desktop app. It targets a specific macOS symptom: the browser works, ChatGPT works, Clash Verge or Clash Verge Rev System Proxy is enabled, TUN is disabled, but Codex keeps reconnecting or takes a long time to connect.

## Codex 使用 Clash Verge 时反复“重新连接 / Reconnecting”的 macOS 解决方案

中文用户可能搜索：Codex 重新连接、Codex 一直重新连接、Codex 重新连接 1/5 ... 5/5、Codex Clash Verge、Codex 系统代理、Codex 连接慢。Clash Bridge 会读取当前 HTTP/HTTPS System Proxy，只把代理环境传给 Codex 进程，不修改全局代理环境。

This is a third-party workaround for some environments, not a promise that every Codex reconnecting problem has the same cause. Development-machine observations were approximately 110–114 seconds and five reconnects for the original direct launch, versus approximately 3–10 seconds and zero reconnects with Clash Bridge; Shadowrocket validation was approximately 6 seconds and zero reconnects. These are observations, not guarantees.

## Start here

- [English README](../README.md)
- [中文 README](../README.zh-CN.md)
- [FAQ](faq.md) · [中文 FAQ](faq.zh-CN.md)
- [Installation and troubleshooting](troubleshooting.md) · [故障排查](troubleshooting.zh-CN.md)
- [How it works](how-it-works.md)
- [GitHub repository]({{ site.github.repository_url }})
- [Releases]({{ site.github.repository_url }}/releases)
- [Related upstream Codex issues]({{ site.github.repository_url }}/issues)

Clash Bridge is not affiliated with OpenAI, ChatGPT, Codex, Clash Verge, Mihomo, or Shadowrocket. It does not modify the official app or proxy configuration.
