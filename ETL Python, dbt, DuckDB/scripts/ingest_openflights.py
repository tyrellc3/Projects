"""Load OpenFlights CSV files into DuckDB under schema `raw`.

Run: python scripts/ingest_openflights.py
"""
import pathlib
import duckdb

ROOT = pathlib.Path(__file__).resolve().parent.parent
DB = ROOT / "data" / "analytics.duckdb"
RAW = ROOT / "data" / "raw"

pathlib.Path(RAW).mkdir(parents=True, exist_ok=True)

con = duckdb.connect(str(DB))
con.execute("CREATE SCHEMA IF NOT EXISTS raw")

files = {
    "airports": RAW / "airports.csv",
    "airlines": RAW / "airlines.csv",
    "routes": RAW / "routes.csv",
}

for name, path in files.items():
    if not path.exists():
        print(f"Skipping {name}; file not found: {path}")
        continue
    print(f"Loading {path} -> raw.{name}")
    # Use read_csv_auto to infer types. Replace table if it exists.
    con.execute(f"CREATE OR REPLACE TABLE raw.{name} AS SELECT * FROM read_csv_auto('{path}', AUTO_DETECT=TRUE)")

con.close()
print("Ingest complete.")
