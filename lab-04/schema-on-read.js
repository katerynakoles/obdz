use dbsa

// 1. Три документи різної форми в колекції-довіднику yarn_catalog:
// 1.1. Базовий об'єкт пряжі
db.yarn_catalog.insertOne({
  _id: "YR-001",
  yarn_name: "Merino Wool Classic",
  brand_name: "Drops",
  price: 140.00
})

// 1.2. Об'єкт з однією додатковою характеристикою (composition)
db.yarn_catalog.insertOne({
  _id: "YR-002",
  yarn_name: "Cotton Soft 4ply",
  brand_name: "YarnArt",
  price: 75.00,
  composition: "100% бавовна"
})

// 1.3. Об'єкт із двома додатковими характеристиками (composition і hook_size_mm)
db.yarn_catalog.insertOne({
  _id: "YR-003",
  yarn_name: "Alpaca Air Lux",
  brand_name: "Alize",
  price: 195.00,
  composition: "65% альпака, 35% поліамід",
  hook_size_mm: 4.5
})

// 2. Дослід з навмисною помилкою в назві поля ("brend_name" замість "brand_name")
db.yarn_catalog.insertOne({
  _id: "YR-004",
  yarn_name: "Linen Breeze",
  brend_name: "Drops",
  price: 120.00
})

// Перевірка пошуку за правильним полем brand_name:
db.yarn_catalog.find({ brand_name: "Drops" })

// 3. Видалення документа з помилкою та перевірка кількості документів
db.yarn_catalog.deleteOne({ _id: "YR-004" })
db.yarn_catalog.countDocuments()
