# Clash Bridge for Codex · Codex Clash 代理桥

> **非官方第三方项目，与 OpenAI 或 Clash Verge Rev 无隶属、认证、背书或支持关系。**

[English README → README.md](README.md)

Clash Bridge 是一个非官方的 Codex mode 启动器，适用于以下情况：

- macOS；
- Clash Verge / Clash Verge Rev；
- System Proxy 开启、TUN 关闭；
- 浏览器与 ChatGPT 正常；
- ChatGPT Desktop App 中的 Codex mode（包括旧版 Codex.app）反复出现 `Reconnecting 1/5 ... 5/5`；
- Codex 一直重新连接、反复重新连接，或显示 `Reconnecting 1/5 → 2/5 → ... → 5/5`；
- Codex 连接很慢、一直转圈、新会话等待几十秒到约两分钟。

Clash Bridge 会读取当前 macOS HTTP/HTTPS System Proxy，只把代理环境传递给 Codex 进程，不修改全局代理环境。它适用于部分具有上述症状的环境，不承诺所有用户都存在相同根因。

中文用户也可能搜索：Codex 重新连接、Codex 正在重新连接、Codex 一直重新连接、Codex 反复重新连接、Codex 重新连接 1/5、Codex 重新连接 2/5、Codex 重新连接 5/5、Codex Clash、Codex Clash Verge、Codex Clash Verge Rev、Clash Verge Codex、Codex 代理、Codex macOS 代理、Codex 系统代理、Codex System Proxy、Codex 连接不上、Codex 无法连接、Codex 连接很慢、Codex 连接慢、Codex 等待很久、Codex 新会话很慢、Codex 一直转圈、Codex 网络错误、Codex Clash 重连、Codex Clash 重新连接、Codex Clash Verge 重新连接、“Clash 开着但 Codex 不能用”以及“浏览器正常 Codex 不能连接”。

英文用户可能会搜索 Codex Clash Verge, Codex reconnecting, Codex System Proxy, Codex macOS proxy, Codex HTTP_PROXY, Codex HTTPS_PROXY, Codex WebSocket proxy, or ChatGPT Desktop Codex proxy。

相关 upstream context：[macOS launchd/system-proxy WebSocket instability](https://github.com/openai/codex/issues/14080)、[Finder 启动时可能缺少 shell proxy environment](https://github.com/openai/codex/issues/30695)、以及 [Responses WebSocket retries before HTTP fallback](https://github.com/openai/codex/issues/19821)。Clash Bridge 是独立的第三方 workaround，不是 OpenAI 官方修复。

Bridge 的工作流程是：

读取当前 macOS System Proxy

↓

验证 HTTP/HTTPS listener

↓

只给即将启动的 Codex 进程注入 `HTTP_PROXY`、`HTTPS_PROXY`、`http_proxy`、`https_proxy`、`NO_PROXY`、`no_proxy`

↓

启动官方 ChatGPT Desktop App 的 Codex mode

↓

Bridge 退出

它不是代理软件、VPN、Clash 节点、Codex 修改版，也不是 OpenAI 官方工具。它不会修改 Clash、Shadowrocket、`~/.codex/.env`、全局 launchctl 代理环境或官方 OpenAI Desktop App，也不会写死代理端口。

## 开发者本机实测结果

| 场景 | 结果 |
|---|---:|
| Clash System Proxy 下直接启动 Codex | 约 110–114 秒，约 5 次 reconnect |
| 临时显式代理环境 | 约 4–5 秒，0 reconnect |
| Clash Verge + Bridge | 约 3–8 秒，0 reconnect |
| Shadowrocket + Bridge | 约 4–12 秒，0 reconnect |

这些是开发者本机观察，不是对所有网络环境的性能保证。

## 兼容性

已测试：macOS、ChatGPT Desktop App 的 Codex mode（包括旧版 Codex.app）、Clash Verge / Clash Verge Rev、Shadowrocket、HTTP/HTTPS System Proxy。

不需要 TUN。PAC-only proxy、仅 SOCKS System Proxy、认证企业代理及其他特殊 macOS 代理配置尚未保证支持。

## 安装

1. 下载 ZIP 及 SHA-256 文件并校验。
2. 解压到 `/Applications` 或 `~/Applications`。
3. 从 OpenAI 官方来源安装官方 ChatGPT Desktop App，并使用 Codex mode。
4. 开启所需的 macOS System Proxy。
5. 完全退出已有 Codex。
6. 双击 `Clash Bridge.app`。

更多入口：[中文 FAQ](docs/faq.zh-CN.md)、[English FAQ](docs/faq.md)、[工作原理](docs/how-it-works.zh-CN.md)、[故障排查](docs/troubleshooting.zh-CN.md) 和 [项目首页](docs/index.md)。

校验下载文件：

```text
cd ~/Downloads
shasum -a 256 -c Clash-Bridge-for-Codex-v1.1.0-macOS.zip.sha256
```

本项目不捆绑或重新分发 Codex。当前版本是个人使用的 ad-hoc 签名版本，没有 Developer ID 或 notarization。Gatekeeper 说明见 [故障排查](docs/troubleshooting.zh-CN.md)。

## 构建与测试

在兼容 Mac 上运行：

```text
scripts/test.sh
scripts/package-release.sh
```

构建只使用本仓库的 `src/`，不依赖私有 Proxy Lab 仓库。

## 许可证

MIT，见 [LICENSE](LICENSE)。
