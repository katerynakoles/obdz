-- Зміна 1 (UPDATE з умовою порівняння): підвищення ціни на 10 грн для пряжі дешевше 100 грн
BEGIN;
SELECT sku, yarn_name, price FROM yarns WHERE price < 100.00 ORDER BY sku;
UPDATE yarns SET price = price + 10.00 WHERE price < 100.00;
SELECT sku, yarn_name, price FROM yarns WHERE price <= 110.00 ORDER BY sku;
COMMIT;

-- Зміна 2 (UPDATE з IN): переведення замовлень зі статусом 'new' у статус 'paid'
BEGIN;
SELECT order_id, status FROM orders WHERE status IN ('new') ORDER BY order_id;
UPDATE orders SET status = 'paid' WHERE status IN ('new');
SELECT order_id, status FROM orders WHERE order_id = 4;
COMMIT;

-- Видалення 3 (DELETE): видалення клієнтки без замовлень (customer_id = 4)
BEGIN;
SELECT customer_id, full_name FROM customers WHERE customer_id = 4;
DELETE FROM customers WHERE customer_id = 4;
SELECT customer_id, full_name FROM customers WHERE customer_id = 4;
COMMIT;

-- Перевірка реакції RESTRICT (завершується ROLLBACK після помилки):
-- Спроба видалити клієнтку №1, у якої є замовлення
BEGIN;
DELETE FROM customers WHERE customer_id = 1;
-- Очікується помилка порушення обмеження зовнішнього ключа (RESTRICT)
ROLLBACK;

-- Перевірка реакції CASCADE (завершується ROLLBACK, щоб відновити дані):
-- Видалення замовлення №4 автоматично видаляє його рядки з order_items
BEGIN;
SELECT order_id, sku, quantity FROM order_items WHERE order_id = 4;
DELETE FROM orders WHERE order_id = 4;
SELECT order_id, sku, quantity FROM order_items WHERE order_id = 4;
ROLLBACK;
