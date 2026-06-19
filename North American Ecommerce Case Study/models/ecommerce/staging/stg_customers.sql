select
  customer_id,
  customer_segment,
  state,
  country,
  acquisition_source
from {{ source('ecommerce', 'customers') }}
