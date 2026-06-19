# Source Manifest

## Included in This Project

| Path | Purpose |
| --- | --- |
| `data/raw/orders.csv` | Redacted raw order extract exported from the source workbook. |
| `data/raw/order_lines.csv` | Generated raw order-line table. |
| `data/raw/payments.csv` | Generated raw payment table. |
| `data/raw/returns.csv` | Generated raw returns table retaining return data issues. |
| `data/raw/customers.csv` | Generated redacted customer dimension source. |
| `data/raw/products.csv` | Generated redacted product dimension source. |
| `data/raw/channels.csv` | Generated channel dimension source. |
| `data/raw/campaigns.csv` | Generated campaign dimension source. |
| `data/raw/date_spine.csv` | Generated date source for order, payment, and return calendars. |
| `data/reference/fct_orders_modeled.csv` | Reference governed fact output from the prior case-study work. |
| `data/reference/revenue_reconciliation_bridge.csv` | Reference reconciliation bridge from raw gross to governed net revenue. |
| `data/reference/finance_view_extract.csv` | Reference Finance reporting extract. |
| `data/reference/marketing_view_extract.csv` | Reference Marketing reporting extract. |
| `data/reference/ecommerce_view_extract.csv` | Reference Ecommerce reporting extract. |
| `assets/dashboard/north_american_ecommerce_dashboard.html` | Redacted dashboard artifact from the presentation workflow. |
| `assets/charts/*.svg` | Static Plotly chart exports used as GitHub-renderable notebook fallbacks. |
| `models/ecommerce/` | dbt staging, core, and mart models that rebuild the governed analytics layer. |
| `notebooks/01_revenue_dashboard.ipynb` | Notebook dashboard generated from dbt marts. |
| `scripts/export_github_charts.py` | Regenerates static SVG chart fallbacks from dbt marts. |

## Redaction and Exclusions

- Company-specific names were removed.
- Brand-specific SKU prefixes were replaced with generic `PRD-` prefixes.
- The original slide deck, PDF prompt, and workbook are not included in this repo.
- Scratch render files and review artifacts were excluded.

## Rebuild Intent

The reference CSVs document what the original presentation produced. The dbt project now rebuilds those outputs from the raw CSV layer using reproducible transformations.
