-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 06_welfare_digital.sql
-- ============================================================
-- Purpose:
-- Analyses household welfare access, education benefits,
-- healthcare benefits and online purchasing behaviour using
-- HCES Level 07 data.
--
-- All results are descriptive characteristics of the HCES
-- sample.
-- ============================================================

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. LPG subsidy access
-- ------------------------------------------------------------
-- Coding:
-- 1 = Yes
-- 2 = No
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    w.LPG_subsidy_received,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY h.Sector),
        2
    ) AS share_pct

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY
    h.Sector,
    w.LPG_subsidy_received

ORDER BY
    h.Sector,
    w.LPG_subsidy_received;


-- ------------------------------------------------------------
-- 2. Education-related welfare benefits
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    SUM(
        CASE
            WHEN w.Free_textbooks_received > 0 THEN 1
            ELSE 0
        END
    ) AS textbook_beneficiary_households,

    SUM(
        CASE
            WHEN w.Free_stationery_received > 0 THEN 1
            ELSE 0
        END
    ) AS stationery_beneficiary_households,

    SUM(
        CASE
            WHEN w.Free_school_bag_received > 0 THEN 1
            ELSE 0
        END
    ) AS school_bag_beneficiary_households,

    SUM(
        CASE
            WHEN w.Fee_waiver_received > 0 THEN 1
            ELSE 0
        END
    ) AS fee_waiver_households

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 3. Education benefit shares
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Free_textbooks_received > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS textbook_benefit_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Free_stationery_received > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS stationery_benefit_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Free_school_bag_received > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS school_bag_benefit_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Fee_waiver_received > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS fee_waiver_pct

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 4. Healthcare access
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    SUM(
        CASE
            WHEN w.Ayushman_beneficiary > 0 THEN 1
            ELSE 0
        END
    ) AS ayushman_households,

    SUM(
        CASE
            WHEN w.Hospitalization_case > 0 THEN 1
            ELSE 0
        END
    ) AS hospitalization_households,

    SUM(
        CASE
            WHEN w.Medical_benefit_received > 0 THEN 1
            ELSE 0
        END
    ) AS medical_benefit_households,

    ROUND(
        SUM(
            CASE
                WHEN w.Medical_benefit_received > 0
                THEN w.Medical_benefit_amount
                ELSE 0
            END
        ),
        2
    ) AS total_reported_medical_benefit_amount

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 5. Healthcare access shares
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Ayushman_beneficiary > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS ayushman_beneficiary_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Hospitalization_case > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS hospitalization_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Medical_benefit_received > 0 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS medical_benefit_pct

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 6. Online purchase participation
-- ------------------------------------------------------------
--
-- Indicators:
--   Fuel / light
--   Toilet articles
--   Education
--   Medicine
--   Services
-- ------------------------------------------------------------

SELECT

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Online_purchase_fuel_light > 0
                THEN 1 ELSE 0
            END
        ),
        2
    ) AS online_fuel_light_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Online_purchase_toilet_articles > 0
                THEN 1 ELSE 0
            END
        ),
        2
    ) AS online_toilet_articles_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Online_purchase_education > 0
                THEN 1 ELSE 0
            END
        ),
        2
    ) AS online_education_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Online_purchase_medicine > 0
                THEN 1 ELSE 0
            END
        ),
        2
    ) AS online_medicine_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Online_purchase_services > 0
                THEN 1 ELSE 0
            END
        ),
        2
    ) AS online_services_pct

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY h.Sector

ORDER BY h.Sector;


-- ------------------------------------------------------------
-- 7. Create welfare and digital analytical view
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_welfare_access AS

SELECT

    h.household_id,

    CASE
        WHEN h.Sector = 1 THEN 'Rural'
        WHEN h.Sector = 2 THEN 'Urban'
        ELSE 'Unknown'
    END AS sector,

    w.LPG_subsidy_received,

    w.Free_textbooks_received,
    w.Free_stationery_received,
    w.Free_school_bag_received,
    w.Fee_waiver_received,

    w.Ayushman_beneficiary,
    w.Hospitalization_case,
    w.Medical_benefit_received,
    w.Medical_benefit_amount,

    w.Online_purchase_fuel_light,
    w.Online_purchase_toilet_articles,
    w.Online_purchase_education,
    w.Online_purchase_medicine,
    w.Online_purchase_services,

    w.Multiplier AS welfare_multiplier

FROM households h

JOIN household_welfare_digital w
    ON h.household_id = w.household_id;


-- ------------------------------------------------------------
-- 8. Verify the analytical view
-- ------------------------------------------------------------

SELECT *
FROM vw_welfare_access
LIMIT 20;


-- ------------------------------------------------------------
-- 9. Key descriptive results from completed analysis
-- ------------------------------------------------------------
--
-- LPG subsidy:
--   Rural: approximately 29.54% received subsidy
--   Urban: approximately 31.33% received subsidy
--
-- Education benefits:
--   Rural:
--     Free textbooks: approximately 27.83%
--     Free stationery: approximately 5.52%
--     School bags: approximately 6.21%
--     Fee waiver: approximately 55.77%
--
--   Urban:
--     Free textbooks: approximately 10.58%
--     Free stationery: approximately 2.78%
--     School bags: approximately 2.57%
--     Fee waiver: approximately 52.46%
--
-- Health:
--   Rural Ayushman beneficiary households: approximately 38.73%
--   Urban Ayushman beneficiary households: approximately 24.52%
--
-- Online services:
--   Rural: approximately 29.75%
--   Urban: approximately 55.84%
--
-- Important correction:
-- Medical-benefit analysis uses Medical_benefit_amount for
-- monetary totals. The binary Medical_benefit_received field
-- is used only for identifying beneficiary households.
--
-- These are descriptive sample statistics, not causal estimates.
-- ------------------------------------------------------------