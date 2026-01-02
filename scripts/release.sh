#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/release"
ZIP_PATH="${OUT_DIR}/DeegoAdvisor.zip"

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"

cd "${ROOT_DIR}"
zip -r "${ZIP_PATH}" . \
  -x "cache/*" \
  -x "release/*" \
  -x ".git/*" \
  -x ".gitignore" \
  -x "*.pyc" \
  -x "__pycache__/*"

echo "Release archive created at ${ZIP_PATH}"
