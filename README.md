# Clash Bridge for Codex

### A lightweight unofficial macOS launcher that helps Codex mode in the ChatGPT desktop app reliably use the active macOS System Proxy.

> **Unofficial third-party project. Not affiliated with or endorsed by OpenAI or Clash Verge Rev.**

[中文说明 → README.zh-CN.md](README.zh-CN.md)

A lightweight unofficial macOS launcher that helps Codex mode in the ChatGPT desktop app reliably use the active macOS System Proxy when it repeatedly shows `Reconnecting 1/5 ... 5/5`, connects slowly, or waits a long time behind Clash Verge / Clash Verge Rev.

Typical symptoms:

- the browser works normally;
- ChatGPT works normally;
- Clash Verge System Proxy is enabled and TUN is disabled;
- Codex keeps reconnecting or is stuck reconnecting;
- a new Codex session takes tens of seconds or around one to two minutes to connect.

Clash Bridge is an unofficial launcher for Codex mode in the ChatGPT desktop app. It reads the active macOS HTTP/HTTPS System Proxy and passes a process-scoped proxy environment to Codex. It does not promise that every Codex slow connection has the same cause.

The symptom is also commonly described as Codex Clash reconnecting, Codex Clash Verge reconnecting, Codex macOS proxy trouble, Codex System Proxy trouble, or a Codex WebSocket proxy problem. See the [FAQ](docs/faq.md), [Chinese FAQ](docs/faq.zh-CN.md), and [troubleshooting guide](docs/troubleshooting.md).

## Related upstream issues

The following OpenAI Codex repository issues describe related macOS System Proxy, GUI proxy environment, WebSocket reconnect, or proxy-routing behavior. Clash Bridge is an independent third-party workaround, not an official fix for these issues:

- [macOS launchd/system-proxy WebSocket instability](https://github.com/openai/codex/issues/14080)
- [Finder-launched Codex missing shell proxy environment](https://github.com/openai/codex/issues/30695)
- [System proxy handling in the Desktop App app-server](https://github.com/openai/codex/issues/39237)
- [Proxy environment and connectivity behavior](https://github.com/openai/codex/issues/13682)

The Bridge:

1. reads the active macOS HTTP/HTTPS System Proxy;
2. checks that its local listener is reachable;
3. passes `HTTP_PROXY`, `HTTPS_PROXY`, `http_proxy`, `https_proxy`, `NO_PROXY`, and `no_proxy` only to the Codex process tree;
4. starts the official ChatGPT desktop app (Codex mode) and exits.

It is not a proxy server, VPN, Clash node, modified Codex, or OpenAI tool. It does not modify Clash, Shadowrocket, `~/.codex/.env`, global launchctl environment, or the official OpenAI desktop app. It does not hardcode common proxy ports.

## Observed development-machine results

| Setup | Result |
|---|---:|
| Original direct Codex launch under Clash System Proxy | ~110–114s, ~5 reconnects |
| Temporary explicit proxy workaround | ~4–5s, 0 reconnect |
| Bridge with Clash Verge | ~3–8s, 0 reconnect |
| Bridge with Shadowrocket | ~4–12s, 0 reconnect |

These are developer-machine observations, not a performance guarantee for every network or macOS configuration.

If you are looking for a Codex Clash Verge or Codex System Proxy fix, this project is aimed at the macOS proxy case where Codex Reconnecting 1/5 through 5/5 appears or Codex macOS proxy connections take too long.

## Compatibility

| Configuration | Status |
|---|---|
| macOS | Tested |
| ChatGPT desktop app (Codex mode), including legacy Codex.app installations | Tested |
| Clash Verge / Clash Verge Rev | Tested with HTTP/HTTPS System Proxy |
| Shadowrocket | Tested with HTTP/HTTPS System Proxy |
| TUN | Not required |
| PAC-only proxy | Not guaranteed |
| SOCKS-only System Proxy | Not guaranteed |
| Authenticated corporate proxy | Not guaranteed |

## Install

1. Download the release ZIP and its SHA-256 file.
2. Verify the checksum.
3. Extract `Clash Bridge.app` into `/Applications` or `~/Applications`.
4. Install the official OpenAI desktop app from its official source and use Codex mode.
5. Enable the desired macOS System Proxy.
6. Fully quit any existing ChatGPT/Codex process.
7. Double-click `Clash Bridge.app`.

More entry points: [FAQ](docs/faq.md), [Chinese FAQ](docs/faq.zh-CN.md), [How it works](docs/how-it-works.md), [Troubleshooting](docs/troubleshooting.md), and the [static project landing page](docs/index.md).

To verify a downloaded release:

```text
cd ~/Downloads
shasum -a 256 -c Clash-Bridge-for-Codex-v1.1.0-macOS.zip.sha256
```

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
