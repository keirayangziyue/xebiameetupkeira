select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select event_id
from `keira-xebia`.`meetupservice`.`certified_events_users_rsvp`
where event_id is null



      
    ) dbt_internal_test