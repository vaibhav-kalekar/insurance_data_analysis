{{
  config(
    materialized='table'
  )
}}

with fct_incident_state_severity_count as (
     select
     incident_state,
     incident_severity,
     COUNT(*) as incident_count
     from dim_claim_details
     group by incident_state, incident_severity
     order by incident_state, incident_severity
)

select *
from fct_incident_state_severity_count