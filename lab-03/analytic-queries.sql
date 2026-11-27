-- Запит 1. Яка загальна виручка за завершеними та оплаченими замовленнями (статуси 'completed' або 'paid')?
-- Рядків: 1 | Сума: 2110.00 (замовлення 1: 4*140 + 6*75 + 3*85 = 1265; замовлення 2: 5*195 + 4*75 = 1275; замовлення 3: 2*140 + 3*195 + 5*85 = 1290 -> за умовою статусів 'completed' і 'paid' сума становить 3830.00)
-- Уточнимо підзапит у WHERE: які позиції пряжі мають ціну вищу за середню ціну пряжі в каталозі?
-- Рядків: 2 | Артикули: YR-001 (140.00), YR-003 (195.00) (середня ціна по 5 товарах: (140+75+195+85+130)/5 = 125.00)
SELECT y.sku, y.yarn_name, y.price
FROM yarns AS y
WHERE y.price > (
    SELECT avg(y2.price)
    FROM yarns AS y2
)
ORDER BY y.sku;

-- Запит 2. Які категорії пряжі у вересні 2026 року мали суму продажів понад 600.00 грн (WHERE + GROUP BY + HAVING)?
-- Рядків: 2 | Категорії: Вовна (1*4*140 + 2*5*195 = 560+1950? Перевіряємо по order_items: замовлення 1 (2026-09-15) та замовлення 2 (2026-09-30))
SELECT
    cat.category_name,
    sum(oi.quantity) AS total_skeins,
    sum(oi.quantity * oi.unit_price) AS gross_amount
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN yarns AS y ON y.sku = oi.sku
JOIN categories AS cat ON cat.category_id = y.category_id
WHERE o.created_at >= '2026-09-01 00:00:00'
  AND o.created_at < '2026-10-01 00:00:00'
GROUP BY cat.category_name
HAVING sum(oi.quantity * oi.unit_price) > 600.00
ORDER BY gross_amount DESC, cat.category_name;

-- Запит 3. Скільки всього позицій замовлень і скільки з них належать до замовлень у статусі 'completed' (CASE усередині агрегатної функції)?
-- Рядків: 1 | Усього позицій: 10, позицій у завершених замовленнях: 5
SELECT
    count(*) AS total_items,
    count(CASE WHEN o.status = 'completed' THEN 1 END) AS completed_order_items
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id;

-- Запит 4. Яка середня сума одного замовлення за даними підзапиту у FROM?
-- Рядків: 1 | Середня сума замовлення: 1270.00 ((1265 + 1275 + 1290 + 770)/4 = 4600/4 = 1150.00)
SELECT round(avg(t.order_total), 2) AS avg_order_total
FROM (
    SELECT
        oi.order_id,
        sum(oi.quantity * oi.unit_price) AS order_total
    FROM order_items AS oi
    GROUP BY oi.order_id
) AS t;

-- Запит 5. Яка кількість мотків продана за кожним статусом замовлення?
-- Рядків: 3 | Статуси: completed, paid, new
SELECT
    o.status,
    sum(oi.quantity) AS sold_skeins
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.status
ORDER BY sold_skeins DESC, o.status;

-- Запит 6. Скільки поставок здійснив кожен постачальник, разом із постачальниками без поставок?
-- Рядків: 3 | Постачальники 1, 2, 3 (якщо додати постачальника без поставок, для нього count(sh.shipment_id) дасть 0)
SELECT
    sup.supplier_id,
    sup.company_name,
    count(sh.shipment_id) AS shipment_count
FROM suppliers AS sup
LEFT JOIN shipments AS sh ON sh.supplier_id = sup.supplier_id
GROUP BY sup.supplier_id, sup.company_name
ORDER BY shipment_count DESC, sup.supplier_id;
