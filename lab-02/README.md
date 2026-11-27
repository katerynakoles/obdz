# Лабораторна робота №2. Наповнення бази даних і запити мовою SQL

Виконавець: Колеснікова Катерина, СТСА-25-1

Предметна область: Магазин пряжі та товарів для в’язання

<!--
Шаблон звіту. Скопіювати як lab-02/README.md і заповнити всі розділи.
Вимоги до кожного розділу - у методичних вказівках до роботи №2.
Коментарі-підказки на кшталт цього перед здачею можна видалити.
-->

## 1. Ключі для повторного завантаження

<!-- Для кожної таблиці - обмеження, яке не пускає повторний рядок. Для таблиці із сурогатним ключем - UNIQUE на потенційному ключі. -->

| Таблиця | Обмеження для повторного завантаження | Стовпці `ON CONFLICT` |
|---|---|---|
| `categories` | `UNIQUE (categories_category_name_key)` — додається міграцією | `(category_name)` |
| `brands` | `UNIQUE (brands_brand_name_key)` — додається міграцією | `(brand_name)` |
| `suppliers` | `UNIQUE (suppliers_phone_key)` — додається міграцією | `(phone)` |
| `shipments` | `UNIQUE (shipments_invoice_number_key)` — вже є в схемі | `(invoice_number)` |
| `customers` | `UNIQUE (customers_phone_key)` — вже є в схемі | `(phone)` |
| `yarns` | `PRIMARY KEY (yarns_pkey)` | `(sku)` |
| `orders` | `UNIQUE (orders_customer_created_key)` — додається міграцією | `(customer_id, created_at)` |
| `order_items` | `PRIMARY KEY (order_items_pkey)` | `(order_id, sku)` |

Зміна схеми: не потрібна / міграція [migrations/002_....up.sql](migrations/002_....up.sql), [migrations/002_....down.sql](migrations/002_....down.sql).

Цикл up - down - up для міграції: результат скрипта перевірки схеми після кожного кроку.

## 2. Скрипт наповнення

Файл: [seed-data.sql](seed-data.sql)

Результат скрипта підрахунку рядків після першого запуску:

```text
вставити результат разом із заголовками стовпців
```

Рядки, додані для вимог до даних:

- у кожній таблиці >= 3 рядки, а в таблиці позицій замовлення (`order_items`) — 10 рядків
- у `customers.email` є і `NULL`, і заповнені адреси
- є рядки, на які ніхто не посилається (наприклад, бренд `Nako`, категорія `Шовк`, постачальник №3, поставка №3, клієнт №4, пряжа `YR-005` — зручно для `LEFT JOIN` та перевірки `RESTRICT`)
- `rders.created_at` охоплює два місяці (вересень і жовтень 2026) і має запис в останній день місяця після `00:00 (2026-09-30 19:15:00)`

## 3. Ідемпотентність

| Дія | Повідомлення СУБД | Кількість рядків у таблицях |
|---|---|---|
| перший запуск `seed-data.sql` | | як у розділі 2 |
| другий запуск `seed-data.sql` | | |
| команда INSERT для таблиці подій окремо | `INSERT 0 0` | |
| та сама команда без ON CONFLICT | `ERROR: duplicate key value violates unique constraint ...` | |

Обмеження, яке захистило кожну таблицю від дублікатів: ...

## 4. Запити з фільтрацією і сортуванням

Файл: [queries.sql](queries.sql)

<!-- Разом: порівняння з AND або OR, BETWEEN, IN, LIKE, IS NULL або IS NOT NULL, ORDER BY з LIMIT. -->

| № | Питання замовника | Використані конструкції | Рядків |
|---|---|---|---|
| 1 | Які позиції пряжі коштують від 80 до 150 грн та мають на складі 20 і більше мотків? | `SELECT sku, yarn_name, price, stock_quantity  FROM yarns    WHERE price BETWEEN 80.00 AND 150.00   AND stock_quantity >= 20  ORDER BY price DESC, sku ASC;` | 2 |
| 2 | Які замовлення мають статус 'new' або 'paid' і створені у вересні або жовтні 2026 року? | `SELECT order_id, customer_id, created_at, status  FROM orders    WHERE status IN ('new', 'paid')     AND created_at >= '2026-09-01 00:00:00'  AND created_at < '2026-11-01 00:00:00'    ORDER BY created_at ASC, order_id ASC;` | 2 |
| 3 | Які артикули пряжі мають у назві літери 'a' (з урахуванням регістру) і чи належать до категорії 1 або мають ціну понад 180 грн? | `SELECT sku, yarn_name, category_id, price   FROM yarns   WHERE yarn_name LIKE '%a%'   AND (category_id = 1 OR price > 180.00)    ORDER BY sku ASC;` | 2 |
| 4 | Які клієнти мають вказану електронну пошту та номер телефону починається з '050'? | `SELECT customer_id, full_name, phone, email   FROM customers    WHERE email IS NOT NULL     AND phone LIKE '050%'   ORDER BY customer_id ASC;` | 2 |
| 5 | Які 3 найдорожчі позиції пряжі в каталозі? | `SELECT sku, yarn_name, price   FROM yarns    ORDER BY price DESC, sku ASC    LIMIT 3;` | 3 |
| 6 | Які замовлення оформлено у вересні 2026 року (напівінтервал за часом)? | `SELECT order_id, customer_id, created_at, status   FROM orders    WHERE created_at >= '2026-09-01 00:00:00'  AND created_at < '2026-10-01 00:00:00'     ORDER BY created_at ASC, order_id ASC;` | 2 |

### Запити з NULL

```sql
запит, який губить рядки з NULL; рядків: 1
SELECT customer_id, full_name, email
FROM customers
WHERE email NOT LIKE '%kovalenko%'
   OR email IS NULL
ORDER BY customer_id ASC;
```

```sql
виправлений запит; рядків: 3
SELECT customer_id, full_name, email
FROM customers
WHERE email NOT LIKE '%kovalenko%'
   OR email IS NULL
ORDER BY customer_id ASC;
```

Пояснення трозначною логікою: У SQL предикат повертає `TRUE`, `FALSE` або `UNKNOWN`. Для рядків, де `email дорівнює NULL`, вираз `email NOT LIKE '%kovalenko%'` дає `UNKNOWN`, а `WHERE` відбирає лише рядки зі значенням `TRUE`. Тому рядки з `NULL` зникають без явної умови `OR email IS NULL`

## 5. Запити зі зʼєднанням таблиць

### Зʼєднання 1. які замовлення оформлені якими клієнтами?

```sql
SELECT o.order_id, o.created_at, o.status, c.customer_id, c.full_name
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
ORDER BY o.order_id ASC;
```

Рядків: 4 Чому саме стільки: усі 4 замовлення мають обов'язкового клієнта customer_id NOT NULL із REFERENCES

### Зʼєднання 2. з'єднання таблиць замовлень, позицій та пряжі за ключами

```sql
SELECT
    o.order_id,
    o.created_at,
    c.customer_id,
    c.full_name,
    c.phone,
    y.sku,
    y.yarn_name,
    b.brand_name,
    cat.category_name,
    oi.quantity,
    oi.unit_price
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
JOIN yarns AS y ON y.sku = oi.sku
JOIN brands AS b ON b.brand_id = y.brand_id
JOIN categories AS cat ON cat.category_id = y.category_id
ORDER BY o.order_id ASC, y.sku ASC;
```

Рядків: 10 Чому саме стільки: по одному рядку на кожну позицію замовлення в order_items

### Зʼєднання 3. яякі клієнти ще не оформили жодного замовлення?

```sql
SELECT c.customer_id, c.full_name, c.phone
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id ASC;
```

Рядків: 1 Чому саме стільки: клієнтка Софія Ткаченко, customer_id = 4, не має рядків у orders

Логічний порядок виконання:

1. FROM і JOIN: спочатку з'єднують `order_items` з `orders, customers, yarns, brands` і `categories` за парами «зовнішній ключ = первинний ключ». Оскільки зовнішні ключі мають `NOT NULL` і `REFERENCES`, кожен із 10 рядків `order_items` знаходить рівно одну пару без дублювання
2. WHERE: (якщо є) відфільтрувало б рядки (тут його немає)
3. SELECT: формує вибірку потрібних стовпців
4. ORDER BY: упорядковує результат за `o.order_id` та `y.sku`

Порівняння з «поганою» таблицею роботи №1: тут немає повторення контактів чи назв брендів/категорій у кожному рядку на рівні сирих даних, але з'єднання повертає повний розріз кожної проданої позиції по одному рядку на позицію замовлення

## 6. Зміна і видалення даних

Файл: [data-changes.sql](data-changes.sql)

| Зміна | Рядків у SELECT | Повідомлення СУБД | Завершення |
|---|---|---|---|
| UPDATE: ... | | `UPDATE N` | COMMIT / ROLLBACK |
| UPDATE: ... | | `UPDATE N` | COMMIT / ROLLBACK |
| DELETE: ... | | `DELETE N` | COMMIT / ROLLBACK |

### Реакції на видалення

| Звʼязок | Реакція | Що сталося з повʼязаними рядками | Повідомлення СУБД |
|---|---|---|---|
| таблиця - таблиця | RESTRICT / CASCADE / SET NULL | ... | ... |

## 7. Явні транзакції

Файл: [transactions.sql](transactions.sql)

Операція: що це за дія в області і які рядки вона змінює.

### Частина 1. COMMIT

Команди, повідомлення СУБД і стан даних після COMMIT.

### Частина 2. ROLLBACK

Стан даних усередині транзакції і після ROLLBACK.

### Частина 3. Помилка всередині транзакції

| Команда | Повідомлення СУБД |
|---|---|
| BEGIN | |
| перша зміна | |
| друга зміна | |
| SELECT | `ERROR: current transaction is aborted, commands ignored until end of transaction block` |
| COMMIT | |

Стан даних після завершення: ...

## 8. Втрачене оновлення

Файл: [lost-update.sql](lost-update.sql)

Стовпець: таблиця, стовпець, початкове значення. Зміна сеансу А: ... Зміна сеансу Б: ... Очікуваний результат: ...

### Дослід 1. READ COMMITTED

| Крок | Сеанс А | Сеанс Б |
|---|---|---|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |
| 6 | | |

Значення в базі наприкінці: ...

### Дослід 2. REPEATABLE READ

| Крок | Сеанс А | Сеанс Б |
|---|---|---|
| 1 | | |

Значення в базі наприкінці: ...

### Дослід 3. Зміна відносно поточного значення

| Крок | Сеанс А | Сеанс Б |
|---|---|---|
| 1 | | |

Значення в базі наприкінці: ...

### Висновок

Чому в досліді 1 зміну втрачено і чим досліди 2 і 3 її зберігають: ...

## 9. Повний прогін у порожній базі

| Дія в базі dbsa_check | Результат |
|---|---|
| файли `*.up.sql` за зростанням номерів | без помилок / помилка |
| цикл down - up міграції роботи №2 (якщо є) | |
| перший запуск `seed-data.sql` і скрипт підрахунку рядків | збігається з розділом 2 / відрізняється |
| другий запуск `seed-data.sql` і скрипт підрахунку рядків | той самий результат / відрізняється |
| запити `queries.sql` | кількість рядків збігається з розділами 4 і 5 / відрізняється |

Виправлені розбіжності, якщо вони були: ...
