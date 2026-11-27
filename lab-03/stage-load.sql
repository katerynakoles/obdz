-- Додавання нового артикулу з джерела у вимір dim_yarns перед завантаженням факту
INSERT INTO dim_yarns (sku, yarn_name, brand_name, category_name)
VALUES ('YR-006', 'Angora Gold', 'Alize', 'Вовна')
ON CONFLICT (sku) DO NOTHING;

-- Частина 1. Відбракування до перетворення типів
INSERT INTO stage_rejects (source_row, reject_reason)
SELECT
    s.source_row,
    CASE
        WHEN trim(s.unit_price_raw) = '' OR s.unit_price_raw IS NULL THEN 'ціна не заповнена'
        ELSE 'такої дати не існує у вимірі дат'
    END
FROM stage_order_items AS s
LEFT JOIN dim_dates AS d ON to_char(d.date_key, 'DD.MM.YYYY') = trim(s.order_date_raw)
WHERE trim(s.unit_price_raw) = ''
   OR s.unit_price_raw IS NULL
   OR d.date_key IS NULL
ON CONFLICT (source_row) DO NOTHING;

-- Частина 2. Перетворення типів у підзапиті, DISTINCT, перевірка суперечностей і завантаження у факт
INSERT INTO fact_order_items (order_id, sku, yarn_key, date_key, quantity, line_revenue)
SELECT DISTINCT
    t.order_id,
    t.sku,
    dy.yarn_key,
    t.order_date,
    t.quantity,
    t.quantity * t.unit_price
FROM (
    SELECT
        CAST(trim(st.order_id_raw) AS integer) AS order_id,
        upper(trim(st.sku_raw)) AS sku,
        to_date(trim(st.order_date_raw), 'DD.MM.YYYY') AS order_date,
        CAST(trim(st.quantity_raw) AS integer) AS quantity,
        CAST(trim(replace(st.unit_price_raw, 'грн', '')) AS numeric(10, 2)) AS unit_price
    FROM stage_order_items AS st
    LEFT JOIN stage_rejects AS rj ON rj.source_row = st.source_row
    WHERE rj.source_row IS NULL
) AS t
JOIN dim_yarns AS dy ON dy.sku = t.sku
WHERE t.quantity > 0 AND t.unit_price > 0
ON CONFLICT (order_id, sku) DO UPDATE
SET
    yarn_key = EXCLUDED.yarn_key,
    date_key = EXCLUDED.date_key,
    quantity = EXCLUDED.quantity,
    line_revenue = EXCLUDED.line_revenue;
