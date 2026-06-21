# OpenFlights Analytics

This project builds a local analytics workflow around OpenFlights airport, airline, and route data. It uses Python to ingest raw CSVs into DuckDB, dbt to standardize and model the data, and notebooks/dashboard exports to answer route network questions.

The project focuses on practical data engineering patterns: clean source ingestion, tested transformations, reusable marts, documented models, and visuals that work both locally and in GitHub.

## How to Run

```bash
./setup.sh
source venv/bin/activate
export DBT_PROFILES_DIR="$PWD/dbt"

python scripts/ingest_openflights.py
dbt run
dbt test
```

To export dashboard and documentation assets:

```bash
python scripts/export_dashboard.py
bash scripts/generate_dbt_docs.sh
```

To refresh GitHub-renderable notebook charts:

```bash
python scripts/export_github_charts.py
```

## File Dictionary

| Path | Purpose |
| --- | --- |
| `data/raw/airports.csv` | Raw OpenFlights airport reference data. |
| `data/raw/airlines.csv` | Raw OpenFlights airline reference data. |
| `data/raw/routes.csv` | Raw OpenFlights route inventory data. |
| `models/openflights/stg_airports.sql` | Cleans and standardizes airport metadata. |
| `models/openflights/stg_airlines.sql` | Cleans and standardizes airline metadata. |
| `models/openflights/stg_routes.sql` | Standardizes route inventory and airport relationships. |
| `models/openflights/mart_top_countries_by_airports.sql` | Ranks countries by airport count. |
| `models/openflights/mart_top_airlines_by_routes.sql` | Ranks airlines by route count. |
| `models/openflights/mart_airport_connectivity.sql` | Calculates airport departures, arrivals, and total route activity. |
| `models/openflights/mart_top_hub_airports.sql` | Identifies the busiest hub airports by route activity. |
| `models/openflights/mart_top_country_pairs.sql` | Models country-to-country route flows. |
| `models/openflights/mart_route_network_summary.sql` | Summarizes domestic versus international route mix. |
| `models/openflights/mart_country_route_mix.sql` | Calculates country-level outbound route mix. |
| `models/openflights/mart_hub_country_dependency.sql` | Measures how concentrated each country is around top hubs. |
| `models/openflights/mart_airline_route_coverage.sql` | Combines carrier names with route coverage metrics. |
| `models/openflights/schema.yml` | dbt source/model documentation and tests. |
| `notebooks/01_openflights_eda.ipynb` | Notebook for overview metrics and initial visuals. |
| `notebooks/02_openflights_deeper_analysis.ipynb` | Notebook for route flows, hub concentration, and network recommendations. |
| `assets/openflights/` | Static SVG chart exports used when notebooks are viewed in GitHub. |
| `scripts/ingest_openflights.py` | Loads raw OpenFlights CSVs into DuckDB. |
| `scripts/export_dashboard.py` | Exports an interactive HTML dashboard from modeled data. |
| `scripts/export_github_charts.py` | Exports static Plotly chart images for GitHub notebook rendering. |
| `scripts/generate_dbt_docs.sh` | Generates dbt documentation. |
| `scripts/serve_dbt_docs.sh` | Serves dbt documentation locally. |
| `PROJECT_SUMMARY.md` | Executive snapshot of outputs and findings. |
| `PORTFOLIO_CASE_STUDY.md` | Narrative case study with practical questions, findings, and recommendation. |

## Key Outputs

- Cleaned airport, airline, and route staging models.
- Route network marts for connectivity, route mix, hub concentration, country pairs, and airline coverage.
- dbt tests and documentation for the modeled layer.
- Interactive notebooks with static Plotly fallbacks for GitHub.
- Exportable HTML dashboard for local review.

## Notes

GitHub does not reliably render interactive Plotly charts inside notebooks. The notebooks keep the interactive charts for local use and include static SVG fallbacks exported from the same Plotly figures.
