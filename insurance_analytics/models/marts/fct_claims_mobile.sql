{{
  config(
    materialized='table'
  )
}}

with fct_claims_mobile as (
    select
        agent_id,
        vendor_id,
        insurance_type,
        claim_amount,
        employment_status,
        social_class,
        incident_severity,
        claim_status,
        police_report_available,
        risk_segmentation
    from {{ ref('dim_claim_details') }}
    where insurance_type
    like 'Mobile'
    and claim_amount > 0
    and risk_segmentation in ('H')
    and claim_status in ('A')
    order by claim_amount desc
)

select *
from fct_claims_mobile

