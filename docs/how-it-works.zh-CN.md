# 工作原理

```text
macOS 系统代理
        |
        v
Clash Bridge for Codex
        | HTTP_PROXY / HTTPS_PROXY
        v
官方 Codex.app
        |
        v
Clash / Shadowrocket
        |
        v
互联网
```

Bridge 不是代理服务器、VPN、Clash 节点或修改版 Codex。它只在启动瞬间读取当前 macOS 系统代理，检查 HTTP/HTTPS listener，然后启动官方 Codex，最后退出。代理环境变量只传给 Codex 进程树，不设置全局 launchd 环境。

它优先检查 `/Applications/Codex.app`，找不到时使用 macOS bundle identifier metadata 查找 `com.openai.codex`，随后动态读取 `CFBundleExecutable`，不假设官方可执行文件一定叫 `ChatGPT`。
