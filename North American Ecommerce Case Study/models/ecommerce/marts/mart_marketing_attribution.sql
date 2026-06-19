select
  coalesce(marketing_source, 'unknown') as marketing_source,
  is_promo_attributed,
  count(*) as orders,
  sum(gross_revenue) as gross_revenue,
  sum(return_amount) as returns_deducted,
  sum(net_revenue) as net_revenue,
  round(100.0 * sum(net_revenue) / nullif(sum(sum(net_revenue)) over (), 0), 1) as pct_net_revenue
from {{ ref('fct_orders') }}
group by coalesce(marketing_source, 'unknown'), is_promo_attributed
order by net_revenue desc
