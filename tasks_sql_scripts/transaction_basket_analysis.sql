
WITH grid AS (
    -- Build grid for price and quantity analysis per item and month in euros 
    SELECT
        DATE_TRUNC('month', t.booked_time) AS month,
        t.client_name AS client_name,
        CASE 
            WHEN t.currency = 'EUR' THEN lif.total_price
            ELSE lif.total_price * erm.rate 
        END AS total_price_eur,
        t.currency,
        lif.quantity AS quantity,
        lif.id AS id,
        lif.name AS item
    FROM
        line_items_flattened lif
    LEFT JOIN
        transactions t ON lif.transaction_id = t.id
    LEFT JOIN
        exchange_rate_modified erm ON DATE(t.booked_time) = erm.date
                                    AND t.currency = erm.sell_currency
                                    AND erm.buy_currency = 'EUR'
)

-- Customers monthly transactions analysis: how many transactions with how much value in euros 
SELECT 
    client_name,
    item,
    month,
    COUNT(DISTINCT id) AS items_count,
    SUM(quantity) AS sum_quantity,
    AVG(quantity) AS avg_quantity,
    SUM(total_price_eur) AS sum_price,
    AVG(total_price_eur) AS avg_price
FROM 
    grid
GROUP BY 
    1,2,3;
