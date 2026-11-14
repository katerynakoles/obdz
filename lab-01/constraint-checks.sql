-- 1. Порушення NOT NULL (назва категорії не може бути порожньою)
INSERT INTO categories (category_name) VALUES (NULL);

-- 2. Порушення UNIQUE (дублювання унікального номера накладної поставки)
INSERT INTO suppliers (company_name, phone) VALUES ('ТОВ Пряжа Плюс', '+380441112233');
INSERT INTO shipments (shipment_date, invoice_number, supplier_id) VALUES ('2026-10-01', 'INV-001', 1);
INSERT INTO shipments (shipment_date, invoice_number, supplier_id) VALUES ('2026-10-02', 'INV-001', 1);

-- 3. Порушення CHECK (ціна пряжі не може бути від'ємною)
INSERT INTO yarns (sku, category_id, brand_id, shipment_id, yarn_name, composition, color_code, dye_lot, weight_grams, length_meters, price, stock_quantity)
VALUES ('ERR-01', 1, 1, 1, 'Test', 'Wool', '01', 'A1', 50, 100, -10.00, 5);

-- 4. Порушення REFERENCES / зовнішнього ключа (поставка з неіснуючим supplier_id)
INSERT INTO shipments (shipment_date, invoice_number, supplier_id) VALUES ('2026-10-05', 'INV-999', 9999);

-- 5. Порушення PRIMARY KEY (дублювання первинного ключа артикулу пряжі)
INSERT INTO yarns (sku, category_id, brand_id, shipment_id, yarn_name, composition, color_code, dye_lot, weight_grams, length_meters, price, stock_quantity)
VALUES ('DUP-SKU', 1, 1, 1, 'Yarn1', 'Acrylic', '02', 'B1', 100, 200, 50.00, 10);
INSERT INTO yarns (sku, category_id, brand_id, shipment_id, yarn_name, composition, color_code, dye_lot, weight_grams, length_meters, price, stock_quantity)
VALUES ('DUP-SKU', 1, 1, 1, 'Yarn2', 'Cotton', '03', 'B2', 100, 200, 60.00, 5);
