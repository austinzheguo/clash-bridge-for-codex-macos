#!/bin/zsh

# Local, no-network portability checks for Clash Bridge.
# Uses only macOS system tools, temporary fixtures, and an explicit test mode.

set -euo pipefail

script_dir="${0:A:h}"
repo_root="$(cd "$script_dir/.." && pwd)"
source_app="${CODEX_BRIDGE_TEST_SOURCE_APP:-$repo_root/dist/Clash Bridge.app}"
test_root="$(mktemp -d)"
app_copy="$test_root/Clash Bridge.app"
launcher="$app_copy/Contents/MacOS/Clash Bridge"
scutil_fixture="$test_root/scutil-fixture.zsh"
nc_fixture="$test_root/nc-fixture.zsh"
mdfind_fixture="$test_root/mdfind-fixture.zsh"

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
  local host="$1" port="$2" enabled="$3"
  print -r -- '#!/bin/zsh' > "$scutil_fixture"
  print -r -- '[[ "${1:-}" == "--proxy" ]] || exit 1' >> "$scutil_fixture"
  print -r -- "print 'HTTPEnable : $enabled'" >> "$scutil_fixture"
  print -r -- "print 'HTTPSEnable : $enabled'" >> "$scutil_fixture"
  if [[ "$enabled" == '1' ]]; then
    print -r -- "print 'HTTPProxy : $host'" >> "$scutil_fixture"
    print -r -- "print 'HTTPPort : $port'" >> "$scutil_fixture"
    print -r -- "print 'HTTPSProxy : $host'" >> "$scutil_fixture"
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

print -r -- '#!/bin/zsh' > "$mdfind_fixture"
print -r -- 'exit 0' >> "$mdfind_fixture"
chmod 755 "$mdfind_fixture"

make_app() {
  local app="$1" bundle_id="$2" executable="$3"
  mkdir -p "$app/Contents/MacOS"
  print -r -- '<?xml version="1.0" encoding="UTF-8"?>' > "$app/Contents/Info.plist"
  print -r -- '<plist version="1.0"><dict>' >> "$app/Contents/Info.plist"
  print -r -- "<key>CFBundleIdentifier</key><string>$bundle_id</string>" >> "$app/Contents/Info.plist"
  print -r -- "<key>CFBundleExecutable</key><string>$executable</string>" >> "$app/Contents/Info.plist"
  print -r -- '</dict></plist>' >> "$app/Contents/Info.plist"
  print -r -- '#!/bin/zsh' > "$app/Contents/MacOS/$executable"
  print -r -- 'exit 0' >> "$app/Contents/MacOS/$executable"
  chmod 755 "$app/Contents/MacOS/$executable"
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

for runtime_tool in /bin/zsh /usr/sbin/scutil /usr/bin/awk /usr/bin/grep /usr/bin/nc /usr/bin/osascript /usr/bin/mdfind /usr/libexec/PlistBuddy; do
  [[ -x "$runtime_tool" ]] || fail "missing macOS runtime tool: $runtime_tool"
done

if /usr/bin/grep -R -Eiq '(proxy-lab|7897|1082|/Applications/Codex.app/Contents/MacOS/ChatGPT|opt/homebrew|python|node|npm|jq|evidence/|/var/folders/)' "$app_copy/Contents/MacOS" "$app_copy/Contents/Info.plist"; then
  fail 'runtime portability audit found a forbidden literal'
fi

before_env="$(launchd_proxy_state)"
common_env=(CODEX_BRIDGE_TEST_NC="$nc_fixture" CODEX_BRIDGE_TEST_MDFIND="$mdfind_fixture")

make_nc_fixture 0
make_scutil_fixture 127.0.0.1 45123 1
output_ipv4="$(env CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" "${common_env[@]}" "$launcher" --self-test)"
assert_contains "$output_ipv4" 'http_url=http://127.0.0.1:45123'
assert_contains "$output_ipv4" 'https_url=http://127.0.0.1:45123'

make_scutil_fixture localhost 45678 1
output_hostname="$(env CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" "${common_env[@]}" "$launcher" --self-test)"
assert_contains "$output_hostname" 'http_url=http://localhost:45678'

make_scutil_fixture ::1 45679 1
output_ipv6="$(env CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" "${common_env[@]}" "$launcher" --self-test)"
assert_contains "$output_ipv6" 'http_url=http://[::1]:45679'
assert_contains "$output_ipv6" 'https_url=http://[::1]:45679'

make_scutil_fixture '' 0 0
output_off="$(env CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" "${common_env[@]}" "$launcher" --self-test)"
assert_contains "$output_off" 'decision=launch_without_explicit_proxy'

make_scutil_fixture 127.0.0.1 45678 1
make_nc_fixture 1
output_dead="$(env CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" "${common_env[@]}" "$launcher" --self-test)"
assert_contains "$output_dead" 'http_listener=unavailable'
assert_contains "$output_dead" 'decision=fail_proxy_listener'

candidate_root="$test_root/candidates"
make_app "$candidate_root/Applications/ChatGPT.app" com.openai.codex ChatGPTTarget
candidate_chatgpt="$(env HOME="$test_root/home" CODEX_BRIDGE_TEST_CANDIDATES_ROOT="$candidate_root" CODEX_BRIDGE_TEST_NC="$nc_fixture" CODEX_BRIDGE_TEST_MDFIND="$mdfind_fixture" "$launcher" --self-test)"
assert_contains "$candidate_chatgpt" 'cf_bundle_id=verified'

rm -rf "$candidate_root/Applications/ChatGPT.app"
make_app "$candidate_root/Applications/Codex.app" com.openai.codex CodexTarget
candidate_codex="$(env HOME="$test_root/home" CODEX_BRIDGE_TEST_CANDIDATES_ROOT="$candidate_root" CODEX_BRIDGE_TEST_NC="$nc_fixture" CODEX_BRIDGE_TEST_MDFIND="$mdfind_fixture" "$launcher" --self-test)"
assert_contains "$candidate_codex" 'cf_bundle_id=verified'

rm -rf "$candidate_root/Applications/Codex.app"
make_app "$candidate_root/Applications/Codex.app" com.example.not-codex WrongTarget
make_app "$candidate_root/Applications/Random/Codex.app" com.example.not-codex RandomTarget
if candidate_wrong="$(env HOME="$test_root/home" CODEX_BRIDGE_TEST_CANDIDATES_ROOT="$candidate_root" CODEX_BRIDGE_TEST_NC="$nc_fixture" CODEX_BRIDGE_TEST_MDFIND="$mdfind_fixture" "$launcher" --self-test 2>&1)"; then
  fail 'wrong-bundle candidate unexpectedly passed'
fi
assert_contains "$candidate_wrong" 'codex_bundle=missing'

fake_target_app="$test_root/fake-target/Codex.app"
fake_target_output="$test_root/fake-target-env.txt"
make_app "$fake_target_app" com.openai.codex FakeCodex
print -r -- '#!/bin/zsh' > "$fake_target_app/Contents/MacOS/FakeCodex"
for variable in HTTP_PROXY HTTPS_PROXY http_proxy https_proxy NO_PROXY no_proxy; do
  print -r -- "print -r -- '$variable='\${${variable}:-} >> '$fake_target_output'" >> "$fake_target_app/Contents/MacOS/FakeCodex"
done
chmod 755 "$fake_target_app/Contents/MacOS/FakeCodex"
make_scutil_fixture 127.0.0.1 45123 1
make_nc_fixture 0
env CODEX_BRIDGE_TEST_CODEX_APP="$fake_target_app" CODEX_BRIDGE_TEST_SCUTIL="$scutil_fixture" CODEX_BRIDGE_TEST_NC="$nc_fixture" CODEX_BRIDGE_TEST_MDFIND="$mdfind_fixture" "$launcher" --test-launch >/dev/null
for expected in \
  'HTTP_PROXY=http://127.0.0.1:45123' \
  'HTTPS_PROXY=http://127.0.0.1:45123' \
  'http_proxy=http://127.0.0.1:45123' \
  'https_proxy=http://127.0.0.1:45123' \
  'NO_PROXY=localhost,127.0.0.1,::1' \
  'no_proxy=localhost,127.0.0.1,::1'; do
  /usr/bin/grep -Fqx "$expected" "$fake_target_output" || fail "missing child environment: $expected"
done

after_env="$(launchd_proxy_state)"
[[ "$before_env" == "$after_env" ]] || fail 'global launchctl proxy environment changed'
if /usr/bin/grep -REq 'launchctl[[:space:]]+(setenv|unsetenv)' "$app_copy/Contents/MacOS"; then
  fail 'launcher contains launchctl environment mutation'
fi

print -r -- 'PORTABILITY_TEST=PASS'
print -r -- 'repo_independence=pass'
print -r -- 'fake_username=pass'
print -r -- 'arbitrary_location=pass'
print -r -- 'dynamic_ports=45123,45678,45679'
print -r -- 'ipv4_url=pass'
print -r -- 'hostname_url=pass'
print -r -- 'ipv6_url=pass'
print -r -- 'chatgpt_bundle_id=pass'
print -r -- 'codex_bundle_id=pass'
print -r -- 'wrong_bundle_rejected=pass'
print -r -- 'process_scoped_env=pass'
print -r -- 'proxy_off=pass'
print -r -- 'dead_listener=pass'
print -r -- 'global_proxy_env_unchanged=pass'
