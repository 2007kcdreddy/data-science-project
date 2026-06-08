
-- BANKING FRAUD DETECTION - SQL SCRIPT
-- ==============================================================================


-- STEP 1: DATABASE INITIALIZATION

CREATE DATABASE data_apex;
USE data_apex;


-- STEP 2: SCHEMA CREATION
-- Define the table structure to hold our cleaned 200,000 transaction records

CREATE TABLE BankTransactions (
    Customer_ID VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    State VARCHAR(50),
    City VARCHAR(50),
    Bank_Branch VARCHAR(100),
    Account_Type VARCHAR(20),
    Transaction_ID VARCHAR(50) PRIMARY KEY, -- Unique identifier for each transaction
    Transaction_Date DATE,
    Transaction_Time TIME,
    Transaction_Amount DECIMAL(15, 2),
    Merchant_ID VARCHAR(50),
    Transaction_Type VARCHAR(20),
    Merchant_Category VARCHAR(50),
    Account_Balance DECIMAL(15, 2),
    Transaction_Device VARCHAR(50),
    Transaction_Location VARCHAR(100),
    Device_Type VARCHAR(20),
    Is_Fraud INT,                           -- Target variable: 1 for fraud, 0 for legitimate
    Transaction_Currency VARCHAR(10),
    Transaction_Description TEXT,
    Transaction_Hour INT,
    Day_of_Week VARCHAR(15),
    Month VARCHAR(15)
);


USE data_apex;


-- STEP 3: DATA IMPORT
-- Enable bulk loading and import the cleaned CSV file from local storage

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- Load the data, skipping the header row
LOAD DATA LOCAL INFILE 'C:/Users/karna/OneDrive/Desktop/dataapex/Cleaned_Bank_Transactions.csv'
INTO TABLE banktransactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- STEP 4: DATA VERIFICATION
-- Check if the data imported correctly

-- Verify the total number of records imported (Should be 200,000)
SELECT count(*) FROM banktransactions;

-- Preview the first 10 rows to ensure columns aligned properly
SELECT * FROM banktransactions LIMIT 10;


-- STEP 5: FRAUD ANALYSIS QUERIES
-- Extracting risk insights using aggregations



-- QUERY 1: Fraud by Location (State)
-- Identifies the top 5 states with the highest volume of fraudulent transactions

SELECT State, COUNT(*) AS Total_Transactions,
SUM(Is_Fraud) AS Fraud_Cases
FROM BankTransactions
GROUP BY State
ORDER BY Fraud_Cases DESC
LIMIT 5;


-- QUERY 2: Fraud by Transaction Type
-- Analyzes which transaction methods (e.g., Transfer, Withdrawal) carry the most risk

SELECT 
    Transaction_Type, 
    COUNT(*) AS Total_Transactions, 
    SUM(Is_Fraud) AS Fraud_Cases
FROM banktransactions
GROUP BY Transaction_Type
ORDER BY Fraud_Cases DESC;


-- QUERY 3: Fraud by Specific Device 
-- Shows which transaction devices are most vulnerable to fraud

SELECT 
    Transaction_Device, 
    COUNT(*) AS Total_Transactions, 
    SUM(Is_Fraud) AS Fraud_Cases
FROM banktransactions
GROUP BY Transaction_Device
ORDER BY Fraud_Cases DESC;


-- QUERY 4: Fraud by Day of the Week
-- Checks if certain days of the week have higher fraud rates

SELECT 
    Day_of_Week, 
    COUNT(*) AS Total_Transactions, 
    SUM(Is_Fraud) AS Fraud_Cases
FROM banktransactions
GROUP BY Day_of_Week
ORDER BY Fraud_Cases DESC;

-- 
--  Fraud by Transaction Description
-- Checks if fraudsters use specific descriptions to hide their activity

SELECT 
    Transaction_Description, 
    COUNT(*) AS Total_Transactions, 
    SUM(Is_Fraud) AS Fraud_Cases
FROM banktransactions
GROUP BY Transaction_Description
ORDER BY Fraud_Cases DESC;


--  Fraud by Merchant Category
-- Identifies which types of merchants are most heavily targeted by fraudsters

SELECT 
    Merchant_Category, 
    COUNT(*) AS Total_Transactions, 
    SUM(Is_Fraud) AS Fraud_Cases
FROM banktransactions
GROUP BY Merchant_Category
ORDER BY Fraud_Cases DESC;


-- QUERY 5: Financial Impact Comparison (Formatted)
-- Compares average and maximum transaction amounts (Fraud vs Legitimate)
-- Uses a CASE statement to make the output highly readable for stakeholders

SELECT 
    CASE WHEN Is_Fraud = 1 THEN 'Fraudulent' ELSE 'Legitimate' END AS Transaction_Status,
    COUNT(*) AS Total_Count,
    ROUND(AVG(Transaction_Amount), 2) AS Average_Amount, 
    MAX(Transaction_Amount) AS Max_Amount
FROM banktransactions
GROUP BY Is_Fraud;


--  Financial Impact Comparison (Basic)
-- A simpler version of Query 7 comparing averages and max amounts

SELECT Is_Fraud, AVG(Transaction_Amount) AS Avg_Amount, MAX(Transaction_Amount) AS Max_Amount
FROM BankTransactions
GROUP BY Is_Fraud;