# Business Requirements

## Objective

Create a governed North American ecommerce revenue model that allows Finance, Marketing, and Ecommerce teams to report from the same modeled data while preserving the intentional differences between their metrics.

## Stakeholders

- Finance: owns the authoritative recognized revenue definition.
- Ecommerce: owns demand, order volume, channel mix, and return-rate analysis.
- Marketing: owns campaign-attributed revenue and promo performance analysis.
- Analytics Engineering: owns modeled facts, tests, documentation, and semantic consistency.
- Data Engineering: owns ingestion reliability, upstream remediation, and pipeline SLAs.

## Core Business Questions

1. Why do Finance, Marketing, and Ecommerce report different revenue numbers?
2. Which differences are intentional metric definitions versus data quality issues?
3. What is the governed net revenue number for a reporting period?
4. Which orders create reconciliation risk through duplicates, timing, returns, cancellations, or incomplete pipeline records?
5. How should each team self-serve its view without creating separate definitions?

## Functional Requirements

- Ingest order-level source-like data that represents ecommerce order-system behavior.
- Keep the most recent `inserted_at` record for duplicate `order_id` values.
- Preserve `order_date`, `payment_date`, and `return_date` for separate reporting calendars.
- Set cancelled order revenue to zero in governed revenue metrics.
- Preserve cancelled orders for funnel and attribution diagnostics.
- Standardize return amounts as negative revenue deductions.
- Flag incomplete or unknown records for review instead of silently counting them.
- Classify marketing sources as promo-attributed or non-promo.
- Build a reconciliation bridge from raw gross revenue to governed net revenue.
- Publish audience-specific views from the same governed fact layer.

## Data Quality Requirements

- `order_id` must be unique in the governed order fact.
- `gross_revenue` and `net_revenue` must not be null in governed facts.
- Cancelled orders must have zero governed revenue.
- Return flags and return amounts must agree.
- Unknown status/channel records must be quarantined or excluded from governed metrics.
- Finance, Marketing, and Ecommerce metrics must reconcile back to the same source fact.

## Success Criteria

- Governed reporting metrics stay within a target cross-team variance below 3%.
- Revenue variances are explainable through documented metric definitions.
- Manual reconciliation steps are replaced by repeatable data tests and a reconciliation bridge.
- Business users can access Finance, Marketing, and Ecommerce views without creating separate extracts.
- Day-end reporting is available before the next business day begins.

## Known Constraints

- The current dbt project runs locally in DuckDB and is designed for portfolio demonstration.
- The dashboard asset in `assets/` is included for project context; the dashboard is generated from dbt marts with `scripts/export_dashboard.py`.
