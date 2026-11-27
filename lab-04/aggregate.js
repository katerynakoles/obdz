use dbsa

// Агрегаційний конвеєр: сума виручки (line_total) та кількість позицій по кожному артикулу пряжі (yarn.sku).
// Звіряється з показником виручки по артикулах з аналітичних запитів роботи №3.
db.order_line_events.aggregate([
  {
    $group: {
      _id: "$yarn.sku",
      positions_count: { $sum: 1 },
      total_revenue: { $sum: "$line_total" }
    }
  },
  {
    $sort: { total_revenue: -1 }
  }
])
