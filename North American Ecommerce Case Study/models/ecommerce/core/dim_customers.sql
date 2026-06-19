select
  customer_id as customer_key,
  customer_id,
  customer_segment,
  state,
  country,
  acquisition_source
from {{ ref('stg_customers') }}
