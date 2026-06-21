# North American Ecommerce Revenue Case Study

## Business Problem

Three teams need revenue reporting, but each team needs a different lens:

- Finance needs recognized net revenue by payment timing.
- Ecommerce needs order demand, channel mix, product mix, and return rates.
- Marketing needs campaign-attributed revenue without overstating cancelled or returned orders.

The risk is that every team can be directionally right and still create confusion if definitions, source rules, and timing conventions are not documented and modeled.

## Raw Data Issues

The case study centers on the kinds of issues that create revenue disagreement:

- duplicate retry loads
- cancelled orders with revenue still attached
- return amounts with incorrect signs or missing deductions
- payment timing that crosses month or quarter boundaries
- incomplete pipeline records with unknown status or channel

## Analytics Engineering Approach

1. Loaded source-like ecommerce data into DuckDB under a `raw` schema.
2. Built dbt staging models to normalize data types and classify source issues.
3. Built dimensions and fact tables around a governed order grain.
4. Built marts for reconciliation, Finance, Marketing, Ecommerce, KPIs, and data quality.
5. Added dbt tests for uniqueness, relationships, cancellation handling, return deductions, and pipeline exclusions.

## Practical Questions Answered

### 1. How much does raw revenue differ from governed revenue?

Raw gross revenue is `$13,144.35`. Governed net revenue is `$10,549.48`, leaving a raw-to-governed gap of `$2,594.87`, or `19.7%`.

That gap is large enough that this cannot be solved with presentation formatting. It needs modeled rules and a reconciliation bridge.

### 2. What creates the revenue gap?

The dbt reconciliation mart breaks the gap into explainable drivers:

- duplicate retry loads removed: `-$729.97`
- incomplete pipeline records excluded: `-$259.98`
- cancelled order revenue zeroed: `-$809.96`
- returns deducted and corrected: `-$794.96`

This creates a traceable bridge from raw order revenue to governed net revenue.

### 3. What should Finance use?

Finance should use recognized net revenue from `mart_finance_monthly_revenue`, keyed by `payment_date`. That model reflects settlement timing, return deductions, and cancellation handling.

### 4. What should Marketing use?

Marketing should use `mart_marketing_attribution`, which separates promo-attributed sources from direct and organic revenue. Promo-attributed net revenue is `$2,749.86` across 18 governed orders.

### 5. What should Ecommerce use?

Ecommerce should use `mart_ecommerce_channel_performance` for channel mix, category mix, average order value, and return rate. This gives Ecommerce the operating view it needs without creating a separate revenue definition.

## Recommendation

I would implement a governed revenue mart as the single backbone for all three teams. The mart should expose multiple date fields and metric variants, but the revenue rules should live in one modeled layer.

The first production milestone should be Finance-aligned net revenue with a reconciliation bridge. Once that is trusted, the Marketing and Ecommerce views can be layered on top without reintroducing separate extracts.

## What I Would Build Next

- A dbt semantic layer for governed metrics
- Source freshness and reconciliation alerts
- A return cohort mart by order date and return date
- Order-line grain for product-level margin and discount analysis
- BI exposures for Finance, Marketing, and Ecommerce dashboards
- CI checks that fail when revenue variance exceeds tolerance

## Caveats

This is a redacted case study using a small mock dataset. The modeling pattern is the point: clear ownership, deterministic transformations, documented metric definitions, and testable revenue rules.
