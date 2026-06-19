with ranked_orders as (
  select
    *,
    row_number() over (
      partition by order_id
      order by inserted_at desc
    ) as order_version_rank
  from {{ ref('stg_orders') }}
),
deduped_orders as (
  select *
  from ranked_orders
  where order_version_rank = 1
),
enriched as (
  select
    o.*,
    p.product_id as product_key,
    c.channel_id as channel_key,
    cust.customer_id as customer_key,
    camp.campaign_id as campaign_key,
    r.return_id,
    r.return_reason,
    r.return_status,
    coalesce(r.return_date, o.return_date) as governed_return_date,
    coalesce(r.return_amount, o.return_amount, 0) as raw_joined_return_amount,
    case
      when o.order_status = 'UNKNOWN'
        or coalesce(o.channel, 'UNKNOWN') = 'UNKNOWN'
        or o.channel is null
        or o.product_sku is null
      then true
      else false
    end as is_pipeline_excluded,
    case
      when o.marketing_source in ('email', 'paid_search', 'affiliate') then true
      else false
    end as is_promo_attributed
  from deduped_orders o
  left join {{ ref('stg_products') }} p
    on p.product_sku = o.product_sku
  left join {{ ref('stg_channels') }} c
    on c.channel_name = o.channel
  left join {{ ref('stg_customers') }} cust
    on cust.customer_id = o.customer_id
  left join {{ ref('stg_campaigns') }} camp
    on camp.marketing_source = o.marketing_source
    and camp.campaign_id like 'CAM-' || strftime(o.order_date, '%Y%m') || '-%'
  left join {{ ref('stg_returns') }} r
    on r.order_id = o.order_id
)

select
  row_number() over (order by order_date, order_id) as order_sk,
  order_id,
  cast(strftime(order_date, '%Y%m%d') as integer) as order_date_key,
  order_date,
  cast(strftime(payment_date, '%Y%m%d') as integer) as payment_date_key,
  payment_date,
  case
    when governed_return_date is not null then cast(strftime(governed_return_date, '%Y%m%d') as integer)
  end as return_date_key,
  governed_return_date as return_date,
  customer_key,
  product_key,
  channel_key,
  campaign_key,
  case
    when order_status = 'CANCELLED' then 0::decimal(12, 2)
    else coalesce(gross_revenue, 0)
  end as gross_revenue,
  case
    when order_status = 'CANCELLED' then 0::decimal(12, 2)
    when return_flag or coalesce(raw_joined_return_amount, 0) <> 0 then
      case
        when coalesce(raw_joined_return_amount, 0) = 0 then -1 * coalesce(gross_revenue, 0)
        when raw_joined_return_amount > 0 then -1 * raw_joined_return_amount
        else raw_joined_return_amount
      end
    else 0::decimal(12, 2)
  end as return_amount,
  gross_revenue
    + case
        when order_status = 'CANCELLED' then -1 * coalesce(gross_revenue, 0)
        when return_flag or coalesce(raw_joined_return_amount, 0) <> 0 then
          case
            when coalesce(raw_joined_return_amount, 0) = 0 then -1 * coalesce(gross_revenue, 0)
            when raw_joined_return_amount > 0 then -1 * raw_joined_return_amount
            else raw_joined_return_amount
          end
        else 0::decimal(12, 2)
      end as net_revenue,
  return_flag or coalesce(raw_joined_return_amount, 0) <> 0 as is_returned,
  order_status = 'CANCELLED' as is_cancelled,
  is_promo_attributed,
  is_pipeline_excluded,
  order_status,
  marketing_source,
  data_issue_category,
  current_timestamp as loaded_at
from enriched
where not is_pipeline_excluded
