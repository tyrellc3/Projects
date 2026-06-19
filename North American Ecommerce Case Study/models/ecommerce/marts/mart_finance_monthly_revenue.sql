select
  date_trunc('month', payment_date) as revenue_month,
  count(*) as orders,
  sum(gross_revenue) as gross_revenue,
  sum(return_amount) as returns_deducted,
  sum(net_revenue) as recognized_net_revenue,
  sum(case when is_cancelled then 1 else 0 end) as cancelled_orders,
  sum(case when is_returned then 1 else 0 end) as returned_orders
from {{ ref('fct_orders') }}
group by date_trunc('month', payment_date)
order by revenue_month
