##Storage Systems
For predicting patient readmission risk, historical clinical data (diagnoses, procedures, admissions) is stored in a Clinical Data Warehouse for structured, high‑quality features, while raw and longitudinal data is retained in a Data Lake (Delta Lake) to support large‑scale model training and reprocessing.
For plain‑English doctor queries, patient notes and historical records are embedded and stored in a Vector Database, enabling semantic search rather than keyword matching.
For monthly management reports (bed occupancy, department costs), curated, aggregated data resides in the Data Warehouse, optimized for fast SQL analytics and consumption via Power BI.
For real‑time ICU vitals, streaming data is ingested into the Data Lake through a real‑time processing layer, allowing both immediate alerting and long‑term storage for analytics and ML.

##OLTP vs OLAP Boundary
The OLTP boundary ends at operational clinical systems such as EHRs, billing systems, and ICU monitoring devices, where data is generated and updated in real time. 
Once data is ingested into the Data Lake and Data Warehouse, it becomes part of the OLAP domain, used for analytics, reporting, NLP‑based querying, and machine learning. 
Doctors’ queries and AI predictions read from analytical stores only and never directly from transactional systems, ensuring isolation and performance stability.

##Trade-offs
A key trade‑off in this design is increased architectural complexity due to maintaining multiple storage systems (warehouse, lake, vector store). 
This can raise operational overhead and governance challenges. 
To mitigate this,  We can utilize the architecture which uses a lakehouse approach with Delta Lake for consistent storage, shared metadata, and ACID guarantees, along with clear data ownership and automated pipelines. 
This preserves flexibility for AI workloads while keeping analytics reliable and maintainable.
