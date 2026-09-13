# FAQ：Codex 重新连接、Clash Verge 与 macOS 系统代理

## Codex 一直显示“重新连接”怎么办？

部分 macOS 用户在 Clash Verge 或 Clash Verge Rev 开启 System Proxy、TUN 关闭时，会看到 Codex 一直重新连接。浏览器和 ChatGPT 可能仍然正常。Clash Bridge 会读取当前 HTTP/HTTPS System Proxy，并只给 Codex 进程传递显式代理环境。它是第三方 workaround，不保证适用于所有根因。请先看[安装说明](../README.zh-CN.md#安装)和[故障排查](troubleshooting.zh-CN.md)。

## Codex 显示“重新连接 1/5、2/5、直到 5/5”是什么问题？

这通常表示 Codex 的某条会话或 WebSocket 传输正在重试，但仅凭文字不能确定根因。项目开发者曾观察到 System Proxy 下等待几十秒到约两分钟，而显式进程代理环境可以明显缩短等待；这些不是对所有用户的保证。

## 为什么 Clash Verge 开启后浏览器正常，但 Codex 连接很慢？

浏览器、ChatGPT 和 Codex 可能使用不同的网络栈或代理解析路径。相关 upstream context 包括 [macOS launchd/system-proxy WebSocket instability](https://github.com/openai/codex/issues/14080) 和 [Finder 启动时可能缺少 shell proxy environment](https://github.com/openai/codex/issues/30695)。

## 为什么打开 Clash TUN 后 Codex 正常，System Proxy 却很慢？

TUN 与 System Proxy 是不同的流量路径。TUN 可以捕获没有完整遵循 macOS System Proxy 的应用流量；Clash Bridge 则尝试通过进程级 HTTP_PROXY/HTTPS_PROXY 解决部分 System Proxy 场景。

## Codex 可以使用 Clash Verge 的 System Proxy 吗？

可以尝试。开启 Clash Verge 的 HTTP/HTTPS System Proxy，保持节点和其他设置不变，然后通过 `Clash Bridge.app` 启动官方 ChatGPT Desktop App 的 Codex mode。Bridge 不会修改 Clash、节点、DNS、TUN 或全局代理。

## Codex 如何设置 HTTP_PROXY / HTTPS_PROXY？

不需要手动设置全局环境。Clash Bridge 启动时读取当前 macOS System Proxy，并只向 Codex 进程传递 `HTTP_PROXY`、`HTTPS_PROXY`、小写变量及 loopback `NO_PROXY`。不要把代理凭据写入公开 issue 或报告。

## Clash Bridge 会修改 Clash 或 Codex 吗？

不会。它不修改 Clash、Mihomo、Shadowrocket、官方 OpenAI Desktop App、Codex 文件、DNS、路由、TUN 或 global launchctl environment。

## Clash Bridge 和 launchctl setenv 有什么区别？

`launchctl setenv` 会改变用户 launchd 环境，可能影响其他 GUI 应用。Clash Bridge 只把变量传给它启动的 Codex 进程树。

## Shadowrocket 可以使用吗？

可以，只要 Shadowrocket 是当前 macOS HTTP/HTTPS System Proxy 且 listener 可达。Bridge 每次启动动态发现当前代理，不写死 Clash 或 Shadowrocket 端口。

## 为什么下载 Clash Bridge 后 macOS 提示无法验证开发者？

当前版本是 ad-hoc 签名、未 notarize。按 macOS“系统设置 → 隐私与安全性 → 仍要打开”的正常流程处理，不要全局关闭 Gatekeeper。详见[故障排查](troubleshooting.zh-CN.md#gatekeeper)。

