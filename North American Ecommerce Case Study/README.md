# North American Ecommerce Revenue Case Study

This project is an analytics engineering case study for North American ecommerce revenue alignment. It models a common operating problem: Finance, Marketing, and Ecommerce each need revenue reporting, but their numbers can diverge because of timing, attribution, cancellations, returns, duplicate loads, and pipeline quality issues.

The project turns that scenario into a governed analytics workflow: CSV inputs, DuckDB ingestion, dbt staging/core/mart models, tests, a notebook dashboard, static GitHub chart fallbacks, and supporting documentation for requirements and metric definitions.

## Data Note

The project data is does not include original company exports or production data. Full data origin is documented in `docs/source_manifest.md`.

## How to Run

```bash
./setup.sh
source venv/bin/activate
export DBT_PROFILES_DIR="$PWD/dbt"

python scripts/generate_raw_sources.py
python scripts/ingest_ecommerce.py
dbt run
dbt test
```

To export the dashboard assets:

```bash
python scripts/export_dashboard.py
python scripts/export_github_charts.py
```

## File Dictionary

| Path | Purpose |
| --- | --- |
| `data/raw/` | Project CSV inputs for orders, payments, returns, customers, products, channels, campaigns, and calendar dates. |
| `data/reference/` | Reference outputs used to validate the modeled revenue facts, reconciliation bridge, and stakeholder views. |
| `models/ecommerce/staging/` | dbt staging models that type, standardize, and classify source records. |
| `models/ecommerce/core/` | dbt dimensions and fact tables, including governed orders, order lines, payments, and returns. |
| `models/ecommerce/marts/` | Business-facing marts for Finance, Marketing, Ecommerce, KPIs, reconciliation, and data quality. |
| `tests/` | Custom dbt tests for cancellation handling, return deductions, and pipeline exclusions. |
| `notebooks/01_revenue_dashboard.ipynb` | Notebook dashboard with local interactive Plotly charts and GitHub-renderable static fallbacks. |
| `assets/charts/` | Static SVG chart exports used by the notebook when viewed in GitHub. |
| `assets/dashboard/` | HTML dashboard reference asset and notes. |
| `scripts/generate_raw_sources.py` | Rebuilds the project CSV inputs. |
| `scripts/ingest_ecommerce.py` | Loads CSVs into DuckDB under the raw schema. |
| `scripts/export_dashboard.py` | Exports an interactive HTML dashboard from dbt marts. |
| `scripts/export_github_charts.py` | Exports static Plotly chart images for GitHub notebook rendering. |
| `docs/business_requirements.md` | Business and technical requirements for the governed revenue layer. |
| `docs/metric_definitions.md` | Definitions for demand, gross revenue, net revenue, recognized revenue, and attributed revenue. |
| `docs/discovery_questions.md` | Stakeholder questions used to separate metric definitions from data quality issues. |
| `docs/data_dictionary.md` | Column-level reference for source files and modeled outputs. |
| `docs/source_manifest.md` | Data provenance, included assets, and exclusions. |
| `docs/implementation_plan.md` | Roadmap for moving the case study pattern toward production. |
| `PROJECT_SUMMARY.md` | Executive snapshot of outputs, results, and recommendation. |
| `PORTFOLIO_CASE_STUDY.md` | Narrative case study with practical questions, findings, and next steps. |

## Key Outputs

- Governed order fact with deterministic deduplication, cancellation handling, return treatment, and pipeline exclusions.
- Revenue reconciliation bridge from raw gross revenue to governed net revenue.
- Finance, Marketing, and Ecommerce marts built from the same modeled revenue layer.
- dbt tests covering uniqueness, relationships, issue handling, and reporting assumptions.
- Notebook and HTML dashboard views for stakeholder review.

## Notes

GitHub does not reliably render interactive Plotly charts inside notebooks. The notebook keeps the interactive charts for local use and includes static SVG fallbacks exported from the same Plotly figures.
