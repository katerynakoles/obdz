-- Частина 1. COMMIT: оновлення статусу замовлення та фіксація ціни позиції
BEGIN;
UPDATE orders SET status = 'shipped' WHERE order_id = 3;
UPDATE order_items SET unit_price = 135.00 WHERE order_id = 3 AND sku = 'YR-001';
COMMIT;
SELECT o.order_id, o.status, oi.sku, oi.unit_price
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_id = 3;

-- Частина 2. ROLLBACK: зміна в транзакції з подальшим скасуванням
BEGIN;
UPDATE yarns SET stock_quantity = stock_quantity - 5 WHERE sku = 'YR-005';
SELECT sku, stock_quantity FROM yarns WHERE sku = 'YR-005';
ROLLBACK;
SELECT sku, stock_quantity FROM yarns WHERE sku = 'YR-005';

-- Частина 3. Помилка всередині транзакції: перша зміна не зберігається
BEGIN;
UPDATE orders SET status = 'completed' WHERE order_id = 3;
-- Наступний запит порушує CHECK на status (неприпустиме значення 'invalid_status')
UPDATE orders SET status = 'invalid_status' WHERE order_id = 3;
-- Наступний SELECT поверне: current transaction is aborted, commands ignored until end of transaction block
SELECT order_id, status FROM orders WHERE order_id = 3;
-- Команда COMMIT у перерваній транзакції завершується ROLLBACK
COMMIT;
SELECT order_id, status FROM orders WHERE order_id = 3;
