
WITH 
    -- Extract line item details including transaction ID, booked time, currency, and amount
    lines AS (
        SELECT
            t.id,
            t.booked_time,
            t.currency,
            CAST(l.details->>'total_price' AS NUMERIC(38,3)) AS amount
        FROM 
            line_items l 
        LEFT JOIN 
            transactions t ON l.transaction_id = t.id
    ),
    
    -- Aggregate transaction amounts by date and currency
    transac AS (
        SELECT 
            id,
            lin.booked_time AS tmsp,
            DATE(lin.booked_time) AS date,
            lin.currency,
            SUM(lin.amount) AS amount 
        FROM 
            lines lin
        GROUP BY 
            1,2,3,4
    ),
    
    -- Calculate cumulative transaction amounts by date and currency
    cumulative AS (
        SELECT 
            tr.id,
            date,
            tr.tmsp,
            tr.currency,
            SUM(tr.amount) AS amount,
            SUM(SUM(tr.amount)) OVER (PARTITION BY date, currency ORDER BY tr.tmsp) AS running_amount
        FROM 
            transac tr
        GROUP BY 
            1,2,3,4
        ORDER BY 
            2
    ),
    
    -- Identify mismatches between bank data and postgres data
    mismatches AS (
        SELECT 
            bp.date AS bp_date,
            bp.currency AS bp_currency,
            bp.amount AS bp_amount,
            pd.date AS pd_date,
            pd.currency AS pd_currency,
            pd.amount AS pd_amount,
            pd.amount - bp.amount AS discrepancy
        FROM 
            bank_partner_data bp
        LEFT JOIN 
            postgres_data pd ON bp.date = pd.date AND bp.currency = pd.currency
        WHERE 
            TRUE 
            AND (bp.amount != pd.amount OR bp.date IS NULL OR bp.currency IS NULL OR bp.amount IS NULL)
    )

-- Select the results by joining mismatches with cumulative data
SELECT
    mis.*,
    cumi.id,
    cumi.amount
FROM 
    mismatches mis
LEFT JOIN 
    cumulative cumi ON cumi.date = mis.bp_date AND cumi.currency = mis.bp_currency 
    -- The ABS threshold checks if the absolute difference between the cumulative transaction amount and the discrepancy is less than 0.08
    AND ABS(cumi.amount - mis.discrepancy) < 0.08;
