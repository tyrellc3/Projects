{{
  config(
    materialized='table'
  )
}}

select
  airline,
  count(*) as route_count
from {{ ref('stg_routes') }}
where airline is not null
group by airline
order by route_count desc
limit 20
