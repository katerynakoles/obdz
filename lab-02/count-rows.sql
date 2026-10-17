-- Кількість рядків у таблицях: лабораторна робота №2.
--
-- Як виконати: у pgAdmin відкрити Query Tool для бази, яку потрібно перевірити,
-- відкрити цей файл і виконати його цілком.
-- Результат - одна таблиця: для кожної таблиці схеми public її назва
-- і кількість рядків у ній на момент виконання.
-- Порожній результат означає, що в схемі public немає жодної таблиці.
--
-- Скрипт виконують до і після повторного запуску скрипта наповнення:
-- якщо наповнення ідемпотентне, обидва результати збігаються.
--
-- Запит лише читає дані й системний каталог і нічого не змінює в базі.
-- Розбирати його текст не потрібно.

SELECT tbl.table_name::text AS table_name,
       (xpath('/row/row_count/text()',
              query_to_xml(format('SELECT count(*) AS row_count FROM %I.%I',
                                  tbl.table_schema, tbl.table_name),
                           false, true, '')))[1]::text::bigint AS row_count
FROM information_schema.tables AS tbl
WHERE tbl.table_schema = 'public'
  AND tbl.table_type = 'BASE TABLE'
ORDER BY tbl.table_name;
