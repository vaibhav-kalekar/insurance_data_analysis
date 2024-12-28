with vendor_data as (
    select * from vendors
)
select
    VENDOR_ID,
    VENDOR_NAME,
    ADDRESS_LINE1 as STREET_NAME,
    ADDRESS_LINE2 as APARTMENT_NAME,
    CITY,
    STATE,
    POSTAL_CODE
from vendor_data