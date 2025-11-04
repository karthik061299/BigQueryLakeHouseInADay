import os
import uuid
import getpass
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine
from google.cloud import bigquery
from google.api_core.exceptions import GoogleAPICallError
import time

# =============================================================================
# CONFIGURATION SECTION
# =============================================================================

# --- Source Database Configuration (Example: PostgreSQL) ---
# In a real-world scenario, use a secure way to manage credentials 
# (e.g., Google Secret Manager, HashiCorp Vault, or environment variables)
SOURCE_DB_TYPE = 'postgresql'
SOURCE_DB_USER = os.environ.get('SOURCE_DB_USER', 'your_user')
SOURCE_DB_PASSWORD = os.environ.get('SOURCE_DB_PASSWORD', 'your_password')
SOURCE_DB_HOST = os.environ.get('SOURCE_DB_HOST', 'localhost')
SOURCE_DB_PORT = os.environ.get('SOURCE_DB_PORT', '5432')
SOURCE_DB_NAME = os.environ.get('SOURCE_DB_NAME', 'credit_card_db')
SOURCE_SYSTEM_NAME = 'PostgreSQL_CreditCardDB'

# --- BigQuery Destination Configuration ---
# Ensure you have authenticated with `gcloud auth application-default login`
# or have the GOOGLE_APPLICATION_CREDENTIALS environment variable set.
BQ_PROJECT_ID = os.environ.get('BQ_PROJECT_ID', 'your-gcp-project-id')
BQ_BRONZE_DATASET = 'Bronze'
BQ_AUDIT_TABLE = f'{BQ_PROJECT_ID}.{BQ_BRONZE_DATASET}.bz_audit_log'

# --- Table Mapping Configuration ---
# Maps source tables to their corresponding BigQuery bronze tables.
TABLE_MAPPING = {
    'public.applicants': 'bz_applicants',
    'public.applications': 'bz_applications',
    'public.card_products': 'bz_card_products',
    'public.credit_scores': 'bz_credit_scores',
    'public.document_submissions': 'bz_document_submissions',
    'public.verification_results': 'bz_verification_results',
    'public.underwriting_decisions': 'bz_underwriting_decisions',
    'public.campaigns': 'bz_campaigns',
    'public.application_campaigns': 'bz_application_campaigns',
    'public.activations': 'bz_activations',
    'public.fraud_checks': 'bz_fraud_checks',
    'public.offers': 'bz_offers',
    'public.offer_performance': 'bz_offer_performance',
    'public.address_history': 'bz_address_history',
    'public.employment_info': 'bz_employment_info',
}

# --- Ingestion Process Configuration ---
PROCESSED_BY = getpass.getuser()

# =============================================================================
# HELPER AND UTILITY FUNCTIONS
# =============================================================================

def get_sqlalchemy_engine():
    """Creates and returns a SQLAlchemy engine for the source database."""
    try:
        connection_url = (
            f"{SOURCE_DB_TYPE}://{SOURCE_DB_USER}:{SOURCE_DB_PASSWORD}@"
            f"{SOURCE_DB_HOST}:{SOURCE_DB_PORT}/{SOURCE_DB_NAME}"
        )
        engine = create_engine(connection_url)
        print("Successfully created SQLAlchemy engine.")
        return engine
    except Exception as e:
        print(f"Error creating SQLAlchemy engine: {e}")
        raise

def get_bigquery_client():
    """Creates and returns a BigQuery client."""
    try:
        client = bigquery.Client(project=BQ_PROJECT_ID)
        print("Successfully created BigQuery client.")
        return client
    except Exception as e:
        print(f"Error creating BigQuery client: {e}")
        raise

# =============================================================================
# AUDIT LOGGING FUNCTION
# =============================================================================

def log_audit_record(client, source_table, target_table, start_time, row_count, status, error_message=None):
    """
    Inserts a record into the BigQuery audit log table.

    Args:
        client (bigquery.Client): The BigQuery client.
        source_table (str): The name of the source table.
        target_table (str): The name of the target BigQuery table.
        start_time (datetime): The timestamp when the process started.
        row_count (int): The number of rows processed.
        status (str): The final status ('Success' or 'Failed').
        error_message (str, optional): The error message if the process failed.
    """
    try:
        load_timestamp = datetime.utcnow()
        end_time = datetime.utcnow()
        processing_time_seconds = (end_time - start_time).total_seconds()

        log_entry = {
            'Record_ID': str(uuid.uuid4()),
            'Source_Table': source_table,
            'Target_Table': target_table,
            'Load_Timestamp': load_timestamp.isoformat(),
            'Processed_By': PROCESSED_BY,
            'Processing_Time_Seconds': processing_time_seconds,
            'Row_Count': row_count,
            'Status': status,
            'Error_Message': str(error_message) if error_message else None
        }

        errors = client.insert_rows_json(BQ_AUDIT_TABLE, [log_entry])
        if errors:
            print(f"Failed to insert audit log record: {errors}")
        else:
            print(f"Successfully logged audit record for {target_table}.")

    except Exception as e:
        print(f"Critical error in log_audit_record function: {e}")

# =============================================================================
# CORE INGESTION FUNCTIONS
# =============================================================================

def extract_from_source(engine, table_name):
    """
    Extracts all data from a specified source table into a pandas DataFrame.

    Args:
        engine (sqlalchemy.engine.Engine): The SQLAlchemy engine for the source DB.
        table_name (str): The name of the table to extract data from.

    Returns:
        pd.DataFrame: A DataFrame containing the extracted data.
    """
    print(f"Starting extraction from source table: {table_name}")
    try:
        query = f'SELECT * FROM {table_name};'
        df = pd.read_sql(query, engine)
        print(f"Successfully extracted {len(df)} rows from {table_name}.")
        return df
    except Exception as e:
        print(f"Error extracting data from {table_name}: {e}")
        raise

def load_to_bronze(client, df, target_table_name):
    """
    Loads a pandas DataFrame into a specified BigQuery Bronze table.

    This function adds required metadata columns and uses the 'append' write disposition.
    It includes a retry mechanism for transient API errors.

    Args:
        client (bigquery.Client): The BigQuery client.
        df (pd.DataFrame): The DataFrame to load.
        target_table_name (str): The name of the target BigQuery table.

    Returns:
        int: The number of rows loaded.
    """
    full_table_id = f"{BQ_PROJECT_ID}.{BQ_BRONZE_DATASET}.{target_table_name}"
    print(f"Preparing to load data into BigQuery table: {full_table_id}")

    # 1. Add metadata columns
    current_timestamp = datetime.utcnow()
    df['Load_Date'] = current_timestamp
    df['Source_System'] = SOURCE_SYSTEM_NAME

    # 2. Ensure schema alignment (simple version)
    # A more robust solution would involve comparing df.dtypes with BQ schema
    # and casting types before loading.
    table_schema = client.get_table(full_table_id).schema
    schema_fields = {field.name for field in table_schema}
    df_columns = set(df.columns)

    if not df_columns.issubset(schema_fields):
        extra_cols = df_columns - schema_fields
        missing_cols = schema_fields - df_columns - {'update_timestamp'} # update_timestamp can be null
        error_msg = f"Schema mismatch for {target_table_name}. Extra in source: {extra_cols}, Missing in source: {missing_cols}"
        raise ValueError(error_msg)

    # 3. Configure the load job
    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
        autodetect=False, # Schema is predefined
    )

    # 4. Execute the load job with retry logic
    max_retries = 3
    for attempt in range(max_retries):
        try:
            job = client.load_table_from_dataframe(df, full_table_id, job_config=job_config)
            job.result()  # Wait for the job to complete
            print(f"Successfully loaded {job.output_rows} rows to {full_table_id}.")
            return job.output_rows
        except GoogleAPICallError as e:
            print(f"Attempt {attempt + 1} failed with API error: {e}. Retrying...")
            time.sleep(2 ** attempt) # Exponential backoff
        except Exception as e:
            # For non-retryable errors, fail immediately
            raise e

    raise Exception(f"Failed to load data to {full_table_id} after {max_retries} attempts.")

# =============================================================================
# MAIN EXECUTION BLOCK
# =============================================================================

def main():
    """Main function to orchestrate the ingestion process for all tables."""
    print("--- Starting Bronze Layer Ingestion Process ---")
    
    try:
        source_engine = get_sqlalchemy_engine()
        bq_client = get_bigquery_client()
    except Exception as e:
        print(f"Failed to initialize database connections. Aborting. Error: {e}")
        return

    for source_table, target_table in TABLE_MAPPING.items():
        print(f"\n--- Processing table: {source_table} -> {target_table} ---")
        start_time = datetime.utcnow()
        row_count = 0
        status = 'Failed'
        error_message = None

        try:
            # 1. Extract data from source
            data_df = extract_from_source(source_engine, source_table)
            row_count = len(data_df)

            if row_count > 0:
                # 2. Load data into BigQuery Bronze table
                loaded_rows = load_to_bronze(bq_client, data_df, target_table)
                if loaded_rows == row_count:
                    status = 'Success'
                else:
                    error_message = f"Row count mismatch. Extracted: {row_count}, Loaded: {loaded_rows}"
            else:
                status = 'Success' # No rows to load is a success case
                print(f"No new data to load for {source_table}.")

        except Exception as e:
            error_message = str(e)
            print(f"An error occurred during the processing of {source_table}: {error_message}")
        
        finally:
            # 3. Log the outcome to the audit table
            log_audit_record(
                client=bq_client,
                source_table=source_table,
                target_table=f"{BQ_BRONZE_DATASET}.{target_table}",
                start_time=start_time,
                row_count=row_count,
                status=status,
                error_message=error_message
            )

    print("\n--- Bronze Layer Ingestion Process Finished ---")

if __name__ == "__main__":
    main()