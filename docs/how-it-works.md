# How it works

```text
macOS System Proxy
        |
        v
Clash Bridge
        | HTTP_PROXY / HTTPS_PROXY
        v
Official ChatGPT Desktop App (Codex mode)
        |
        v
Clash / Shadowrocket
        |
        v
Internet
```

Clash Bridge is an unofficial launcher for Codex mode. It is not a proxy server, VPN, Clash node, or modified Codex. It reads the active macOS System Proxy at launch time, verifies the HTTP and HTTPS listeners, starts the official ChatGPT desktop app's Codex executable, and then exits. Proxy variables are inherited only by that Codex process tree.

The launcher checks `/Applications/ChatGPT.app`, `/Applications/Codex.app`, and the corresponding user Applications paths in that order. Each candidate must have bundle identifier `com.openai.codex`. If those candidates are not found, it asks macOS metadata services for the same identifier and verifies the result again. It then reads that app's `CFBundleExecutable`; it does not assume the executable is named `ChatGPT`.
