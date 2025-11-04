-- Card_Products (these products are referenced throughout)
INSERT INTO Card_Products VALUES (1, 'Platinum Cashback Card', 'Cashback', 18.5, 2500);
INSERT INTO Card_Products VALUES (2, 'Elite Travel Card', 'Travel', 21.0, 3500);
INSERT INTO Card_Products VALUES (3, 'Fuel Saver Card', 'Fuel', 15.9, 999);
INSERT INTO Card_Products VALUES (4, 'Premium Lifestyle Card', 'Premium', 24.0, 5999);
INSERT INTO Card_Products VALUES (5, 'Everyday Value Card', 'Cashback', 17.0, 0);

-- Offers
INSERT INTO Offers VALUES (1, 1, '5% Cashback on Groceries', '2025-07-01', '2025-12-31');
INSERT INTO Offers VALUES (2, 2, 'Free Lounge Access', '2025-07-01', '2025-12-31');
INSERT INTO Offers VALUES (3, 3, '1% Fuel Surcharge Waiver', '2025-07-01', '2025-12-31');
INSERT INTO Offers VALUES (4, 4, 'Welcome Gift Voucher', '2025-07-01', '2025-09-30');
INSERT INTO Offers VALUES (5, 5, '0% Annual Fee for 1st Year', '2025-07-01', '2025-09-30');

-- Applicants
INSERT INTO Applicants VALUES (1,  'Alice Johnson',  'alice.johnson@example.com', '555-0001', '1990-08-15', '912-34-1001', 'Online');
INSERT INTO Applicants VALUES (2,  'Brian Smith',    'brian.smith@example.com',   '555-0002', '1986-11-20', '912-34-1002', 'Branch');
INSERT INTO Applicants VALUES (3,  'Cynthia Patel',  'c.patel@example.com',       '555-0003', '1977-09-13', '912-34-1003', 'Mobile');
INSERT INTO Applicants VALUES (4,  'David Lee',      'dlee@example.com',          '555-0004', '1982-05-06', '912-34-1004', 'Partner');
INSERT INTO Applicants VALUES (5,  'Emma Brown',     'emma.brown@example.com',    '555-0005', '1995-12-30', '912-34-1005', 'Online');

-- Credit_Scores
INSERT INTO Credit_Scores VALUES (1, 1, 780, '2025-06-30');
INSERT INTO Credit_Scores VALUES (2, 2, 590, '2025-06-30');
INSERT INTO Credit_Scores VALUES (3, 3, 735, '2025-06-30');
INSERT INTO Credit_Scores VALUES (4, 4, 820, '2025-06-30');
INSERT INTO Credit_Scores VALUES (5, 5, 760, '2025-06-30');

-- Applications
INSERT INTO Applications VALUES (1, 1, 1,  '2025-07-01', 'Approved', '2025-07-03', NULL);
INSERT INTO Applications VALUES (2, 2, 2,  '2025-07-02', 'Rejected', NULL, 'Low credit score');
INSERT INTO Applications VALUES (3, 3, 4,  '2025-07-02', 'Pending', NULL, NULL);
INSERT INTO Applications VALUES (4, 4, 3,  '2025-07-02', 'Approved', '2025-07-05', NULL);
INSERT INTO Applications VALUES (5, 5, 2,  '2025-07-03', 'Approved', '2025-07-08', NULL);

-- Address_History 
INSERT INTO Address_History VALUES (1, 1, 'Current',   '123 Elm St',  'New York',   'NY', '10001');
INSERT INTO Address_History VALUES (2, 1, 'Permanent', '900 Oak Ave', 'Brooklyn',   'NY', '11201');
INSERT INTO Address_History VALUES (3, 2, 'Current',   '5 Lakeview',  'Dallas',     'TX', '75201');
INSERT INTO Address_History VALUES (4, 2, 'Permanent', '98 Central',  'Houston',    'TX', '77002');

-- Employment_Info
INSERT INTO Employment_Info VALUES (1,  1,  'Acme Corp',   'Data Analyst',     9800,  'Salaried');
INSERT INTO Employment_Info VALUES (2,  2,  'Smith Retail','Branch Manager',   7500,  'Salaried');
INSERT INTO Employment_Info VALUES (3,  3,  'Patel Stores','Owner',           16500, 'Self-employed');
INSERT INTO Employment_Info VALUES (4,  4,  'Tech Advance','Engineer',         12000, 'Salaried');

-- Document_Submissions
INSERT INTO Document_Submissions VALUES (101, 1, 'ID',           '2025-07-01', TRUE);
INSERT INTO Document_Submissions VALUES (102, 1, 'Income Proof',  '2025-07-01', TRUE);
INSERT INTO Document_Submissions VALUES (103, 2, 'ID',          '2025-07-02', TRUE);
INSERT INTO Document_Submissions VALUES (104, 2, 'Address Proof','2025-07-02', FALSE);

-- Verification_Results
INSERT INTO Verification_Results VALUES (1, 1, 'Identity', 'Pass', '2025-07-02');
INSERT INTO Verification_Results VALUES (2, 2, 'Income',   'Fail', '2025-07-03');
INSERT INTO Verification_Results VALUES (3, 3, 'Address',  'Pass', '2025-07-04');

-- Underwriting_Decisions
INSERT INTO Underwriting_Decisions VALUES (1, 1, 'Approved', NULL, '2025-07-03');
INSERT INTO Underwriting_Decisions VALUES (2, 2, 'Rejected', 'Low credit score', '2025-07-04');

-- Campaigns
INSERT INTO Campaigns VALUES (1, 'Summer Travel Bonanza', 'Email', '2025-06-01', '2025-08-31');
INSERT INTO Campaigns VALUES (2, 'Cashback Carnival',     'SMS',   '2025-07-01', '2025-08-31');
INSERT INTO Campaigns VALUES (3, 'Petrol Saver Week',     'Social','2025-07-10', '2025-07-31');
INSERT INTO Campaigns VALUES (4, 'Premium Welcome',       'Branch','2025-06-15', '2025-09-15');
INSERT INTO Campaigns VALUES (5, 'Everyday Offers',       'Email', '2025-07-01', '2025-09-30');

-- Application_Campaigns
INSERT INTO Application_Campaigns VALUES (1, 1, 2);
INSERT INTO Application_Campaigns VALUES (2, 2, 3);
INSERT INTO Application_Campaigns VALUES (3, 3, 1);

-- Activations 
INSERT INTO Activations VALUES (1, 1, '2025-07-04', 1200.0);
INSERT INTO Activations VALUES (2, 4, '2025-07-05', 950.5);
INSERT INTO Activations VALUES (3, 5, '2025-07-09', 2500.0);

-- Fraud_Checks 
INSERT INTO Fraud_Checks VALUES (1, 1, 'GeoIP',  'Pass',   '2025-07-01');
INSERT INTO Fraud_Checks VALUES (2, 2, 'Velocity','Review', '2025-07-02');
INSERT INTO Fraud_Checks VALUES (3, 3, 'Identity','Pass',   '2025-07-03');

-- Offer_Performance
INSERT INTO Offer_Performance VALUES (1, 1, 120, 48);
INSERT INTO Offer_Performance VALUES (2, 2, 95,  32);
INSERT INTO Offer_Performance VALUES (3, 3, 110, 59);
INSERT INTO Offer_Performance VALUES (4, 4, 75,  23);
INSERT INTO Offer_Performance VALUES (5, 5, 99,  44);