select *
from {{ ref('fct_orders') }}
where is_cancelled
  and (gross_revenue <> 0 or net_revenue <> 0)
