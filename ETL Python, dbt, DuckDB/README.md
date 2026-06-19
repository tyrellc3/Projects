# OpenFlights Analytics

This project cleans OpenFlights data, builds dbt analytics models, and produces reports with DuckDB and Python.

## Overview

I use OpenFlights airport, airline, and route data to demonstrate end-to-end analytics engineering.

## Setup

```bash
./setup.sh
source venv/bin/activate
export DBT_PROFILES_DIR="$PWD/dbt"
```

## Ingestion

1. Put the OpenFlights raw CSVs into `data/raw/`.
2. Run:

```bash
python scripts/ingest_openflights.py
```

## dbt workflow

```bash
dbt debug
dbt run
dbt test
dbt docs generate
```

## Models

- `stg_airports`: airport metadata cleanup
- `stg_airlines`: airline metadata cleanup
- `stg_routes`: route inventory standardization
- `mart_top_countries_by_airports`: country airport ranking
- `mart_top_airlines_by_routes`: airline route ranking
- `mart_airport_connectivity`: airport departures and arrivals
- `mart_top_hub_airports`: busiest airports by route activity
- `mart_top_country_pairs`: country-to-country route flows

## Analytics

- `notebooks/01_openflights_eda.ipynb`: overview metrics and visuals
- `notebooks/02_openflights_deeper_analysis.ipynb`: route flows and geographic hub analysis

## Dashboard

```bash
python scripts/export_dashboard.py
```

Then open `reports/openflights_dashboard.html`.

## Documentation

```bash
bash scripts/generate_dbt_docs.sh
bash scripts/serve_dbt_docs.sh
```

## Portfolio case study

See `PORTFOLIO_CASE_STUDY.md` for the project story, impact, and talking points.

## Files to ignore

The repo excludes files that are not useful for portfolio review:
- `venv/` for the local Python environment
- `target/` for dbt compiled artifacts
- `logs/` for runtime logs such as `dbt.log`
- `data/*.duckdb` for local DuckDB database files
- `reports/` for generated dashboard output
