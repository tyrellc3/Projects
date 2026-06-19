{{
  config(
    materialized='table'
  )
}}

select
  source_airport_country as source_country,
  destination_airport_country as destination_country,
  count(*) as route_count
from (
  select
    coalesce(src_iata.country, src_icao.country) as source_airport_country,
    coalesce(dst_iata.country, dst_icao.country) as destination_airport_country
  from {{ ref('stg_routes') }} r
  left join {{ ref('stg_airports') }} src_iata
    on src_iata.iata = r.source_airport
  left join {{ ref('stg_airports') }} src_icao
    on src_icao.icao = r.source_airport
  left join {{ ref('stg_airports') }} dst_iata
    on dst_iata.iata = r.destination_airport
  left join {{ ref('stg_airports') }} dst_icao
    on dst_icao.icao = r.destination_airport
  where r.source_airport is not null
    and r.destination_airport is not null
) route_countries
where source_airport_country is not null
  and destination_airport_country is not null
group by source_airport_country, destination_airport_country
order by route_count desc
limit 50
