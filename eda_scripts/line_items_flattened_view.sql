create view line_items_flattened as 

select 

li.id as id
,li.transaction_id as transaction_id
,li.details->>'name' as name
,cast(li.details->>'quantity' as integer) as quantity
,cast(li.details->>'total_price' as numeric(38,3)) as total_price
from line_items li 
;