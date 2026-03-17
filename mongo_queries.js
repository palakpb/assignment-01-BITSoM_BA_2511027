// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  { "product_id": "ELEC-101", "name": "UltraView OLED TV", "category": "Electronics", "price": 85000, "specs": { "display": "65-inch 4K OLED", "voltage": "240V" }, "expiry_date": null },
  { "product_id": "CLOTH-502", "name": "Classic Denim Jacket", "category": "Clothing", "price": 2500, "attributes": { "size": ["M", "L", "XL"] } },
  { "product_id": "GROC-909", "name": "Organic Almond Milk", "category": "Groceries", "price": 350, "expiry_date": "2024-12-15" }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({
  category: "Electronics",
  price: { $gt: 20000 }
});

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({
  category: "Groceries",
  expiry_date: { $lt: "2025-01-01" }
});

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { product_id: "ELEC-101" },
  { $set: { "discount_percent": 15 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ category: 1 });

