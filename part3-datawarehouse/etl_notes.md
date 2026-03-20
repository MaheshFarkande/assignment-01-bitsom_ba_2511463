
## ETL Decisions
### Decision 1 — Standardizing Inconsistent Date Formats
Problem:
The raw dataset contained multiple date formats, including DD/MM/YYYY (e.g., 29/08/2023), DD-MM-YYYY (e.g., 12-12-2023), and   YYYY-MM-DD (e.g., 2023-02-05). This inconsistency makes time-based aggregation (monthly trends, year-over-year analysis) unreliable and error‑prone.  
Resolution:
All dates were parsed and converted into a single standardized format (YYYY-MM-DD) before loading into the warehouse. A surrogate date_key in YYYYMMDD format was generated and used consistently across the fact and dim_date table, enabling accurate joins and time-based analytics.  

### Decision 2 — Updated Product Category Casing
Problem:
Product categories appeared with inconsistent casing and naming in the raw data, such as electronics, Electronics, Grocery, and Groceries. Without normalization, this would result in fragmented aggregations where the same logical category appears multiple times in reports.  
Resolution:
All category values were standardized into a controlled set: Electronics, Clothing, and Groceries before inserting into dim_product. This ensured that category-level aggregations (e.g., total revenue by category) produce accurate and meaningful results.  

### Decision 3 — Set Missing Store City Values
Problem:
Several records contained NULL or blank store_city values, even though the same store_name appeared elsewhere with a valid city. Leaving these values NULL would weaken dimensional analysis by geography and break grouping consistency. 
Resolution:
Missing store_city values were imputed using the most frequently occurring city associated with the same store_name in other records (e.g., “Mumbai Central” → “Mumbai”). This produced a complete and consistent dim_store table suitable for location-based reporting.
