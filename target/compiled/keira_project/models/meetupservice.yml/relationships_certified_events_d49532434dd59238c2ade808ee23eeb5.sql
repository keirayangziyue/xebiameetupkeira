
    
    

with child as (
    select rsvp_user_id as from_field
    from `keira-xebia`.`meetupservice`.`certified_events_users_rsvp`
    where rsvp_user_id is not null
),

parent as (
    select user_id as to_field
    from `keira-xebia`.`meetupservice`.`certified_users`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


