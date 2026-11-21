-- Скасування міграції 002_add_reload_unique_constraints.up.sql

ALTER TABLE orders
    DROP CONSTRAINT orders_customer_created_key;

ALTER TABLE suppliers
    DROP CONSTRAINT suppliers_phone_key;

ALTER TABLE brands
    DROP CONSTRAINT brands_brand_name_key;

ALTER TABLE categories
    DROP CONSTRAINT categories_category_name_key;
