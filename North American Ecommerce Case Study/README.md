# North American Ecommerce Revenue Case Study

This project is a redacted analytics engineering case study focused on North American Ecommerce revenue alignment. The original prompt centered on a common business problem: Finance, Marketing, and Ecommerce were all reporting revenue from related data, but each team used different definitions, calendars, and source logic.

The goal of this project is to turn that situation into a governed analytics design: clear metric definitions, clean source data, modeled facts, audience-specific views, and a practical roadmap for reducing manual reconciliation.

## Project Structure

- `data/raw/`: redacted source CSVs for orders, lines, payments, returns, customers, products, channels, campaigns, and dates
- `models/ecommerce/staging/`: typed and standardized source models
- `models/ecommerce/core/`: dimensions and fact tables
- `models/ecommerce/marts/`: business-facing marts for Finance, Marketing, Ecommerce, reconciliation, and data quality
- `notebooks/`: notebook dashboard for analysis
- `scripts/`: source generation, ingestion, and dashboard export scripts
- `docs/`: requirements, definitions, data dictionary, discovery questions, and implementation plan

## Setup

```bash
./setup.sh
source venv/bin/activate
export DBT_PROFILES_DIR="$PWD/dbt"
```

Or run the workflow manually:

```bash
python scripts/generate_raw_sources.py
python scripts/ingest_ecommerce.py
dbt run
dbt test
```

## Business Case

The business needs a trusted revenue foundation for North American ecommerce reporting. Today, teams can arrive at different numbers because they answer different questions:

- Ecommerce looks at demand when the order is placed.
- Finance recognizes revenue after payment settlement and return treatment.
- Marketing needs attributed revenue tied to eligible campaign sources.

Those differences are not automatically wrong. The issue is that they are not consistently documented, governed, or reconciled. Without a shared model, teams spend time explaining variances instead of acting on the business.

## Requirements

The analytics solution should:

- Define demand, gross revenue, net revenue, recognized revenue, and attributed revenue.
- Preserve multiple business calendars, including order date, payment date, and return date.
- Deduplicate order records using deterministic rules.
- Zero out cancelled order revenue while preserving cancellation context for funnel analysis.
- Normalize return handling so returned revenue is deducted consistently.
- Exclude incomplete pipeline failure records until they can be remediated.
- Provide Finance, Marketing, and Ecommerce views from the same governed fact layer.
- Add tests and reconciliation checks so reporting variance is visible and explainable.
- Support a target cross-team variance tolerance below 3% for governed reporting metrics.

## Dataset

The primary raw dataset is exported to:

- `data/raw/orders.csv`

Additional raw source tables are generated from the order extract:

- `data/raw/order_lines.csv`
- `data/raw/payments.csv`
- `data/raw/returns.csv`
- `data/raw/customers.csv`
- `data/raw/products.csv`
- `data/raw/channels.csv`
- `data/raw/campaigns.csv`
- `data/raw/date_spine.csv`

Reference outputs from the prior analysis are stored separately:

- `data/reference/fct_orders_modeled.csv`
- `data/reference/revenue_reconciliation_bridge.csv`
- `data/reference/finance_view_extract.csv`
- `data/reference/marketing_view_extract.csv`
- `data/reference/ecommerce_view_extract.csv`

The raw extract contains 66 order rows from January through April 2026. It intentionally includes common ecommerce data issues:

- duplicate order loads
- cancelled orders with revenue still attached
- returns with inconsistent signs or flags
- timing differences between order date and payment date
- incomplete records from pipeline failures

## Current Baseline

From the redacted source workbook:

- Raw gross revenue: `$13,144.35`
- Governed gross revenue after cleaning: `$11,344.44`
- Governed net revenue: `$10,549.48`
- Modeled orders after cleaning: `60`
- Promo-attributed net revenue: `$2,749.86`
- Promo-attributed orders: `18`

The reconciliation bridge shows a raw-to-governed revenue gap of `$2,594.87`, or `19.7%` of raw gross revenue. That gap is the core reason the case needs a governed model instead of another dashboard.

## Proposed Analytics Design

The model should center on a conformed order fact table:

- `fct_orders`: one row per governed order
- `fct_order_lines`: product-level order-line grain
- `fct_returns`: return events and refund timing
- `fct_payments`: payment and settlement timing
- `dim_customer`, `dim_product`, `dim_channel`, `dim_campaign`

Audience views should sit on top of the same modeled layer:

- Finance view: recognized net revenue by payment date
- Marketing view: attributed revenue by campaign eligibility
- Ecommerce view: demand, order volume, channel mix, and return rate

## dbt Marts

- `mart_revenue_kpis`: executive KPI summary
- `mart_revenue_reconciliation`: bridge from raw gross revenue to governed net revenue
- `mart_finance_monthly_revenue`: recognized net revenue by payment month
- `mart_marketing_attribution`: promo and non-promo revenue by source
- `mart_ecommerce_channel_performance`: channel and product-category performance
- `mart_data_quality_issues`: raw data issue summary

## Dashboard

The notebook dashboard is in `notebooks/01_revenue_dashboard.ipynb`.

To export an interactive HTML dashboard from the dbt marts:

```bash
python scripts/export_dashboard.py
```

Then open `reports/north_american_ecommerce_dashboard.html`.

GitHub does not reliably render interactive Plotly charts inside notebooks. The notebook keeps the interactive charts for local use and includes static SVG fallback versions exported from Plotly with Kaleido:

```bash
python scripts/export_github_charts.py
```

The static notebook charts are saved in `assets/charts/`.

## Assets

- `assets/dashboard/north_american_ecommerce_dashboard.html`: redacted dashboard artifact from the original presentation work
- `docs/business_requirements.md`: expanded business and technical requirements
- `docs/discovery_questions.md`: stakeholder discovery questions used to separate metric definitions from data defects
- `docs/metric_definitions.md`: governed revenue definitions
- `docs/data_dictionary.md`: source and reference file dictionary
- `docs/implementation_plan.md`: roadmap for turning the case study into a fuller analytics engineering project
- `PROJECT_SUMMARY.md`: concise project summary and outputs
- `PORTFOLIO_CASE_STUDY.md`: practical case study with findings and recommendation

## Redaction Note

This folder intentionally removes company-specific references from the original case study. Product SKUs and presentation assets were renamed or generalized so the project can be shared as a neutral North American ecommerce revenue case study.
