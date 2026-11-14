-- 1. Порушення NOT NULL (Правило 1: назва категорії не може бути порожньою)
INSERT INTO categories (category_name) VALUES (NULL);

-- 2. Порушення UNIQUE (Правило 1: назва категорії має бути унікальною)
INSERT INTO categories (category_name) VALUES ('Вовна'), ('Вовна');

-- 3. Порушення CHECK (Правило 2: ціна пряжі повинна бути більшою за 0)
INSERT INTO yarns (sku, yarn_name, composition, color_code, dye_lot, weight_grams, length_meters, price, stock_quantity, category_id, brand_id)
VALUES ('TEST-01', 'Merino', '100% вовна', '01', 'L100', 50, 125, -50.00, 10, 1, 1);

-- 4. Порушення REFERENCES / зовнішнього ключа (Посилальна цілісність: неіснуючий клієнт)
INSERT INTO orders (status, customer_id) VALUES ('new', 9999);

-- 5. Порушення PRIMARY KEY (Цілісність сутностей: дублювання артикулу пряжі)
INSERT INTO yarns (sku, yarn_name, composition, color_code, dye_lot, weight_grams, length_meters, price, stock_quantity, category_id, brand_id)
VALUES 
('DUP-01', 'Cotton Soft', '100% бавовна', '12', 'B20', 100, 200, 95.00, 5, 1, 1),
('DUP-01', 'Cotton Hard', '100% бавовна', '14', 'B21', 100, 200, 105.00, 5, 1, 1);
