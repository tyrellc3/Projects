select
  try_cast(date_day as date) as date_day,
  try_cast(date_key as integer) as date_key,
  try_cast(year as integer) as year,
  try_cast(month as integer) as month,
  month_name,
  quarter,
  try_cast(week_start_date as date) as week_start_date
from {{ source('ecommerce', 'date_spine') }}
