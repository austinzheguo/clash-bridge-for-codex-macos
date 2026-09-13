# 工作原理

```text
macOS 系统代理
        |
        v
Clash Bridge
        | HTTP_PROXY / HTTPS_PROXY
        v
官方 ChatGPT Desktop App（Codex mode）
        |
        v
Clash / Shadowrocket
        |
        v
互联网
```

Clash Bridge 是非官方的 Codex mode 启动器，不是代理服务器、VPN、Clash 节点或修改版 Codex。它只在启动瞬间读取当前 macOS 系统代理，检查 HTTP/HTTPS listener，然后启动官方 ChatGPT Desktop App 的 Codex mode，最后退出。代理环境变量只传给该进程树，不设置全局 launchd 环境。

它按顺序检查 `/Applications/ChatGPT.app`、`/Applications/Codex.app` 及用户 Applications 中的对应路径。每个候选都必须验证 bundle identifier 为 `com.openai.codex`。都找不到时才使用 macOS metadata 查找并再次验证该 identifier，随后动态读取 `CFBundleExecutable`，不假设官方可执行文件一定叫 `ChatGPT`。
