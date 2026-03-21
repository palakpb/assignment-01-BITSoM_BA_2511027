# Architecture Choice

## Architecture Recommendation

**Recommended architecture: Data Lakehouse**

For a fast-growing food delivery startup handling GPS logs, customer text reviews, payment transactions, and restaurant menu images, a **Data Lakehouse** is the most appropriate choice. Here are three specific reasons:

**1. Heterogeneous data types demand open storage.**
The startup collects structured data (payment transactions), semi-structured data (GPS coordinates, reviews), and unstructured data (menu images). A traditional Data Warehouse cannot store unstructured or semi-structured data natively and would require discarding or pre-processing these assets. A Data Lake can store everything raw, while the Lakehouse layer adds schema enforcement and ACID transactions on top — giving the best of both worlds without forcing data into rigid tables prematurely.

**2. Real-time and batch workloads coexist.**
GPS location logs arrive as high-frequency streams requiring low-latency processing for live order tracking, while payment analytics and review sentiment analysis are batch workloads run periodically. A Data Lakehouse supports both through open table formats like Delta Lake or Apache Iceberg, which enable streaming ingest alongside historical queries on the same dataset — eliminating the need for a separate Lambda architecture.

**3. Cost-effective scalability with BI and ML flexibility.**
As the startup grows, data volumes will scale rapidly. Object storage (S3/GCS) underlying a Lakehouse is far cheaper than Warehouse compute-storage bundles. Critically, the Lakehouse enables data scientists to run ML models (e.g., delivery time prediction, review NLP) directly on raw files, while analysts run SQL over the same data — without duplication or ETL pipelines between a Lake and a Warehouse.

A pure Data Lake would lack governance and transactional consistency needed for payments; a pure Data Warehouse would be unable to handle images and GPS streams. The Lakehouse unifies these requirements in a single, scalable architecture.
