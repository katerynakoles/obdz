-- Наповнення бази даних магазину пряжі початковими тестовими даними

INSERT INTO categories (category_name)
VALUES 
('Вовна'),
('Бавовна'),
('Змішана'),
('Акрил')
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO brands (brand_name, country)
VALUES 
('Alize', 'Туреччина'),
('Drops', 'Норвегія'),
('YarnArt', 'Туреччина'),
('Vita', 'Німеччина')
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO customers (full_name, phone, email)
VALUES 
('Коваленко Олена Ігорівна', '+380501112233', 'kovalenko@gmail.com'),
('Мельник Андрій Васильович', '+380679998877', 'melnyk@ukr.net'),
('Шевченко Марія Петрівна', '+380934445566', NULL),
('Бондаренком Іван Сергійович', '+380507778899', 'bondar@gmail.com'),
('Гриценко Катерина Олегівна', '+380632223344', NULL);

-- Товари (пряжа): 6 рядків, артикул є PRIMARY KEY
INSERT INTO yarns (sku, yarn_name, composition, color_code, dye_lot, weight_grams, length_meters, price, stock_quantity, category_id, brand_id)
VALUES 
('AL-LAN-01', 'Lanagold', '51% вовна, 49% акрил', '21', 'LOT-101', 100, 240, 120.00, 15, 3, 1),
('DR-MER-05', 'Merino Extra', '100% вовна', '08', 'LOT-202', 50, 105, 210.00, 8, 1, 2),
('YA-COT-12', 'Jeans', '55% бавовна, 45% поліакрил', '15', 'LOT-303', 50, 160, 95.00, 25, 3, 3),
('VI-BAB-02', 'Baby Wool', '40% вовна, 20% бавовна, 40% акрил', '02', 'LOT-404', 50, 175, 110.00, 0, 3, 4), -- товар із нульовим залишком (без покупців)
('AL-COT-99', 'Cotton Gold', '55% бавовна, 45% акрил', '60', 'LOT-505', 100, 330, 135.00, 12, 2, 1),
('YA-BE-08', 'Begonia', '100% мерсеризована бавовна', '4528', 'LOT-606', 50, 169, 75.00, 30, 2, 3);

-- Замовлення (події): 10 рядків
INSERT INTO orders (created_at, status, customer_id)
VALUES 
('2026-03-01 10:15:00', 'completed', 1),
('2026-03-15 14:20:00', 'completed', 1),
('2026-03-20 09:30:00', 'paid', 2),
('2026-03-25 18:45:00', 'shipped', 3),
('2026-04-01 11:00:00', 'new', 4),
('2026-04-05 16:10:00', 'completed', 2),
('2026-04-10 12:00:00', 'paid', 5),
('2026-04-12 15:30:00', 'new', 1),
('2026-04-14 10:00:00', 'cancelled', 3),
('2026-04-15 23:59:59', 'completed', 4); -- подія в останній день місяця пізніше 00:00

-- Позиції замовлень
INSERT INTO order_items (order_id, sku, quantity, unit_price)
VALUES 
(1, 'AL-LAN-01', 3, 120.00),
(1, 'YA-COT-12', 2, 95.00),
(2, 'DR-MER-05', 4, 210.00),
(3, 'AL-COT-99', 5, 135.00),
(4, 'YA-BE-08', 6, 75.00),
(5, 'AL-LAN-01', 2, 120.00),
(6, 'DR-MER-05', 1, 210.00),
(7, 'YA-COT-12', 4, 95.00),
(8, 'AL-COT-99', 3, 135.00),
(10, 'YA-BE-08', 2, 75.00)
ON CONFLICT (order_id, sku) DO NOTHING;
