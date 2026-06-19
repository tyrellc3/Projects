{{
  config(
    materialized='table'
  )
}}

with route_countries as (
  select
    coalesce(src_iata.country, src_icao.country) as source_country,
    coalesce(dst_iata.country, dst_icao.country) as destination_country
  from {{ ref('stg_routes') }} r
  left join {{ ref('stg_airports') }} src_iata
    on src_iata.iata = r.source_airport
  left join {{ ref('stg_airports') }} src_icao
    on src_icao.icao = r.source_airport
  left join {{ ref('stg_airports') }} dst_iata
    on dst_iata.iata = r.destination_airport
  left join {{ ref('stg_airports') }} dst_icao
    on dst_icao.icao = r.destination_airport
  where coalesce(src_iata.country, src_icao.country) is not null
    and coalesce(dst_iata.country, dst_icao.country) is not null
),
country_routes as (
  select
    source_country as country,
    count(*) as outbound_routes,
    sum(case when source_country = destination_country then 1 else 0 end) as domestic_routes,
    sum(case when source_country <> destination_country then 1 else 0 end) as international_routes
  from route_countries
  group by source_country
)

select
  country,
  outbound_routes,
  domestic_routes,
  international_routes,
  round(100.0 * domestic_routes / nullif(outbound_routes, 0), 1) as pct_domestic_routes,
  round(100.0 * international_routes / nullif(outbound_routes, 0), 1) as pct_international_routes
from country_routes
order by outbound_routes desc
limit 25
