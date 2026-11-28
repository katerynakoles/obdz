use dbsa

// 1. insertOne: записати нову позицію замовлення, у якої дата відправлення shipped_at ще не заповнена (null).
// Очікуваний результат: acknowledged: true, insertedId з _id документа.
// Фактичний результат: 
db.order_line_events.insertOne({
  _id: { order_id: 5, sku: "YR-005" },
  ordered_at: ISODate("2026-10-15T09:00:00Z"),
  shipped_at: null,
  order_status: "new",
  quantity: 2,
  unit_price: 130.00,
  line_total: 260.00,
  customer: {
    customer_id: 2,
    full_name: "Ірина Мельник",
    phone: "+380672223344"
  },
  yarn: {
    sku: "YR-005",
    yarn_name: "Acrylic Baby Color",
    brand_name: "Alize",
    category_name: "Акрил",
    color_code: "18",
    dye_lot: "LOT-E1"
  },
  shipment: {
    shipment_id: 1,
    invoice_number: "INV-2026-001",
    supplier_name: "ПряжаСвіт"
  }
})

// 2. find з умовою: знайти всі позиції замовлень, які ще не відправлено (shipped_at: null).
// У роботі №2 для аналогічного виводу клієнта/артикулу/статусу з'єднувалися 3 таблиці (order_items, orders, customers/yarns), умова перевіряла 1 поле.
// Очікуваний результат: повернеться доданий документ { order_id: 5, sku: "YR-005" } (і ще раніше перенесені з shipped_at: null, якщо такі є).
// Фактичний результат: 
db.order_line_events.find({ shipped_at: null })

// 3. find за вкладеним полем: знайти позиції пряжі бренду "Drops" і повернути лише ім'я клієнта та суму позиції.
// Очікуваний результат: документи з "customer.full_name" та "line_total" (і _id за замовчуванням).
// Фактичний результат: 
db.order_line_events.find(
  { "yarn.brand_name": "Drops" },
  { "customer.full_name": 1, line_total: 1 }
)

// 4. updateOne з $set: зафіксувати дату відправлення shipped_at та змінити статус замовлення на "shipped" для доданої позиції.
// Очікуваний результат: matchedCount: 1, modifiedCount: 1.
// Фактичний результат:
db.order_line_events.updateOne(
  { _id: { order_id: 5, sku: "YR-005" } },
  { $set: { shipped_at: ISODate("2026-10-16T12:00:00Z"), order_status: "shipped" } }
)

// 5. deleteOne: видалити помилково/тимчасово додану позицію замовлення №5.
// Кількість документів до видалення: 10
// Очікуваний результат: deletedCount: 1
// Фактичний результат: 
db.order_line_events.countDocuments()
db.order_line_events.deleteOne({ _id: { order_id: 5, sku: "YR-005" } })
db.order_line_events.countDocuments()
// Кількість документів після видалення: 10
