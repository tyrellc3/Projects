# Discovery Questions

These questions are designed to clarify whether the revenue mismatch is a metric-definition issue, a data quality issue, a pipeline reliability issue, or some combination of all three.

## Business Alignment

1. Which revenue metrics are expected to differ by design, and which are expected to reconcile?
2. Who owns the authoritative revenue definition?
3. When Finance, Marketing, and Ecommerce report different numbers, who resolves the variance?
4. What variance threshold requires explanation or escalation?

## Data Sources

1. Which systems own orders, payments, returns, campaign attribution, and finance settlement?
2. What is included or excluded from each team's revenue number?
3. Are taxes, fees, gift cards, discounts, cancellations, and refunds modeled as separate line items?
4. How are returns applied: order date, return date, refund date, or accounting close?
5. Is there already a warehouse and transformation layer to extend, or does the model need to start from scratch?

## Root Cause Priority

1. Which issue creates the most day-to-day friction: timing, duplicates, returns, attribution, or pipeline instability?
2. What happens when a pipeline fails or delivers stale data?
3. Is there a runbook for replaying or correcting failed loads?
4. Which reporting periods are most sensitive to late or incorrect revenue?
5. What business deadline should the first governed version be ready for?

## Why These Questions Matter

The key is to avoid treating every mismatch as a dashboard problem. Some differences are valid because teams need different definitions. Others are defects caused by duplicate loads, missing returns, cancelled orders, or unstable pipelines. The discovery process separates intentional metric variants from issues the data model needs to correct.
