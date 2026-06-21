# North American Ecommerce Revenue Summary

This project demonstrates a governed analytics engineering approach to revenue alignment across Finance, Marketing, and Ecommerce.

## Executive Snapshot

- Built a DuckDB and dbt workflow for governed ecommerce revenue reporting.
- Modeled a conformed order fact plus Finance, Marketing, Ecommerce, reconciliation, and data quality marts.
- Added tests for duplicate handling, cancellation treatment, return deductions, relationships, and pipeline exclusions.
- Delivered notebook and HTML dashboard outputs with GitHub-renderable chart fallbacks.

## Key Results

- Raw order rows: 66
- Governed orders: 60
- Raw gross revenue: `$13,144.35`
- Governed gross revenue: `$11,344.44`
- Governed net revenue: `$10,549.48`
- Raw-to-governed gap: `$2,594.87`, or `19.7%`
- Promo-attributed net revenue: `$2,749.86`

## Recommendation

Use one governed order fact as the revenue backbone, then publish team-specific marts from that same model. Finance should own recognized net revenue, Ecommerce should use order-date demand and channel performance views, and Marketing should use attributed revenue only after cancellations and returns are handled consistently.
