# HCES 2023–24 Household Economic Intelligence

A MySQL-based household economic intelligence project using India's Household Consumption Expenditure Survey (HCES) 2023–24.

The project transforms large-scale survey data into a relational database and uses SQL to examine household consumption, economic characteristics, welfare access, digital participation, durable-goods ownership, state-level differences, and a transparent portfolio-defined observed access-gap segmentation.

---

## Project Overview

The Household Consumption Expenditure Survey (HCES) 2023–24 provides detailed information on household consumption expenditure and related household characteristics.

This project uses selected HCES levels to build a relational MySQL database and answer descriptive economic questions across rural and urban households and across states/Union Territories.

### Key objectives

- Build a relational database from multi-level HCES survey data.
- Establish a consistent household-level key across survey levels.
- Analyse household consumption patterns.
- Compare rural and urban household characteristics.
- Examine welfare and digital-access indicators.
- Analyse durable-goods ownership.
- Compare household economic indicators across states.
- Create a transparent observed access-gap segmentation framework.

---

## Dataset

**Dataset:** Household Consumption Expenditure Survey (HCES) 2023–24

**Source:** Ministry of Statistics & Programme Implementation (MoSPI), Government of India.

The downloaded HCES CSV archive is approximately 244 MB and the extracted CSV files occupy several GB.

For repository size and data-distribution reasons, the raw and extracted survey files are not committed to GitHub.

The repository documents the database architecture, SQL workflow, analytical queries, validation procedures, and methodology required to reproduce the analysis.

---

## Data Architecture

Selected HCES levels were mapped into the following relational tables:

| HCES Level | Database Table | Granularity |
|---|---|---|
| Level 01 | `households` | One record per household |
| Level 02 | `persons` | One record per person |
| Level 03 | `household_economic_profile` | One record per household |
| Level 05 | `household_consumption` | One record per household × item |
| Level 07 | `household_welfare_digital` | One record per household |
| Level 11 | `household_durables` | One record per household |

### Validated database size

| Table | Records |
|---|---:|
| `households` | 261,953 |
| `persons` | 1,107,221 |
| `household_economic_profile` | 261,953 |
| `household_welfare_digital` | 261,953 |
| `household_durables` | 261,953 |
| `household_consumption` | 12,754,437 |

---

## Household Identification

A full natural household key was used to connect records across HCES levels.

The household key consists of:

- `Survey_Name`
- `Year`
- `FSU_Serial_No`
- `Sector`
- `State`
- `NSS_Region`
- `District`
- `Stratum`
- `Sub_stratum`
- `Panel`
- `Sub_sample`
- `FOD_Sub_Region`
- `Sample_SU_No`
- `Sample_Sub_Division_No`
- `Second_Stage_Stratum_No`
- `Sample_Household_No`

`Questionnaire_No` was not treated as the household identity because its value varies across HCES levels.

The final household natural key contained 261,953 unique households with no duplicate household keys.

---

## SQL Analysis

### 1. Consumption Structure

Analyses:

- Item-level consumption diagnostics.
- Rural–urban consumption comparison.
- Selected broad HCES consumption categories.
- Survey-weighted descriptive estimates.

Selected categories include:

- Cereals
- Cereal substitutes
- Pulses and pulse products
- Salt and sugar
- Milk and milk products
- Vegetables
- Fresh fruits
- Dry fruits
- Egg, fish and meat
- Edible oil
- Spices
- Beverages
- Served processed food
- Packaged processed food

### Important methodological consideration

HCES Level 05 contains both subtotal and component item codes.

Therefore, all `Item_Code` values were not simply summed to represent total household expenditure.

The analytical view uses explicitly identified broad category codes to reduce the risk of subtotal/component double counting.

---

### 2. Household Economic Profile

The analysis examines:

- Household size.
- Land owned.
- Economic activity status.
- Cooking energy.
- Lighting source.
- Ration-card categories.

A rural–urban comparison was performed using household-level characteristics.

---

### 3. Welfare and Digital Access

The analysis examines:

- LPG subsidy access.
- Free textbooks.
- Free stationery.
- School-bag benefits.
- Fee waivers.
- Ayushman beneficiary status.
- Hospitalization.
- Medical benefits.
- Online purchases of:
  - Fuel/light
  - Toilet articles
  - Education
  - Medicine
  - Services

Monetary medical-benefit analysis uses `Medical_benefit_amount`, while `Medical_benefit_received` is used as a beneficiary indicator.

---

### 4. Durable Goods

Household ownership was analysed for:

- Television
- Mobile phone
- Laptop
- Refrigerator
- Washing machine
- Bicycle
- Scooter
- Car

The project also examines selected goods received free of cost, including:

- Laptop
- Tablet
- Mobile
- Bicycle
- Scooter
- Clothing
- Footwear

---

### 5. State-Level Comparison

State-level descriptive indicators include:

- Sample household count.
- Average household size.
- Average land owned.
- LPG use.
- Mobile ownership.
- Refrigerator ownership.
- Online-services participation.

State comparisons are descriptive and are not presented as an overall ranking of states.

Sample sizes differ across states and Union Territories and should be considered when interpreting comparisons.

---

## Observed Access-Gap Segmentation

A transparent portfolio-defined segmentation framework was created using five observable household-access indicators:

1. No LPG cooking fuel.
2. No refrigerator.
3. No mobile.
4. No online service purchase.
5. No ration card.

Each observed gap contributes one point.

| Score | Segment |
|---:|---|
| 0–1 | Lower observed access gap |
| 2–3 | Moderate observed access gap |
| 4–5 | Higher observed access gap |

### Completed-project distribution

| Segment | Households | Share |
|---|---:|---:|
| Lower observed access gap | 120,073 | 45.84% |
| Moderate observed access gap | 130,537 | 49.83% |
| Higher observed access gap | 11,343 | 4.33% |

The average observed access-gap score was 1.6873, with scores ranging from 0 to 5.

### Rural–urban distribution

| Sector | Lower | Moderate | Higher |
|---|---:|---:|---:|
| Rural | 33.04% | 61.27% | 5.69% |
| Urban | 64.20% | 33.42% | 2.37% |

### Important limitation

This segmentation is **not an official HCES poverty, deprivation, or government vulnerability index**.

It is a portfolio-defined descriptive framework. The indicators receive equal weight, and the thresholds are analytical choices made for this project.

Missing values are treated as observed gaps in this framework and should therefore be considered when interpreting the results.

---

## Survey Weights

HCES multiplier values were used for survey-weighted descriptive calculations.

For the consumption analysis, the multiplier was applied using the project's validated scaling convention:

`Multiplier / 100.0`

Weighted results are treated as descriptive survey estimates.

They are **not interpreted as causal estimates**.

---

## Key Findings

The analysis identified several descriptive differences between rural and urban households:

- Rural households had a larger average household size and higher average land ownership than urban households in the sample.
- LPG use was substantially more common among urban households, while firewood/chips remained prominent among rural households.
- Mobile ownership was high in both sectors.
- Refrigerator and washing-machine ownership showed substantial rural–urban differences.
- Online-services participation was higher among urban households.
- The observed access-gap segmentation showed a larger share of rural households in the moderate and higher access-gap categories.

These findings describe patterns within the HCES sample and should not be interpreted as causal relationships.

---

## SQL Techniques Demonstrated

This project demonstrates practical MySQL techniques including:

- Database and table creation.
- Primary keys.
- Foreign keys.
- Composite primary keys.
- Unique constraints.
- Relational data modelling.
- Multi-table joins.
- `CASE` statements.
- Aggregation.
- `GROUP BY`.
- Window functions.
- `COUNT(DISTINCT ...)`.
- Conditional aggregation.
- Percentage calculations.
- Survey-weighted descriptive calculations.
- Analytical views.
- Data validation.
- Duplicate detection.
- Referential-integrity checks.

---

## Repository Structure

```text
hces-sql-analysis/
│
├── data/
│   ├── documentation/
│   ├── extracted/          # Local only; excluded from GitHub
│   ├── notebook/           # Legacy local folder
│   └── raw/                # Local only; excluded from GitHub
│
├── notebooks/
│   ├── inspect_level_05.py
│   └── inspect_level_07.py
│
├── reports/
│   ├── figures/
│   └── presentation/
│
├── sql/
│   ├── 01_database_schema.sql
│   ├── 02_data_loading.sql
│   ├── 03_data_validation.sql
│   ├── 04_consumption_analysis.sql
│   ├── 05_economic_profile.sql
│   ├── 06_welfare_digital.sql
│   ├── 07_durable_goods.sql
│   ├── 08_state_comparison.sql
│   └── 09_vulnerability_segmentation.sql
│
├── .gitignore
└── README.md