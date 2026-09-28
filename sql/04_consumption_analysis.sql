-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 04_consumption_analysis.sql
-- ============================================================
-- Purpose:
-- Analyses household consumption patterns using HCES Level 05
-- item-level consumption records.
--
-- Key analytical dimensions:
--   1. Item-level consumption
--   2. Rural-urban comparison
--   3. Selected broad consumption categories
--   4. Survey-weighted descriptive estimates
--
-- Important:
-- Item_Code is a survey code and should not be interpreted as
-- an item name without the corresponding HCES codebook.
--
-- The analysis therefore uses explicitly identified broad
-- category codes rather than assigning labels to arbitrary
-- item codes.
-- ============================================================

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. Overall item-level consumption
-- ------------------------------------------------------------
-- Diagnostic query used to identify the largest consumption
-- codes by recorded consumption value.
--
-- IMPORTANT:
-- Level 05 contains both subtotal and component codes.
-- Therefore, this query is exploratory and should NOT be used
-- as a final expenditure-composition estimate.

SELECT
    Item_Code,
    COUNT(DISTINCT household_id) AS households_reporting,
    SUM(Total_Consumption_Value) AS total_consumption_value,
    SUM(Total_Consumption_Quantity) AS total_consumption_quantity
FROM household_consumption
GROUP BY Item_Code
ORDER BY total_consumption_value DESC
LIMIT 20;


-- ------------------------------------------------------------
-- 2. Rural-urban item-level comparison
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    c.Item_Code,

    COUNT(DISTINCT c.household_id) AS households_reporting,

    SUM(c.Total_Consumption_Value) AS total_consumption_value,

    SUM(c.Total_Consumption_Quantity) AS total_consumption_quantity

FROM households h
JOIN household_consumption c
    ON h.household_id = c.household_id

GROUP BY
    h.Sector,
    c.Item_Code

ORDER BY
    sector,
    total_consumption_value DESC;


-- ------------------------------------------------------------
-- 3. Broad HCES consumption categories
-- ------------------------------------------------------------
--
-- Explicitly identified category codes used in the analysis:
--
-- 129  Cereals
-- 139  Cereal substitutes
-- 159  Pulses & pulse products
-- 179  Salt & sugar
-- 169  Milk & milk products
-- 219  Vegetables
-- 239  Fresh fruits
-- 249  Dry fruits
-- 199  Egg, fish & meat
-- 189  Edible oil
-- 269  Spices
-- 279  Beverages
-- 289  Served processed food
-- 299  Packaged processed food
--
-- Only these explicitly identified codes are included in the
-- analytical view below.
-- ------------------------------------------------------------


-- ------------------------------------------------------------
-- 4. Create consumption analytical view
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_consumption_structure AS
SELECT

    h.household_id,

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    c.Item_Code,

    CASE c.Item_Code
        WHEN 129 THEN 'Cereals'
        WHEN 139 THEN 'Cereal substitutes'
        WHEN 159 THEN 'Pulses & pulse products'
        WHEN 179 THEN 'Salt & sugar'
        WHEN 169 THEN 'Milk & milk products'
        WHEN 219 THEN 'Vegetables'
        WHEN 239 THEN 'Fresh fruits'
        WHEN 249 THEN 'Dry fruits'
        WHEN 199 THEN 'Egg, fish & meat'
        WHEN 189 THEN 'Edible oil'
        WHEN 269 THEN 'Spices'
        WHEN 279 THEN 'Beverages'
        WHEN 289 THEN 'Served processed food'
        WHEN 299 THEN 'Packaged processed food'
    END AS consumption_category,

    c.Total_Consumption_Quantity,

    c.Total_Consumption_Value,

    c.Multiplier

FROM households h

JOIN household_consumption c
    ON h.household_id = c.household_id

WHERE c.Item_Code IN (
    129,
    139,
    159,
    179,
    169,
    219,
    239,
    249,
    199,
    189,
    269,
    279,
    289,
    299
);


-- ------------------------------------------------------------
-- 5. Verify the analytical view
-- ------------------------------------------------------------

SELECT *
FROM vw_consumption_structure
LIMIT 20;


-- ------------------------------------------------------------
-- 6. Survey-weighted consumption by sector and category
-- ------------------------------------------------------------
--
-- HCES Multiplier values use a scaling convention.
-- The project uses:
--
--     Multiplier / 100.0
--
-- for weighted calculations.
--
-- This corrects the scale of weighted totals while preserving
-- the corresponding weighted average per reporting household.
--
-- These are descriptive survey-weighted estimates and should
-- not be interpreted as causal estimates.
-- ------------------------------------------------------------

SELECT

    v.sector,

    v.consumption_category,

    COUNT(DISTINCT v.household_id) AS sample_households,

    ROUND(
        SUM(
            v.Total_Consumption_Value *
            (h.Multiplier / 100.0)
        ),
        2
    ) AS weighted_consumption_value,

    ROUND(
        SUM(
            v.Total_Consumption_Value *
            (h.Multiplier / 100.0)
        )
        /
        SUM(h.Multiplier / 100.0),
        2
    ) AS weighted_avg_per_reporting_household

FROM vw_consumption_structure v

JOIN households h
    ON v.household_id = h.household_id

GROUP BY
    v.sector,
    v.consumption_category

ORDER BY
    v.sector,
    weighted_consumption_value DESC;


-- ------------------------------------------------------------
-- 7. Rural-urban comparison of weighted averages
-- ------------------------------------------------------------
--
-- This output can be used for descriptive comparison of
-- selected consumption categories between rural and urban
-- households.
-- ------------------------------------------------------------

SELECT

    v.consumption_category,

    ROUND(
        SUM(
            CASE
                WHEN v.sector = 'Rural'
                THEN v.Total_Consumption_Value *
                     (h.Multiplier / 100.0)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN v.sector = 'Rural'
                    THEN h.Multiplier / 100.0
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS rural_weighted_avg,

    ROUND(
        SUM(
            CASE
                WHEN v.sector = 'Urban'
                THEN v.Total_Consumption_Value *
                     (h.Multiplier / 100.0)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN v.sector = 'Urban'
                    THEN h.Multiplier / 100.0
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS urban_weighted_avg

FROM vw_consumption_structure v

JOIN households h
    ON v.household_id = h.household_id

GROUP BY
    v.consumption_category

ORDER BY
    v.consumption_category;


-- ------------------------------------------------------------
-- 8. Analytical interpretation notes
-- ------------------------------------------------------------
--
-- Key findings from the completed analysis included:
--
-- Rural weighted averages were highest for:
--   Cereals
--   Pulses & pulse products
--   Milk & milk products
--   Vegetables
--   Egg, fish & meat
--
-- Urban weighted averages were highest for:
--   Cereals
--   Milk & milk products
--   Pulses & pulse products
--   Vegetables
--   Egg, fish & meat
--
-- The analysis is descriptive and reflects the sampled
-- households represented in the HCES dataset.
--
-- Because Level 05 includes subtotal/component relationships,
-- the project does not sum all Item_Code values together to
-- represent total household expenditure.
-- ------------------------------------------------------------