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
    coalesce(src.country, srcicao.country) as source_airport_country,
    coalesce(dst.country, dsticao.country) as destination_airport_country
  from {{ ref('stg_routes') }} r
  left join {{ ref('stg_airports') }} src
    on src.iata = r.source_airport
    or src.icao = r.source_airport
  left join {{ ref('stg_airports') }} srcicao
    on srcicao.iata = r.source_airport
    or srcicao.icao = r.source_airport
  left join {{ ref('stg_airports') }} dst
    on dst.iata = r.destination_airport
    or dst.icao = r.destination_airport
  left join {{ ref('stg_airports') }} dsticao
    on dsticao.iata = r.destination_airport
    or dsticao.icao = r.destination_airport
  where r.source_airport is not null
    and r.destination_airport is not null
) route_countries
where source_airport_country is not null
  and destination_airport_country is not null
group by source_airport_country, destination_airport_country
order by route_count desc
limit 50
