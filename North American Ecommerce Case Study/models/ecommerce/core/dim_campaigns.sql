select
  campaign_id as campaign_key,
  campaign_id,
  marketing_source,
  campaign_name,
  campaign_type,
  is_promo_attributed
from {{ ref('stg_campaigns') }}
