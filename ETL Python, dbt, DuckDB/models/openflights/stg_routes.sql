{{
  config(
    materialized='table'
  )
}}

with src as (
  select * from {{ source('openflights','routes') }}
)

select
  column0 as airline,
  try_cast(column1 as int) as airline_id,
  column2 as source_airport,
  try_cast(column3 as int) as source_airport_id,
  column4 as destination_airport,
  try_cast(column5 as int) as destination_airport_id,
  nullif(trim(column6),'\\N') as codeshare,
  try_cast(column7 as int) as stops,
  nullif(trim(column8),'\\N') as equipment
from src
