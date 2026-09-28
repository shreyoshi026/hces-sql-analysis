-- ============================================================
-- HCES 2023-24 Household Economic Intelligence
-- 01_database_schema.sql
-- ============================================================
-- Purpose:
-- Creates the core relational tables used for household-level
-- economic, welfare, durable-goods and consumption analysis.
--
-- Dataset:
-- Household Consumption Expenditure Survey (HCES) 2023-24
-- Ministry of Statistics & Programme Implementation (MoSPI)
-- ============================================================


-- ------------------------------------------------------------
-- Database
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS hces_economic_intelligence;

USE hces_economic_intelligence;


-- ------------------------------------------------------------
-- 1. Households
-- Level 01
-- One record per sampled household
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS households (
    household_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    Survey_Name VARCHAR(10) NOT NULL,
    Year INT NOT NULL,

    FSU_Serial_No INT NOT NULL,
    Sector INT NOT NULL,
    State INT NOT NULL,
    NSS_Region INT NOT NULL,
    District INT NOT NULL,
    Stratum INT NOT NULL,
    Sub_stratum INT NOT NULL,
    Panel INT NOT NULL,
    Sub_sample INT NOT NULL,
    FOD_Sub_Region INT NOT NULL,
    Sample_SU_No INT NOT NULL,
    Sample_Sub_Division_No INT NULL,
    Second_Stage_Stratum_No INT NOT NULL,
    Sample_Household_No INT NOT NULL,

    Questionnaire_No VARCHAR(5),

    Level INT NOT NULL,
    Survey_Code INT NOT NULL,
    Reason_for_Substitution_Code INT NULL,

    Multiplier INT NOT NULL,

    UNIQUE KEY uk_household_natural_key (
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
    )
);


-- ------------------------------------------------------------
-- 2. Persons
-- Level 02
-- One record per person within household
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS persons (
    household_id BIGINT UNSIGNED NOT NULL,
    Person_Serial_No INT NOT NULL,

    PRIMARY KEY (
        household_id,
        Person_Serial_No
    ),

    CONSTRAINT fk_person_household
        FOREIGN KEY (household_id)
        REFERENCES households(household_id)
);


-- ------------------------------------------------------------
-- 3. Household Economic Profile
-- Level 03
-- One record per household
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS household_economic_profile (
    household_id BIGINT UNSIGNED NOT NULL,

    HH_Size_FDQ INT,

    Engaged_in_Economic_Activity_Las INT,
    NCO_2015_Code INT,
    NIC_2008_Code INT,

    Max_Income_Activity INT,

    Self_Employment_Source_Sector INT,
    Regular_Wage_Source_Sector INT,
    Casual_Labour_Source_Sector INT,

    Household_Type INT,
    Religion_of_HH_Head INT,
    Social_Group_of_HH_Head INT,

    Land_Ownership INT,
    Type_of_Land_Owned INT,

    Total_Area_Land_Owned_Acres DECIMAL(12,2),

    Dwelling_Unit_Exists INT,
    Type_of_Dwelling_Unit INT,

    Energy_Source_Cooking INT,
    Energy_Source_Lighting INT,

    Ration_Card_Type INT,

    Rent_Rate_Available_Rural INT,

    Benefitted_From_PMGKY INT,

    Multiplier INT NOT NULL,

    PRIMARY KEY (household_id),

    CONSTRAINT fk_economic_household
        FOREIGN KEY (household_id)
        REFERENCES households(household_id)
);


-- ------------------------------------------------------------
-- 4. Household Welfare & Digital Access
-- Level 07
-- One record per household
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS household_welfare_digital (
    household_id BIGINT UNSIGNED NOT NULL,

    Kerosene_ration_card INT,
    LPG_subsidy_received INT,
    LPG_subsidized_cylinders INT,

    Free_electricity INT,

    Any_member_attended_school INT,
    Num_govt_school_attended INT,
    Num_private_school_attended INT,

    Free_textbooks_received INT,
    Total_textbooks INT,

    Free_stationery_received INT,
    Total_stationery INT,

    Free_school_bag_received INT,
    Total_school_bags INT,

    Free_other_items_received INT,
    Total_other_items INT,

    Fee_waiver_received INT,
    Num_fee_waiver_received INT,

    Ayushman_beneficiary INT,
    Num_ayushman_beneficiaries INT,

    Hospitalization_case INT,

    Medical_benefit_received INT,
    Num_medical_beneficiaries INT,
    Medical_benefit_amount DECIMAL(14,2),

    Online_purchase_fuel_light INT,
    Online_purchase_toilet_articles INT,
    Online_purchase_education INT,
    Online_purchase_medicine INT,
    Online_purchase_services INT,

    Multiplier INT NOT NULL,

    PRIMARY KEY (household_id),

    CONSTRAINT fk_welfare_household
        FOREIGN KEY (household_id)
        REFERENCES households(household_id)
);


-- ------------------------------------------------------------
-- 5. Household Durable Goods
-- Level 11
-- One record per household
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS household_durables (
    household_id BIGINT UNSIGNED NOT NULL,

    Online_Clothing INT,
    Online_Footwear INT,
    Online_Furniture INT,
    Online_Mobile INT,
    Online_PersonalGoods INT,
    Online_RecreationGoods INT,
    Online_HouseholdAppliances INT,
    Online_Crockery INT,
    Online_SportsGoods INT,
    Online_MedicalEquipment INT,
    Online_Bedding INT,

    Free_Laptop INT,
    Num_Free_Laptop INT,

    Free_Tablet INT,
    Num_Free_Tablet INT,

    Free_Mobile INT,
    Num_Free_Mobile INT,

    Free_Bicycle INT,
    Num_Free_Bicycle INT,

    Free_Scooter INT,
    Num_Free_Scooter INT,

    Free_Clothing INT,
    Num_Free_Clothing INT,

    Free_Footwear INT,
    Num_Free_Footwear INT,

    Free_Other INT,
    Num_Free_Other INT,

    Possess_Television INT,
    Possess_Radio INT,
    Possess_Laptop INT,
    Possess_Mobile INT,
    Possess_Bicycle INT,
    Possess_Scooter INT,
    Possess_Car INT,
    Possess_Truck INT,
    Possess_AnimalCart INT,
    Possess_Refrigerator INT,
    Possess_WashingMachine INT,
    Possess_AirCooler INT,

    TV_Facility_Type INT,

    Multiplier INT NOT NULL,

    PRIMARY KEY (household_id),

    CONSTRAINT fk_durable_household
        FOREIGN KEY (household_id)
        REFERENCES households(household_id)
);


-- ------------------------------------------------------------
-- 6. Household Consumption
-- Level 05
-- One record per household and Item_Code
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS household_consumption (
    household_id BIGINT UNSIGNED NOT NULL,
    Item_Code INT NOT NULL,

    OutOfHome_Consumption_Quantity DECIMAL(14,3),
    OutOfHome_Consumption_Value DECIMAL(14,2),

    Total_Consumption_Quantity DECIMAL(14,3),
    Total_Consumption_Value DECIMAL(14,2),

    Source INT,

    Multiplier INT NOT NULL,

    PRIMARY KEY (
        household_id,
        Item_Code
    ),

    CONSTRAINT fk_consumption_household
        FOREIGN KEY (household_id)
        REFERENCES households(household_id)
);