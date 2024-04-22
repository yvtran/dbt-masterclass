with
orders as (
  select * from {{ ref('stg_orders') }}
),

customers as (
  select * from {{ ref('stg_customers') }}
),

final as (
  select
    customer_id,
    order_id,
    first_name as customer_first_name,
    last_name as customer_last_name,
    status,
  from orders
  left join
    customers
  using (customer_id)
)

select * from final