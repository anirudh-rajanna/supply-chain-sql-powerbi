-- ============================================
-- 01_data_cleaning.sql
-- Goal: Create a clean working table from raw data
-- ============================================

CREATE TABLE IF NOT EXISTS supply_chain_clean AS
SELECT
    [Order Id]                          AS order_id,
    DATE([order date (DateOrders)])     AS order_date,
    DATE([Shipping Date (DateOrders)])  AS ship_date,
    [Days for shipping (real)]          AS actual_ship_days,
    [Days for shipment (scheduled)]     AS scheduled_ship_days,
    [Delivery Status]                   AS delivery_status,
    [Sales]                             AS revenue,
    [Order Profit Per Order]            AS profit,
    [Category Name]                     AS category,
    [Customer Segment]                  AS segment,
    [Order Region]                      AS region,
    [Shipping Mode]                     AS shipping_mode,
    [Order Item Quantity]               AS quantity
FROM supply_chain_raw
WHERE [Order Id] IS NOT NULL
  AND [Sales] > 0;

-- Verify row count
SELECT COUNT(*) AS clean_row_count FROM supply_chain_clean;