select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{ source('external__jaffle_shop', 'orders') }}