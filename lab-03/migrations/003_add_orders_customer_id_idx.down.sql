-- Створення індексу за зовнішнім ключем customer_id у таблиці orders
CREATE INDEX orders_customer_id_idx ON orders (customer_id);
