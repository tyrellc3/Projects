{{
  config(
    materialized='table'
  )
}}

select
  r.airline as airline_code,
  coalesce(a.name, r.airline) as airline_name,
  a.country as airline_country,
  count(*) as route_count,
  count(distinct r.source_airport) as source_airports_served,
  count(distinct r.destination_airport) as destination_airports_served,
  count(distinct r.source_airport || '>' || r.destination_airport) as unique_route_pairs
from {{ ref('stg_routes') }} r
left join {{ ref('stg_airlines') }} a
  on try_cast(a.airline_id as int) = r.airline_id
where r.airline is not null
group by
  r.airline,
  coalesce(a.name, r.airline),
  a.country
order by route_count desc
limit 25
