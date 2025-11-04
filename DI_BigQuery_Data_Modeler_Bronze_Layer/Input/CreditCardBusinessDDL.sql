-- Dataset: credit_card

-- Table: Applicants
CREATE TABLE `credit_card.Applicants` (
  applicant_id INT64 NOT NULL, -- PRIMARY KEY
  full_name STRING NOT NULL,
  email STRING,
  phone_number STRING NOT NULL,
  dob DATE NOT NULL,
  ssn STRING,
  channel STRING
)
OPTIONS (
  description="Applicants table (constraints not enforced: PRIMARY KEY, UNIQUE)"
);

-- Table: Card_Products
CREATE TABLE `credit_card.Card_Products` (
  card_product_id INT64 NOT NULL, -- PRIMARY KEY
  card_name STRING NOT NULL,
  category STRING,
  interest_rate FLOAT64, -- CHECK (interest_rate >= 0)
  annual_fee FLOAT64 -- CHECK (annual_fee >= 0)
)
OPTIONS (
  description="Card Products table"
);

-- Table: Applications
CREATE TABLE `credit_card.Applications` (
  application_id INT64 NOT NULL, -- PRIMARY KEY
  applicant_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applicants
  card_product_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Card_Products
  application_date DATE NOT NULL,
  status STRING NOT NULL,
  approval_date DATE,
  rejection_reason STRING
)
OPTIONS (
  description="Applications table (relationships not enforced)"
);

-- Table: Credit_Scores
CREATE TABLE `credit_card.Credit_Scores` (
  credit_score_id INT64 NOT NULL, -- PRIMARY KEY
  applicant_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applicants
  score INT64, -- CHECK (score BETWEEN 300 AND 900)
  score_date DATE NOT NULL
)
OPTIONS (
  description="Credit Scores table"
);

-- Table: Document_Submissions
CREATE TABLE `credit_card.Document_Submissions` (
  document_id INT64 NOT NULL, -- PRIMARY KEY
  application_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applications
  document_type STRING,
  upload_date DATE NOT NULL,
  verified_flag BOOL
)
OPTIONS (
  description="Document Submissions table"
);

-- Table: Verification_Results
CREATE TABLE `credit_card.Verification_Results` (
  verification_id INT64 NOT NULL, -- PRIMARY KEY
  application_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applications
  verification_type STRING,
  result STRING,
  verified_on DATE
)
OPTIONS (
  description="Verification Results table"
);

-- Table: Underwriting_Decisions
CREATE TABLE `credit_card.Underwriting_Decisions` (
  decision_id INT64 NOT NULL, -- PRIMARY KEY
  application_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applications
  decision STRING,
  decision_reason STRING,
  decision_date DATE
)
OPTIONS (
  description="Underwriting Decisions table"
);

-- Table: Campaigns
CREATE TABLE `credit_card.Campaigns` (
  campaign_id INT64 NOT NULL, -- PRIMARY KEY
  campaign_name STRING NOT NULL,
  channel STRING,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
)
OPTIONS (
  description="Campaigns table"
);

-- Table: Application_Campaigns
CREATE TABLE `credit_card.Application_Campaigns` (
  app_campaign_id INT64 NOT NULL, -- PRIMARY KEY
  application_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applications
  campaign_id INT64 NOT NULL -- FOREIGN KEY REFERENCES Campaigns
)
OPTIONS (
  description="Application Campaigns table"
);

-- Table: Activations
CREATE TABLE `credit_card.Activations` (
  activation_id INT64 NOT NULL, -- PRIMARY KEY
  application_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applications
  activation_date DATE,
  first_transaction_amount FLOAT64 -- CHECK (first_transaction_amount >= 0)
)
OPTIONS (
  description="Activations table"
);

-- Table: Fraud_Checks
CREATE TABLE `credit_card.Fraud_Checks` (
  fraud_check_id INT64 NOT NULL, -- PRIMARY KEY
  application_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applications
  check_type STRING,
  check_result STRING,
  check_date DATE
)
OPTIONS (
  description="Fraud Checks table"
);

-- Table: Offers
CREATE TABLE `credit_card.Offers` (
  offer_id INT64 NOT NULL, -- PRIMARY KEY
  card_product_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Card_Products
  offer_detail STRING,
  valid_from DATE,
  valid_to DATE
)
OPTIONS (
  description="Offers table"
);

-- Table: Offer_Performance
CREATE TABLE `credit_card.Offer_Performance` (
  offer_analytics_id INT64 NOT NULL, -- PRIMARY KEY
  offer_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Offers
  applications_count INT64, -- CHECK (applications_count >= 0)
  activations_count INT64 -- CHECK (activations_count >= 0)
)
OPTIONS (
  description="Offer Performance table"
);

-- Table: Address_History
CREATE TABLE `credit_card.Address_History` (
  address_id INT64 NOT NULL, -- PRIMARY KEY
  applicant_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applicants
  address_type STRING,
  street STRING,
  city STRING,
  state STRING,
  zip STRING
)
OPTIONS (
  description="Address History table"
);

-- Table: Employment_Info
CREATE TABLE `credit_card.Employment_Info` (
  employment_id INT64 NOT NULL, -- PRIMARY KEY
  applicant_id INT64 NOT NULL, -- FOREIGN KEY REFERENCES Applicants
  employer_name STRING,
  job_title STRING,
  income FLOAT64, -- CHECK (income >= 0)
  employment_type STRING
)
OPTIONS (
  description="Employment Info table"
);
