INSERT INTO categories (category_name)
VALUES ('Тестова категорія')
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO brands (brand_name, country)
VALUES ('Тестовий бренд', 'Туреччина')
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO suppliers (company_name, phone)
VALUES ('Тестовий постачальник', '+380990000000')
ON CONFLICT (phone) DO NOTHING;

INSERT INTO shipments (shipment_date, invoice_number, supplier_id)
SELECT '2025-01-01', 'INV-BIG-001', supplier_id
FROM suppliers
WHERE phone = '+380990000000'
ON CONFLICT (invoice_number) DO NOTHING;

INSERT INTO customers (full_name, phone, email)
SELECT
    'Тестовий клієнт ' || n,
    '099' || lpad(n::text, 7, '0'),
    'loadtest' || n || '@example.com'
FROM generate_series(1, 10000) AS n
ON CONFLICT (phone) DO NOTHING;

INSERT INTO orders (customer_id, created_at, status)
SELECT
    c.customer_id,
    timestamp '2025-01-01 08:00:00' + (g.n * interval '5 minutes'),
    'completed'
FROM generate_series(1, 100000) AS g(n)
JOIN customers AS c ON c.phone = '099' || lpad(((g.n % 10000) + 1)::text, 7, '0')
ON CONFLICT (customer_id, created_at) DO NOTHING;
