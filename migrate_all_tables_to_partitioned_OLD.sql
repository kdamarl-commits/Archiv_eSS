/* Copy all tables from eSS_Bronze to Archive_eSS */

config {
  type: "operations",
  hasOutput: false
}

-- 1. Create the target dataset in the 'US' location if it does not already exist
CREATE SCHEMA IF NOT EXISTS `tabc-eds-test.Archive_eSS`
OPTIONS(
  location="US"
);

-- 2. Loop through every table in the eSS_Bronze dataset automatically
FOR record IN (
  SELECT table_name 
  FROM `tabc-eds-test.eSS_Bronze.INFORMATION_SCHEMA.TABLES` 
  WHERE table_type = 'BASE TABLE'
)
DO
  -- 3. Dynamically copy each table into the newly ensured Archive_eSS dataset
  EXECUTE IMMEDIATE FORMAT("""
    CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.%s`
    AS SELECT * FROM `tabc-eds-test.eSS_Bronze.%s`
  """, record.table_name, record.table_name);
END FOR;

/* Deleted backup files after the migration and review with Tom */

/* Partitioned 6 tables from eSS_Bronze into Archive_eSS */

config {
  type: "operations",
  hasOutput: true,
  schema: "Archive_eSS",
  name: "migrate_all_tables_to_partitioned",
  description: "One-time operation to safely transition all 6 eSS_Bronze tables to Archive_eSS. Transactions are partitioned and clustered; Monthly/Quarterly are only clustered."
}

-- =========================================================================
-- 1. SESSIONS TRANSACTIONS (Partitioned & Clustered)
-- =========================================================================
-- 1. Create a temporary partitioned and clustered copy of the table
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Sessions_Transactions-temp`
PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Sessions_Transactions-tbl`;

-- 2. Drop the old non-partitioned table
DROP TABLE `tabc-eds-test.Archive_eSS.Sessions_Transactions-tbl`;

-- 3. Copy the temporary table structure and data back to the original name
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Sessions_Transactions-tbl`
PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Sessions_Transactions-temp`;

-- 4. Clean up the temporary table
DROP TABLE `tabc-eds-test.Archive_eSS.Sessions_Transactions-temp`;


-- =========================================================================
-- 2. TRAINEES TRANSACTIONS (Partitioned & Clustered)
-- =========================================================================
-- 1. Create a temporary partitioned and clustered copy of the table
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Trainees_Transactions-temp`
PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Trainees_Transactions-tbl`;

-- 2. Drop the old non-partitioned table
DROP TABLE `tabc-eds-test.Archive_eSS.Trainees_Transactions-tbl`;

-- 3. Copy the temporary table structure and data back to the original name
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Trainees_Transactions-tbl`
PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Trainees_Transactions-temp`;

-- 4. Clean up the temporary table
DROP TABLE `tabc-eds-test.Archive_eSS.Trainees_Transactions-temp`;


-- =========================================================================
-- 3. SESSIONS MONTHLY (Clustered Only)
-- =========================================================================
-- 1. Create a temporary clustered copy of the table
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Sessions_Monthly-temp`
-- PARTITION BY execution_date
CLUSTER BY FY, FM
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Sessions_Monthly-tbl`;

-- 2. Drop the old table
DROP TABLE `tabc-eds-test.Archive_eSS.Sessions_Monthly-tbl`;

-- 3. Copy the temporary table structure and data back to the original name
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Sessions_Monthly-tbl`
-- PARTITION BY execution_date
CLUSTER BY FY, FM
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Sessions_Monthly-temp`;

-- 4. Clean up the temporary table
DROP TABLE `tabc-eds-test.Archive_eSS.Sessions_Monthly-temp`;


-- =========================================================================
-- 4. SESSIONS QUARTERLY (Clustered Only)
-- =========================================================================
-- 1. Create a temporary clustered copy of the table
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Sessions_Quarterly-temp`
-- PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Sessions_Quarterly-tbl`;

-- 2. Drop the old table
DROP TABLE `tabc-eds-test.Archive_eSS.Sessions_Quarterly-tbl`;

-- 3. Copy the temporary table structure and data back to the original name
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Sessions_Quarterly-tbl`
-- PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Sessions_Quarterly-temp`;

-- 4. Clean up the temporary table
DROP TABLE `tabc-eds-test.Archive_eSS.Sessions_Quarterly-temp`;


-- =========================================================================
-- 5. TRAINEES MONTHLY (Clustered Only)
-- =========================================================================
-- 1. Create a temporary clustered copy of the table
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Trainees_Monthly-temp`
-- PARTITION BY execution_date
CLUSTER BY FY, FM
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Trainees_Monthly-tbl`;

-- 2. Drop the old table
DROP TABLE `tabc-eds-test.Archive_eSS.Trainees_Monthly-tbl`;

-- 3. Copy the temporary table structure and data back to the original name
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Trainees_Monthly-tbl`
-- PARTITION BY execution_date
CLUSTER BY FY, FM
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Trainees_Monthly-temp`;

-- 4. Clean up the temporary table
DROP TABLE `tabc-eds-test.Archive_eSS.Trainees_Monthly-temp`;


-- =========================================================================
-- 6. TRAINEES QUARTERLY (Clustered Only)
-- =========================================================================
-- 1. Create a temporary clustered copy of the table
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Trainees_Quarterly-temp`
-- PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Trainees_Quarterly-tbl`;

-- 2. Drop the old table
DROP TABLE `tabc-eds-test.Archive_eSS.Trainees_Quarterly-tbl`;

-- 3. Copy the temporary table structure and data back to the original name
CREATE OR REPLACE TABLE `tabc-eds-test.Archive_eSS.Trainees_Quarterly-tbl`
-- PARTITION BY execution_date
CLUSTER BY FY, FQ
AS SELECT * FROM `tabc-eds-test.Archive_eSS.Trainees_Quarterly-temp`;

-- 4. Clean up the temporary table
DROP TABLE `tabc-eds-test.Archive_eSS.Trainees_Quarterly-temp`;
