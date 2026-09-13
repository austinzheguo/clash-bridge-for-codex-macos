# Security and privacy

Clash Bridge for Codex is an unofficial third-party macOS launcher. It is not developed, endorsed, certified, or supported by OpenAI or Clash Verge Rev.

The launcher:

- collects no telemetry;
- does not read Codex chat content;
- does not read Clash subscriptions, node credentials, passwords, or private keys;
- does not upload proxy configuration;
- does not contact a project server;
- does not modify global `launchctl` proxy environment;
- does not modify the official Codex.app.

At launch it reads the enabled state, host, and port of the current macOS HTTP/HTTPS System Proxy and checks whether the local listener is reachable. It then passes process-scoped proxy variables only to the Codex process tree.

After the GitHub repository is published, the maintainer should enable GitHub Private Vulnerability Reporting if available and use the repository Security page for private reports. Until that channel exists, do not submit proxy credentials, subscriptions, UUIDs, tokens, or private configuration in public issues.
