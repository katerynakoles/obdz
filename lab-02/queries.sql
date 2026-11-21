-- Запит 1. Які позиції пряжі коштують від 80 до 150 грн та мають на складі 20 і більше мотків?
-- Рядків: 2
SELECT sku, yarn_name, price, stock_quantity
FROM yarns
WHERE price BETWEEN 80.00 AND 150.00
  AND stock_quantity >= 20
ORDER BY price DESC, sku ASC;

-- Запит 2. Які замовлення мають статус 'new' або 'paid' і створені у вересні або жовтні 2026 року?
-- Рядків: 2
SELECT order_id, customer_id, created_at, status
FROM orders
WHERE status IN ('new', 'paid')
  AND created_at >= '2026-09-01 00:00:00'
  AND created_at < '2026-11-01 00:00:00'
ORDER BY created_at ASC, order_id ASC;

-- Запит 3. Які артикули пряжі мають у назві літери 'a' (з урахуванням регістру) і чи належать до категорії 1 або мають ціну понад 180 грн?
-- Рядків: 2
SELECT sku, yarn_name, category_id, price
FROM yarns
WHERE yarn_name LIKE '%a%'
  AND (category_id = 1 OR price > 180.00)
ORDER BY sku ASC;

-- Запит 4. Які клієнти мають вказану електронну пошту та номер телефону починається з '050'?
-- Рядків: 2
SELECT customer_id, full_name, phone, email
FROM customers
WHERE email IS NOT NULL
  AND phone LIKE '050%'
ORDER BY customer_id ASC;

-- Запит 5. Які 3 найдорожчі позиції пряжі в каталозі?
-- Рядків: 3
SELECT sku, yarn_name, price
FROM yarns
ORDER BY price DESC, sku ASC
LIMIT 3;

-- Запит 6. Які замовлення оформлено у вересні 2026 року (напівінтервал за часом)?
-- Рядків: 2
SELECT order_id, customer_id, created_at, status
FROM orders
WHERE created_at >= '2026-09-01 00:00:00'
  AND created_at < '2026-10-01 00:00:00'
ORDER BY created_at ASC, order_id ASC;

-- Пара запитів із NULL (стовпець customers.email без NOT NULL)
-- Варіант із втратою рядків NULL:
-- Рядків: 1 (повертає лише клієнтів, де email заповнений і не містить 'kovalenko')
SELECT customer_id, full_name, email
FROM customers
WHERE email NOT LIKE '%kovalenko%'
ORDER BY customer_id ASC;

-- Виправлений варіант з урахуванням NULL:
-- Рядків: 3 (додає клієнтів із email IS NULL)
SELECT customer_id, full_name, email
FROM customers
WHERE email NOT LIKE '%kovalenko%'
   OR email IS NULL
ORDER BY customer_id ASC;
