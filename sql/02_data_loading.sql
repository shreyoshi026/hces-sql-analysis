-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 02_data_loading.sql
-- ============================================================
-- Purpose:
-- Documents the data-loading workflow used to import the
-- HCES 2023-24 CSV files into MySQL.
--
-- Note:
-- Raw HCES files are intentionally excluded from GitHub because
-- the downloaded ZIP is approximately 244 MB and the extracted
-- CSV files occupy several GB.
--
-- The commands below document the loading environment and
-- workflow. They are not intended to be blindly rerun against
-- the completed database.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Select the project database
-- ------------------------------------------------------------

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 2. Enable LOCAL INFILE
-- ------------------------------------------------------------
-- Required for loading local CSV files into MySQL.

SET GLOBAL local_infile = 1;


-- ------------------------------------------------------------
-- 3. Verify LOCAL INFILE
-- ------------------------------------------------------------

SHOW VARIABLES LIKE 'local_infile';


-- Expected completed-project state:
-- local_infile = ON


-- ------------------------------------------------------------
-- 4. HCES data hierarchy used in the project
-- ------------------------------------------------------------
--
-- Level 01
--   Household identification and survey metadata
--
-- Level 02
--   Person-level information
--
-- Level 03
--   Household economic profile
--
-- Level 05
--   Item-level consumption records
--
-- Level 07
--   Welfare, education, health and digital-access information
--
-- Level 11
--   Durable goods and selected online purchases
--
-- Additional HCES levels were retained locally but were not
-- required for the core analytical workflow.
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- 5. Loading sequence
-- ------------------------------------------------------------
--
-- The project followed this sequence:
--
--   HCES Level 01
--       ↓
--   households
--
--   HCES Level 02
--       ↓
--   persons
--
--   HCES Level 03
--       ↓
--   household_economic_profile
--
--   HCES Level 07
--       ↓
--   household_welfare_digital
--
--   HCES Level 11
--       ↓
--   household_durables
--
--   HCES Level 05
--       ↓
--   household_consumption
--
-- Household-level tables were mapped to the generated
-- household_id using the full natural household key.
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- 6. Household natural key
-- ------------------------------------------------------------
-- The following fields identify a household across HCES levels:
--
-- Survey_Name
-- Year
-- FSU_Serial_No
-- Sector
-- State
-- NSS_Region
-- District
-- Stratum
-- Sub_stratum
-- Panel
-- Sub_sample
-- FOD_Sub_Region
-- Sample_SU_No
-- Sample_Sub_Division_No
-- Second_Stage_Stratum_No
-- Sample_Household_No
--
-- Questionnaire_No was NOT used as the household identity
-- because its value varies across HCES levels.
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- 7. Loading principle
-- ------------------------------------------------------------
--
-- CSV files were first loaded into staging structures where
-- necessary, followed by mapping records to the household_id
-- generated in the households table.
--
-- This avoided using Questionnaire_No as the primary household
-- identifier and preserved relational integrity across levels.
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- 8. Important data-loading validation
-- ------------------------------------------------------------
-- After loading, row counts were checked against the source
-- files and household-key uniqueness was validated.
--
-- Final validated row counts:
--
-- households                     261,953
-- persons                      1,107,221
-- household_economic_profile     261,953
-- household_welfare_digital      261,953
-- household_durables             261,953
-- household_consumption       12,754,437
-- ------------------------------------------------------------