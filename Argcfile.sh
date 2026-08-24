#!/usr/bin/env bash
# @describe Repository development tasks for the compiled Bash CLI framework.
# @version 0.1.0

ROOT=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export LC_ALL=C TZ=UTC

# @cmd Build all generated artifacts.
build() {
  _build_binary
  _build_artifacts
}

_build_binary() {
  mkdir -p "$ROOT/build" "$ROOT/dist/bin"
  "$ROOT/scripts/assemble" "$ROOT/src" "$ROOT/build/app.sh"
  "$ROOT/scripts/validate" "$ROOT/build/app.sh"
  argc --argc-build "$ROOT/build/app.sh" "$ROOT/dist/bin/app"
  perl -0pi -e 's/exit 1\n}\n\n_argc_run/exit 2\n}\n\n_argc_run/' "$ROOT/dist/bin/app"
  chmod +x "$ROOT/dist/bin/app"
}

_build_artifacts() {
  mkdir -p "$ROOT/dist/completions" "$ROOT/dist/man"
  argc --argc-completions bash app >"$ROOT/dist/completions/app.bash"
  argc --argc-completions zsh app >"$ROOT/dist/completions/_app"
  argc --argc-completions fish app >"$ROOT/dist/completions/app.fish"
  argc --argc-mangen "$ROOT/build/app.sh" "$ROOT/dist/man"
  (cd "$ROOT/dist" && shasum -a 256 bin/app completions/* man/* >SHA256SUMS)
}

# @cmd Run all tests.
test() {
  lint
  _build_binary
  _build_artifacts
  _test_unit
  _test_contract
}

# @cmd Run static quality checks.
lint() {
  command -v shellcheck >/dev/null || {
    printf 'shellcheck is required\n' >&2
    return 4
  }
  command -v shfmt >/dev/null || {
    printf 'shfmt is required\n' >&2
    return 4
  }
  find "$ROOT/src" "$ROOT/scripts" "$ROOT/packaging" -type f -name '*.sh' | sort | while read -r file; do
    shellcheck -x "$file"
    shfmt -d "$file"
  done
  "$ROOT/scripts/validate" "$ROOT/src/cli.sh" "$ROOT/src/commands"/*.sh "$ROOT/src/lib"/*.sh
}

# Run unit tests.
_test_unit() { "$ROOT/scripts/test"; }

# Run installed-artifact contract tests.
_test_contract() {
  local app="$ROOT/dist/bin/app"
  [[ "$($app --version)" == 'app 0.1.0' ]]
  [[ "$($app config get APP_NAME)" == app ]]
  ! "$app" unknown >/dev/null 2>&1
}

# @cmd Generate documentation.
docs() {
  mkdir -p "$ROOT/docs"
  "$ROOT/scripts/docgen" "$ROOT/build/app.sh" "$ROOT/docs/cli.md"
}

# @cmd Build release packages.
package() {
  _package_archive
  _package_deb
}

# Build a versioned tar archive.
_package_archive() {
  build
  mkdir -p "$ROOT/dist/packages"
  tar -C "$ROOT/dist/bin" -czf "$ROOT/dist/packages/app-0.1.0.tar.gz" app
  shasum -a 256 "$ROOT/dist/packages/app-0.1.0.tar.gz" >"$ROOT/dist/packages/app-0.1.0.tar.gz.sha256"
}

# Build a Debian package; fails if dpkg-deb is unavailable.
_package_deb() {
  command -v dpkg-deb >/dev/null || {
    printf 'dpkg-deb is required\n' >&2
    return 4
  }
  mkdir -p "$ROOT/build/deb/DEBIAN" "$ROOT/build/deb/usr/bin" "$ROOT/dist/packages"
  printf 'Package: app\nVersion: 0.1.0\nArchitecture: all\nMaintainer: template-bash-cli\nDescription: Compiled Bash CLI application\n' >"$ROOT/build/deb/DEBIAN/control"
  cp "$ROOT/dist/bin/app" "$ROOT/build/deb/usr/bin/app"
  dpkg-deb --build "$ROOT/build/deb" "$ROOT/dist/packages/app_0.1.0_all.deb"
}

# @cmd Remove disposable build and distribution outputs.
clean() { rm -rf "$ROOT/build" "$ROOT/dist"; }

eval "$(argc --argc-eval "$0" "$@")"
