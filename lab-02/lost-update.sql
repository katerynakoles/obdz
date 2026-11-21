-- Підготовка перед кожним дослідом:
-- UPDATE yarns SET price = 200.00 WHERE sku = 'YR-001';

-- ==========================================
-- Дослід 1. READ COMMITTED (втрачене оновлення)
-- ==========================================
-- Крок 1. Сеанс А:
BEGIN;
SELECT price FROM yarns WHERE sku = 'YR-001'; -- бачить 200.00

-- Крок 2. Сеанс Б:
BEGIN;
SELECT price FROM yarns WHERE sku = 'YR-001'; -- також бачить 200.00

-- Крок 3. Сеанс А (200 - 10% = 180.00):
UPDATE yarns SET price = 180.00 WHERE sku = 'YR-001';

-- Крок 4. Сеанс Б (200 + 30 = 230.00) — команда чекає на блокування рядка Сеансом А:
UPDATE yarns SET price = 230.00 WHERE sku = 'YR-001';

-- Крок 5. Сеанс А:
COMMIT;

-- Крок 6. Сеанс Б (завершується після COMMIT Сеансу А та затирає 180.00 на 230.00):
COMMIT;
SELECT price FROM yarns WHERE sku = 'YR-001'; -- у базі 230.00 замість 210.00

-- ==========================================
-- Дослід 2. REPEATABLE READ (помилка серіалізації та повтор)
-- ==========================================
-- Крок 1. Сеанс А:
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT price FROM yarns WHERE sku = 'YR-001';

-- Крок 2. Сеанс Б:
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT price FROM yarns WHERE sku = 'YR-001';

-- Крок 3. Сеанс А:
UPDATE yarns SET price = 180.00 WHERE sku = 'YR-001';

-- Крок 4. Сеанс Б (чекає на Сеанс А):
UPDATE yarns SET price = 230.00 WHERE sku = 'YR-001';

-- Крок 5. Сеанс А:
COMMIT;

-- Крок 6. Сеанс Б отримує помилку: could not serialize access due to concurrent update
-- Далі Сеанс Б виконує ROLLBACK і повторює транзакцію з актуальним значенням (180.00):
ROLLBACK;
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT price FROM yarns WHERE sku = 'YR-001'; -- 180.00
UPDATE yarns SET price = 210.00 WHERE sku = 'YR-001'; -- 180 + 30 = 210.00
COMMIT;

-- ==========================================
-- Дослід 3. Зміна відносно поточного значення на READ COMMITTED
-- ==========================================
-- Крок 1. Сеанс А:
BEGIN;
SELECT price FROM yarns WHERE sku = 'YR-001';

-- Крок 2. Сеанс Б:
BEGIN;
SELECT price FROM yarns WHERE sku = 'YR-001';

-- Крок 3. Сеанс А:
UPDATE yarns SET price = price * 0.9 WHERE sku = 'YR-001'; -- стане 180.00 після COMMIT

-- Крок 4. Сеанс Б (чекає, а після COMMIT Сеансу А рахує від актуального значення):
UPDATE yarns SET price = price + 30.00 WHERE sku = 'YR-001';

-- Крок 5. Сеанс А:
COMMIT;

-- Крок 6. Сеанс Б:
COMMIT;
SELECT price FROM yarns WHERE sku = 'YR-001'; -- коректно 210.00
