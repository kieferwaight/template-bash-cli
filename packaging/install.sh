#!/usr/bin/env bash
set -euo pipefail

version=${1:-latest}
owner=${APP_GITHUB_OWNER:-kieferwaight}
repo=${APP_GITHUB_REPO:-template-bash-cli}
prefix=${APP_INSTALL_PREFIX:-${HOME}/.local}
base="https://github.com/${owner}/${repo}/releases/download/${version}"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/app-install.XXXXXX")
trap 'rm -rf -- "$tmp"' EXIT

command -v curl >/dev/null 2>&1 || {
  printf 'curl is required\n' >&2
  exit 4
}
command -v shasum >/dev/null 2>&1 || {
  printf 'shasum is required\n' >&2
  exit 4
}
curl --fail --location --silent --show-error "$base/app-${version}.tar.gz" -o "$tmp/app.tar.gz"
curl --fail --location --silent --show-error "$base/app-${version}.tar.gz.sha256" -o "$tmp/app.tar.gz.sha256"
(cd "$tmp" && shasum -a 256 -c app.tar.gz.sha256)
mkdir -p "$prefix/bin"
tar -xzf "$tmp/app.tar.gz" -C "$tmp"
install -m 0755 "$tmp/app" "$prefix/bin/app"
printf 'installed app %s at %s\n' "$version" "$prefix/bin/app"
