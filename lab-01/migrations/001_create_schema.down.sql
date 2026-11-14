-- Скасування міграції 001_create_schema.up.sql: видалення всіх таблиць у зворотному порядку залежностей

DROP TABLE order_items;
DROP TABLE orders;
DROP TABLE yarns;
DROP TABLE customers;
DROP TABLE brands;
DROP TABLE categories;
