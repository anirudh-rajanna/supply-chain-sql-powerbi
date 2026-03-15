-- ============================================
-- 04_shipping_performance.sql
-- Goal: Monthly delivery trend with rolling average
-- ============================================

WITH monthly AS (
    SELECT
        SUBSTR(SUBSTR([order date (DateOrders)], 1, 
               INSTR([order date (DateOrders)], ' ') - 1), -4)
        || '-' ||
        PRINTF('%02d', CAST(SUBSTR([order date (DateOrders)], 1,
               INSTR([order date (DateOrders)], '/') - 1) AS INT))             AS month,
        COUNT(*)                                                                AS total_orders,
        SUM(CASE WHEN [Delivery Status] = 'Late delivery' THEN 1 ELSE 0 END)   AS late_orders
    FROM supply_chain_raw
    GROUP BY month
)
SELECT
    month,
    total_orders,
    late_orders,
    ROUND(100.0 * late_orders / total_orders, 2)                               AS late_pct,
    ROUND(AVG(100.0 * late_orders / total_orders)
          OVER (ORDER BY month ROWS 2 PRECEDING), 2)                           AS rolling_3mo_avg
FROM monthly
ORDER BY month;