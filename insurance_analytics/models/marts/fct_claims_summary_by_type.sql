{{
  config(
    materialized='table'
  )
}}

with fct_claims_summary_by_type as (
    Select
    count(insurance_type) as total_insurance_as_per_type,
    SUM(claim_amount) as total_claim_amount_for_each_type,
    insurance_type
    from {{ ref('dim_claim_details') }}
    group by (insurance_type)
    order by total_claim_amount_for_each_type desc
)

select *
from fct_claims_summary_by_type