with raw_orders as (
  select * from {{ ref('stg_orders') }}
),
governed_orders as (
  select * from {{ ref('fct_orders') }}
)

select
  count(*) as governed_orders,
  (select count(*) from raw_orders) as raw_order_rows,
  sum(gross_revenue) as governed_gross_revenue,
  sum(return_amount) as returns_deducted,
  sum(net_revenue) as governed_net_revenue,
  sum(case when is_promo_attributed then net_revenue else 0 end) as promo_attributed_net_revenue,
  sum(case when is_promo_attributed then 1 else 0 end) as promo_attributed_orders,
  sum(case when is_cancelled then 1 else 0 end) as cancelled_orders,
  sum(case when is_returned then 1 else 0 end) as returned_orders,
  (select sum(gross_revenue) from raw_orders) as raw_gross_revenue,
  (select sum(gross_revenue) from raw_orders) - sum(net_revenue) as raw_to_governed_revenue_gap,
  round(
    100.0 * ((select sum(gross_revenue) from raw_orders) - sum(net_revenue))
      / nullif((select sum(gross_revenue) from raw_orders), 0),
    1
  ) as raw_to_governed_gap_pct
from governed_orders
