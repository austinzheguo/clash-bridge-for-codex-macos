# Clash Bridge for Codex · Codex Clash 代理桥

> **非官方第三方项目，与 OpenAI 或 Clash Verge Rev 无隶属、认证、背书或支持关系。**

[English README → README.md](README.md)

适用于以下情况：

- macOS；
- Clash Verge / Clash Verge Rev；
- System Proxy 开启、TUN 关闭；
- 浏览器与 ChatGPT 正常；
- Codex Desktop 反复出现 `Reconnecting 1/5 ... 5/5`；
- Codex 新会话可能等待约 1–2 分钟。

Bridge 的工作流程是：

读取当前 macOS System Proxy

↓

验证 HTTP/HTTPS listener

↓

只给即将启动的 Codex 进程注入 `HTTP_PROXY`、`HTTPS_PROXY`、`http_proxy`、`https_proxy`、`NO_PROXY`、`no_proxy`

↓

启动官方 Codex

↓

Bridge 退出

它不是代理软件、VPN、Clash 节点、Codex 修改版，也不是 OpenAI 官方工具。它不会修改 Clash、Shadowrocket、`~/.codex/.env`、全局 launchctl 代理环境或官方 Codex.app，也不会写死 Clash 的 7897 或 Shadowrocket 的 1082。

## 开发者本机实测结果

| 场景 | 结果 |
|---|---:|
| Clash System Proxy 下直接启动 Codex | 约 110–114 秒，约 5 次 reconnect |
| 临时显式代理环境 | 约 4–5 秒，0 reconnect |
| Clash Verge + Bridge | 约 3–8 秒，0 reconnect |
| Shadowrocket + Bridge | 约 4–12 秒，0 reconnect |

这些是开发者本机观察，不是对所有网络环境的性能保证。

## 兼容性

已测试：macOS、Codex Desktop、Clash Verge / Clash Verge Rev、Shadowrocket、HTTP/HTTPS System Proxy。

不需要 TUN。PAC-only proxy、仅 SOCKS System Proxy、认证企业代理及其他特殊 macOS 代理配置尚未保证支持。

## 安装

1. 下载 ZIP 及 SHA-256 文件并校验。
2. 解压到 `/Applications` 或 `~/Applications`。
3. 从官方来源安装官方 Codex.app。
4. 开启所需的 macOS System Proxy。
5. 完全退出已有 Codex。
6. 双击 `Clash Bridge for Codex.app`。

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
