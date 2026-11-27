-- Показник 1 (Картка). Виручка за місяцями
SELECT
    d.month_label,
    sum(f.line_revenue) AS revenue
FROM fact_order_items AS f
JOIN dim_dates AS d ON d.date_key = f.date_key
GROUP BY d.month_label
ORDER BY d.month_label;

-- Показник 2 (Стовпчикова діаграма). Виручка по артикулах пряжі, включно з позиціями без продажів
SELECT
    dy.sku,
    dy.yarn_name,
    dy.brand_name,
    coalesce(sum(f.line_revenue), 0.00) AS revenue
FROM dim_yarns AS dy
LEFT JOIN fact_order_items AS f ON f.yarn_key = dy.yarn_key
GROUP BY dy.yarn_key, dy.sku, dy.yarn_name, dy.brand_name
ORDER BY revenue DESC, dy.sku;

-- Показник 3 (Часовий ряд). Виручка по днях
SELECT
    d.date_key AS order_date,
    sum(f.line_revenue) AS daily_revenue
FROM fact_order_items AS f
JOIN dim_dates AS d ON d.date_key = f.date_key
GROUP BY d.date_key
ORDER BY d.date_key;
