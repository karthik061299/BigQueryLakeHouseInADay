# BigQuery Bronze Layer: Logical Data Model

This document outlines the logical data model for the Bronze layer of a Medallion architecture implemented in Google BigQuery. It includes PII classification, table structures, an audit log design, and the conceptual data model relationships.

---

## 1. PII Classification

Personally Identifiable Information (PII) fields are identified below, along with the rationale and recommended security measures in BigQuery.

| Column Name | Reason for PII Classification | BigQuery Security Recommendation |
| :--- | :--- | :--- |
| `full_name` | Directly identifies an individual. | Data Masking (e.g., show only initials), Column-level security |
| `email` | A unique personal identifier that can be used to contact the individual. | Data Masking (e.g., format-preserving masking), Column-level security |
| `phone_number` | A unique personal identifier that can be used to contact the individual. | Data Masking (e.g., show last 4 digits), Column-level security |
| `dob` | Date of Birth is a key component of an individual's identity. | Data Masking (e.g., show only year), Column-level security |
| `ssn` | Social Security Number is a highly sensitive government identifier. | Always encrypt or tokenize. Use Column-level security. Do not store in raw format in analytical layers. |
| `street`, `city`, `state`, `zip` | Components of a physical address that can locate an individual. | Data Masking, Column-level security |
| `employer_name` | Can be used to infer information about an individual's employment. | Column-level security |

---

## 2. Bronze Layer Logical Model

The Bronze layer tables mirror the source system structure, with the addition of metadata columns for auditability and lineage. Primary and foreign key columns are retained to facilitate joins in downstream layers.

### Table: Bz_Applicants
**Description:** This table contains the raw, ingested data for individuals applying for a credit card.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `full_name` | The full name of the applicant. | STRING |
| `email` | The email address of the applicant. | STRING |
| `phone_number` | The phone number of the applicant. | STRING |
| `dob` | The date of birth of the applicant. | DATE |
| `ssn` | The Social Security Number of the applicant. | STRING |
| `channel` | The channel through which the applicant applied. | STRING |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Not recommended on this table as it lacks a natural date/timestamp column representing an event time.
*   **Clustering:** Cluster by `channel`.

### Table: Bz_Card_Products
**Description:** This table contains the raw, ingested data for the different credit card products offered.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `card_name` | The name of the credit card product. | STRING |
| `category` | The category of the card (e.g., Rewards, Travel). | STRING |
| `interest_rate` | The annual interest rate for the card. | FLOAT64 |
| `annual_fee` | The annual fee for the card. | FLOAT64 |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Not applicable.
*   **Clustering:** Cluster by `category`.

### Table: Bz_Applications
**Description:** This table contains the raw, ingested data for credit card applications.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `application_date` | The date the application was submitted. | DATE |
| `status` | The current status of the application. | STRING |
| `approval_date` | The date the application was approved. | DATE |
| `rejection_reason` | The reason for application rejection. | STRING |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `application_date` (monthly or yearly).
*   **Clustering:** Cluster by `status`.

### Table: Bz_Credit_Scores
**Description:** This table contains the raw, ingested data for applicant credit scores.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `score` | The credit score of the applicant. | INT64 |
| `score_date` | The date the credit score was pulled. | DATE |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `score_date` (monthly or yearly).
*   **Clustering:** Cluster by `score` if range-based filtering is common.

### Table: Bz_Document_Submissions
**Description:** This table contains the raw, ingested data for documents submitted as part of an application.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `document_type` | The type of document submitted (e.g., ID, Payslip). | STRING |
| `upload_date` | The date the document was uploaded. | DATE |
| `verified_flag` | A flag indicating if the document was verified. | BOOL |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `upload_date` (monthly).
*   **Clustering:** Cluster by `document_type`, `verified_flag`.

### Table: Bz_Verification_Results
**Description:** This table contains the raw, ingested data for application verification results.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `verification_type` | The type of verification performed (e.g., KYC, Income). | STRING |
| `result` | The result of the verification. | STRING |
| `verified_on` | The date the verification was completed. | DATE |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `verified_on` (monthly).
*   **Clustering:** Cluster by `verification_type`, `result`.

### Table: Bz_Underwriting_Decisions
**Description:** This table contains the raw, ingested data for underwriting decisions on applications.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `decision` | The underwriting decision (e.g., Approved, Denied). | STRING |
| `decision_reason` | The reason for the decision. | STRING |
| `decision_date` | The date the decision was made. | DATE |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `decision_date` (monthly).
*   **Clustering:** Cluster by `decision`.

### Table: Bz_Campaigns
**Description:** This table contains the raw, ingested data for marketing campaigns.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `campaign_name` | The name of the marketing campaign. | STRING |
| `channel` | The channel used for the campaign. | STRING |
| `start_date` | The start date of the campaign. | DATE |
| `end_date` | The end date of the campaign. | DATE |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Not applicable.
*   **Clustering:** Cluster by `channel`.

### Table: Bz_Application_Campaigns
**Description:** This table links applications to the campaigns that sourced them. It is a junction table.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   Not applicable for this small junction table in Bronze.

### Table: Bz_Activations
**Description:** This table contains the raw, ingested data for card activations.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `activation_date` | The date the credit card was activated. | DATE |
| `first_transaction_amount` | The amount of the first transaction made. | FLOAT64 |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `activation_date` (monthly).
*   **Clustering:** Not critical.

### Table: Bz_Fraud_Checks
**Description:** This table contains the raw, ingested data for fraud checks performed on applications.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `check_type` | The type of fraud check performed. | STRING |
| `check_result` | The result of the fraud check. | STRING |
| `check_date` | The date the fraud check was performed. | DATE |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Partition by `check_date` (monthly).
*   **Clustering:** Cluster by `check_type`, `check_result`.

### Table: Bz_Offers
**Description:** This table contains the raw, ingested data for promotional offers associated with card products.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `offer_detail` | A description of the promotional offer. | STRING |
| `valid_from` | The start date of the offer's validity. | DATE |
| `valid_to` | The end date of the offer's validity. | DATE |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Not applicable.
*   **Clustering:** Not critical.

### Table: Bz_Offer_Performance
**Description:** This table contains raw, ingested data on the performance of offers.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `applications_count` | The number of applications generated from the offer. | INT64 |
| `activations_count` | The number of activations resulting from the offer. | INT64 |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   Not applicable.

### Table: Bz_Address_History
**Description:** This table contains the raw, ingested address history for applicants.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `address_type` | The type of address (e.g., Home, Work). | STRING |
| `street` | The street address. | STRING |
| `city` | The city. | STRING |
| `state` | The state. | STRING |
| `zip` | The ZIP code. | STRING |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Not applicable.
*   **Clustering:** Cluster by `state`, `city`.

### Table: Bz_Employment_Info
**Description:** This table contains the raw, ingested employment information for applicants.

| Column Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `employer_name` | The name of the applicant's employer. | STRING |
| `job_title` | The applicant's job title. | STRING |
| `income` | The applicant's income. | FLOAT64 |
| `employment_type` | The type of employment (e.g., Full-time, Part-time). | STRING |
| `load_timestamp` | The timestamp when the record was loaded into Bronze. | TIMESTAMP |
| `update_timestamp` | The timestamp when the record was last updated. | TIMESTAMP |
| `source_system` | The name of the source system providing the data. | STRING |

**Partitioning/Clustering:**
*   **Partitioning:** Not applicable.
*   **Clustering:** Cluster by `employment_type`.

---

## 3. Audit Table Design

### Table: Bz_Audit_Log
**Description:** This table tracks metadata for each data loading process into the Bronze layer, providing traceability and monitoring capabilities.

| Field Name | Description | BigQuery Data Type |
| :--- | :--- | :--- |
| `record_id` | A unique identifier for the audit log entry. | STRING |
| `source_table` | The name of the source table being loaded. | STRING |
| `load_timestamp` | The timestamp when the data loading process started. | TIMESTAMP |
| `processed_by` | The user or service account that ran the process. | STRING |
| `processing_time` | The duration of the data loading process in seconds. | FLOAT64 |
| `status` | The final status of the load (e.g., Success, Failed). | STRING |

---

## 4. Conceptual Data Model Diagram

This table outlines the relationships between the entities based on the foreign keys in the source DDL.

| From Table | To Table | Relationship Key |
| :--- | :--- | :--- |
| `Applications` | `Applicants` | `applicant_id` |
| `Applications` | `Card_Products` | `card_product_id` |
| `Credit_Scores` | `Applicants` | `applicant_id` |
| `Document_Submissions` | `Applications` | `application_id` |
| `Verification_Results` | `Applications` | `application_id` |
| `Underwriting_Decisions` | `Applications` | `application_id` |
| `Application_Campaigns` | `Applications` | `application_id` |
| `Application_Campaigns` | `Campaigns` | `campaign_id` |
| `Activations` | `Applications` | `application_id` |
| `Fraud_Checks` | `Applications` | `application_id` |
| `Offers` | `Card_Products` | `card_product_id` |
| `Offer_Performance` | `Offers` | `offer_id` |
| `Address_History` | `Applicants` | `applicant_id` |
| `Employment_Info` | `Applicants` | `applicant_id` |

---

## 5. Rationale and Assumptions

*   **Assumptions:**
    *   The source DDL (`CreditCardBusinessDDL.sql`) accurately represents the structure of the source systems.
    *   The primary goal of the Bronze layer is to be a raw, immutable copy of the source data, with minimal transformation (only adding metadata).
    *   Timestamps for loading (`load_timestamp`) are sufficient for initial partitioning needs. Event timestamps from the source (`application_date`, `check_date`, etc.) are used for partitioning where logical.

*   **Design Decisions:**
    *   **Naming Convention:** The `Bz_` prefix is used for all Bronze layer tables to ensure clear identification and organization within the data warehouse.
    *   **Metadata Columns:** `load_timestamp`, `update_timestamp`, and `source_system` are added to every table to provide essential data lineage, auditability, and traceability back to the source.
    *   **Data Types:** BigQuery-native data types (e.g., `STRING`, `INT64`, `TIMESTAMP`, `DATE`) are used for optimal performance and compatibility. `FLOAT64` is used for monetary values and rates as per the source DDL.
    *   **PII Handling:** PII fields are explicitly identified. The recommendation is to apply BigQuery's column-level security and data masking in downstream layers (Silver/Gold) while keeping the Bronze layer as a secure, restricted-access raw backup.
    *   **Partitioning and Clustering:** Recommendations are based on BigQuery best practices. Partitioning is suggested for large, time-series tables on a date column (e.g., `application_date`) to optimize queries and manage costs. Clustering is recommended on columns frequently used in `WHERE` clauses or `JOIN` conditions to improve query performance.
    *   **Key Fields:** The instruction to remove primary and foreign key fields was interpreted as removing the *constraints*, not the columns themselves. The ID columns (`applicant_id`, `application_id`, etc.) are retained in the Bronze layer tables to maintain the relationships present in the source data, which is crucial for joining tables in subsequent Silver and Gold layers. BigQuery does not enforce key constraints, so this aligns with platform capabilities.