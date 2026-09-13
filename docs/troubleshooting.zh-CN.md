# 故障排查

## 没有有效系统代理

启动 Bridge 前，在 Clash Verge、Clash Verge Rev 或 Shadowrocket 中开启 HTTP/HTTPS System Proxy。Bridge 不会修改代理设置。

## listener 不可达

如果系统代理已开启但 HTTP/HTTPS listener 不可达，Bridge 会提示并停止，不会把 Codex 启动到已知失效的显式代理环境中。

## Gatekeeper

当前版本是个人使用的 ad-hoc 签名版本，没有 notarization。下载的 app 第一次启动可能需要到“系统设置 → 隐私与安全性 → 仍要打开”。不要全局关闭 Gatekeeper。

如明确理解风险，只想移除下载的本项目 app 自身的 quarantine 属性，可以针对该 app 使用：

```text
xattr -d com.apple.quarantine "/path/to/Clash Bridge for Codex.app"
```

项目不会自动执行这条命令。
