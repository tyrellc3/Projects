# Source Manifest

## Included in This Project

| Path | Purpose |
| --- | --- |
| `data/raw/orders.csv` | Order table created to represent case-study requirements and data issues. |
| `data/raw/order_lines.csv` | Order-line table for product-level order detail. |
| `data/raw/payments.csv` | Payment table for settlement timing and method details. |
| `data/raw/returns.csv` | Returns table retaining return data issues. |
| `data/raw/customers.csv` | Customer dimension source. |
| `data/raw/products.csv` | Product dimension source. |
| `data/raw/channels.csv` | Channel dimension source. |
| `data/raw/campaigns.csv` | Campaign dimension source. |
| `data/raw/date_spine.csv` | Date source for order, payment, and return calendars. |
| `data/reference/fct_orders_modeled.csv` | Reference governed fact output created for the case-study build. |
| `data/reference/revenue_reconciliation_bridge.csv` | Reference reconciliation bridge from raw gross to governed net revenue. |
| `data/reference/finance_view_extract.csv` | Reference Finance reporting extract. |
| `data/reference/marketing_view_extract.csv` | Reference Marketing reporting extract. |
| `data/reference/ecommerce_view_extract.csv` | Reference Ecommerce reporting extract. |
| `assets/dashboard/north_american_ecommerce_dashboard.html` | Dashboard artifact created for the portfolio case-study scenario. |
| `assets/charts/*.svg` | Static Plotly chart exports used as GitHub-renderable notebook fallbacks. |
| `models/ecommerce/` | dbt staging, core, and mart models that rebuild the governed analytics layer. |
| `notebooks/01_revenue_dashboard.ipynb` | Notebook dashboard generated from dbt marts. |
| `scripts/export_github_charts.py` | Regenerates static SVG chart fallbacks from dbt marts. |

## Data Creation, Redaction, and Exclusions

- All CSVs were created by me for this portfolio case study.
- The raw tables are synthetic source-like inputs, not original company exports or production data.
- Company-specific names were intentionally excluded.
- Product SKUs use generic `PRD-` prefixes.
- The original slide deck, case study brief, and workbook are not included in this repo.

## Rebuild Intent

The reference CSVs document the intended stakeholder outputs for the case study. The dbt project rebuilds those outputs from the raw CSV layer using reproducible transformations.
