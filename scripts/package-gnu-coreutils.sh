#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "usage: $0 <abi> <version> <gnu-coreutils-out-dir> <install-prefix-root>" >&2
  exit 1
fi

ABI="$1"
VERSION="$2"
OUT_DIR="$3"
PREFIX_ROOT="$4"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STAGE_DIR="$REPO_DIR/staging/gnu-coreutils"
ARCHIVE_NAME="gnu-coreutils-${VERSION}-${ABI}.zip"
ARCHIVE_PATH="$REPO_DIR/packages/$ARCHIVE_NAME"

rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"

if [[ ! -d "$OUT_DIR/$PREFIX_ROOT" ]]; then
  echo "missing installed tree: $OUT_DIR/$PREFIX_ROOT" >&2
  exit 1
fi

cp -a "$OUT_DIR/$PREFIX_ROOT"/. "$STAGE_DIR"/

(
  cd "$STAGE_DIR"
  zip -qr "$ARCHIVE_PATH" .
)

SHA="$(sha256sum "$ARCHIVE_PATH" | cut -d ' ' -f 1)"
echo "archive: $ARCHIVE_PATH"
echo "sha256:  $SHA"
echo "Add this to packages/index.txt:"
echo "gnu-coreutils|$VERSION|$ARCHIVE_NAME|$SHA|Official GNU coreutils subset for Yada"
