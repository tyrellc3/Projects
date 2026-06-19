# Implementation Plan

## Phase 1: Discovery and Baseline

- Confirm metric owners for demand, gross revenue, net revenue, recognized revenue, and attributed revenue.
- Document which team metrics should intentionally differ and which should match.
- Baseline raw revenue, governed revenue, duplicate volume, return corrections, cancellations, and pipeline exclusions.
- Agree on a variance tolerance and escalation process.

## Phase 2: Governed Order Model

- Build staging models for raw orders, customers, products, channels, campaigns, payments, and returns.
- Build `fct_orders` at one row per governed order.
- Add deterministic duplicate handling using `inserted_at`.
- Normalize cancellation and return logic.
- Add data tests for uniqueness, null handling, cancelled revenue, and return sign consistency.

## Phase 3: Reconciliation and Audience Views

- Build a revenue reconciliation bridge from raw gross revenue to governed net revenue.
- Publish Finance, Marketing, and Ecommerce views from the same governed fact.
- Expose multiple date fields so each team can use the correct calendar without redefining the metric.
- Add documentation for metric definitions, owners, and allowed variants.

## Phase 4: Reliability and Observability

- Add job freshness checks for day-end reporting.
- Add alerts for failed loads, stale data, duplicate spikes, return anomalies, and revenue variance outside tolerance.
- Create a runbook for replaying late returns, payment settlements, and corrected order events.
- Track recurring upstream issues and feed them back to source-system owners.

## Phase 5: Expansion Opportunities

- Add order-line grain for product and margin analysis.
- Add promotional discount handling and gift-card/tax/fee exclusions.
- Add cohort-based return analysis.
- Add semantic-layer metrics for BI tools.
- Add dbt exposures for Finance, Marketing, and Ecommerce dashboards.
- Add a lightweight dashboard generated from the governed CSVs or a local DuckDB model.
