#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: $0 <abi> <version> <coreutils-mini-out-dir>" >&2
  exit 1
fi

ABI="$1"
VERSION="$2"
OUT_DIR="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STAGE_DIR="$REPO_DIR/staging/coreutils-mini"
ARCHIVE_NAME="coreutils-mini-${VERSION}-${ABI}.zip"
ARCHIVE_PATH="$REPO_DIR/packages/$ARCHIVE_NAME"

rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR/usr/bin"
cp -f "$OUT_DIR"/bin/* "$STAGE_DIR/usr/bin/"

(
  cd "$STAGE_DIR"
  zip -qr "$ARCHIVE_PATH" .
)

SHA="$(sha256sum "$ARCHIVE_PATH" | cut -d ' ' -f 1)"
echo "archive: $ARCHIVE_PATH"
echo "sha256:  $SHA"
echo "Add this to packages/index.txt:"
echo "coreutils-mini|$VERSION|$ARCHIVE_NAME|$SHA|Small base userland for Yada"
