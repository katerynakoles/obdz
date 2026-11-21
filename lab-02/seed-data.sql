-- Наповнення бази даних магазину пряжі тестовими даними (ідемпотентний скрипт)

INSERT INTO categories (category_name)
VALUES
    ('Вовна'),
    ('Бавовна'),
    ('Акрил'),
    ('Шовк')
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO brands (brand_name, country)
VALUES
    ('Alize', 'Туреччина'),
    ('Drops', 'Норвегія'),
    ('YarnArt', 'Туреччина'),
    ('Nako', 'Туреччина')
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO suppliers (company_name, phone)
VALUES
    ('ТОВ "Пряжа Схід"', '+380501110001'),
    ('ПП "Клубок Торг"', '+380671110002'),
    ('ТОВ "ЄвроНитки"', '+380631110003')
ON CONFLICT (phone) DO NOTHING;

INSERT INTO shipments (shipment_date, invoice_number, supplier_id)
VALUES
    ('2026-09-10', 'INV-2026-001', 1),
    ('2026-09-20', 'INV-2026-002', 2),
    ('2026-10-05', 'INV-2026-003', 3)
ON CONFLICT (invoice_number) DO NOTHING;

INSERT INTO customers (full_name, phone, email)
VALUES
    ('Олена Коваленко', '0503001122', 'olena.kovalenko@example.com'),
    ('Ірина Мельник', '0674002233', NULL),
    ('Марія Шевченко', '0505003344', 'maria.sh@example.com'),
    ('Софія Ткаченко', '0936004455', NULL)
ON CONFLICT (phone) DO NOTHING;

INSERT INTO yarns (
    sku, category_id, brand_id, shipment_id, yarn_name, composition,
    color_code, dye_lot, weight_grams, length_meters, price, stock_quantity
)
VALUES
    ('YR-001', 1, 1, 1, 'Lanagold 800', '49% вовна, 51% акрил', '55', 'LOT-A1', 100, 800, 140.00, 35),
    ('YR-002', 2, 3, 1, 'Jeans', '55% бавовна, 45% поліакрил', '62', 'LOT-A2', 50, 160, 75.00, 50),
    ('YR-003', 1, 2, 2, 'Lima', '65% вовна, 35% альпака', '0100', 'LOT-B1', 50, 100, 195.00, 20),
    ('YR-004', 3, 3, 2, 'Baby Wool', '40% вовна, 20% бамбук, 40% акрил', '210', 'LOT-B2', 50, 175, 85.00, 40),
    ('YR-005', 2, 2, 2, 'Safran', '100% єгипетська бавовна', '18', 'LOT-B3', 50, 160, 130.00, 15)
ON CONFLICT (sku) DO NOTHING;

INSERT INTO orders (customer_id, created_at, status)
VALUES
    (1, '2026-09-15 11:20:00', 'completed'),
    (2, '2026-09-30 19:15:00', 'completed'),
    (1, '2026-10-03 14:05:00', 'paid'),
    (3, '2026-10-12 16:40:00', 'new')
ON CONFLICT (customer_id, created_at) DO NOTHING;

INSERT INTO order_items (order_id, sku, quantity, unit_price)
VALUES
    (1, 'YR-001', 4, 140.00),
    (1, 'YR-002', 6, 75.00),
    (1, 'YR-004', 3, 85.00),
    (2, 'YR-003', 5, 195.00),
    (2, 'YR-002', 4, 75.00),
    (3, 'YR-001', 2, 140.00),
    (3, 'YR-003', 3, 195.00),
    (3, 'YR-004', 5, 85.00),
    (4, 'YR-002', 8, 75.00),
    (4, 'YR-004', 2, 85.00)
ON CONFLICT (order_id, sku) DO NOTHING;
