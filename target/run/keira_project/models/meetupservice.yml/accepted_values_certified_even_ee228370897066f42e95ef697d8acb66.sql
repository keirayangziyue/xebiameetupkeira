select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        final_response as value_field,
        count(*) as n_records

    from `keira-xebia`.`meetupservice`.`certified_events_users_rsvp`
    group by final_response

)

select *
from all_values
where value_field not in (
    'yes','no','waitlist'
)



      
    ) dbt_internal_test