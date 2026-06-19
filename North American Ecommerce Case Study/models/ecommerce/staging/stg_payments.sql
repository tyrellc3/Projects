select
  payment_id,
  order_id,
  try_cast(payment_date as date) as payment_date,
  payment_status,
  try_cast(payment_amount as decimal(12, 2)) as payment_amount,
  payment_method
from {{ source('ecommerce', 'payments') }}
