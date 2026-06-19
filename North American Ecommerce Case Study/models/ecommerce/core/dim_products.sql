select
  product_id as product_key,
  product_id,
  product_sku,
  product_category,
  product_name,
  list_price,
  is_active
from {{ ref('stg_products') }}
