# Gold Layer Logical Data Model

## 1. Rationale for Key Design Decisions and Assumptions

*   **Dimensional Model:** The Gold layer is designed as a dimensional model (star schema) to optimize for reporting and analytics. It consists of a central fact table (`Go_Fact_Application`) surrounded by dimension tables. This structure simplifies queries and improves performance for the KPIs listed in the reporting requirements.
*   **Fact Table Design:** A single fact table, `Go_Fact_Application`, is created to consolidate key events in the credit card acquisition funnel: application, approval, activation, and the first transaction. This denormalized approach avoids complex joins during querying and directly supports the calculation of metrics like 'Time to Approval' and 'Time to First Transaction'.
*   **Dimension Table Design:** Dimension tables (`Go_Dim_Applicant`, `Go_Dim_Card_Product`, etc.) are designed to be wide and descriptive, providing the "who, what, where, when, why" context for the fact data.
*   **SCD Types:** All dimensions are designated as SCD Type 1. This decision is based on the assumption that the reporting requirements are focused on the state of the data at the time of the application. For instance, the applicant's `income_level` at the time of application is what matters for credit risk assessment, not their historical income levels. If historical tracking were required, SCD Type 2 would be implemented.
*   **Aggregate Table:** The `Go_Agg_Application_Monthly` table is introduced to pre-calculate key metrics at a monthly grain. This is a performance optimization strategy. Reports and dashboards requiring monthly trend analysis can query this smaller, summary table instead of the large fact table, resulting in significantly faster response times.
*   **Audit and Error Logging:** The `Go_Process_Audit_Log` and `Go_Data_Validation_Error_Log` tables are included to ensure data governance, traceability, and operational monitoring of the Gold layer ETL/ELT processes. They capture pipeline execution metadata and any data quality issues encountered when creating the curated Gold layer tables.
*   **PII Classification:** PII classification is based on the potential to identify an individual. `geography` is marked as PII as it can contribute to re-identification when combined with other attributes.
*   **No Physical Keys:** As per the instructions, no primary or foreign key columns (e.g., `application_id`, `applicant_id`) are included in the table definitions. The relationships are logical and are enforced by the ETL/ELT process that joins the Silver layer tables to populate this Gold model.

---

## 2. Gold Layer Logical Model

### **Dimension Tables**

#### **Table: Go_Dim_Applicant**
*   **Description:** Stores descriptive attributes of the credit card applicants.
*   **Table Type:** Dimension
*   **SCD Type:** Type 1

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| geography | The geographical region or state of the applicant. | `STRING` | Yes |
| age_group | The derived age bracket of the applicant (e.g., '25-34', '35-44'). | `STRING` | No |
| income_level | The derived income bracket of the applicant (e.g., '50k-75k'). | `STRING` | No |
| employment_type | The standardized employment status of the applicant. | `STRING` | No |
| credit_score | The credit score of the applicant at the time of application. | `INT64` | No |
| risk_tier | The risk category assigned based on the credit score. | `STRING` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |
| update_date | The date the record was last updated. | `TIMESTAMP` | No |
| source_system | The source system from which the data originated. | `STRING` | No |

---
#### **Table: Go_Dim_Card_Product**
*   **Description:** Stores details about the credit card products offered.
*   **Table Type:** Dimension
*   **SCD Type:** Type 1

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| product_name | The standardized name of the credit card product. | `STRING` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |
| update_date | The date the record was last updated. | `TIMESTAMP` | No |
| source_system | The source system from which the data originated. | `STRING` | No |

---
#### **Table: Go_Dim_Acquisition_Channel**
*   **Description:** Stores details about the channels through which applications are acquired.
*   **Table Type:** Dimension
*   **SCD Type:** Type 1

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| channel_name | The standardized name of the acquisition channel (e.g., 'Online'). | `STRING` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |
| update_date | The date the record was last updated. | `TIMESTAMP` | No |
| source_system | The source system from which the data originated. | `STRING` | No |

---
#### **Table: Go_Dim_Campaign**
*   **Description:** Stores details about marketing campaigns.
*   **Table Type:** Dimension
*   **SCD Type:** Type 1

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| campaign_name | The standardized name of the marketing campaign. | `STRING` | No |
| campaign_type | The standardized type of the campaign (e.g., 'Digital'). | `STRING` | No |
| start_date | The start date of the campaign. | `DATE` | No |
| end_date | The end date of the campaign. | `DATE` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |
| update_date | The date the record was last updated. | `TIMESTAMP` | No |
| source_system | The source system from which the data originated. | `STRING` | No |

---
#### **Table: Go_Dim_Fraud_Check**
*   **Description:** Stores details about the fraud checks performed on applications.
*   **Table Type:** Dimension
*   **SCD Type:** Type 1

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| fraud_check_type | The type of fraud check performed. | `STRING` | No |
| screening_result | The result of the specific fraud screening check. | `STRING` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |
| update_date | The date the record was last updated. | `TIMESTAMP` | No |
| source_system | The source system from which the data originated. | `STRING` | No |

---
### **Fact Table**

#### **Table: Go_Fact_Application**
*   **Description:** A central fact table containing measures and key dates for the entire credit card acquisition funnel, from application to first transaction.
*   **Table Type:** Fact

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| application_date | The date the application was submitted. | `DATE` | No |
| approval_date | The date the application was approved. | `DATE` | No |
| activation_date | The date the card was activated. | `DATE` | No |
| transaction_date | The date of the first transaction. | `DATE` | No |
| application_outcome | The final status of the application. | `STRING` | No |
| fraud_screening_result | The final outcome of the fraud screening process. | `STRING` | No |
| transaction_amount | The amount of the first transaction. | `FLOAT64` | No |
| marketing_cost | The cost associated with the campaign linked to the application. | `FLOAT64` | No |
| time_to_approval_days | The number of days from application to approval. | `INT64` | No |
| time_to_activation_days | The number of days from approval to activation. | `INT64` | No |
| time_to_first_transaction_days | The number of days from activation to the first transaction. | `INT64` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |
| source_system | The source system from which the data originated. | `STRING` | No |

---
### **Aggregate Table**

#### **Table: Go_Agg_Application_Monthly**
*   **Description:** An aggregate table summarizing key application metrics by month, product, channel, and campaign for faster reporting.
*   **Table Type:** Aggregated

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| year_month | The year and month of the aggregation (e.g., '2023-01'). | `STRING` | No |
| product_name | The name of the credit card product. | `STRING` | No |
| channel_name | The name of the acquisition channel. | `STRING` | No |
| campaign_name | The name of the marketing campaign. | `STRING` | No |
| total_applications | The total count of applications. | `INT64` | No |
| approved_applications | The count of approved applications. | `INT64` | No |
| activated_applications | The count of activated cards. | `INT64` | No |
| total_first_transaction_amount | The sum of the first transaction amounts. | `FLOAT64` | No |
| total_marketing_cost | The sum of marketing costs for the applications. | `FLOAT64` | No |
| approval_rate | The calculated approval rate for the group. | `FLOAT64` | No |
| activation_rate | The calculated activation rate for the group. | `FLOAT64` | No |
| cost_per_acquisition | The calculated cost per acquisition for the group. | `FLOAT64` | No |
| load_date | The date the record was loaded into the Gold layer. | `TIMESTAMP` | No |

---
### **Audit and Error Data Tables**

#### **Table: Go_Process_Audit_Log**
*   **Description:** Tracks metadata for each data processing pipeline run that loads data into the Gold layer. Provides a complete audit trail for data curation and aggregation.
*   **Table Type:** Audit

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| pipeline_run_id | A unique identifier for each execution of a pipeline. | `STRING` | No |
| pipeline_name | The name of the pipeline that was executed (e.g., 'silver_to_gold_dimensions'). | `STRING` | No |
| start_timestamp | The timestamp when the pipeline run began. | `TIMESTAMP` | No |
| end_timestamp | The timestamp when the pipeline run finished. | `TIMESTAMP` | No |
| status | The final status of the run ('Success', 'Failed'). | `STRING` | No |
| source_tables | A list of source tables read during the pipeline run. | `STRING` | No |
| target_table | The destination table in the Gold layer. | `STRING` | No |
| rows_read | The total number of rows read from the source(s). | `INT64` | No |
| rows_written | The total number of rows written to the target table. | `INT64` | No |
| run_by_user | The service account or user that executed the pipeline. | `STRING` | No |

---
#### **Table: Go_Data_Validation_Error_Log**
*   **Description:** Captures detailed information about individual records that fail data quality or business rule checks during the transformation from Silver to Gold.
*   **Table Type:** Error Data

| Column Name | Description | Data Type | PII Classification |
| :--- | :--- | :--- | :--- |
| error_id | A unique identifier for each error record. | `STRING` | No |
| pipeline_run_id | The identifier of the pipeline run during which the error occurred. | `STRING` | No |
| error_timestamp | The timestamp when the error was logged. | `TIMESTAMP` | No |
| source_table | The source Silver table from which the problematic record originated. | `STRING` | No |
| record_identifier | A unique reference to the source record (e.g., a hash of the row). | `STRING` | No |
| column_name | The name of the column where the error was detected. | `STRING` | No |
| failed_rule | The specific business or quality rule that the record failed. | `STRING` | No |
| error_description | A detailed description of the validation failure. | `STRING` | No |
| erroneous_value | The actual data value that caused the error. | `STRING` | No |

---

## 3. Conceptual Data Model Diagram

This table describes the logical relationships between the Fact and Dimension tables in the Gold Layer. The joins are performed by the ETL/ELT process using business keys from the Silver layer.

| From Table (Fact) | To Table (Dimension) | Relationship Key (Logical) |
| :--- | :--- | :--- |
| Go_Fact_Application | Go_Dim_Applicant | Based on a unique applicant identifier |
| Go_Fact_Application | Go_Dim_Card_Product | Based on `product_name` |
| Go_Fact_Application | Go_Dim_Acquisition_Channel | Based on `channel_name` |
| Go_Fact_Application | Go_Dim_Campaign | Based on `campaign_name` |
| Go_Fact_Application | Go_Dim_Fraud_Check | Based on a unique application identifier |

---
## 4. API Cost
*   **apiCost:** 0.00075 USD
