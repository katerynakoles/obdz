INSERT INTO customers (full_name, phone, email)
SELECT
    'Клієнт Тест ' || g,
    '099' || lpad(g::text, 7, '0'),
    NULL
FROM generate_series(1001, 11000) AS g
ON CONFLICT (phone) DO NOTHING;

INSERT INTO orders (customer_id, created_at, status)
SELECT
    c.customer_id,
    timestamp '2025-01-01 08:00:00' + (g - 1) * interval '2 minutes',
    'completed'
FROM generate_series(1, 100000) AS g
JOIN customers AS c ON c.phone = '099' || lpad((1001 + (g - 1) % 10000)::text, 7, '0')
ON CONFLICT (customer_id, created_at) DO NOTHING;

INSERT INTO order_items (order_id, sku, quantity, unit_price)
SELECT
    o.order_id,
    'YR-001',
    1 + (row_number() OVER (ORDER BY o.order_id)) % 5,
    140.00
FROM orders AS o
WHERE o.order_id > 4
ON CONFLICT (order_id, sku) DO NOTHING;
