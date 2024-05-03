
WITH grid AS (
    SELECT
        t.id,
        t.booked_time,
        DATE_TRUNC('month',booked_time)::DATE AS month,
        t.client_name,
        t.currency,
        er.sell_currency,
        er.buy_currency,
        t.revenue,
        er.rate,
        -- Case to convert currencies into euros
        CASE 
            WHEN t.currency = 'EUR' THEN t.revenue
            ELSE t.revenue * er.rate 
        END AS revenue_eur
    FROM 
        transactions t 
    LEFT JOIN 
        exchange_rate_modified er ON DATE(t.booked_time) = er.date AND t.currency = er.sell_currency AND er.buy_currency = 'EUR'
)

-- Aggregate revenue in euros by customer and month
SELECT 
    gr.client_name AS customer,
    gr.month AS month,
    SUM(gr.revenue_eur) AS revenue_eur
FROM 
    grid gr
GROUP BY 
    1,2
ORDER BY 
    2;
