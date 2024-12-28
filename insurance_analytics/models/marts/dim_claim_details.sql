{{
  config(
    materialized='table',
    unique_key='claim_details_id'
  )
}}

with dim_claim_details as (
    SELECT
    CAST(TXN_DATE_TIME AS DATETIME) as transaction_time,
    TRANSACTION_ID as transaction_id,
    CUSTOMER_ID as customer_id,
    POLICY_NUMBER as policy_number,
    CAST(POLICY_EFFECTIVE_FROM as DATE) as policy_effective_date ,
    CAST(LOSS_DATE as DATE) as loss_date,
    CAST(REPORTING_DATE as DATETIME) as reporting_date,
    INSURANCE_TYPE as insurance_type,
    CAST(PREMIUM_AMOUNT as DECIMAL) as premium_amount,
    CLAIM_AMOUNT as claim_amount,
    CUSTOMER_NAME as customer_name,
    STREET_NAME as street_name,
    APARTMENT_NAME as apartment_name,
    CITY as city,
    STATE as state,
    POSTAL_CODE as postal_code,
    SSN as ssn,
    MARITAL_STATUS as marital_status,
    AGE as age,
    TENURE as tenure,
    EMPLOYMENT_STATUS as employment_status,
    NO_OF_FAMILY_MEMBERS as number_of_family_members,
    RISK_SEGMENTATION as risk_segmentation,
    HOUSE_TYPE as house_type,
    SOCIAL_CLASS as social_class,
    ROUTING_NUMBER as routing_number,
    ACCT_NUMBER as account_number,
    CUSTOMER_EDUCATION_LEVEL as customer_education_level,
    CLAIM_STATUS as claim_status,
    INCIDENT_SEVERITY as incident_severity,
    AUTHORITY_CONTACTED as authority_contacted,
    ANY_INJURY as any_injury,
    POLICE_REPORT_AVAILABLE as police_report_available,
    INCIDENT_STATE as incident_state,
    INCIDENT_CITY as incident_city,
    INCIDENT_HOUR_OF_THE_DAY as incident_hour,
    AGENT_ID as agent_id,
    VENDOR_ID as vendor_id,
    ROW_NUMBER() OVER () AS claim_details_id  -- New Column for ID
    from {{ ref('stg_insurance_data') }}
)
select *
from dim_claim_details