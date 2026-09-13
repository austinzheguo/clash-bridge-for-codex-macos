# Clash Bridge for Codex

### A lightweight unofficial macOS launcher that helps Codex Desktop reliably use the active macOS System Proxy.

> **Unofficial third-party project. Not affiliated with or endorsed by OpenAI or Clash Verge Rev.**

[中文说明 → README.zh-CN.md](README.zh-CN.md)

Clash Bridge for Codex is for a macOS setup where browsers and ChatGPT work through Clash Verge / Clash Verge Rev or Shadowrocket, while Codex Desktop repeatedly shows `Reconnecting 1/5 ... 5/5` or takes one to two minutes to become usable under System Proxy.

The Bridge:

1. reads the active macOS HTTP/HTTPS System Proxy;
2. checks that its local listener is reachable;
3. passes `HTTP_PROXY`, `HTTPS_PROXY`, `http_proxy`, `https_proxy`, `NO_PROXY`, and `no_proxy` only to the Codex process tree;
4. starts the official Codex.app and exits.

It is not a proxy server, VPN, Clash node, modified Codex, or OpenAI tool. It does not modify Clash, Shadowrocket, `~/.codex/.env`, global launchctl environment, or the official Codex.app. It does not hardcode common proxy ports.

## Observed development-machine results

| Setup | Result |
|---|---:|
| Original direct Codex launch under Clash System Proxy | ~110–114s, ~5 reconnects |
| Temporary explicit proxy workaround | ~4–5s, 0 reconnect |
| Bridge with Clash Verge | ~3–8s, 0 reconnect |
| Bridge with Shadowrocket | ~4–12s, 0 reconnect |

These are developer-machine observations, not a performance guarantee for every network or macOS configuration.

## Compatibility

| Configuration | Status |
|---|---|
| macOS | Tested |
| Codex Desktop | Tested |
| Clash Verge / Clash Verge Rev | Tested with HTTP/HTTPS System Proxy |
| Shadowrocket | Tested with HTTP/HTTPS System Proxy |
| TUN | Not required |
| PAC-only proxy | Not guaranteed |
| SOCKS-only System Proxy | Not guaranteed |
| Authenticated corporate proxy | Not guaranteed |

## Install

1. Download the release ZIP and its SHA-256 file.
2. Verify the checksum.
3. Extract `Clash Bridge for Codex.app` into `/Applications` or `~/Applications`.
4. Install the official Codex.app from its official source.
5. Enable the desired macOS System Proxy.
6. Fully quit any existing Codex process.
7. Double-click `Clash Bridge for Codex.app`.

The project does not bundle or redistribute Codex. The build is ad-hoc signed for personal use and is not Developer ID signed or notarized. See [troubleshooting](docs/troubleshooting.md) for Gatekeeper notes.

## Build and test

On a compatible Mac with the standard Apple command-line tools:

```text
scripts/test.sh
scripts/package-release.sh
```

The build is generated from this repository's `src/` directory. It does not require the private Proxy Lab repository.

## License

MIT. See [LICENSE](LICENSE).
