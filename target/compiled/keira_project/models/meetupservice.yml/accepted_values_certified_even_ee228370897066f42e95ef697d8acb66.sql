
    
    

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


