select
  coalesce(r.return_id, 'RET-' || o.order_id) as return_id,
  o.order_id,
  o.order_sk,
  o.return_date,
  o.return_date_key,
  o.return_amount,
  coalesce(r.return_reason, 'unknown') as return_reason,
  coalesce(r.return_status, 'modeled_from_order') as return_status
from {{ ref('fct_orders') }} o
left join {{ ref('stg_returns') }} r
  on r.order_id = o.order_id
where o.is_returned
