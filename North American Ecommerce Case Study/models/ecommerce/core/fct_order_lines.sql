select
  l.line_id,
  o.order_id,
  o.order_sk,
  p.product_id as product_key,
  l.product_sku,
  l.quantity,
  l.unit_price,
  l.discount_amount,
  l.line_gross_revenue
from {{ ref('stg_order_lines') }} l
join {{ ref('fct_orders') }} o
  on o.order_id = l.order_id
left join {{ ref('stg_products') }} p
  on p.product_sku = l.product_sku
