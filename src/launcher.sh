#!/bin/zsh

# External, Codex-only dynamic System Proxy launcher.
# Reads current macOS SystemConfiguration on every start and never changes
# launchctl environment or the official Codex.app bundle.

set -u

script_mode='launch'
if [[ "${1:-}" == '--self-test' ]]; then
  script_mode='self-test'
fi

codex_app_override=''
system_scutil='/usr/sbin/scutil'
system_nc='/usr/bin/nc'
if [[ "$script_mode" == 'self-test' ]]; then
  codex_app_override="${CODEX_BRIDGE_TEST_CODEX_APP:-}"
  system_scutil="${CODEX_BRIDGE_TEST_SCUTIL:-$system_scutil}"
  system_nc="${CODEX_BRIDGE_TEST_NC:-$system_nc}"
fi

find_codex_app() {
  local candidate
  if [[ -n "$codex_app_override" ]]; then
    print -r -- "$codex_app_override"
    return
  fi
  if [[ -d '/Applications/Codex.app' && -f '/Applications/Codex.app/Contents/Info.plist' ]]; then
    print -r -- '/Applications/Codex.app'
    return
  fi
  while IFS= read -r candidate; do
    if [[ "$candidate" == *.app && -f "$candidate/Contents/Info.plist" ]]; then
      print -r -- "$candidate"
      return
    fi
  done < <(/usr/bin/mdfind 'kMDItemCFBundleIdentifier == "com.openai.codex"c' 2>/dev/null)
}

codex_app="$(find_codex_app)"
codex_info="$codex_app/Contents/Info.plist"

notify() {
  local message="$1"
  /usr/bin/osascript -e "display notification \"${message//\"/\\\"}\" with title \"Clash Bridge for Codex\"" >/dev/null 2>&1 || true
}

proxy_value() {
  local key="$1"
  "$system_scutil" --proxy | /usr/bin/awk -v key="$key" '$1 == key && ($2 == ":" || $2 == "=") { print $3; exit }'
}

valid_port() {
  [[ "$1" =~ '^[0-9]+$' && "$1" -ge 1 && "$1" -le 65535 ]]
}

valid_host() {
  [[ -n "$1" && "$1" != *[[:space:]]* ]]
}

is_listener_reachable() {
  "$system_nc" -z -w 1 "$1" "$2" >/dev/null 2>&1
}

host_category() {
  case "$1" in
    127.0.0.1|localhost|::1) print 'loopback' ;;
    *) print 'non-loopback' ;;
  esac
}

if [[ -z "$codex_app" || ! -d "$codex_app" || ! -f "$codex_info" ]]; then
  if [[ "$script_mode" == 'self-test' ]]; then
    print 'codex_bundle=missing'
    print 'decision=fail_missing_codex'
  else
    notify 'Official Codex.app bundle was not found; Codex was not started.'
  fi
  exit 1
fi

codex_bundle_executable=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$codex_info" 2>/dev/null || true)
if [[ -z "$codex_bundle_executable" || "$codex_bundle_executable" == *'/'* ]]; then
  if [[ "$script_mode" == 'self-test' ]]; then
    print 'codex_bundle=present'
    print 'decision=fail_invalid_codex_executable'
  else
    notify 'Codex.app has no usable CFBundleExecutable; Codex was not started.'
  fi
  exit 1
fi

codex_executable="$codex_app/Contents/MacOS/$codex_bundle_executable"
if [[ ! -x "$codex_executable" ]]; then
  if [[ "$script_mode" == 'self-test' ]]; then
    print 'codex_bundle=present'
    print 'decision=fail_missing_codex_executable'
  else
    notify 'Codex.app executable is unavailable; Codex was not started.'
  fi
  exit 1
fi

http_enabled="$(proxy_value HTTPEnable)"
http_host="$(proxy_value HTTPProxy)"
http_port="$(proxy_value HTTPPort)"
https_enabled="$(proxy_value HTTPSEnable)"
https_host="$(proxy_value HTTPSProxy)"
https_port="$(proxy_value HTTPSPort)"

if [[ "$script_mode" == 'self-test' ]]; then
  print 'codex_bundle=present cf_bundle_executable=read official_executable=executable'
  print "http_enabled=${http_enabled:-0} http_host_category=$(host_category "$http_host") http_port=${http_port:-unavailable}"
  print "https_enabled=${https_enabled:-0} https_host_category=$(host_category "$https_host") https_port=${https_port:-unavailable}"
  if [[ "$http_enabled" == '1' && "$https_enabled" == '1' ]] && valid_host "$http_host" && valid_host "$https_host" && valid_port "$http_port" && valid_port "$https_port"; then
    http_listener='unavailable'
    https_listener='unavailable'
    is_listener_reachable "$http_host" "$http_port" && http_listener='reachable'
    is_listener_reachable "$https_host" "$https_port" && https_listener='reachable'
    print "http_listener=$http_listener"
    print "https_listener=$https_listener"
    if [[ "$http_listener" == 'reachable' && "$https_listener" == 'reachable' ]]; then
      print 'decision=explicit_proxy_if_both_reachable'
    else
      print 'decision=fail_proxy_listener'
    fi
  else
    print 'decision=launch_without_explicit_proxy'
  fi
  exit 0
fi

if [[ "$http_enabled" == '1' && "$https_enabled" == '1' ]] && valid_host "$http_host" && valid_host "$https_host" && valid_port "$http_port" && valid_port "$https_port"; then
  if ! is_listener_reachable "$http_host" "$http_port" || ! is_listener_reachable "$https_host" "$https_port"; then
    notify 'System Proxy is configured but its HTTP/HTTPS listener is unavailable; Codex was not started.'
    exit 1
  fi
  export HTTP_PROXY="http://$http_host:$http_port"
  export HTTPS_PROXY="http://$https_host:$https_port"
  export http_proxy="$HTTP_PROXY"
  export https_proxy="$HTTPS_PROXY"
  export NO_PROXY='localhost,127.0.0.1,::1'
  export no_proxy="$NO_PROXY"
  exec "$codex_executable"
fi

notify 'No valid HTTP and HTTPS System Proxy was detected; starting Codex without explicit proxy environment.'
exec "$codex_executable"
