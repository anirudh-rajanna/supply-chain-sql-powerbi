-- ============================================
-- 03_profitability_analysis.sql
-- Goal: Identify which categories and segments drive profit
-- ============================================

-- Profit margin by category using CTE + window function
WITH category_stats AS (
    SELECT
        category,
        SUM(revenue)      AS total_revenue,
        SUM(profit)       AS total_profit,
        COUNT(*)          AS order_count
    FROM supply_chain_clean
    GROUP BY category
)
SELECT
    category,
    ROUND(total_revenue, 2)                             AS total_revenue,
    ROUND(total_profit, 2)                              AS total_profit,
    order_count,
    ROUND(100.0 * total_profit / total_revenue, 2)      AS profit_margin_pct,
    RANK() OVER (ORDER BY total_profit DESC)            AS profit_rank
FROM category_stats
ORDER BY profit_rank;

-- Profit breakdown by customer segment
SELECT
    segment,
    COUNT(*)                                            AS total_orders,
    ROUND(SUM(revenue), 2)                              AS total_revenue,
    ROUND(SUM(profit), 2)                              AS total_profit,
    ROUND(100.0 * SUM(profit) / SUM(revenue), 2)       AS profit_margin_pct
FROM supply_chain_clean
GROUP BY segment
ORDER BY total_profit DESC;