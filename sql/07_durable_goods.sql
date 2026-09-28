-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 07_durable_goods.sql
-- ============================================================
-- Purpose:
-- Analyses household ownership of selected durable goods and
-- selected goods received free of cost.
--
-- All results are descriptive characteristics of the HCES
-- sample.
-- ============================================================

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. Durable-goods ownership by rural / urban sector
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    SUM(
        CASE WHEN d.Possess_Television > 0 THEN 1 ELSE 0 END
    ) AS television_households,

    SUM(
        CASE WHEN d.Possess_Mobile > 0 THEN 1 ELSE 0 END
    ) AS mobile_households,

    SUM(
        CASE WHEN d.Possess_Laptop > 0 THEN 1 ELSE 0 END
    ) AS laptop_households,

    SUM(
        CASE WHEN d.Possess_Refrigerator > 0 THEN 1 ELSE 0 END
    ) AS refrigerator_households,

    SUM(
        CASE WHEN d.Possess_WashingMachine > 0 THEN 1 ELSE 0 END
    ) AS washing_machine_households,

    SUM(
        CASE WHEN d.Possess_Bicycle > 0 THEN 1 ELSE 0 END
    ) AS bicycle_households,

    SUM(
        CASE WHEN d.Possess_Scooter > 0 THEN 1 ELSE 0 END
    ) AS scooter_households,

    SUM(
        CASE WHEN d.Possess_Car > 0 THEN 1 ELSE 0 END
    ) AS car_households

FROM households h

JOIN household_durables d
    ON h.household_id = d.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 2. Durable-goods ownership percentages
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Television > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS television_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Mobile > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS mobile_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Laptop > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS laptop_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Refrigerator > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS refrigerator_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_WashingMachine > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS washing_machine_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Bicycle > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS bicycle_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Scooter > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS scooter_ownership_pct,

    ROUND(
        100.0 * AVG(
            CASE WHEN d.Possess_Car > 0
                 THEN 1 ELSE 0 END
        ),
        2
    ) AS car_ownership_pct

FROM households h

JOIN household_durables d
    ON h.household_id = d.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 3. Selected free-goods distribution
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    SUM(
        CASE WHEN d.Free_Laptop > 0 THEN 1 ELSE 0 END
    ) AS free_laptop_households,

    SUM(
        CASE WHEN d.Free_Tablet > 0 THEN 1 ELSE 0 END
    ) AS free_tablet_households,

    SUM(
        CASE WHEN d.Free_Mobile > 0 THEN 1 ELSE 0 END
    ) AS free_mobile_households,

    SUM(
        CASE WHEN d.Free_Bicycle > 0 THEN 1 ELSE 0 END
    ) AS free_bicycle_households,

    SUM(
        CASE WHEN d.Free_Scooter > 0 THEN 1 ELSE 0 END
    ) AS free_scooter_households,

    SUM(
        CASE WHEN d.Free_Clothing > 0 THEN 1 ELSE 0 END
    ) AS free_clothing_households,

    SUM(
        CASE WHEN d.Free_Footwear > 0 THEN 1 ELSE 0 END
    ) AS free_footwear_households

FROM households h

JOIN household_durables d
    ON h.household_id = d.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 4. Create durable-goods analytical view
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_durable_goods AS

SELECT

    h.household_id,

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    d.Possess_Television,
    d.Possess_Mobile,
    d.Possess_Laptop,
    d.Possess_Refrigerator,
    d.Possess_WashingMachine,
    d.Possess_Bicycle,
    d.Possess_Scooter,
    d.Possess_Car,

    d.Free_Laptop,
    d.Free_Tablet,
    d.Free_Mobile,
    d.Free_Bicycle,
    d.Free_Scooter,
    d.Free_Clothing,
    d.Free_Footwear,

    d.Multiplier AS durable_multiplier

FROM households h

JOIN household_durables d
    ON h.household_id = d.household_id;


-- ------------------------------------------------------------
-- 5. Verify the analytical view
-- ------------------------------------------------------------

SELECT *
FROM vw_durable_goods
LIMIT 20;


-- ------------------------------------------------------------
-- 6. Key descriptive results from completed analysis
-- ------------------------------------------------------------
--
-- Rural ownership:
--   Television: approximately 62.32%
--   Mobile: approximately 96.82%
--   Laptop: approximately 2.69%
--   Refrigerator: approximately 34.83%
--   Washing machine: approximately 12.31%
--   Bicycle: approximately 45.94%
--   Scooter: approximately 56.96%
--   Car: approximately 4.74%
--
-- Urban ownership:
--   Television: approximately 79.66%
--   Mobile: approximately 98.59%
--   Laptop: approximately 15.30%
--   Refrigerator: approximately 68.12%
--   Washing machine: approximately 40.93%
--   Bicycle: approximately 28.61%
--   Scooter: approximately 65.50%
--   Car: approximately 13.99%
--
-- Free-goods records included laptops, tablets, mobiles,
-- bicycles, scooters, clothing and footwear.
--
-- These are descriptive sample statistics.
-- ------------------------------------------------------------