### Data Mapping for Bronze Layer

This document provides the detailed data mapping from the source systems to the Bronze layer tables in Google BigQuery. The Bronze layer is designed to be a direct, immutable copy of the source data, with the addition of metadata for auditability and lineage.

**Guiding Principles:**
- **1-1 Mapping:** Each source attribute is mapped directly to a corresponding attribute in the Bronze layer.
- **No Transformations:** Data is ingested as-is, with no cleansing, validation, or business logic applied.
- **BigQuery Native Types:** Data types are mapped to BigQuery Standard SQL types.
- **Auditability:** Each table includes metadata columns (`ingestion_timestamp`, `source_system`, `source_feed`) to track data provenance.

--- 

### Bronze Table: `bronze_applicants`

| Target Layer | Target Table        | Target Field          | BigQuery Data Type | Source Layer | Source Table | Source Field          | Source Data Type | Transformation Rule |
|--------------|---------------------|-----------------------|--------------------|--------------|--------------|-----------------------|------------------|---------------------|
| Bronze       | `bronze_applicants` | `applicant_id`        | `INT64`            | Source       | `Applicants` | `applicant_id`        | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `full_name`           | `STRING`           | Source       | `Applicants` | `full_name`           | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `email`               | `STRING`           | Source       | `Applicants` | `email`               | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `phone_number`        | `STRING`           | Source       | `Applicants` | `phone_number`        | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `dob`                 | `DATE`             | Source       | `Applicants` | `dob`                 | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `ssn`                 | `STRING`           | Source       | `Applicants` | `ssn`                 | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `channel`             | `STRING`           | Source       | `Applicants` | `channel`             | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applicants` | `ingestion_timestamp` | `TIMESTAMP`        | System       | N/A          | `ingestion_timestamp` | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_applicants` | `source_system`       | `STRING`           | System       | N/A          | `source_system`       | `STRING`         | System Generated    |
| Bronze       | `bronze_applicants` | `source_feed`         | `STRING`           | System       | N/A          | `source_feed`         | `STRING`         | System Generated    |

### Bronze Table: `bronze_card_products`

| Target Layer | Target Table           | Target Field           | BigQuery Data Type | Source Layer | Source Table    | Source Field           | Source Data Type | Transformation Rule |
|--------------|------------------------|------------------------|--------------------|--------------|-----------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_card_products` | `card_product_id`      | `INT64`            | Source       | `Card_Products` | `card_product_id`      | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_card_products` | `card_name`            | `STRING`           | Source       | `Card_Products` | `card_name`            | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_card_products` | `category`             | `STRING`           | Source       | `Card_Products` | `category`             | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_card_products` | `interest_rate`        | `FLOAT64`          | Source       | `Card_Products` | `interest_rate`        | `FLOAT64`        | 1-1 Mapping         |
| Bronze       | `bronze_card_products` | `annual_fee`           | `FLOAT64`          | Source       | `Card_Products` | `annual_fee`           | `FLOAT64`        | 1-1 Mapping         |
| Bronze       | `bronze_card_products` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A             | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_card_products` | `source_system`        | `STRING`           | System       | N/A             | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_card_products` | `source_feed`          | `STRING`           | System       | N/A             | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_applications`

| Target Layer | Target Table          | Target Field           | BigQuery Data Type | Source Layer | Source Table   | Source Field           | Source Data Type | Transformation Rule |
|--------------|-----------------------|------------------------|--------------------|--------------|----------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_applications` | `application_id`       | `INT64`            | Source       | `Applications` | `application_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `applicant_id`         | `INT64`            | Source       | `Applications` | `applicant_id`         | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `card_product_id`      | `INT64`            | Source       | `Applications` | `card_product_id`      | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `application_date`     | `DATE`             | Source       | `Applications` | `application_date`     | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `status`               | `STRING`           | Source       | `Applications` | `status`               | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `approval_date`        | `DATE`             | Source       | `Applications` | `approval_date`        | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `rejection_reason`     | `STRING`           | Source       | `Applications` | `rejection_reason`     | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_applications` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A            | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_applications` | `source_system`        | `STRING`           | System       | N/A            | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_applications` | `source_feed`          | `STRING`           | System       | N/A            | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_credit_scores`

| Target Layer | Target Table           | Target Field           | BigQuery Data Type | Source Layer | Source Table      | Source Field           | Source Data Type | Transformation Rule |
|--------------|------------------------|------------------------|--------------------|--------------|-------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_credit_scores` | `credit_score_id`      | `INT64`            | Source       | `Credit_Scores`   | `credit_score_id`      | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_credit_scores` | `applicant_id`         | `INT64`            | Source       | `Credit_Scores`   | `applicant_id`         | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_credit_scores` | `score`                | `INT64`            | Source       | `Credit_Scores`   | `score`                | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_credit_scores` | `score_date`           | `DATE`             | Source       | `Credit_Scores`   | `score_date`           | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_credit_scores` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A               | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_credit_scores` | `source_system`        | `STRING`           | System       | N/A               | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_credit_scores` | `source_feed`          | `STRING`           | System       | N/A               | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_document_submissions`

| Target Layer | Target Table                  | Target Field           | BigQuery Data Type | Source Layer | Source Table             | Source Field           | Source Data Type | Transformation Rule |
|--------------|-------------------------------|------------------------|--------------------|--------------|--------------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_document_submissions` | `document_id`          | `INT64`            | Source       | `Document_Submissions`   | `document_id`          | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_document_submissions` | `application_id`       | `INT64`            | Source       | `Document_Submissions`   | `application_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_document_submissions` | `document_type`        | `STRING`           | Source       | `Document_Submissions`   | `document_type`        | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_document_submissions` | `upload_date`          | `DATE`             | Source       | `Document_Submissions`   | `upload_date`          | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_document_submissions` | `verified_flag`        | `BOOL`             | Source       | `Document_Submissions`   | `verified_flag`        | `BOOL`           | 1-1 Mapping         |
| Bronze       | `bronze_document_submissions` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                      | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_document_submissions` | `source_system`        | `STRING`           | System       | N/A                      | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_document_submissions` | `source_feed`          | `STRING`           | System       | N/A                      | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_verification_results`

| Target Layer | Target Table                  | Target Field           | BigQuery Data Type | Source Layer | Source Table             | Source Field           | Source Data Type | Transformation Rule |
|--------------|-------------------------------|------------------------|--------------------|--------------|--------------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_verification_results` | `verification_id`      | `INT64`            | Source       | `Verification_Results`   | `verification_id`      | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_verification_results` | `application_id`       | `INT64`            | Source       | `Verification_Results`   | `application_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_verification_results` | `verification_type`    | `STRING`           | Source       | `Verification_Results`   | `verification_type`    | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_verification_results` | `result`               | `STRING`           | Source       | `Verification_Results`   | `result`               | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_verification_results` | `verified_on`          | `DATE`             | Source       | `Verification_Results`   | `verified_on`          | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_verification_results` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                      | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_verification_results` | `source_system`        | `STRING`           | System       | N/A                      | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_verification_results` | `source_feed`          | `STRING`           | System       | N/A                      | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_underwriting_decisions`

| Target Layer | Target Table                      | Target Field           | BigQuery Data Type | Source Layer | Source Table                | Source Field           | Source Data Type | Transformation Rule |
|--------------|-----------------------------------|------------------------|--------------------|--------------|-----------------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_underwriting_decisions`   | `decision_id`          | `INT64`            | Source       | `Underwriting_Decisions`    | `decision_id`          | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_underwriting_decisions`   | `application_id`       | `INT64`            | Source       | `Underwriting_Decisions`    | `application_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_underwriting_decisions`   | `decision`             | `STRING`           | Source       | `Underwriting_Decisions`    | `decision`             | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_underwriting_decisions`   | `decision_reason`      | `STRING`           | Source       | `Underwriting_Decisions`    | `decision_reason`      | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_underwriting_decisions`   | `decision_date`        | `DATE`             | Source       | `Underwriting_Decisions`    | `decision_date`        | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_underwriting_decisions`   | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                         | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_underwriting_decisions`   | `source_system`        | `STRING`           | System       | N/A                         | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_underwriting_decisions`   | `source_feed`          | `STRING`           | System       | N/A                         | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_campaigns`

| Target Layer | Target Table       | Target Field           | BigQuery Data Type | Source Layer | Source Table | Source Field           | Source Data Type | Transformation Rule |
|--------------|--------------------|------------------------|--------------------|--------------|--------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_campaigns` | `campaign_id`          | `INT64`            | Source       | `Campaigns`  | `campaign_id`          | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_campaigns` | `campaign_name`        | `STRING`           | Source       | `Campaigns`  | `campaign_name`        | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_campaigns` | `channel`              | `STRING`           | Source       | `Campaigns`  | `channel`              | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_campaigns` | `start_date`           | `DATE`             | Source       | `Campaigns`  | `start_date`           | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_campaigns` | `end_date`             | `DATE`             | Source       | `Campaigns`  | `end_date`             | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_campaigns` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A          | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_campaigns` | `source_system`        | `STRING`           | System       | N/A          | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_campaigns` | `source_feed`          | `STRING`           | System       | N/A          | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_application_campaigns`

| Target Layer | Target Table                     | Target Field           | BigQuery Data Type | Source Layer | Source Table            | Source Field           | Source Data Type | Transformation Rule |
|--------------|----------------------------------|------------------------|--------------------|--------------|-------------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_application_campaigns`   | `app_campaign_id`      | `INT64`            | Source       | `Application_Campaigns` | `app_campaign_id`      | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_application_campaigns`   | `application_id`       | `INT64`            | Source       | `Application_Campaigns` | `application_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_application_campaigns`   | `campaign_id`          | `INT64`            | Source       | `Application_Campaigns` | `campaign_id`          | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_application_campaigns`   | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                     | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_application_campaigns`   | `source_system`        | `STRING`           | System       | N/A                     | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_application_campaigns`   | `source_feed`          | `STRING`           | System       | N/A                     | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_activations`

| Target Layer | Target Table         | Target Field                 | BigQuery Data Type | Source Layer | Source Table  | Source Field                 | Source Data Type | Transformation Rule |
|--------------|----------------------|------------------------------|--------------------|--------------|---------------|------------------------------|------------------|---------------------|
| Bronze       | `bronze_activations` | `activation_id`              | `INT64`            | Source       | `Activations` | `activation_id`              | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_activations` | `application_id`             | `INT64`            | Source       | `Activations` | `application_id`             | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_activations` | `activation_date`            | `DATE`             | Source       | `Activations` | `activation_date`            | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_activations` | `first_transaction_amount`   | `FLOAT64`          | Source       | `Activations` | `first_transaction_amount`   | `FLOAT64`        | 1-1 Mapping         |
| Bronze       | `bronze_activations` | `ingestion_timestamp`        | `TIMESTAMP`        | System       | N/A           | `ingestion_timestamp`        | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_activations` | `source_system`              | `STRING`           | System       | N/A           | `source_system`              | `STRING`         | System Generated    |
| Bronze       | `bronze_activations` | `source_feed`                | `STRING`           | System       | N/A           | `source_feed`                | `STRING`         | System Generated    |

### Bronze Table: `bronze_fraud_checks`

| Target Layer | Target Table          | Target Field           | BigQuery Data Type | Source Layer | Source Table   | Source Field           | Source Data Type | Transformation Rule |
|--------------|-----------------------|------------------------|--------------------|--------------|----------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_fraud_checks` | `fraud_check_id`       | `INT64`            | Source       | `Fraud_Checks` | `fraud_check_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_fraud_checks` | `application_id`       | `INT64`            | Source       | `Fraud_Checks` | `application_id`       | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_fraud_checks` | `check_type`           | `STRING`           | Source       | `Fraud_Checks` | `check_type`           | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_fraud_checks` | `check_result`         | `STRING`           | Source       | `Fraud_Checks` | `check_result`         | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_fraud_checks` | `check_date`           | `DATE`             | Source       | `Fraud_Checks` | `check_date`           | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_fraud_checks` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A            | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_fraud_checks` | `source_system`        | `STRING`           | System       | N/A            | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_fraud_checks` | `source_feed`          | `STRING`           | System       | N/A            | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_offers`

| Target Layer | Target Table    | Target Field           | BigQuery Data Type | Source Layer | Source Table | Source Field           | Source Data Type | Transformation Rule |
|--------------|-----------------|------------------------|--------------------|--------------|--------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_offers` | `offer_id`             | `INT64`            | Source       | `Offers`     | `offer_id`             | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_offers` | `card_product_id`      | `INT64`            | Source       | `Offers`     | `card_product_id`      | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_offers` | `offer_detail`         | `STRING`           | Source       | `Offers`     | `offer_detail`         | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_offers` | `valid_from`           | `DATE`             | Source       | `Offers`     | `valid_from`           | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_offers` | `valid_to`             | `DATE`             | Source       | `Offers`     | `valid_to`             | `DATE`           | 1-1 Mapping         |
| Bronze       | `bronze_offers` | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A          | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_offers` | `source_system`        | `STRING`           | System       | N/A          | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_offers` | `source_feed`          | `STRING`           | System       | N/A          | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_offer_performance`

| Target Layer | Target Table                 | Target Field           | BigQuery Data Type | Source Layer | Source Table          | Source Field           | Source Data Type | Transformation Rule |
|--------------|------------------------------|------------------------|--------------------|--------------|-----------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_offer_performance`   | `offer_analytics_id`   | `INT64`            | Source       | `Offer_Performance`   | `offer_analytics_id`   | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_offer_performance`   | `offer_id`             | `INT64`            | Source       | `Offer_Performance`   | `offer_id`             | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_offer_performance`   | `applications_count`   | `INT64`            | Source       | `Offer_Performance`   | `applications_count`   | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_offer_performance`   | `activations_count`    | `INT64`            | Source       | `Offer_Performance`   | `activations_count`    | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_offer_performance`   | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                   | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_offer_performance`   | `source_system`        | `STRING`           | System       | N/A                   | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_offer_performance`   | `source_feed`          | `STRING`           | System       | N/A                   | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_address_history`

| Target Layer | Target Table               | Target Field           | BigQuery Data Type | Source Layer | Source Table        | Source Field           | Source Data Type | Transformation Rule |
|--------------|----------------------------|------------------------|--------------------|--------------|---------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_address_history`   | `address_id`           | `INT64`            | Source       | `Address_History`   | `address_id`           | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `applicant_id`         | `INT64`            | Source       | `Address_History`   | `applicant_id`         | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `address_type`         | `STRING`           | Source       | `Address_History`   | `address_type`         | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `street`               | `STRING`           | Source       | `Address_History`   | `street`               | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `city`                 | `STRING`           | Source       | `Address_History`   | `city`                 | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `state`                | `STRING`           | Source       | `Address_History`   | `state`                | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `zip`                  | `STRING`           | Source       | `Address_History`   | `zip`                  | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_address_history`   | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                 | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_address_history`   | `source_system`        | `STRING`           | System       | N/A                 | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_address_history`   | `source_feed`          | `STRING`           | System       | N/A                 | `source_feed`          | `STRING`         | System Generated    |

### Bronze Table: `bronze_employment_info`

| Target Layer | Target Table               | Target Field           | BigQuery Data Type | Source Layer | Source Table        | Source Field           | Source Data Type | Transformation Rule |
|--------------|----------------------------|------------------------|--------------------|--------------|---------------------|------------------------|------------------|---------------------|
| Bronze       | `bronze_employment_info`   | `employment_id`        | `INT64`            | Source       | `Employment_Info`   | `employment_id`        | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_employment_info`   | `applicant_id`         | `INT64`            | Source       | `Employment_Info`   | `applicant_id`         | `INT64`          | 1-1 Mapping         |
| Bronze       | `bronze_employment_info`   | `employer_name`        | `STRING`           | Source       | `Employment_Info`   | `employer_name`        | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_employment_info`   | `job_title`            | `STRING`           | Source       | `Employment_Info`   | `job_title`            | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_employment_info`   | `income`               | `FLOAT64`          | Source       | `Employment_Info`   | `income`               | `FLOAT64`        | 1-1 Mapping         |
| Bronze       | `bronze_employment_info`   | `employment_type`      | `STRING`           | Source       | `Employment_Info`   | `employment_type`      | `STRING`         | 1-1 Mapping         |
| Bronze       | `bronze_employment_info`   | `ingestion_timestamp`  | `TIMESTAMP`        | System       | N/A                 | `ingestion_timestamp`  | `TIMESTAMP`      | System Generated    |
| Bronze       | `bronze_employment_info`   | `source_system`        | `STRING`           | System       | N/A                 | `source_system`        | `STRING`         | System Generated    |
| Bronze       | `bronze_employment_info`   | `source_feed`          | `STRING`           | System       | N/A                 | `source_feed`          | `STRING`         | System Generated    |