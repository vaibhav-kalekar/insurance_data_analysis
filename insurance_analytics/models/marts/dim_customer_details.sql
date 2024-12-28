{{
  config(
    materialized='table',
    unique_key='customer_details_id'
  )
}}

with dim_customer_details as (
    SELECT
    DISTINCT CUSTOMER_ID as customer_id,
    CUSTOMER_NAME as customer_name,
    AGE as age,
    SSN as social_security_name,
    STREET_NAME as street_name,
    APARTMENT_NAME as apt_name,
    CITY as city,
    STATE as state,
    POSTAL_CODE as post_code,
    EMPLOYMENT_STATUS as employment_status,
    HOUSE_TYPE as house_type,
    SOCIAL_CLASS as income_group,
    ROUTING_NUMBER as bank_routing_number,
    ACCT_NUMBER as bank_account_number,
    CUSTOMER_EDUCATION_LEVEL as customer_education_level,
    ROW_NUMBER() OVER () AS customer_details_id  -- New Column for ID
    from {{ ref('stg_insurance_data') }}
)
select *
from dim_customer_details



