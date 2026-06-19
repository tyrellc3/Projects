#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Helper for status
echo_status() {
  printf "=> %s\n" "$1"
}

# Create or activate a Python virtual environment
if [ ! -d "venv" ]; then
  echo_status "Creating virtual environment venv"
  python3 -m venv venv
else
  echo_status "Using existing virtual environment venv"
fi

source "venv/bin/activate"

echo_status "Upgrading pip"
python -m pip install --upgrade pip

echo_status "Checking Python packages (installing only missing ones)"
MISSING=$(python - <<'PY'
import importlib
mapping = {
    'dbt-duckdb': 'dbt',
    'duckdb': 'duckdb',
    'pandas': 'pandas',
    'jupyter': 'notebook',
    'plotly': 'plotly'
}
missing = []
for pkg, mod in mapping.items():
    try:
        importlib.import_module(mod)
    except Exception:
        missing.append(pkg)
print(' '.join(missing))
PY
)

if [ -n "$MISSING" ]; then
  echo_status "Installing: $MISSING"
  python -m pip install $MISSING
else
  echo_status "All required Python packages are already installed"
fi

# Create project directories
mkdir -p data models notebooks dbt

# Create a simple dbt project file if it does not exist
if [ ! -f "dbt_project.yml" ]; then
  cat > dbt_project.yml <<'YAML'
name: portfolio
version: '1.0'
config-version: 2
profile: portfolio
source-paths: ["models"]
analysis-paths: ["analysis"]
test-paths: ["tests"]
data-paths: ["data"]
macro-paths: ["macros"]
model-paths: ["models"]
YAML
fi

# Create a local dbt profiles directory and profile (do not overwrite existing)
if [ -f "dbt/profiles.yml" ]; then
  echo_status "dbt/profiles.yml already exists; leaving it in place: dbt/profiles.yml"
else
  cat > dbt/profiles.yml <<'YAML'
portfolio:
  outputs:
    dev:
      type: duckdb
      path: "${ROOT_DIR}/data/analytics.duckdb"
      threads: 1
      extensions: []
  target: dev
YAML
  echo_status "Wrote new dbt/profiles.yml"
fi

# Create an empty models folder marker
if [ ! -f "models/.gitkeep" ]; then
  touch models/.gitkeep
fi

# Initialize DuckDB database file if it does not exist
python - <<'PY'
import pathlib
import duckdb
pathlib.Path('data').mkdir(exist_ok=True)
con = duckdb.connect('data/analytics.duckdb')
con.execute('CREATE SCHEMA IF NOT EXISTS analytics')
con.close()
PY

cat <<EOF
Setup complete.

Next steps:
  1. Activate the virtualenv: source "$ROOT_DIR/venv/bin/activate"
  2. Export the local dbt profiles directory:
       export DBT_PROFILES_DIR="$ROOT_DIR/dbt"
  3. Verify the dbt connection:
       dbt debug
  4. Add models in the models/ directory and analytics notebooks in notebooks/.

You can also launch Jupyter:
  jupyter notebook notebooks
EOF
