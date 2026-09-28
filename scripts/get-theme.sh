#!/usr/bin/env bash
# Fetch the vendored terminus theme (pinned by commit, see THEME_SHA).
# The themes/ directory is gitignored; run this after cloning, and CI runs it before build.
set -euo pipefail

THEME_SHA="2bef349d339d42b19c431d0478934b10d32f485b"
DEST="themes/terminus"

if [ "${1:-}" != "--force" ] && [ -f "$DEST/theme.toml" ]; then
    echo "Theme already present at $DEST (use --force to re-fetch)."
    exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fSL -o "$tmp/theme.tar.gz" "https://github.com/ebkalderon/terminus/archive/${THEME_SHA}.tar.gz"
rm -rf "$DEST"
mkdir -p "$DEST"
tar xzf "$tmp/theme.tar.gz" -C "$DEST" --strip-components=1
echo "Fetched terminus @ ${THEME_SHA} into $DEST."
