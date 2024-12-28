with employee_data as (
    select * from employees
)
select
    AGENT_ID,
    AGENT_NAME,
    DATE_OF_JOINING,
    ADDRESS_LINE1 as STREET_NAME,
    ADDRESS_LINE2 as APARTMENT_NAME,
    CITY,
    STATE,
    POSTAL_CODE,
    EMP_ROUTING_NUMBER as EMPLOYEE_ROUTING_NUMBER,
    EMP_ACCT_NUMBER as EMPLOYEE_ACCOUNT_NUMBER
from employee_data