-- 1. Які товари мають ціну в діапазоні від 100 до 150 грн і залишок більше нуля? (Рядків: 3)
SELECT sku, yarn_name, price, stock_quantity
FROM yarns
WHERE price BETWEEN 100.00 AND 150.00 AND stock_quantity > 0
ORDER BY price DESC, sku ASC;

-- 2. Які замовлення мають статус 'completed' або 'paid'? (Рядків: 6)
SELECT order_id, status, created_at, customer_id
FROM orders
WHERE status = 'completed' OR status = 'paid'
ORDER BY created_at ASC;

-- 3. Які замовлення оформлені клієнтами з ID 1, 2 або 4 у березні 2026 року? (Рядків: 3)
SELECT order_id, customer_id, created_at, status
FROM orders
WHERE customer_id IN (1, 2, 4)
  AND created_at >= '2026-03-01' AND created_at < '2026-04-01'
ORDER BY created_at DESC, order_id DESC;

-- 4. Які клієнти мають у пошті домен gmail.com? (Рядків: 2)
SELECT customer_id, full_name, email
FROM customers
WHERE email LIKE '%gmail.com'
ORDER BY full_name;

-- 5. Які клієнти не вказали електронну пошту (IS NULL)? (Рядків: 2)
SELECT customer_id, full_name, email
FROM customers
WHERE email IS NULL
ORDER BY customer_id;

-- 6. Топ-2 найдорожчі позиції пряжі в каталозі (використання ORDER BY та LIMIT). (Рядків: 2)
SELECT sku, yarn_name, price
FROM yarns
ORDER BY price DESC, sku ASC
LIMIT 2;
