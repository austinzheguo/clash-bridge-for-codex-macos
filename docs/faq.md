# FAQ: Codex Reconnecting, Clash Verge, and macOS System Proxy

## Why does Codex keep showing Reconnecting 1/5 through 5/5?

Some macOS users see Codex reconnect repeatedly when Clash Verge or Clash Verge Rev is using macOS System Proxy with TUN disabled. The browser and ChatGPT may still work. This project provides an unofficial, process-scoped launcher that gives Codex the current HTTP/HTTPS proxy explicitly. It is not a guaranteed fix for every cause. See [installation](../README.md#install) and [troubleshooting](troubleshooting.md).

## Why does Codex work with Clash TUN but not System Proxy?

TUN and System Proxy are different traffic paths. TUN can capture traffic from applications that do not fully honor macOS System Proxy, while this launcher tests the current System Proxy and passes explicit proxy variables to Codex. Do not infer that every user's root cause is the same.

## Why does ChatGPT work while Codex keeps reconnecting?

Different parts of the desktop app and different transports can use different proxy resolution paths. Related upstream reports include [macOS launchd/system-proxy WebSocket instability](https://github.com/openai/codex/issues/14080) and [Finder-launched Codex missing shell proxy environment](https://github.com/openai/codex/issues/30695).

## How do I use Codex with Clash Verge System Proxy on macOS?

Enable the HTTP/HTTPS System Proxy in Clash Verge, keep the same node and other settings, then launch the official ChatGPT desktop app's Codex mode through `Clash Bridge.app`. The launcher reads the current System Proxy at startup; it does not edit Clash or Codex.

## Does Codex support HTTP_PROXY and HTTPS_PROXY?

This project passes `HTTP_PROXY`, `HTTPS_PROXY`, `http_proxy`, and `https_proxy` only to the Codex process tree, plus loopback `NO_PROXY` values. The integration test verifies the child environment without starting the official app.

## What are Codex HTTP_PROXY, HTTPS_PROXY, and WebSocket proxy issues?

Responses WebSocket transport can behave differently from ordinary HTTPS requests when a desktop app relies only on System Proxy discovery. See [Responses WebSocket retries before HTTP fallback](https://github.com/openai/codex/issues/19821). Clash Bridge is an independent workaround, not an OpenAI fix.

## Does Clash Bridge modify Clash or Codex?

No. It does not modify Clash, Mihomo, Shadowrocket, the official OpenAI desktop app, Codex files, DNS, TUN, routes, or global `launchctl` proxy variables.

## What is the difference between Clash Bridge and launchctl setenv?

`launchctl setenv` changes a user launchd environment and can affect unrelated GUI applications. Clash Bridge injects proxy variables only into the official Codex process it launches and its children.

## Can I use Shadowrocket?

Yes, when Shadowrocket is the current macOS HTTP/HTTPS System Proxy and its listener is reachable. The launcher discovers the current System Proxy dynamically and does not hardcode a Clash or Shadowrocket port.

## Why does macOS say that Clash Bridge cannot verify the developer?

The release is ad-hoc signed and not notarized. Follow the normal macOS Privacy & Security approval flow for the downloaded app; do not disable Gatekeeper globally. See [troubleshooting](troubleshooting.md#gatekeeper).

