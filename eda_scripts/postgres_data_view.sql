create view postgres_data as (

SELECT 
    t.currency AS currency,
    t.booked_time::date as date,
    sum(cast(l.details->>'total_price' as numeric(38,3)))  AS amount
FROM 
    transactions t
JOIN 
    line_items l ON t.id = l.transaction_id
    group by 1,2
    order by 2,1
    );