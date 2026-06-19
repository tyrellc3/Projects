{{
  config(
    materialized='table'
  )
}}

with src as (
  select * from {{ source('openflights','airlines') }}
)

select
  cast(column0 as varchar) as airline_id,
  column1 as name,
  column2 as alias,
  nullif(trim(column3),'\\N') as iata,
  nullif(trim(column4),'\\N') as icao,
  nullif(trim(column5),'\\N') as callsign,
  column6 as country,
  column7 as active
from src
