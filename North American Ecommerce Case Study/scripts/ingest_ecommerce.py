#!/usr/bin/env python3
"""Load redacted ecommerce raw CSVs into DuckDB under schema `raw`."""

from __future__ import annotations

from pathlib import Path

import duckdb


ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "ecommerce.duckdb"
RAW_DIR = ROOT / "data" / "raw"

TABLES = {
    "orders": RAW_DIR / "orders.csv",
    "order_lines": RAW_DIR / "order_lines.csv",
    "payments": RAW_DIR / "payments.csv",
    "returns": RAW_DIR / "returns.csv",
    "customers": RAW_DIR / "customers.csv",
    "products": RAW_DIR / "products.csv",
    "channels": RAW_DIR / "channels.csv",
    "campaigns": RAW_DIR / "campaigns.csv",
    "date_spine": RAW_DIR / "date_spine.csv",
}


def main() -> None:
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DB_PATH))
    con.execute("create schema if not exists raw")

    for table_name, path in TABLES.items():
        if not path.exists():
            print(f"Skipping {table_name}; missing {path}")
            continue
        print(f"Loading {path} -> raw.{table_name}")
        con.execute(
            f"""
            create or replace table raw.{table_name} as
            select *
            from read_csv_auto(?, header=true, all_varchar=true)
            """,
            [str(path)],
        )

    con.close()
    print(f"Ingest complete: {DB_PATH}")


if __name__ == "__main__":
    main()
