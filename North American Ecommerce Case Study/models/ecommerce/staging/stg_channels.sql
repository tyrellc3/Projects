select
  channel_id,
  channel_name,
  channel_group,
  lower(is_known_channel) = 'true' as is_known_channel
from {{ source('ecommerce', 'channels') }}
