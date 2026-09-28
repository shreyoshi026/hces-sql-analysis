-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 08_state_comparison.sql
-- ============================================================
-- Purpose:
-- Compares selected household economic and digital-access
-- indicators across Indian states and Union Territories.
--
-- Indicators:
--   - Sample household count
--   - Average household size
--   - Average land owned
--   - LPG use
--   - Mobile ownership
--   - Refrigerator ownership
--   - Online services participation
--
-- Results are descriptive sample statistics.
-- ============================================================

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. State sample distribution
-- ------------------------------------------------------------

SELECT

    CASE h.State
        WHEN 1 THEN 'Jammu & Kashmir'
        WHEN 2 THEN 'Himachal Pradesh'
        WHEN 3 THEN 'Punjab'
        WHEN 4 THEN 'Chandigarh'
        WHEN 5 THEN 'Uttarakhand'
        WHEN 6 THEN 'Haryana'
        WHEN 7 THEN 'Delhi'
        WHEN 8 THEN 'Rajasthan'
        WHEN 9 THEN 'Uttar Pradesh'
        WHEN 10 THEN 'Bihar'
        WHEN 11 THEN 'Sikkim'
        WHEN 12 THEN 'Arunachal Pradesh'
        WHEN 13 THEN 'Nagaland'
        WHEN 14 THEN 'Manipur'
        WHEN 15 THEN 'Mizoram'
        WHEN 16 THEN 'Tripura'
        WHEN 17 THEN 'Meghalaya'
        WHEN 18 THEN 'Assam'
        WHEN 19 THEN 'West Bengal'
        WHEN 20 THEN 'Jharkhand'
        WHEN 21 THEN 'Odisha'
        WHEN 22 THEN 'Chhattisgarh'
        WHEN 23 THEN 'Madhya Pradesh'
        WHEN 24 THEN 'Gujarat'
        WHEN 25 THEN 'Daman & Diu and Dadra & Nagar Haveli'
        WHEN 27 THEN 'Maharashtra'
        WHEN 28 THEN 'Andhra Pradesh'
        WHEN 29 THEN 'Karnataka'
        WHEN 30 THEN 'Goa'
        WHEN 31 THEN 'Lakshadweep'
        WHEN 32 THEN 'Kerala'
        WHEN 33 THEN 'Tamil Nadu'
        WHEN 34 THEN 'Puducherry'
        WHEN 35 THEN 'Andaman & Nicobar Islands'
        WHEN 36 THEN 'Telangana'
        WHEN 37 THEN 'Ladakh'
        ELSE 'Unknown'
    END AS state_name,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS sample_share_pct

FROM households h

GROUP BY h.State

ORDER BY households DESC;


-- ------------------------------------------------------------
-- 2. State-level household economic and digital profile
-- ------------------------------------------------------------

SELECT

    CASE h.State
        WHEN 1 THEN 'Jammu & Kashmir'
        WHEN 2 THEN 'Himachal Pradesh'
        WHEN 3 THEN 'Punjab'
        WHEN 4 THEN 'Chandigarh'
        WHEN 5 THEN 'Uttarakhand'
        WHEN 6 THEN 'Haryana'
        WHEN 7 THEN 'Delhi'
        WHEN 8 THEN 'Rajasthan'
        WHEN 9 THEN 'Uttar Pradesh'
        WHEN 10 THEN 'Bihar'
        WHEN 11 THEN 'Sikkim'
        WHEN 12 THEN 'Arunachal Pradesh'
        WHEN 13 THEN 'Nagaland'
        WHEN 14 THEN 'Manipur'
        WHEN 15 THEN 'Mizoram'
        WHEN 16 THEN 'Tripura'
        WHEN 17 THEN 'Meghalaya'
        WHEN 18 THEN 'Assam'
        WHEN 19 THEN 'West Bengal'
        WHEN 20 THEN 'Jharkhand'
        WHEN 21 THEN 'Odisha'
        WHEN 22 THEN 'Chhattisgarh'
        WHEN 23 THEN 'Madhya Pradesh'
        WHEN 24 THEN 'Gujarat'
        WHEN 25 THEN 'Daman & Diu and Dadra & Nagar Haveli'
        WHEN 27 THEN 'Maharashtra'
        WHEN 28 THEN 'Andhra Pradesh'
        WHEN 29 THEN 'Karnataka'
        WHEN 30 THEN 'Goa'
        WHEN 31 THEN 'Lakshadweep'
        WHEN 32 THEN 'Kerala'
        WHEN 33 THEN 'Tamil Nadu'
        WHEN 34 THEN 'Puducherry'
        WHEN 35 THEN 'Andaman & Nicobar Islands'
        WHEN 36 THEN 'Telangana'
        WHEN 37 THEN 'Ladakh'
        ELSE 'Unknown'
    END AS state_name,

    COUNT(*) AS households,

    ROUND(
        AVG(e.HH_Size_FDQ),
        2
    ) AS avg_household_size,

    ROUND(
        AVG(e.Total_Area_Land_Owned_Acres),
        2
    ) AS avg_land_owned_acres,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN e.Energy_Source_Cooking = 2
                THEN 1
                ELSE 0
            END
        ),
        2
    ) AS lpg_household_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN d.Possess_Mobile > 0
                THEN 1
                ELSE 0
            END
        ),
        2
    ) AS mobile_ownership_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN d.Possess_Refrigerator > 0
                THEN 1
                ELSE 0
            END
        ),
        2
    ) AS refrigerator_ownership_pct,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN w.Online_purchase_services > 0
                THEN 1
                ELSE 0
            END
        ),
        2
    ) AS online_services_pct

FROM households h

JOIN household_economic_profile e
    ON h.household_id = e.household_id

JOIN household_durables d
    ON h.household_id = d.household_id

JOIN household_welfare_digital w
    ON h.household_id = w.household_id

GROUP BY h.State

ORDER BY households DESC;


-- ------------------------------------------------------------
-- 3. State-level comparison with observed access-gap segments
-- ------------------------------------------------------------

SELECT

    CASE h.State
        WHEN 1 THEN 'Jammu & Kashmir'
        WHEN 2 THEN 'Himachal Pradesh'
        WHEN 3 THEN 'Punjab'
        WHEN 4 THEN 'Chandigarh'
        WHEN 5 THEN 'Uttarakhand'
        WHEN 6 THEN 'Haryana'
        WHEN 7 THEN 'Delhi'
        WHEN 8 THEN 'Rajasthan'
        WHEN 9 THEN 'Uttar Pradesh'
        WHEN 10 THEN 'Bihar'
        WHEN 11 THEN 'Sikkim'
        WHEN 12 THEN 'Arunachal Pradesh'
        WHEN 13 THEN 'Nagaland'
        WHEN 14 THEN 'Manipur'
        WHEN 15 THEN 'Mizoram'
        WHEN 16 THEN 'Tripura'
        WHEN 17 THEN 'Meghalaya'
        WHEN 18 THEN 'Assam'
        WHEN 19 THEN 'West Bengal'
        WHEN 20 THEN 'Jharkhand'
        WHEN 21 THEN 'Odisha'
        WHEN 22 THEN 'Chhattisgarh'
        WHEN 23 THEN 'Madhya Pradesh'
        WHEN 24 THEN 'Gujarat'
        WHEN 25 THEN 'Daman & Diu and Dadra & Nagar Haveli'
        WHEN 27 THEN 'Maharashtra'
        WHEN 28 THEN 'Andhra Pradesh'
        WHEN 29 THEN 'Karnataka'
        WHEN 30 THEN 'Goa'
        WHEN 31 THEN 'Lakshadweep'
        WHEN 32 THEN 'Kerala'
        WHEN 33 THEN 'Tamil Nadu'
        WHEN 34 THEN 'Puducherry'
        WHEN 35 THEN 'Andaman & Nicobar Islands'
        WHEN 36 THEN 'Telangana'
        WHEN 37 THEN 'Ladakh'
        ELSE 'Unknown'
    END AS state_name,

    v.vulnerability_segment,

    COUNT(*) AS households,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY h.State),
        2
    ) AS share_pct

FROM vw_vulnerability_segments v

JOIN households h
    ON v.household_id = h.household_id

GROUP BY
    h.State,
    v.vulnerability_segment

ORDER BY
    h.State,
    v.vulnerability_segment;


-- ------------------------------------------------------------
-- 4. Interpretation notes
-- ------------------------------------------------------------
--
-- The state-level comparison is intended to describe variation
-- in household characteristics across the HCES sample.
--
-- The indicators should not be combined into an overall ranking
-- of states.
--
-- State sample sizes differ substantially, so estimates from
-- smaller sampled populations should be interpreted with
-- appropriate caution.
--
-- The analysis is descriptive and does not establish causal
-- relationships.
-- ------------------------------------------------------------