# How it works

```text
macOS System Proxy
        |
        v
Clash Bridge for Codex
        | HTTP_PROXY / HTTPS_PROXY
        v
Official Codex.app
        |
        v
Clash / Shadowrocket
        |
        v
Internet
```

The Bridge is not a proxy server, VPN, Clash node, or modified Codex. It reads the active macOS System Proxy at launch time, verifies the HTTP and HTTPS listeners, starts the official Codex executable, and then exits. Proxy variables are inherited only by that Codex process tree.

The launcher checks `/Applications/Codex.app` first. If it is not there, it asks macOS metadata services for an app with bundle identifier `com.openai.codex`. It then reads that app's `CFBundleExecutable`; it does not assume the executable is named `ChatGPT`.
