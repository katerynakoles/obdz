-- Додавання обмежень UNIQUE на потенційні ключі для ідемпотентного повторного завантаження даних
ALTER TABLE categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);

ALTER TABLE brands
    ADD CONSTRAINT brands_brand_name_key UNIQUE (brand_name);

ALTER TABLE suppliers
    ADD CONSTRAINT suppliers_phone_key UNIQUE (phone);

ALTER TABLE orders
    ADD CONSTRAINT orders_customer_created_key UNIQUE (customer_id, created_at);
