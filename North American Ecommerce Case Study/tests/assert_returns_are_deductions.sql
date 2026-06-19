select *
from {{ ref('fct_orders') }}
where is_returned
  and return_amount > 0
