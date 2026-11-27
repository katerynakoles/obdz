-- Створення таблиць сховища даних

CREATE TABLE dim_yarns (
    yarn_key integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku text NOT NULL UNIQUE,
    yarn_name text NOT NULL,
    brand_name text NOT NULL,
    category_name text NOT NULL
);

CREATE TABLE dim_dates (
    date_key date PRIMARY KEY,
    year_number integer NOT NULL,
    month_label text NOT NULL,
    day_of_week integer NOT NULL,
    is_weekend boolean NOT NULL
);

CREATE TABLE fact_order_items (
    order_id integer NOT NULL,
    sku text NOT NULL,
    yarn_key integer NOT NULL REFERENCES dim_yarns (yarn_key) ON DELETE RESTRICT,
    date_key date NOT NULL REFERENCES dim_dates (date_key) ON DELETE RESTRICT,
    quantity integer NOT NULL,
    line_revenue numeric(10, 2) NOT NULL,
    PRIMARY KEY (order_id, sku)
);
