#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
cd "$ROOT_DIR"

if [ ! -d "venv" ]; then
  echo "Virtual environment not found. Run ./setup.sh first."
  exit 1
fi

source "venv/bin/activate"
export DBT_PROFILES_DIR="$ROOT_DIR/dbt"

echo "Generating dbt docs..."
dbt docs generate

echo "Done. Open the docs locally with:"
echo "  dbt docs serve --profiles-dir $ROOT_DIR/dbt"
