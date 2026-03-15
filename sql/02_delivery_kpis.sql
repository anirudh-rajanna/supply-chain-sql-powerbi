-- ============================================
-- 02_delivery_kpis.sql
-- Goal: Late delivery rates and on-time performance
-- ============================================

-- Late delivery rate by region
SELECT
    region,
    COUNT(*)                                                        AS total_orders,
    SUM(CASE WHEN delivery_status = 'Late delivery' THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN delivery_status = 'Late delivery' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                            AS late_delivery_rate_pct,
    ROUND(AVG(actual_ship_days - scheduled_ship_days), 2)          AS avg_delay_days
FROM supply_chain_clean
GROUP BY region
ORDER BY late_delivery_rate_pct DESC;

-- Final: Delivery outcome breakdown by shipping mode
SELECT
    shipping_mode,
    COUNT(*)                                                                        AS total_orders,
    SUM(CASE WHEN delivery_status = 'Advance shipping' THEN 1 ELSE 0 END)          AS early_orders,
    SUM(CASE WHEN delivery_status = 'Shipping on time' THEN 1 ELSE 0 END)          AS on_time_orders,
    SUM(CASE WHEN delivery_status = 'Late delivery' THEN 1 ELSE 0 END)             AS late_orders,
    SUM(CASE WHEN delivery_status = 'Shipping canceled' THEN 1 ELSE 0 END)         AS canceled_orders,
    ROUND(100.0 * SUM(CASE WHEN delivery_status = 'Late delivery' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                                            AS late_rate_pct
FROM supply_chain_clean
GROUP BY shipping_mode
ORDER BY late_rate_pct DESC;