select *
from {{ ref('fct_orders') }}
where is_pipeline_excluded
