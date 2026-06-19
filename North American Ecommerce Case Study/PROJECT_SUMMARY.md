# North American Ecommerce Revenue Summary

This project demonstrates a governed analytics engineering approach to ecommerce revenue alignment.

## What It Covers

- Expanded raw ecommerce source tables from a redacted order extract
- DuckDB ingestion into a raw schema
- dbt staging models, dimensions, facts, and marts
- Revenue governance for demand, gross, net, recognized, and attributed revenue
- Data quality tests for duplicates, cancellations, returns, and pipeline exclusions
- Notebook and HTML dashboard outputs for stakeholder review
- Static Plotly chart fallbacks so notebook visuals render in GitHub

## Raw Sources

- `orders`
- `order_lines`
- `payments`
- `returns`
- `customers`
- `products`
- `channels`
- `campaigns`
- `date_spine`

## dbt Models

- Staging models standardize source types and issue classifications.
- Core dimensions model customers, products, channels, campaigns, and dates.
- Core facts model governed orders, order lines, payments, and returns.
- Marts answer Finance, Marketing, Ecommerce, reconciliation, and data quality questions.

## Key Results

- Raw order rows: 66
- Governed orders: 60
- Raw gross revenue: `$13,144.35`
- Governed gross revenue: `$11,344.44`
- Governed net revenue: `$10,549.48`
- Raw-to-governed gap: `$2,594.87`, or `19.7%`
- Promo-attributed net revenue: `$2,749.86`

## Practical Questions Answered

- Why are teams reporting different revenue numbers?
- Which differences are intentional metric definitions?
- Which differences are caused by data quality issues?
- How much revenue is at risk from duplicates, returns, cancellations, and pipeline failures?
- Which governed marts should Finance, Marketing, and Ecommerce use?

## Recommendation

Use one governed order fact as the revenue backbone, then publish team-specific marts from that same model. Finance should own recognized net revenue, Ecommerce should use order-date demand and channel performance views, and Marketing should use attributed revenue only after cancellations and returns are handled consistently.
