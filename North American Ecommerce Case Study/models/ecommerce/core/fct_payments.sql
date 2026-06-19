select
  p.payment_id,
  o.order_id,
  o.order_sk,
  p.payment_date,
  cast(strftime(p.payment_date, '%Y%m%d') as integer) as payment_date_key,
  p.payment_status,
  case
    when o.is_cancelled then 0::decimal(12, 2)
    else p.payment_amount
  end as governed_payment_amount,
  p.payment_method
from {{ ref('stg_payments') }} p
join {{ ref('fct_orders') }} o
  on o.order_id = p.order_id
