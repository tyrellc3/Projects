select
  return_id,
  order_id,
  try_cast(nullif(return_date, '') as date) as return_date,
  try_cast(return_amount as decimal(12, 2)) as return_amount,
  return_reason,
  return_status
from {{ source('ecommerce', 'returns') }}
