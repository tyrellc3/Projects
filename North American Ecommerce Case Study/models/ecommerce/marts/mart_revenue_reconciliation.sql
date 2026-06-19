with raw_ranked as (
  select
    *,
    row_number() over (
      partition by order_id
      order by inserted_at desc
    ) as order_version_rank
  from {{ ref('stg_orders') }}
),
deduped as (
  select *
  from raw_ranked
  where order_version_rank = 1
),
components as (
  select
    1 as step_order,
    'Raw extracted orders' as reconciliation_step,
    count(*) as order_delta,
    sum(gross_revenue) as revenue_adjustment,
    'Raw source' as root_cause_layer
  from {{ ref('stg_orders') }}

  union all

  select
    2,
    'Less: duplicate retry loads removed',
    -1 * count(*),
    -1 * sum(gross_revenue),
    'Source and capture'
  from raw_ranked
  where order_version_rank > 1

  union all

  select
    3,
    'Less: incomplete pipeline records excluded',
    -1 * count(*),
    -1 * sum(gross_revenue),
    'Pipeline and consumption'
  from deduped
  where order_status = 'UNKNOWN'
    or coalesce(channel, 'UNKNOWN') = 'UNKNOWN'
    or channel is null
    or product_sku is null

  union all

  select
    4,
    'Less: cancelled order revenue zeroed',
    0,
    -1 * sum(gross_revenue),
    'Semantic policy'
  from deduped
  where order_status = 'CANCELLED'

  union all

  select
    5,
    'Less: returns deducted and sign issues corrected',
    0,
    sum(return_amount),
    'Semantic policy'
  from {{ ref('fct_orders') }}
  where is_returned
),
bridge as (
  select
    *,
    sum(revenue_adjustment) over (
      order by step_order
      rows between unbounded preceding and current row
    ) as running_revenue
  from components
)

select
  step_order,
  reconciliation_step,
  order_delta,
  revenue_adjustment,
  running_revenue,
  root_cause_layer
from bridge

union all

select
  6 as step_order,
  'Governed net revenue' as reconciliation_step,
  null as order_delta,
  sum(net_revenue) as revenue_adjustment,
  sum(net_revenue) as running_revenue,
  'Governed fact' as root_cause_layer
from {{ ref('fct_orders') }}
order by step_order
