{{
  config(
    materialized='table'
  )
}}

select
  country,
  count(*) as airport_count
from {{ ref('stg_airports') }}
where country is not null
group by country
order by airport_count desc
limit 20
