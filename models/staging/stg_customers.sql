select
    id as customer_id,
    first_name,
    last_name

from {{ source('external__jaffle_shop', 'customers') }}
