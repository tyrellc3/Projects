#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

python scripts/generate_raw_sources.py
python scripts/ingest_ecommerce.py

export DBT_PROFILES_DIR="$ROOT_DIR/dbt"
dbt debug
dbt run
dbt test

echo "Setup complete."
echo "Activate with: source \"$ROOT_DIR/venv/bin/activate\""
echo "Use dbt with: export DBT_PROFILES_DIR=\"$ROOT_DIR/dbt\""
