-- Індекс за зовнішнім ключем orders.customer_id для пришвидшення пошуку замовлень клієнта

CREATE INDEX orders_customer_id_idx ON orders (customer_id);
