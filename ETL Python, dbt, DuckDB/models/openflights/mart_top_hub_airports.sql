{{
  config(
    materialized='table'
  )
}}

select
  airport_id,
  name,
  city,
  country,
  departures,
  arrivals,
  total_routes
from {{ ref('mart_airport_connectivity') }}
order by total_routes desc
limit 20
