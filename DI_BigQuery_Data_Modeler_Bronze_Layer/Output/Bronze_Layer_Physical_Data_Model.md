# BigQuery Physical Data Model - Bronze Layer

This document outlines the physical data model for the Bronze layer of the Medallion architecture, designed for Google BigQuery. The Bronze layer stores raw, immutable data as ingested from source systems, with the addition of metadata for traceability and auditing.

## 1. Bronze Layer DDL Scripts

The following DDL scripts are designed for BigQuery Standard SQL. Each table includes metadata columns (`load_timestamp`, `update_timestamp`, `source_system`), partitioning by `load_timestamp`, and clustering on frequently queried columns to optimize performance.

---

### **Audit Table**

This table logs the ingestion process for all records loaded into the Bronze layer.

```sql
-- DDL for Audit Table
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_audit_log (
    record_id STRING NOT NULL,
    source_table STRING NOT NULL,
    load_timestamp TIMESTAMP NOT NULL,
    processed_by STRING,
    processing_time_ms INT64,
    status STRING,
    error_message STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY source_table, status
OPTIONS (
    description="Audit log for all data ingestion processes into the Bronze layer.",
    partition_expiration_days=730, -- Retain audit logs for 2 years
    labels=[("layer", "bronze"), ("table_type", "audit")]
);
```

---

### **Source System Tables**

#### **Table: `bz_applicants`**
Stores raw applicant data.

```sql
-- DDL for bz_applicants
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_applicants (
    -- Source Columns
    applicant_id INT64,
    full_name STRING,
    email STRING,
    phone_number STRING,
    dob DATE,
    ssn STRING,
    channel STRING,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY applicant_id, ssn
OPTIONS (
    description="Raw applicant data from source systems.",
    partition_expiration_days=1095, -- Retain raw data for 3 years
    labels=[("layer", "bronze"), ("source_table", "applicants")]
);
```

#### **Table: `bz_card_products`**
Stores raw card product information.

```sql
-- DDL for bz_card_products
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_card_products (
    -- Source Columns
    card_product_id INT64,
    card_name STRING,
    category STRING,
    interest_rate FLOAT64,
    annual_fee FLOAT64,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY card_product_id, category
OPTIONS (
    description="Raw card product details from source systems.",
    labels=[("layer", "bronze"), ("source_table", "card_products")]
);
```

#### **Table: `bz_applications`**
Stores raw application data, linking applicants to card products.

```sql
-- DDL for bz_applications
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_applications (
    -- Source Columns
    application_id INT64,
    applicant_id INT64,
    card_product_id INT64,
    application_date DATE,
    status STRING,
    approval_date DATE,
    rejection_reason STRING,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id, applicant_id, card_product_id
OPTIONS (
    description="Raw application data from source systems.",
    partition_expiration_days=1095, -- Retain raw data for 3 years
    labels=[("layer", "bronze"), ("source_table", "applications")]
);
```

#### **Table: `bz_credit_scores`**
Stores raw credit score data for applicants.

```sql
-- DDL for bz_credit_scores
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_credit_scores (
    -- Source Columns
    credit_score_id INT64,
    applicant_id INT64,
    score INT64,
    score_date DATE,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY applicant_id, score_date
OPTIONS (
    description="Raw credit score data for applicants.",
    partition_expiration_days=1095, -- Retain raw data for 3 years
    labels=[("layer", "bronze"), ("source_table", "credit_scores")]
);
```

#### **Table: `bz_document_submissions`**
Stores raw data on submitted documents for applications.

```sql
-- DDL for bz_document_submissions
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_document_submissions (
    -- Source Columns
    document_id INT64,
    application_id INT64,
    document_type STRING,
    upload_date DATE,
    verified_flag BOOL,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id, document_type
OPTIONS (
    description="Raw data on documents submitted for applications.",
    labels=[("layer", "bronze"), ("source_table", "document_submissions")]
);
```

#### **Table: `bz_verification_results`**
Stores raw verification results for applications.

```sql
-- DDL for bz_verification_results
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_verification_results (
    -- Source Columns
    verification_id INT64,
    application_id INT64,
    verification_type STRING,
    result STRING,
    verified_on DATE,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id, verification_type
OPTIONS (
    description="Raw verification results for applications.",
    labels=[("layer", "bronze"), ("source_table", "verification_results")]
);
```

#### **Table: `bz_underwriting_decisions`**
Stores raw underwriting decisions for applications.

```sql
-- DDL for bz_underwriting_decisions
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_underwriting_decisions (
    -- Source Columns
    decision_id INT64,
    application_id INT64,
    decision STRING,
    decision_reason STRING,
    decision_date DATE,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id
OPTIONS (
    description="Raw underwriting decisions for applications.",
    labels=[("layer", "bronze"), ("source_table", "underwriting_decisions")]
);
```

#### **Table: `bz_campaigns`**
Stores raw marketing campaign data.

```sql
-- DDL for bz_campaigns
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_campaigns (
    -- Source Columns
    campaign_id INT64,
    campaign_name STRING,
    channel STRING,
    start_date DATE,
    end_date DATE,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY campaign_id, channel
OPTIONS (
    description="Raw marketing campaign data.",
    labels=[("layer", "bronze"), ("source_table", "campaigns")]
);
```

#### **Table: `bz_application_campaigns`**
Stores raw data linking applications to marketing campaigns.

```sql
-- DDL for bz_application_campaigns
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_application_campaigns (
    -- Source Columns
    app_campaign_id INT64,
    application_id INT64,
    campaign_id INT64,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id, campaign_id
OPTIONS (
    description="Raw data linking applications to campaigns.",
    labels=[("layer", "bronze"), ("source_table", "application_campaigns")]
);
```

#### **Table: `bz_activations`**
Stores raw card activation data.

```sql
-- DDL for bz_activations
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_activations (
    -- Source Columns
    activation_id INT64,
    application_id INT64,
    activation_date DATE,
    first_transaction_amount FLOAT64,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id
OPTIONS (
    description="Raw card activation data.",
    labels=[("layer", "bronze"), ("source_table", "activations")]
);
```

#### **Table: `bz_fraud_checks`**
Stores raw fraud check results for applications.

```sql
-- DDL for bz_fraud_checks
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_fraud_checks (
    -- Source Columns
    fraud_check_id INT64,
    application_id INT64,
    check_type STRING,
    check_result STRING,
    check_date DATE,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY application_id, check_type
OPTIONS (
    description="Raw fraud check results for applications.",
    labels=[("layer", "bronze"), ("source_table", "fraud_checks")]
);
```

#### **Table: `bz_offers`**
Stores raw data on special offers for card products.

```sql
-- DDL for bz_offers
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_offers (
    -- Source Columns
    offer_id INT64,
    card_product_id INT64,
    offer_detail STRING,
    valid_from DATE,
    valid_to DATE,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY offer_id, card_product_id
OPTIONS (
    description="Raw data on special offers for card products.",
    labels=[("layer", "bronze"), ("source_table", "offers")]
);
```

#### **Table: `bz_offer_performance`**
Stores raw performance metrics for offers.

```sql
-- DDL for bz_offer_performance
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_offer_performance (
    -- Source Columns
    offer_analytics_id INT64,
    offer_id INT64,
    applications_count INT64,
    activations_count INT64,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY offer_id
OPTIONS (
    description="Raw performance metrics for offers.",
    labels=[("layer", "bronze"), ("source_table", "offer_performance")]
);
```

#### **Table: `bz_address_history`**
Stores raw address history for applicants.

```sql
-- DDL for bz_address_history
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_address_history (
    -- Source Columns
    address_id INT64,
    applicant_id INT64,
    address_type STRING,
    street STRING,
    city STRING,
    state STRING,
    zip STRING,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY applicant_id
OPTIONS (
    description="Raw address history for applicants.",
    labels=[("layer", "bronze"), ("source_table", "address_history")]
);
```

#### **Table: `bz_employment_info`**
Stores raw employment information for applicants.

```sql
-- DDL for bz_employment_info
CREATE TABLE IF NOT EXISTS bronze_dataset.bz_employment_info (
    -- Source Columns
    employment_id INT64,
    applicant_id INT64,
    employer_name STRING,
    job_title STRING,
    income FLOAT64,
    employment_type STRING,

    -- Metadata Columns
    load_timestamp TIMESTAMP,
    update_timestamp TIMESTAMP,
    source_system STRING
)
PARTITION BY DATE(load_timestamp)
CLUSTER BY applicant_id
OPTIONS (
    description="Raw employment information for applicants.",
    labels=[("layer", "bronze"), ("source_table", "employment_info")]
);
```

---

## 2. Conceptual Data Model Diagram

The following table describes the relationships between the Bronze layer tables. In BigQuery, these relationships are not enforced but serve as a blueprint for joins in the Silver and Gold layers.

| From Table (`Parent`)         | To Table (`Child`)              | Relationship Key(s) | Description                                         |
|-------------------------------|---------------------------------|---------------------|-----------------------------------------------------|
| `bz_applicants`               | `bz_applications`               | `applicant_id`      | An applicant can have multiple applications.        |
| `bz_applicants`               | `bz_credit_scores`              | `applicant_id`      | An applicant has a credit score history.            |
| `bz_applicants`               | `bz_address_history`            | `applicant_id`      | An applicant has an address history.                |
| `bz_applicants`               | `bz_employment_info`            | `applicant_id`      | An applicant has an employment history.             |
| `bz_card_products`            | `bz_applications`               | `card_product_id`   | An application is for a specific card product.      |
| `bz_card_products`            | `bz_offers`                     | `card_product_id`   | A card product can have multiple special offers.    |
| `bz_applications`             | `bz_document_submissions`       | `application_id`    | An application may require document submissions.    |
| `bz_applications`             | `bz_verification_results`       | `application_id`    | An application undergoes various verifications.     |
| `bz_applications`             | `bz_underwriting_decisions`     | `application_id`    | An application receives an underwriting decision.   |
| `bz_applications`             | `bz_application_campaigns`      | `application_id`    | An application can be linked to a campaign.         |
| `bz_applications`             | `bz_activations`                | `application_id`    | An approved application can lead to an activation.  |
| `bz_applications`             | `bz_fraud_checks`               | `application_id`    | An application is subject to fraud checks.          |
| `bz_campaigns`                | `bz_application_campaigns`      | `campaign_id`       | A campaign can be linked to multiple applications.  |
| `bz_offers`                   | `bz_offer_performance`          | `offer_id`          | The performance of an offer is tracked.             |

---

## 3. BigQuery Optimization Recommendations

### Partitioning Strategy
*   **Strategy**: All tables are partitioned by `DATE(load_timestamp)`.
*   **Rationale**:
    *   **Cost and Performance**: This is the most effective strategy for the Bronze layer, as it allows queries to scan only the data loaded within a specific time range (e.g., daily, monthly). This significantly reduces query cost and improves performance, especially for incremental processing in downstream ETL/ELT jobs.
    *   **Data Lifecycle Management**: Time-based partitioning simplifies data retention policies. Old partitions can be automatically expired and deleted using `partition_expiration_days`, which is a cost-effective way to manage storage.

### Clustering Recommendations
*   **Strategy**: Tables are clustered by their primary identifier(s) and common filter/join keys (e.g., `applicant_id`, `application_id`, `card_product_id`).
*   **Rationale**:
    *   **Improved Filter Performance**: Clustering co-locates data with similar values for the specified columns. When a query filters on a clustered column, BigQuery can avoid scanning unnecessary data blocks, leading to faster query execution and lower costs.
    *   **Efficient Joins**: Clustering tables by the keys used in joins (e.g., clustering `bz_applications` and `bz_activations` by `application_id`) can significantly speed up join operations, as BigQuery can perform more efficient sort-merge joins.
    *   **Granular Sorting**: Clustering provides more granular sorting within partitions than partitioning alone.

### Additional Optimization Notes
1.  **Data Ingestion**: For the Bronze layer, ingesting data in its raw format (e.g., as `STRING` for ambiguous types) can prevent load failures. However, the provided DDLs use specific types based on the source schema, which is optimal if the source data quality is reliable.
2.  **Informational Constraints**: While not included in the DDLs for simplicity, adding informational `PRIMARY KEY` and `FOREIGN KEY` constraints with `NOT ENFORCED` can provide valuable metadata to the query optimizer and to other tools or developers using the data.
3.  **Querying**: When querying Bronze tables, always include a `WHERE` clause on the `load_timestamp` column to leverage partition pruning. For example: `WHERE DATE(load_timestamp) = CURRENT_DATE() - 1`.
4.  **Column Selection**: Avoid `SELECT *`. Explicitly select only the columns needed for the downstream transformation. This reduces the amount of data processed and can lower costs.
