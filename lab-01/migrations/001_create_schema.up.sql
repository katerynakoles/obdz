CREATE TABLE categories (
    category_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name text NOT NULL UNIQUE
);

CREATE TABLE brands (
    brand_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    brand_name text NOT NULL UNIQUE,
    country text NOT NULL
);

CREATE TABLE customers (
    customer_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name text NOT NULL,
    phone text NOT NULL UNIQUE,
    email text UNIQUE
);

CREATE TABLE yarns (
    sku text PRIMARY KEY,
    yarn_name text NOT NULL,
    composition text NOT NULL,
    color_code text NOT NULL,
    dye_lot text NOT NULL,
    weight_grams integer NOT NULL CHECK (weight_grams > 0),
    length_meters integer NOT NULL CHECK (length_meters > 0),
    price numeric(10, 2) NOT NULL CHECK (price > 0),
    stock_quantity integer NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    category_id integer NOT NULL REFERENCES categories (category_id) ON DELETE RESTRICT,
    brand_id integer NOT NULL REFERENCES brands (brand_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status text NOT NULL CHECK (status IN ('new', 'paid', 'shipped', 'completed', 'cancelled')),
    customer_id integer NOT NULL REFERENCES customers (customer_id) ON DELETE RESTRICT
);

CREATE TABLE order_items (
    order_id integer NOT NULL REFERENCES orders (order_id) ON DELETE CASCADE,
    sku text NOT NULL REFERENCES yarns (sku) ON DELETE RESTRICT,
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric(10, 2) NOT NULL CHECK (unit_price > 0),
    PRIMARY KEY (order_id, sku)
);
