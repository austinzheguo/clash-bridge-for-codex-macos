#!/bin/zsh

# Local, no-network portability checks for Clash Bridge for Codex.
# Uses only temporary app copies and test fixtures; it never changes System Proxy
# or launchctl environment and never starts the official Codex executable.

set -euo pipefail

script_dir="${0:A:h}"
repo_root="$(cd "$script_dir/.." && pwd)"
source_app="${CODEX_BRIDGE_TEST_SOURCE_APP:-$repo_root/dist/Clash Bridge for Codex.app}"
test_root="$(mktemp -d)"
app_copy="$test_root/Clash Bridge for Codex.app"
launcher="$app_copy/Contents/MacOS/Clash Bridge for Codex"
scutil_fixture="$test_root/scutil-fixture.zsh"
nc_fixture="$test_root/nc-fixture.zsh"

fail() {
  print -u2 -r -- "FAIL: $1"
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  [[ "$haystack" == *"$needle"* ]] || fail "missing: $needle"
}

make_scutil_fixture() {
  local port="$1"
  local enabled="$2"
  print -r -- '#!/bin/zsh' > "$scutil_fixture"
  print -r -- '[[ "${1:-}" == "--proxy" ]] || exit 1' >> "$scutil_fixture"
  print -r -- "print 'HTTPEnable : $enabled'" >> "$scutil_fixture"
  print -r -- "print 'HTTPSEnable : $enabled'" >> "$scutil_fixture"
  if [[ "$enabled" == '1' ]]; then
    print -r -- "print 'HTTPProxy : 127.0.0.1'" >> "$scutil_fixture"
    print -r -- "print 'HTTPPort : $port'" >> "$scutil_fixture"
    print -r -- "print 'HTTPSProxy : 127.0.0.1'" >> "$scutil_fixture"
    print -r -- "print 'HTTPSPort : $port'" >> "$scutil_fixture"
  fi
  chmod 755 "$scutil_fixture"
}

make_nc_fixture() {
  local exit_code="$1"
  print -r -- '#!/bin/zsh' > "$nc_fixture"
  print -r -- "exit $exit_code" >> "$nc_fixture"
  chmod 755 "$nc_fixture"
}

launchd_proxy_state() {
  local proxy_var proxy_value
  for proxy_var in HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy NO_PROXY no_proxy; do
    proxy_value="$(launchctl getenv "$proxy_var" 2>/dev/null)"
    [[ -n "$proxy_value" ]] && print -r -- "$proxy_var=nonempty" || print -r -- "$proxy_var=empty"
  done
}

[[ -d "$source_app/Contents" ]] || fail 'source bundle missing'
ditto "$source_app" "$app_copy"
[[ -x "$launcher" ]] || fail 'copied launcher is not executable'
[[ -f "$app_copy/Contents/Resources/ClashBridge.icns" ]] || fail 'copied icon missing'
plutil -lint "$app_copy/Contents/Info.plist" >/dev/null || fail 'plist invalid'

for runtime_tool in /bin/zsh /usr/sbin/scutil /usr/bin/awk /usr/bin/nc /usr/bin/osascript /usr/libexec/PlistBuddy /usr/bin/mdfind; do
  [[ -x "$runtime_tool" ]] || fail "missing macOS runtime tool: $runtime_tool"
done

if rg -n -i '(proxy-lab|7897|1082|/Applications/Codex.app/Contents/MacOS/ChatGPT|opt/homebrew|python|node|npm|jq|evidence/|/var/folders/)' "$app_copy/Contents/MacOS" "$app_copy/Contents/Info.plist" >/dev/null; then
  fail 'runtime portability audit found a forbidden literal'
fi

before_env="$(launchd_proxy_state)"

make_nc_fixture 0
make_scutil_fixture 45123 1
output_a="$(CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" CODEX_BRIDGE_TEST_NC="$nc_fixture" "$launcher" --self-test)"
assert_contains "$output_a" 'http_port=45123'
assert_contains "$output_a" 'https_port=45123'
assert_contains "$output_a" 'http_listener=reachable'
assert_contains "$output_a" 'decision=explicit_proxy_if_both_reachable'

make_scutil_fixture 45678 1
output_b="$(CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" CODEX_BRIDGE_TEST_NC="$nc_fixture" "$launcher" --self-test)"
assert_contains "$output_b" 'http_port=45678'
assert_contains "$output_b" 'https_port=45678'

make_scutil_fixture 0 0
output_off="$(CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" CODEX_BRIDGE_TEST_NC="$nc_fixture" "$launcher" --self-test)"
assert_contains "$output_off" 'decision=launch_without_explicit_proxy'

make_scutil_fixture 45678 1
make_nc_fixture 1
output_dead="$(CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" CODEX_BRIDGE_TEST_NC="$nc_fixture" "$launcher" --self-test)"
assert_contains "$output_dead" 'http_listener=unavailable'
assert_contains "$output_dead" 'https_listener=unavailable'
assert_contains "$output_dead" 'decision=fail_proxy_listener'

if output_missing="$(CODEX_BRIDGE_TEST_CODEX_APP="$test_root/missing/Codex.app" "$launcher" --self-test 2>&1)"; then
  fail 'missing Codex fixture unexpectedly passed'
fi
assert_contains "$output_missing" 'codex_bundle=missing'
assert_contains "$output_missing" 'decision=fail_missing_codex'

arbitrary_output="$(cd "$test_root" && HOME=portable-fixture-user CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" CODEX_BRIDGE_TEST_NC="$nc_fixture" "$launcher" --self-test)"
assert_contains "$arbitrary_output" 'decision=fail_proxy_listener'

after_env="$(launchd_proxy_state)"
[[ "$before_env" == "$after_env" ]] || fail 'global launchctl proxy environment changed'
if rg -n 'launchctl[[:space:]]+setenv|launchctl[[:space:]]+unsetenv' "$app_copy/Contents/MacOS" >/dev/null; then
  fail 'launcher contains launchctl environment mutation'
fi

print -r -- 'PORTABILITY_TEST=PASS'
print -r -- 'repo_independence=pass'
print -r -- 'fake_username=pass'
print -r -- 'arbitrary_location=pass'
print -r -- 'dynamic_ports=45123,45678'
print -r -- 'missing_codex=pass'
print -r -- 'proxy_off=pass'
print -r -- 'dead_listener=pass'
print -r -- 'global_proxy_env_unchanged=pass'
