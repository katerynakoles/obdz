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

-- З'єднання 1 (INNER JOIN): які замовлення оформлені якими клієнтами?
-- Рядків: 4 (усі 4 замовлення мають обов'язкового клієнта customer_id NOT NULL із REFERENCES)
SELECT o.order_id, o.created_at, o.status, c.customer_id, c.full_name
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
ORDER BY o.order_id ASC;

-- З'єднання 2 (з'єднання таблиць замовлень, позицій та пряжі за ключами):
-- Рядків: 10 (по одному рядку на кожну позицію замовлення в order_items)
SELECT
    o.order_id,
    o.created_at,
    c.customer_id,
    c.full_name,
    c.phone,
    y.sku,
    y.yarn_name,
    b.brand_name,
    cat.category_name,
    oi.quantity,
    oi.unit_price
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
JOIN yarns AS y ON y.sku = oi.sku
JOIN brands AS b ON b.brand_id = y.brand_id
JOIN categories AS cat ON cat.category_id = y.category_id
ORDER BY o.order_id ASC, y.sku ASC;

-- З'єднання 3 (LEFT JOIN з IS NULL): які клієнти ще не оформили жодного замовлення?
-- Рядків: 1 (клієнтка Софія Ткаченко, customer_id = 4, не має рядків у orders)
SELECT c.customer_id, c.full_name, c.phone
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id ASC;
