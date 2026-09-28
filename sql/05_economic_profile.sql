-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 05_economic_profile.sql
-- ============================================================
-- Purpose:
-- Builds a household-level economic profile using HCES Level 03
-- information.
--
-- Analytical dimensions:
--   1. Household size
--   2. Land ownership
--   3. Economic activity status
--   4. Cooking energy
--   5. Lighting
--   6. Ration-card category
--
-- All results are descriptive characteristics of the HCES
-- sample.
-- ============================================================

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. Rural-urban household profile
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    COUNT(*) AS households,

    ROUND(AVG(e.HH_Size_FDQ), 2) AS avg_household_size,

    MIN(e.HH_Size_FDQ) AS minimum_household_size,

    MAX(e.HH_Size_FDQ) AS maximum_household_size,

    ROUND(
        AVG(e.Total_Area_Land_Owned_Acres),
        2
    ) AS avg_land_owned_acres,

    ROUND(
        AVG(
            CASE
                WHEN e.Total_Area_Land_Owned_Acres > 0
                THEN e.Total_Area_Land_Owned_Acres
            END
        ),
        2
    ) AS avg_land_among_landholders

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 2. Economic activity status
-- ------------------------------------------------------------
-- The source code is retained rather than assigning an
-- unverified substantive label.

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    e.Engaged_in_Economic_Activity_Las AS economic_activity_code,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY h.Sector),
        2
    ) AS share_pct

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id

GROUP BY
    h.Sector,
    e.Engaged_in_Economic_Activity_Las

ORDER BY
    h.Sector,
    economic_activity_code;


-- ------------------------------------------------------------
-- 3. Cooking energy
-- ------------------------------------------------------------
-- HCES coding used in the analysis:
--
-- 1  Firewood / chips
-- 2  LPG
-- 3  Other natural gas
-- 4  Dung cake
-- 5  Kerosene
-- 6  Coke / coal
-- 7  Gobar gas
-- 8  Other biogas
-- 9  Others
-- 10 Charcoal
-- 11 Electricity
-- 12 No cooking arrangement
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    CASE e.Energy_Source_Cooking
        WHEN 1 THEN 'Firewood / chips'
        WHEN 2 THEN 'LPG'
        WHEN 3 THEN 'Other natural gas'
        WHEN 4 THEN 'Dung cake'
        WHEN 5 THEN 'Kerosene'
        WHEN 6 THEN 'Coke / coal'
        WHEN 7 THEN 'Gobar gas'
        WHEN 8 THEN 'Other biogas'
        WHEN 9 THEN 'Others'
        WHEN 10 THEN 'Charcoal'
        WHEN 11 THEN 'Electricity'
        WHEN 12 THEN 'No cooking arrangement'
        ELSE 'Unknown'
    END AS cooking_energy,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY h.Sector),
        2
    ) AS share_pct

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id

GROUP BY
    h.Sector,
    e.Energy_Source_Cooking

ORDER BY
    h.Sector,
    households DESC;


-- ------------------------------------------------------------
-- 4. Lighting source
-- ------------------------------------------------------------
-- HCES coding used:
--
-- 1 Electricity
-- 2 Kerosene
-- 3 Other oil
-- 4 Gas
-- 5 Candle
-- 6 No lighting
-- 9 Others
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    CASE e.Energy_Source_Lighting
        WHEN 1 THEN 'Electricity'
        WHEN 2 THEN 'Kerosene'
        WHEN 3 THEN 'Other oil'
        WHEN 4 THEN 'Gas'
        WHEN 5 THEN 'Candle'
        WHEN 6 THEN 'No lighting'
        WHEN 9 THEN 'Others'
        ELSE 'Unknown'
    END AS lighting_source,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY h.Sector),
        2
    ) AS share_pct

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id

GROUP BY
    h.Sector,
    e.Energy_Source_Lighting

ORDER BY
    h.Sector,
    households DESC;


-- ------------------------------------------------------------
-- 5. Ration-card distribution
-- ------------------------------------------------------------
-- HCES coding used:
--
-- 0 No ration card
-- 1 AAY
-- 2 BPL
-- 3 APL
-- 4 PHH
-- 5 SFSS
-- 9 Others
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    CASE e.Ration_Card_Type
        WHEN 0 THEN 'No ration card'
        WHEN 1 THEN 'AAY'
        WHEN 2 THEN 'BPL'
        WHEN 3 THEN 'APL'
        WHEN 4 THEN 'PHH'
        WHEN 5 THEN 'SFSS'
        WHEN 9 THEN 'Others'
        ELSE 'Unknown'
    END AS ration_card_type,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY h.Sector),
        2
    ) AS share_pct

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id

GROUP BY
    h.Sector,
    e.Ration_Card_Type

ORDER BY
    h.Sector,
    households DESC;


-- ------------------------------------------------------------
-- 6. Create household economic profile view
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_household_economic_profile AS

SELECT

    h.household_id,

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    e.HH_Size_FDQ AS household_size,

    e.Total_Area_Land_Owned_Acres AS land_owned_acres,

    CASE
        WHEN e.Engaged_in_Economic_Activity_Las = 1
            THEN 'Code 1'
        WHEN e.Engaged_in_Economic_Activity_Las = 2
            THEN 'Code 2'
        ELSE 'Unknown'
    END AS economic_activity_status,

    CASE e.Energy_Source_Cooking
        WHEN 1 THEN 'Firewood / chips'
        WHEN 2 THEN 'LPG'
        WHEN 3 THEN 'Other natural gas'
        WHEN 4 THEN 'Dung cake'
        WHEN 5 THEN 'Kerosene'
        WHEN 6 THEN 'Coke / coal'
        WHEN 7 THEN 'Gobar gas'
        WHEN 8 THEN 'Other biogas'
        WHEN 9 THEN 'Others'
        WHEN 10 THEN 'Charcoal'
        WHEN 11 THEN 'Electricity'
        WHEN 12 THEN 'No cooking arrangement'
        ELSE 'Unknown'
    END AS cooking_energy,

    CASE e.Energy_Source_Lighting
        WHEN 1 THEN 'Electricity'
        WHEN 2 THEN 'Kerosene'
        WHEN 3 THEN 'Other oil'
        WHEN 4 THEN 'Gas'
        WHEN 5 THEN 'Candle'
        WHEN 6 THEN 'No lighting'
        WHEN 9 THEN 'Others'
        ELSE 'Unknown'
    END AS lighting_energy,

    CASE e.Ration_Card_Type
        WHEN 0 THEN 'No ration card'
        WHEN 1 THEN 'AAY'
        WHEN 2 THEN 'BPL'
        WHEN 3 THEN 'APL'
        WHEN 4 THEN 'PHH'
        WHEN 5 THEN 'SFSS'
        WHEN 9 THEN 'Others'
        ELSE 'Unknown'
    END AS ration_card_type,

    e.Multiplier AS household_multiplier

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id;


-- ------------------------------------------------------------
-- 7. Verify the analytical view
-- ------------------------------------------------------------

SELECT *
FROM vw_household_economic_profile
LIMIT 20;


-- ------------------------------------------------------------
-- 8. Key descriptive results from completed analysis
-- ------------------------------------------------------------
--
-- Rural:
--   Average household size: 4.47
--   Average land owned: 1.27 acres
--   Average land among landholders: 1.30 acres
--
-- Urban:
--   Average household size: 3.85
--   Average land owned: 0.32 acres
--   Average land among landholders: 0.39 acres
--
-- Cooking energy:
--   Rural LPG: approximately 49.09%
--   Rural firewood / chips: approximately 46.80%
--   Urban LPG: approximately 86.25%
--   Urban firewood / chips: approximately 5.16%
--
-- Lighting:
--   Electricity accounted for approximately 99% of households
--   in both rural and urban samples.
--
-- Ration-card distribution:
--   Rural households were concentrated in PHH and BPL categories.
--   Urban households had a larger share reporting no ration card.
--
-- These findings are descriptive sample characteristics.
-- ------------------------------------------------------------