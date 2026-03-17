ETL Decisions
Decision 1 — Date Standardization
Problem: The raw date column contained inconsistent formats including DD/MM/YYYY, DD-MM-YYYY, and YYYY-MM-DD. This prevents standard date sorting and indexing in a data warehouse.
Resolution: During ETL, I applied a multi-format parsing logic to convert all strings into a standard YYYY-MM-DD Python datetime object. This was then used to generate a numeric date_key (YYYYMMDD) for the dim_date table, ensuring consistent performance and simplified joining.

Decision 2 — Category Normalization
Problem: The category field had inconsistent casing (e.g., "electronics" vs "Electronics") and synonymous labels (e.g., "Grocery" vs "Groceries"). This would cause analytical queries to split revenue across multiple rows for the same category.
Resolution: I transformed all category values to Title Case and mapped specific synonyms like "Grocery" to a unified "Groceries" value. This ensures that a GROUP BY category query correctly aggregates all relevant data.

Decision 3 — Missing City Imputation
Problem: The store_city column had 19 NULL values. However, the data warehouse requires this dimension to be complete for accurate regional reporting.
Resolution: I identified that store_name (e.g., "Chennai Anna") always mapped to a specific city. I created a lookup dictionary from the non-null rows and used it to fill the missing store_city values based on the store's name, achieving 100% data completeness for the dim_store table.