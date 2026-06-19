select
  campaign_id,
  marketing_source,
  campaign_name,
  campaign_type,
  lower(is_promo_attributed) = 'true' as is_promo_attributed
from {{ source('ecommerce', 'campaigns') }}
