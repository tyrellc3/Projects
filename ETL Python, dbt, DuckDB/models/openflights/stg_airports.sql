{{
  config(
    materialized='table'
  )
}}

with src as (
  select * from {{ source('openflights','airports') }}
)

select
  cast(column00 as varchar) as airport_id,
  column01 as name,
  column02 as city,
  column03 as country,
  nullif(trim(column04),'\\N') as iata,
  nullif(trim(column05),'\\N') as icao,
  try_cast(column06 as double) as latitude,
  try_cast(column07 as double) as longitude,
  try_cast(column08 as double) as altitude,
  try_cast(column09 as double) as timezone,
  column10 as dst,
  column11 as tz_database_time_zone,
  column12 as type,
  column13 as source
from src
