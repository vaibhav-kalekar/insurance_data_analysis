{{
  config(
    materialized='table',
    unique_key='insurance_type_id'
  )
}}

with unique_insurance_types as (
    select
    DISTINCT INSURANCE_TYPE
    from {{ ref('stg_insurance_data') }}
),
dim_insurance_type AS (
    select
    ROW_NUMBER() OVER (order by INSURANCE_TYPE) AS insurance_type_id, -- New Column for ID
    INSURANCE_TYPE as insurance_type_name
    from unique_insurance_types
)
select *
from dim_insurance_type