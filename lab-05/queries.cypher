// Запит 1. Зіставлення зі зразком з умовою на властивість зв'язку.
// Питання області: Які клієнти та які артикули пряжі мають активні замовлення у статусі 'new' (ще не завершені/відправлені)?
// Очікуваний результат: клієнт customer_id = 1 та артикул YR-003.
// Фактичний результат:
MATCH (c:Customer)-[r:PLACED]->(y:Yarn)
WHERE r.status = 'new'
RETURN c.full_name AS customer, y.sku AS sku, r.quantity AS quantity, r.status AS status;

// Запит 2. Шлях змінної довжини (*1..2) за зв'язком SIMILAR_TO, якого не було в реляційній схемі роботи №1.
// Питання області: Які артикули пряжі можна запропонувати як аналог або заміну для YR-001 на відстані 1–2 кроків схожості?
// Очікуваний результат: YR-003 (довжина 1) та YR-004 (довжина 2).
// Фактичний результат:
MATCH p = (start:Yarn {sku: 'YR-001'})-[:SIMILAR_TO*1..2]-(candidate:Yarn)
RETURN DISTINCT candidate.sku AS candidate_sku, candidate.yarn_name AS yarn_name, length(p) AS steps
ORDER BY steps, candidate_sku;

// Запит 3. Перевірка умови правила П4 (артикул має низький складський залишок і замовлена кількість >= 5 мотків).
// Питання області: Для яких артикулів та клієнтів виконується умова низького залишку (< 5 мотків) і партії від 5 мотків?
// Очікуваний результат: клієнт Ірина Мельник та артикул YR-002 (залишок 4, замовлено 10).
// Фактичний результат:
MATCH (c:Customer)-[r:PLACED]->(y:Yarn)
WHERE y.stock_quantity < 5 AND r.quantity >= 5
RETURN c.full_name AS customer, y.sku AS sku, y.stock_quantity AS stock_quantity, r.quantity AS ordered_quantity;
