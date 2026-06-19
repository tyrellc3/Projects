select
  channel_id as channel_key,
  channel_id,
  channel_name,
  channel_group,
  is_known_channel
from {{ ref('stg_channels') }}
