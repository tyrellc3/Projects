select
  date_key,
  date_day,
  year,
  month,
  month_name,
  quarter,
  week_start_date
from {{ ref('stg_date_spine') }}
