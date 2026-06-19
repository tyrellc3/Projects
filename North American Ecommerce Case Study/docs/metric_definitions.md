# Metric Definitions

## Demand Revenue

Revenue at the time of order intent. This is useful for Ecommerce because it reflects customer demand before cancellations and returns are fully resolved.

Recommended date: `order_date`

## Gross Revenue

Revenue after cancellations are removed, but before returns are deducted. This is useful for understanding completed sales before post-purchase adjustments.

Recommended date: `order_date` or `payment_date`, depending on the reporting audience.

## Net Revenue

Gross revenue minus returns and refunds. This is the primary governed revenue metric for cross-team reporting.

Recommended date: `payment_date` for Finance-aligned reporting.

## Recognized Revenue

Net revenue reported according to Finance timing policy. In this case study, settlement/payment timing is the recognition anchor.

Recommended owner: Finance

## Promo-Attributed Revenue

Revenue tied to eligible paid or owned marketing sources. In the sample data, promo sources include `email`, `paid_search`, and `affiliate`.

Recommended owner: Marketing

## Return Rate

Returned orders divided by governed orders, optionally segmented by product category, channel, or campaign.

Recommended date: `return_date` for return-event analysis and `order_date` for cohort analysis.

## Variance

The difference between team-reported revenue numbers for the same period. The working tolerance for governed metrics is below 3%, with known exceptions for intentionally different metrics like demand revenue.
