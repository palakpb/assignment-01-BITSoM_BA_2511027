# Part 6 — Capstone Design Justification

## Storage Systems

Each of the four goals drives a distinct storage choice, because no single database handles all four access patterns well.

**Goal 1 — Readmission Risk Prediction** uses **PostgreSQL (OLTP)** as the source of truth for patient records, feeding a **Feature Store (Feast)**. Historical treatment data is periodically synced to **Snowflake (OLAP)** where aggregated patient features (prior admissions, diagnosis codes, medication history) are computed. Snowflake's columnar format makes these heavy analytical reads fast without impacting the live EHR system.

**Goal 2 — Plain-English Doctor Queries** uses a **Vector Database (Pinecone)** alongside the LLM. Patient history is chunked, embedded, and stored as high-dimensional vectors, enabling Retrieval-Augmented Generation (RAG). When a doctor asks "Has this patient had a cardiac event?", the LLM retrieves semantically relevant records from Pinecone rather than running full SQL scans, giving sub-second responses over unstructured clinical notes.

**Goal 3 — Monthly Management Reports** uses the **Snowflake OLAP warehouse**, fed by nightly **dbt transformations** that build clean data marts for bed occupancy, department costs, and staffing. OLAP is purpose-built for this — aggregating millions of rows with complex GROUP BY and window functions in seconds, then serving them to Power BI or Metabase.

**Goal 4 — Real-time ICU Vitals Streaming** uses **Apache Kafka** as the primary event bus for ingestion and a short-term buffer, backed by **InfluxDB** as the time-series store. InfluxDB's time-series engine handles high-frequency writes (one reading per second per patient) and supports fast range queries ("last 30 minutes of SpO2") that relational databases handle poorly. Raw data is also landed in the **Data Lake (S3/ADLS)** as Parquet files for long-term retention and retrospective model training.

---

## OLTP vs OLAP Boundary

The **transactional boundary** is PostgreSQL — it handles all writes from the EHR system: admissions, discharges, prescriptions, diagnoses, and doctor notes. It is optimised for row-level reads and writes with strong ACID guarantees, which is essential when a nurse updates a patient's medication or a doctor records a diagnosis in real time. PostgreSQL also serves the real-time readmission risk API during a patient's active stay.

The **analytical boundary begins at the nightly ETL pipeline (Apache Airflow)**. At this point, data is extracted from PostgreSQL, transformed by dbt, and loaded into Snowflake. From this point onward, all workloads are read-only and analytical: monthly reports, historical feature engineering for ML models, and BI dashboard queries. No application writes directly to Snowflake. This clean separation means that heavy analytical queries on Snowflake never lock rows or degrade response time on the live EHR system.

The ICU stream has its own boundary: Kafka handles real-time ingestion and passes data to both InfluxDB (operational queries) and the Data Lake (archival / batch training), keeping the streaming and batch worlds decoupled.

---

## Trade-offs

**The most significant trade-off is data duplication and consistency lag across storage systems.** Patient data lives simultaneously in PostgreSQL, Snowflake, InfluxDB, Pinecone, and the Data Lake — with Snowflake and Pinecone lagging PostgreSQL by up to 24 hours (nightly ETL). This means a doctor querying the NLP interface late in the day might not see a diagnosis entered that morning, creating a stale-read risk in a clinical context.

**Mitigation strategies:** First, introduce a **Change Data Capture (CDC) pipeline using Debezium** on PostgreSQL, which streams row-level changes to Kafka in near-real time, reducing the lag from 24 hours to under 5 minutes for critical updates. Second, implement a **cache-aside pattern** in the NLP query engine that checks PostgreSQL directly for records modified in the last 6 hours before falling back to Pinecone, ensuring freshness for same-day clinical events. Third, **data freshness timestamps** should be surfaced in the doctor-facing UI ("as of 14:32 today") so clinicians understand the recency of the information they are reading. These measures collectively reduce the risk without abandoning the architectural separation that makes the system scalable.
