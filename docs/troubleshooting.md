# Troubleshooting

## No valid System Proxy

Enable the HTTP/HTTPS System Proxy in Clash Verge, Clash Verge Rev, or Shadowrocket before launching the Bridge. The Bridge does not change proxy settings.

## Listener unavailable

The Bridge stops and shows a notification when an enabled HTTP/HTTPS proxy listener cannot be reached. It does not start Codex with a known-dead explicit proxy.

## Gatekeeper

The release candidate is ad-hoc signed for personal use and is not notarized. For a downloaded app, macOS may require **System Settings → Privacy & Security → Open Anyway** after the first blocked launch. Do not disable Gatekeeper globally.

If you understand the risk and only want to remove the quarantine attribute from the downloaded project app, target that app explicitly:

```text
xattr -d com.apple.quarantine "/path/to/Clash Bridge.app"
```

The project does not run this command automatically.
