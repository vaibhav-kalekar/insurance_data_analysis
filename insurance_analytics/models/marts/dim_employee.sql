{{
  config(
    materialized='table',
    unique_key='employee_id'
  )
}}
WITH dim_employee AS (
    SELECT
        AGENT_ID AS agent_id,
        AGENT_NAME AS agent_name,
        CAST(DATE_OF_JOINING AS DATE) AS date_of_joining,
        STREET_NAME AS street_name,
        APARTMENT_NAME AS apartment_name,
        CITY AS city,
        STATE AS state,
        CAST(POSTAL_CODE AS VARCHAR) AS postal_code,
        EMPLOYEE_ROUTING_NUMBER AS employee_routing_number,
        EMPLOYEE_ACCOUNT_NUMBER AS employee_account_number,
        ROW_NUMBER() OVER () AS employee_id  -- New Column for ID
    FROM {{ ref('stg_employee_data') }}
)

SELECT * 
FROM dim_employee