-- Проміжні таблиці для сирих рядків джерела та відбракованих рядків

CREATE TABLE stage_order_items (
    source_row integer PRIMARY KEY,
    order_id_raw text,
    sku_raw text,
    order_date_raw text,
    quantity_raw text,
    unit_price_raw text
);

CREATE TABLE stage_rejects (
    source_row integer PRIMARY KEY,
    reject_reason text NOT NULL
);
