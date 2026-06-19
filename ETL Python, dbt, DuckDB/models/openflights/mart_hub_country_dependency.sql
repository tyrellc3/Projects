{{
  config(
    materialized='table'
  )
}}

with country_connectivity as (
  select
    country,
    sum(total_routes) as country_total_routes
  from {{ ref('mart_airport_connectivity') }}
  where country is not null
  group by country
)

select
  a.country,
  a.name as airport_name,
  a.city,
  a.departures,
  a.arrivals,
  a.total_routes,
  c.country_total_routes,
  round(100.0 * a.total_routes / nullif(c.country_total_routes, 0), 1) as pct_country_connectivity
from {{ ref('mart_airport_connectivity') }} a
join country_connectivity c
  on c.country = a.country
where a.total_routes > 0
  and c.country_total_routes >= 500
order by pct_country_connectivity desc, total_routes desc
limit 25
