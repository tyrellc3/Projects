select
  line_id,
  order_id,
  product_sku,
  try_cast(quantity as integer) as quantity,
  try_cast(unit_price as decimal(12, 2)) as unit_price,
  try_cast(discount_amount as decimal(12, 2)) as discount_amount,
  try_cast(line_gross_revenue as decimal(12, 2)) as line_gross_revenue
from {{ source('ecommerce', 'order_lines') }}
