select
    *
from 
    {{ ref('fct_order')}}
where 
    item_discount_amount < 0