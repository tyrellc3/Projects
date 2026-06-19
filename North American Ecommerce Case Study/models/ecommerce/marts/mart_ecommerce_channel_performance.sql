select
  c.channel_name,
  c.channel_group,
  p.product_category,
  count(*) as orders,
  sum(o.gross_revenue) as gross_revenue,
  sum(o.return_amount) as returns_deducted,
  sum(o.net_revenue) as net_revenue,
  round(sum(o.gross_revenue) / nullif(count(*), 0), 2) as average_order_value,
  round(100.0 * sum(case when o.is_returned then 1 else 0 end) / nullif(count(*), 0), 1) as return_rate_pct
from {{ ref('fct_orders') }} o
left join {{ ref('dim_channels') }} c
  on c.channel_key = o.channel_key
left join {{ ref('dim_products') }} p
  on p.product_key = o.product_key
group by
  c.channel_name,
  c.channel_group,
  p.product_category
order by net_revenue desc
