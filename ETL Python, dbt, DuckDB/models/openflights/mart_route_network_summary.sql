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
),
matched_routes as (
  select *
  from route_countries
  where source_country is not null
    and destination_country is not null
)

select
  count(*) as matched_routes,
  sum(case when source_country = destination_country then 1 else 0 end) as domestic_routes,
  sum(case when source_country <> destination_country then 1 else 0 end) as international_routes,
  round(
    100.0 * sum(case when source_country = destination_country then 1 else 0 end) / count(*),
    1
  ) as pct_domestic_routes,
  round(
    100.0 * sum(case when source_country <> destination_country then 1 else 0 end) / count(*),
    1
  ) as pct_international_routes
from matched_routes
