select
  product_id,
  product_sku,
  product_category,
  product_name,
  try_cast(list_price as decimal(12, 2)) as list_price,
  lower(is_active) = 'true' as is_active
from {{ source('ecommerce', 'products') }}
