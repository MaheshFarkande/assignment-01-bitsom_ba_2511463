## Database Recommendation
Recommended DB: MySQL for the core patient management system
Reason: Patient data requires strong consistency and correctness
ACID: MySQL guarantees atomic, consistent, isolated, and durable transactions
Risk Avoidance: Prevents partial writes or inconsistent medical records
CAP Theorem: Healthcare systems prioritize Consistency + Partition Tolerance (CP)
Availability Trade‑off: Temporary unavailability is safer than incorrect patient data
Schema Enforcement: Fixed schemas and constraints support compliance and audits
MongoDB Limitation: BASE / eventual consistency unsuitable for core clinical data
Fraud Detection Need: High‑volume, semi‑structured data favors MongoDB
Final Choice: Polyglot persistence — MySQL for core system, MongoDB for fraud analytics
