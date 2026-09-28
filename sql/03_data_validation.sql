-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 03_data_validation.sql
-- ============================================================
-- Purpose:
-- Documents the validation checks performed after loading the
-- HCES 2023-24 data into the relational MySQL database.
-- ============================================================

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. Final table row counts
-- ------------------------------------------------------------

SELECT 'households' AS object_name, COUNT(*) AS row_count
FROM households

UNION ALL

SELECT 'persons', COUNT(*)
FROM persons

UNION ALL

SELECT 'household_economic_profile', COUNT(*)
FROM household_economic_profile

UNION ALL

SELECT 'household_welfare_digital', COUNT(*)
FROM household_welfare_digital

UNION ALL

SELECT 'household_durables', COUNT(*)
FROM household_durables

UNION ALL

SELECT 'household_consumption', COUNT(*)
FROM household_consumption;


-- ------------------------------------------------------------
-- 2. Household natural-key uniqueness
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_households,
    COUNT(DISTINCT CONCAT_WS('|',
        Survey_Name,
        Year,
        FSU_Serial_No,
        Sector,
        State,
        NSS_Region,
        District,
        Stratum,
        Sub_stratum,
        Panel,
        Sub_sample,
        FOD_Sub_Region,
        Sample_SU_No,
        Sample_Sub_Division_No,
        Second_Stage_Stratum_No,
        Sample_Household_No
    )) AS unique_household_keys
FROM households;


-- Expected:
-- total_households = 261,953
-- unique_household_keys = 261,953


-- ------------------------------------------------------------
-- 3. Person-level key uniqueness
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_person_records,
    COUNT(DISTINCT household_id, Person_Serial_No)
        AS unique_person_keys
FROM persons;


-- Expected:
-- total_person_records = 1,107,221
-- unique_person_keys = 1,107,221


-- ------------------------------------------------------------
-- 4. Consumption key uniqueness
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_consumption_records,
    COUNT(DISTINCT household_id, Item_Code)
        AS unique_consumption_keys
FROM household_consumption;


-- Expected:
-- total_consumption_records = 12,754,437
-- unique_consumption_keys = 12,754,437


-- ------------------------------------------------------------
-- 5. Households represented in consumption data
-- ------------------------------------------------------------

SELECT
    COUNT(DISTINCT household_id) AS households_with_consumption,
    COUNT(*) AS consumption_records
FROM household_consumption;


-- Validated result:
-- 261,245 households have Level 05 consumption records.
-- 708 sampled households have no Level 05 records.


-- ------------------------------------------------------------
-- 6. Check unmatched household references
-- ------------------------------------------------------------

SELECT COUNT(*) AS unmatched_person_records
FROM persons p
LEFT JOIN households h
    ON p.household_id = h.household_id
WHERE h.household_id IS NULL;


SELECT COUNT(*) AS unmatched_economic_records
FROM household_economic_profile e
LEFT JOIN households h
    ON e.household_id = h.household_id
WHERE h.household_id IS NULL;


SELECT COUNT(*) AS unmatched_welfare_records
FROM household_welfare_digital w
LEFT JOIN households h
    ON w.household_id = h.household_id
WHERE h.household_id IS NULL;


SELECT COUNT(*) AS unmatched_durable_records
FROM household_durables d
LEFT JOIN households h
    ON d.household_id = h.household_id
WHERE h.household_id IS NULL;


SELECT COUNT(*) AS unmatched_consumption_records
FROM household_consumption c
LEFT JOIN households h
    ON c.household_id = h.household_id
WHERE h.household_id IS NULL;


-- Expected result for all five checks:
-- 0 unmatched records


-- ------------------------------------------------------------
-- 7. Household-level table coverage
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS households,
    COUNT(e.household_id) AS economic_profile_matches,
    COUNT(w.household_id) AS welfare_matches,
    COUNT(d.household_id) AS durable_matches
FROM households h
LEFT JOIN household_economic_profile e
    ON h.household_id = e.household_id
LEFT JOIN household_welfare_digital w
    ON h.household_id = w.household_id
LEFT JOIN household_durables d
    ON h.household_id = d.household_id;


-- Expected:
-- households = 261,953
-- economic_profile_matches = 261,953
-- welfare_matches = 261,953
-- durable_matches = 261,953


-- ------------------------------------------------------------
-- 8. Sector distribution
-- ------------------------------------------------------------

SELECT
    Sector,
    COUNT(*) AS households
FROM households
GROUP BY Sector
ORDER BY Sector;


-- Validated coding:
-- Sector 1 = Rural
-- Sector 2 = Urban
--
-- Rural  = 154,357
-- Urban  = 107,596


-- ------------------------------------------------------------
-- 9. Multiplier range check
-- ------------------------------------------------------------

SELECT
    MIN(Multiplier) AS minimum_multiplier,
    MAX(Multiplier) AS maximum_multiplier,
    AVG(Multiplier) AS average_multiplier
FROM households;


-- Multiplier treatment:
-- HCES multiplier values were used with the survey's scaling
-- convention. For weighted calculations in this project,
-- Multiplier / 100.0 was used.


-- ------------------------------------------------------------
-- 10. Final validation summary
-- ------------------------------------------------------------
--
-- The completed database was validated for:
--
-- 1. Table row counts
-- 2. Household natural-key uniqueness
-- 3. Person-level key uniqueness
-- 4. Consumption household/item uniqueness
-- 5. Household coverage
-- 6. Foreign-key mapping
-- 7. Rural/urban sector distribution
-- 8. Survey multiplier range
--
-- These checks confirmed that the core relational structure
-- was suitable for the subsequent analytical SQL workflow.
-- ------------------------------------------------------------