/**
 * part2-nosql/mongo_queries.js
 *
 * Assumes a MongoDB collection named `products`.
 * In mongosh, run: use <your_db_name>
 */

const products = db.products;

// OP1: insertMany() — insert all 3 documents from sample_documents.json
const sampleDocs = [
  {
    "_id": "ELEC-1001",
    "category": "Electronics",
    "name": "Smartphone X12",
    "brand": "TechNova",
    "price": 799.99,
    "currency": "USD",
    "specifications": {
      "warranty_years": 2,
      "voltage": "110-240V",
      "battery": {
        "capacity_mAh": 4500,
        "fast_charging": true
      }
    },
    "connectivity": ["5G", "WiFi 6", "Bluetooth 5.3"],
    "in_stock": true
  },
  {
    "_id": "CLOT-2001",
    "category": "Clothing",
    "name": "Men's Running Jacket",
    "brand": "AeroFit",
    "price": 129.5,
    "currency": "USD",
    "sizes_available": ["S", "M", "L", "XL"],
    "material": {
      "primary": "Polyester",
      "secondary": "Elastane",
      "care_instructions": [
        "Machine wash cold",
        "Do not bleach"
      ]
    },
    "color_options": ["Black", "Blue", "Red"],
    "in_stock": true
  },
  {
    "_id": "GROC-3001",
    "category": "Groceries",
    "name": "Organic Almond Milk",
    "brand": "GreenHarvest",
    "price": 3.99,
    "currency": "USD",
    "expiry_date": "2026-07-15",
    "nutrition": {
      "serving_size_ml": 250,
      "calories": 60,
      "fat_g": 2.5,
      "carbohydrates_g": 8,
      "protein_g": 1
    },
    "allergens": ["Almonds"],
    "in_stock": true
  }
];
products.insertMany(sampleDocs);

// OP2: find() — retrieve all Electronics products with price > 20000
products.find(
  { category: "Electronics", price: { $gt: 20000 } },
  { _id: 1, name: 1, price: 1, currency: 1, category: 1 }
);

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
// expiry_date is stored as an ISO-like string (YYYY-MM-DD) in sample_documents.json,
// so lexicographic comparison works correctly for this format.
products.find(
  { category: "Groceries", expiry_date: { $lt: "2025-01-01" } },
  { _id: 1, name: 1, expiry_date: 1, brand: 1, category: 1 }
);

// OP4: updateOne() — add a "discount_percent" field to a specific product
products.updateOne(
  { _id: "ELEC-1001" },
  { $set: { discount_percent: 10 } }
);

// OP5: createIndex() — create an index on category field and explain why
// Why: Many queries filter by category (e.g., Electronics / Groceries), so an index on `category`
// reduces collection scans and speeds up category-based lookups and aggregations.
products.createIndex({{ category: 1 }})