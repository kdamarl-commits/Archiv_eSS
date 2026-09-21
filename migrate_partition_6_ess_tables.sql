config {
  type: "operations",
  hasOutput: true,
  schema: "Archive_eSS",
  name: "create_all_ess_tables",
  description: "One-time setup script to create and initialize all 6 partitioned and clustered Archive_eSS tables from eSS_Bronze source."
}

-- =========================================================================
-- 1. SESSIONS TRANSACTIONS (Partitioned & Clustered)
-- =========================================================================
-- Explicitly drop the table first to reset the partitioning spec
DROP TABLE IF EXISTS `tabc-eds-test.Archive_eSS.Sessions_Transactions-tbl`;

CREATE TABLE IF NOT EXISTS `tabc-eds-test.Archive_eSS.Sessions_Transactions-tbl`
PARTITION BY execution_date
CLUSTER BY FY, FQ
AS
SELECT
  CAST(brz_insert_date AS TIMESTAMP) AS brz_insert_date,
  CAST(FY AS INT64) AS FY,
  CAST(FQ AS INT64) AS FQ,
  CAST(FM AS INT64) AS FM,
  brz_history, 
  CAST(brz_is_active AS BOOLEAN) AS brz_is_active,
  CAST(id AS INT64) AS id,
  CAST(status AS STRING) AS status,
  CAST(date AS DATE) AS date,
  CAST(reported_at AS DATE) AS reported_at,
  CAST(created_at AS DATE) AS created_at,
  CAST(execution_date AS DATE) AS execution_date,
  CAST(execution_timestamp AS TIMESTAMP) AS execution_timestamp
FROM
  `tabc-eds-test.eSS_Bronze.Sessions_Transactions-tbl`;

-- =========================================================================
-- 2. TRAINEES TRANSACTIONS (Partitioned & Clustered)
-- =========================================================================
-- Explicitly drop the table first to reset the partitioning spec
DROP TABLE IF EXISTS `tabc-eds-test.Archive_eSS.Trainees_Transactions-tbl`;

CREATE TABLE IF NOT EXISTS `tabc-eds-test.Archive_eSS.Trainees_Transactions-tbl`
PARTITION BY execution_date
CLUSTER BY FY, FQ
AS
SELECT
  CAST(brz_insert_date AS TIMESTAMP) AS brz_insert_date,
  CAST(FY AS INT64) AS FY,
  CAST(FQ AS INT64) AS FQ,
  CAST(FM AS INT64) AS FM,
  CAST(brz_is_active AS BOOLEAN) AS brz_is_active,
  CAST(id AS INT64) AS id,
  CAST(first_name AS STRING) AS first_name,
  CAST(last_name AS STRING) AS last_name,
  CAST(license_id AS INT64) AS license_id,
  CAST(ssn AS STRING) AS ssn,
  CAST(date_of_birth AS DATE) AS date_of_birth,
  CAST(certificate_number AS INT64) AS certificate_number,
  CAST(certificate_issue_date AS DATE) AS certificate_issue_date,
  CAST(session_id AS INT64) AS session_id,
  CAST(execution_date AS DATE) AS execution_date,
  CAST(execution_timestamp AS TIMESTAMP) AS execution_timestamp,
  CAST(Archive_ROW_HASH AS BYTES) AS Archive_ROW_HASH,
  CAST(ARCH_ROW_HASH AS BYTES) AS ARCH_ROW_HASH,
  CAST(ARCH_PK_HASH AS BYTES) AS ARCH_PK_HASH
FROM
  `tabc-eds-test.eSS_Bronze.Trainees_Transactions-tbl`;

-- =========================================================================
-- 3. SESSIONS MONTHLY (Clustered Only)
-- =========================================================================
-- Explicitly drop the table first to reset the partitioning spec
DROP TABLE IF EXISTS `tabc-eds-test.Archive_eSS.Sessions_Monthly-tbl`;

CREATE TABLE IF NOT EXISTS `tabc-eds-test.Archive_eSS.Sessions_Monthly-tbl`
CLUSTER BY FY, FM
AS
SELECT
  CAST(FY AS INT64) AS FY,
  CAST(FM AS INT64) AS FM,
  CAST(session_count AS INT64) AS session_count,
  CAST(first_transaction_date AS DATE) AS first_transaction_date,
  CAST(last_transaction_date AS DATE) AS last_transaction_date,
  CAST(execution_date AS DATE) AS execution_date,
  CAST(execution_timestamp AS TIMESTAMP) AS execution_timestamp
FROM
  `tabc-eds-test.eSS_Bronze.Sessions_Monthly-tbl`;

-- =========================================================================
-- 4. SESSIONS QUARTERLY (Clustered Only)
-- =========================================================================
-- Explicitly drop the table first to reset the partitioning spec
DROP TABLE IF EXISTS `tabc-eds-test.Archive_eSS.Sessions_Quarterly-tbl`;

CREATE TABLE IF NOT EXISTS `tabc-eds-test.Archive_eSS.Sessions_Quarterly-tbl`
CLUSTER BY FY, FQ
AS
SELECT
  CAST(FY AS INT64) AS FY,
  CAST(FQ AS INT64) AS FQ,
  CAST(session_count AS INT64) AS session_count,
  CAST(first_transaction_date AS DATE) AS first_transaction_date,
  CAST(last_transaction_date AS DATE) AS last_transaction_date,
  CAST(execution_date AS DATE) AS execution_date,
  CAST(execution_timestamp AS TIMESTAMP) AS execution_timestamp
FROM
  `tabc-eds-test.eSS_Bronze.Sessions_Quarterly-tbl`;

-- =========================================================================
-- 5. TRAINEES MONTHLY (Clustered Only)
-- =========================================================================
-- Explicitly drop the table first to reset the partitioning spec
DROP TABLE IF EXISTS `tabc-eds-test.Archive_eSS.Trainees_Monthly-tbl`;

CREATE TABLE IF NOT EXISTS `tabc-eds-test.Archive_eSS.Trainees_Monthly-tbl`
CLUSTER BY FY, FM
AS
SELECT
  CAST(FY AS INT64) AS FY,
  CAST(FM AS INT64) AS FM,
  CAST(certificate_count AS INT64) AS certificate_count,
  CAST(first_transaction_date AS DATE) AS first_transaction_date,
  CAST(last_transaction_date AS DATE) AS last_transaction_date,
  CAST(execution_date AS DATE) AS execution_date,
  CAST(execution_timestamp AS TIMESTAMP) AS execution_timestamp
FROM
  `tabc-eds-test.eSS_Bronze.Trainees_Monthly-tbl`;

-- =========================================================================
-- 6. TRAINEES QUARTERLY (Clustered Only)
-- =========================================================================
-- Explicitly drop the table first to reset the partitioning spec
DROP TABLE IF EXISTS `tabc-eds-test.Archive_eSS.Trainees_Quarterly-tbl`;

CREATE TABLE IF NOT EXISTS `tabc-eds-test.Archive_eSS.Trainees_Quarterly-tbl`
CLUSTER BY FY, FQ
AS
SELECT
  CAST(FY AS INT64) AS FY,
  CAST(FQ AS INT64) AS FQ,
  CAST(certificate_count AS INT64) AS certificate_count,
  CAST(first_transaction_date AS DATE) AS first_transaction_date,
  CAST(last_transaction_date AS DATE) AS last_transaction_date,
  CAST(execution_date AS DATE) AS execution_date,
  CAST(execution_timestamp AS TIMESTAMP) AS execution_timestamp
FROM
  `tabc-eds-test.eSS_Bronze.Trainees_Quarterly-tbl`;
