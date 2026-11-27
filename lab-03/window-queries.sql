-- Запит 1. Місце артикулу пряжі за кількістю замовлень, у яких він зустрічається.
-- Рядків: 4 (YR-002 та YR-004 по 3 замовлення — 1 місце; YR-001 та YR-003 по 2 замовлення — 3 місце)
SELECT
    y.sku,
    y.yarn_name,
    count(oi.order_id) AS orders_count,
    rank() OVER (ORDER BY count(oi.order_id) DESC) AS rank_place,
    dense_rank() OVER (ORDER BY count(oi.order_id) DESC) AS dense_rank_place,
    row_number() OVER (ORDER BY count(oi.order_id) DESC, y.sku ASC) AS row_num_place
FROM yarns AS y
JOIN order_items AS oi ON oi.sku = y.sku
GROUP BY y.sku, y.yarn_name
ORDER BY rank_place, y.sku;

-- Запит 2. Накопичувальний підсумок виручки за днями оформлення замовлень.
-- Рядків: 4 (1265.00, 2540.00, 3830.00, 4600.00)
SELECT
    d.order_day,
    d.day_revenue,
    sum(d.day_revenue) OVER (ORDER BY d.order_day) AS running_total
FROM (
    SELECT
        CAST(o.created_at AS date) AS order_day,
        sum(oi.quantity * oi.unit_price) AS day_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    GROUP BY CAST(o.created_at AS date)
) AS d
ORDER BY d.order_day;

-- Запит 3. Ковзне середнє виручки за три останні дні з продажами.
-- Рядків: 4 (1265.00, 1270.00, 1276.67, 1111.67)
SELECT
    d.order_day,
    d.day_revenue,
    round(
        avg(d.day_revenue) OVER (
            ORDER BY d.order_day
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_revenue
FROM (
    SELECT
        CAST(o.created_at AS date) AS order_day,
        sum(oi.quantity * oi.unit_price) AS day_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    GROUP BY CAST(o.created_at AS date)
) AS d
ORDER BY d.order_day;
