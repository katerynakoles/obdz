// Створення фрагмента графа знань предметної області «Магазин пряжі» (ідемпотентно через MERGE).
// Мітки: Customer, Yarn, Brand, Category, Shipment, Supplier; зв'язки: PLACED, CONTAINS_YARN, PRODUCED_BY, BELONGS_TO, SUPPLIED_BY, SIMILAR_TO.

MERGE (c1:Customer {customer_id: 1})
  SET c1.full_name = 'Олена Коваленко', c1.phone = '+380501112233'

MERGE (c2:Customer {customer_id: 2})
  SET c2.full_name = 'Ірина Мельник', c2.phone = '+380672223344'

MERGE (b1:Brand {brand_name: 'Drops'})
  SET b1.country = 'Норвегія'

MERGE (b2:Brand {brand_name: 'YarnArt'})
  SET b2.country = 'Туреччина'

MERGE (cat1:Category {category_name: 'Вовна'})
MERGE (cat2:Category {category_name: 'Бавовна'})

MERGE (sup1:Supplier {company_name: 'ПряжаСвіт'})
  SET sup1.phone = '+380509998877'

MERGE (sh1:Shipment {invoice_number: 'INV-2026-001'})
  SET sh1.shipment_date = date('2026-09-10')

MERGE (y1:Yarn {sku: 'YR-001'})
  SET y1.yarn_name = 'Merino Wool Classic', y1.price = 140.00, y1.stock_quantity = 25

MERGE (y2:Yarn {sku: 'YR-002'})
  SET y2.yarn_name = 'Cotton Soft 4ply', y2.price = 75.00, y2.stock_quantity = 4

MERGE (y3:Yarn {sku: 'YR-003'})
  SET y3.yarn_name = 'Alpaca Air Lux', y3.price = 195.00, y3.stock_quantity = 18

MERGE (y4:Yarn {sku: 'YR-004'})
  SET y4.yarn_name = 'Linen Breeze', y4.price = 120.00, y4.stock_quantity = 22

MERGE (c1)-[r1:PLACED {order_id: 1, ordered_at: datetime('2026-09-15T10:20:00Z'), status: 'completed', quantity: 4, unit_price: 140.00}]->(y1)
MERGE (c1)-[r2:PLACED {order_id: 4, ordered_at: datetime('2026-10-12T17:10:00Z'), status: 'new', quantity: 5, unit_price: 192.00}]->(y3)
MERGE (c2)-[r3:PLACED {order_id: 2, ordered_at: datetime('2026-09-30T15:05:00Z'), status: 'completed', quantity: 10, unit_price: 75.00}]->(y2)

MERGE (y1)-[:PRODUCED_BY]->(b1)
MERGE (y2)-[:PRODUCED_BY]->(b2)
MERGE (y3)-[:PRODUCED_BY]->(b1)
MERGE (y4)-[:PRODUCED_BY]->(b1)

MERGE (y1)-[:BELONGS_TO]->(cat1)
MERGE (y2)-[:BELONGS_TO]->(cat2)
MERGE (y3)-[:BELONGS_TO]->(cat1)
MERGE (y4)-[:BELONGS_TO]->(cat2)

MERGE (sh1)-[:CONTAINS_YARN]->(y1)
MERGE (sh1)-[:CONTAINS_YARN]->(y2)
MERGE (sh1)-[:SUPPLIED_BY]->(sup1)

// Новий зв'язок предметної області (заміна/схожість артикулів для підбору пряжі), якого не було в реляційній схемі роботи №1
MERGE (y1)-[:SIMILAR_TO {reason: 'однакова категорія та близька товщина нитки'}]->(y3)
MERGE (y3)-[:SIMILAR_TO {reason: 'сумісний склад для зимових виробів'}]->(y4)
