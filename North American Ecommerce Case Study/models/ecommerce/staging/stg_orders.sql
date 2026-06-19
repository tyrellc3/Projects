with source as (
  select * from {{ source('ecommerce', 'orders') }}
)

select
  order_id,
  try_cast(inserted_at as timestamp) as inserted_at,
  try_cast(order_date as date) as order_date,
  try_cast(payment_date as date) as payment_date,
  customer_id,
  nullif(channel, '') as channel,
  nullif(product_category, '') as product_category,
  nullif(product_sku, '') as product_sku,
  try_cast(gross_revenue as decimal(12, 2)) as gross_revenue,
  lower(return_flag) = 'true' as return_flag,
  try_cast(return_amount as decimal(12, 2)) as return_amount,
  try_cast(nullif(return_date, '') as date) as return_date,
  nullif(order_status, '') as order_status,
  nullif(marketing_source, '') as marketing_source,
  nullif(data_issue, '') as data_issue,
  case
    when upper(coalesce(data_issue, '')) like 'DUPLICATE%' then 'duplicate'
    when upper(coalesce(data_issue, '')) like 'RETURN ISSUE%' then 'return'
    when upper(coalesce(data_issue, '')) like 'CANCEL ATTRIBUTION%' then 'cancellation'
    when upper(coalesce(data_issue, '')) like 'TIMING%' then 'timing'
    when upper(coalesce(data_issue, '')) like 'PIPELINE%' then 'pipeline'
    else 'none'
  end as data_issue_category
from source
