-- Крок 1. Завантаження виміру пряжі
INSERT INTO dim_yarns (sku, yarn_name, brand_name, category_name)
SELECT
    y.sku,
    y.yarn_name,
    b.brand_name,
    c.category_name
FROM yarns AS y
JOIN brands AS b ON b.brand_id = y.brand_id
JOIN categories AS c ON c.category_id = y.category_id
ON CONFLICT (sku) DO UPDATE
SET
    yarn_name = EXCLUDED.yarn_name,
    brand_name = EXCLUDED.brand_name,
    category_name = EXCLUDED.category_name;

-- Крок 2. Завантаження виміру дат за період даних
INSERT INTO dim_dates (date_key, year_number, month_label, day_of_week, is_weekend)
SELECT
    CAST(d AS date),
    CAST(EXTRACT(year FROM d) AS integer),
    to_char(d, 'YYYY-MM'),
    CAST(EXTRACT(isodow FROM d) AS integer),
    EXTRACT(isodow FROM d) >= 6
FROM generate_series(timestamp '2026-09-01', timestamp '2026-10-31', interval '1 day') AS d
ON CONFLICT (date_key) DO NOTHING;

-- Крок 3. Завантаження таблиці фактів позицій замовлень
INSERT INTO fact_order_items (order_id, sku, yarn_key, date_key, quantity, line_revenue)
SELECT
    oi.order_id,
    oi.sku,
    dy.yarn_key,
    CAST(o.created_at AS date),
    oi.quantity,
    oi.quantity * oi.unit_price
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN dim_yarns AS dy ON dy.sku = oi.sku
ON CONFLICT (order_id, sku) DO UPDATE
SET
    yarn_key = EXCLUDED.yarn_key,
    date_key = EXCLUDED.date_key,
    quantity = EXCLUDED.quantity,
    line_revenue = EXCLUDED.line_revenue;
