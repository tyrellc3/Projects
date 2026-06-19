# Data Dictionary

## `data/raw/orders.csv`

Raw order-level extract used as the source input for the case study.

| Column | Description |
| --- | --- |
| `order_id` | Source order identifier. Duplicates may exist in raw data. |
| `inserted_at` | Load timestamp used to resolve duplicate order records. |
| `order_date` | Date the order was placed. |
| `payment_date` | Date the order settled or was paid. |
| `customer_id` | Redacted customer identifier. |
| `channel` | Sales channel, such as Direct Web, Retail, B2B, Wholesale, or marketplace. |
| `product_category` | Product grouping used for ecommerce reporting. |
| `product_sku` | Redacted product SKU. |
| `gross_revenue` | Source gross revenue before governed cleanup. |
| `return_flag` | Source return indicator. May be inconsistent in raw data. |
| `return_amount` | Source return amount. May have incorrect sign or missing value. |
| `return_date` | Date the return was processed. |
| `order_status` | Source order status. |
| `marketing_source` | Source marketing attribution value. |
| `data_issue` | Embedded issue label used for case-study diagnostics. |

## Additional Raw Sources

| File | Grain | Purpose |
| --- | --- | --- |
| `order_lines.csv` | one row per raw order line | Product-level order detail for building line facts. |
| `payments.csv` | one row per raw order payment | Payment timing, payment status, and method. |
| `returns.csv` | one row per raw return event | Return timing, amount, reason, and status. |
| `customers.csv` | one row per customer | Redacted customer attributes and acquisition source. |
| `products.csv` | one row per product SKU | Product category, product name, and list price. |
| `channels.csv` | one row per channel | Channel names and channel groupings. |
| `campaigns.csv` | one row per generated campaign | Promo-attributed campaign metadata. |
| `date_spine.csv` | one row per relevant date | Calendar fields for order, payment, and return reporting. |

## dbt Facts and Dimensions

| Model | Grain | Purpose |
| --- | --- | --- |
| `fct_orders` | one row per governed order | Revenue backbone after dedupe, return correction, cancellation handling, and pipeline exclusions. |
| `fct_order_lines` | one row per governed order line | Product-level revenue detail tied to governed orders. |
| `fct_payments` | one row per governed payment | Payment timing and payment method tied to governed orders. |
| `fct_returns` | one row per governed return | Standardized return deductions. |
| `dim_customers` | one row per customer | Customer attributes. |
| `dim_products` | one row per product | Product attributes. |
| `dim_channels` | one row per channel | Channel attributes. |
| `dim_campaigns` | one row per campaign | Campaign attributes. |
| `dim_dates` | one row per reporting date | Calendar dimension. |

## `data/reference/fct_orders_modeled.csv`

Reference output representing the governed order fact from the original analysis. This should be treated as a rebuild target, not as raw source data.

Key concepts:

- one row per governed order
- duplicate records removed
- cancelled revenue zeroed
- return amounts standardized
- promo attribution flagged
- date keys exposed for Finance, Marketing, and Ecommerce calendars

## `data/reference/revenue_reconciliation_bridge.csv`

Bridge from raw extracted revenue to governed net revenue. It explains how duplicate removal, return correction, cancellation handling, and pipeline exclusions move the business from raw gross revenue to a trusted reporting number.

## Audience View Extracts

The following files are redacted presentation extracts:

- `finance_view_extract.csv`
- `marketing_view_extract.csv`
- `ecommerce_view_extract.csv`

These are useful for validating the intended stakeholder outputs. The dbt marts now rebuild the governed results from the raw CSV layer.
