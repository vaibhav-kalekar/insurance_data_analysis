{{
  config(
    materialized='table',
    unique_key='id'
  )
}}

with dim_vendor as (
    select
    VENDOR_ID as vendor_id,
    VENDOR_NAME as vendor_name,
    STREET_NAME as street_name,
    APARTMENT_NAME as apartment_name,
    CITY as city,
    STATE as state,
    POSTAL_CODE as postal_code,
    ROW_NUMBER() OVER () AS id  -- New Column for ID
    from {{ ref('stg_vendor_data') }}
)
select *
from dim_vendor