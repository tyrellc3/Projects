{{
  config(
    materialized='table'
  )
}}

with departures as (
  select
    source_airport as airport_code,
    count(*) as departures
  from {{ ref('stg_routes') }}
  where source_airport is not null
  group by source_airport
),
arrivals as (
  select
    destination_airport as airport_code,
    count(*) as arrivals
  from {{ ref('stg_routes') }}
  where destination_airport is not null
  group by destination_airport
)

select
  a.airport_id,
  a.name,
  a.city,
  a.country,
  coalesce(d.departures, 0) as departures,
  coalesce(ar.arrivals, 0) as arrivals,
  coalesce(d.departures, 0) + coalesce(ar.arrivals, 0) as total_routes
from {{ ref('stg_airports') }} a
left join departures d on d.airport_code in (a.iata, a.icao)
left join arrivals ar on ar.airport_code in (a.iata, a.icao)
