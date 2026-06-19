with raw_ranked as (
  select
    *,
    row_number() over (
      partition by order_id
      order by inserted_at desc
    ) as order_version_rank
  from {{ ref('stg_orders') }}
),
issue_rows as (
  select
    case
      when order_version_rank > 1 then 'duplicate_removed'
      when order_status = 'UNKNOWN'
        or coalesce(channel, 'UNKNOWN') = 'UNKNOWN'
        or channel is null
        or product_sku is null
      then 'pipeline_excluded'
      when order_status = 'CANCELLED' and gross_revenue <> 0 then 'cancelled_revenue_zeroed'
      when data_issue_category = 'duplicate' then 'duplicate_primary_retained'
      when data_issue_category = 'return' then 'return_standardized'
      when data_issue_category = 'timing' then 'date_timing_difference'
      else data_issue_category
    end as issue_type,
    order_id,
    gross_revenue
  from raw_ranked
  where data_issue_category <> 'none'
    or order_version_rank > 1
    or order_status = 'UNKNOWN'
    or coalesce(channel, 'UNKNOWN') = 'UNKNOWN'
    or channel is null
    or product_sku is null
)

select
  issue_type,
  count(*) as affected_rows,
  count(distinct order_id) as affected_orders,
  sum(gross_revenue) as raw_gross_revenue_at_risk
from issue_rows
group by issue_type
order by affected_rows desc, issue_type
