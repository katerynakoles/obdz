// Перемикання на базу даних проєкту та завантаження 10 документів подій (позиції замовлень / продажів пряжі)
// на основі даних наповнення роботи №2.
use dbsa

db.order_line_events.insertMany([
  {
    _id: { order_id: 1, sku: "YR-001" },
    ordered_at: ISODate("2026-09-15T10:20:00Z"),
    shipped_at: ISODate("2026-09-16T14:00:00Z"),
    order_status: "completed",
    quantity: 4,
    unit_price: 140.00,
    line_total: 560.00,
    customer: {
      customer_id: 1,
      full_name: "Олена Коваленко",
      phone: "+380501112233"
    },
    yarn: {
      sku: "YR-001",
      yarn_name: "Merino Wool Classic",
      brand_name: "Drops",
      category_name: "Вовна",
      color_code: "0100",
      dye_lot: "LOT-A1"
    },
    shipment: {
      shipment_id: 1,
      invoice_number: "INV-2026-001",
      supplier_name: "ПряжаСвіт"
    }
  },
  {
    _id: { order_id: 1, sku: "YR-002" },
    ordered_at: ISODate("2026-09-15T10:20:00Z"),
    shipped_at: ISODate("2026-09-16T14:00:00Z"),
    order_status: "completed",
    quantity: 3,
    unit_price: 75.00,
    line_total: 225.00,
    customer: {
      customer_id: 1,
      full_name: "Олена Коваленко",
      phone: "+380501112233"
    },
    yarn: {
      sku: "YR-002",
      yarn_name: "Cotton Soft 4ply",
      brand_name: "YarnArt",
      category_name: "Бавовна",
      color_code: "204",
      dye_lot: "LOT-C2"
    },
    shipment: {
      shipment_id: 1,
      invoice_number: "INV-2026-001",
      supplier_name: "ПряжаСвіт"
    }
  },
  {
    _id: { order_id: 1, sku: "YR-004" },
    ordered_at: ISODate("2026-09-15T10:20:00Z"),
    shipped_at: ISODate("2026-09-16T14:00:00Z"),
    order_status: "completed",
    quantity: 4,
    unit_price: 120.00,
    line_total: 480.00,
    customer: {
      customer_id: 1,
      full_name: "Олена Коваленко",
      phone: "+380501112233"
    },
    yarn: {
      sku: "YR-004",
      yarn_name: "Linen Breeze",
      brand_name: "Drops",
      category_name: "Бавовна",
      color_code: "05",
      dye_lot: "LOT-D1"
    },
    shipment: {
      shipment_id: 2,
      invoice_number: "INV-2026-002",
      supplier_name: "НиткиМаркет"
    }
  },
  {
    _id: { order_id: 2, sku: "YR-002" },
    ordered_at: ISODate("2026-09-30T15:05:00Z"),
    shipped_at: ISODate("2026-10-01T11:30:00Z"),
    order_status: "completed",
    quantity: 10,
    unit_price: 75.00,
    line_total: 750.00,
    customer: {
      customer_id: 2,
      full_name: "Ірина Мельник",
      phone: "+380672223344"
    },
    yarn: {
      sku: "YR-002",
      yarn_name: "Cotton Soft 4ply",
      brand_name: "YarnArt",
      category_name: "Бавовна",
      color_code: "204",
      dye_lot: "LOT-C2"
    },
    shipment: {
      shipment_id: 1,
      invoice_number: "INV-2026-001",
      supplier_name: "ПряжаСвіт"
    }
  },
  {
    _id: { order_id: 2, sku: "YR-004" },
    ordered_at: ISODate("2026-09-30T15:05:00Z"),
    shipped_at: ISODate("2026-10-01T11:30:00Z"),
    order_status: "completed",
    quantity: 5,
    unit_price: 105.00,
    line_total: 525.00,
    customer: {
      customer_id: 2,
      full_name: "Ірина Мельник",
      phone: "+380672223344"
    },
    yarn: {
      sku: "YR-004",
      yarn_name: "Linen Breeze",
      brand_name: "Drops",
      category_name: "Бавовна",
      color_code: "05",
      dye_lot: "LOT-D1"
    },
    shipment: {
      shipment_id: 2,
      invoice_number: "INV-2026-002",
      supplier_name: "НиткиМаркет"
    }
  },
  {
    _id: { order_id: 3, sku: "YR-001" },
    ordered_at: ISODate("2026-10-03T12:40:00Z"),
    shipped_at: ISODate("2026-10-04T09:15:00Z"),
    order_status: "paid",
    quantity: 2,
    unit_price: 145.00,
    line_total: 290.00,
    customer: {
      customer_id: 3,
      full_name: "Марія Шевченко",
      phone: "+380633334455"
    },
    yarn: {
      sku: "YR-001",
      yarn_name: "Merino Wool Classic",
      brand_name: "Drops",
      category_name: "Вовна",
      color_code: "0100",
      dye_lot: "LOT-A1"
    },
    shipment: {
      shipment_id: 1,
      invoice_number: "INV-2026-001",
      supplier_name: "ПряжаСвіт"
    }
  },
  {
    _id: { order_id: 3, sku: "YR-002" },
    ordered_at: ISODate("2026-10-03T12:40:00Z"),
    shipped_at: ISODate("2026-10-04T09:15:00Z"),
    order_status: "paid",
    quantity: 5,
    unit_price: 80.00,
    line_total: 400.00,
    customer: {
      customer_id: 3,
      full_name: "Марія Шевченко",
      phone: "+380633334455"
    },
    yarn: {
      sku: "YR-002",
      yarn_name: "Cotton Soft 4ply",
      brand_name: "YarnArt",
      category_name: "Бавовна",
      color_code: "204",
      dye_lot: "LOT-C2"
    },
    shipment: {
      shipment_id: 1,
      invoice_number: "INV-2026-001",
      supplier_name: "ПряжаСвіт"
    }
  },
  {
    _id: { order_id: 3, sku: "YR-003" },
    ordered_at: ISODate("2026-10-03T12:40:00Z"),
    shipped_at: ISODate("2026-10-04T09:15:00Z"),
    order_status: "paid",
    quantity: 3,
    unit_price: 200.00,
    line_total: 600.00,
    customer: {
      customer_id: 3,
      full_name: "Марія Шевченко",
      phone: "+380633334455"
    },
    yarn: {
      sku: "YR-003",
      yarn_name: "Alpaca Air Lux",
      brand_name: "Alize",
      category_name: "Вовна",
      color_code: "62",
      dye_lot: "LOT-B1"
    },
    shipment: {
      shipment_id: 2,
      invoice_number: "INV-2026-002",
      supplier_name: "НиткиМаркет"
    }
  },
  {
    _id: { order_id: 4, sku: "YR-003" },
    ordered_at: ISODate("2026-10-12T17:10:00Z"),
    shipped_at: null,
    order_status: "new",
    quantity: 5,
    unit_price: 192.00,
    line_total: 960.00,
    customer: {
      customer_id: 1,
      full_name: "Олена Коваленко",
      phone: "+380501112233"
    },
    yarn: {
      sku: "YR-003",
      yarn_name: "Alpaca Air Lux",
      brand_name: "Alize",
      category_name: "Вовна",
      color_code: "62",
      dye_lot: "LOT-B1"
    },
    shipment: {
      shipment_id: 2,
      invoice_number: "INV-2026-002",
      supplier_name: "НиткиМаркет"
    }
  },
  {
    _id: { order_id: 4, sku: "YR-004" },
    ordered_at: ISODate("2026-10-12T17:10:00Z"),
    shipped_at: null,
    order_status: "new",
    quantity: 3,
    unit_price: 110.00,
    line_total: 330.00,
    customer: {
      customer_id: 1,
      full_name: "Олена Коваленко",
      phone: "+380501112233"
    },
    yarn: {
      sku: "YR-004",
      yarn_name: "Linen Breeze",
      brand_name: "Drops",
      category_name: "Бавовна",
      color_code: "05",
      dye_lot: "LOT-D1"
    },
    shipment: {
      shipment_id: 2,
      invoice_number: "INV-2026-002",
      supplier_name: "НиткиМаркет"
    }
  }
])

db.order_line_events.countDocuments()
