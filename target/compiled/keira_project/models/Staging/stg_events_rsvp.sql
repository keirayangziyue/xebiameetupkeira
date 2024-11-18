

SELECT 
    event_id,
    event_name,
    event_start_time,
    group_id,
    venue_id,
    rsvp_user_id,
    rsvp_response,
    rsvp_response_time,
    rsvp_guests
FROM `keira-xebia`.`meetupservice`.`stg_events_o`
WHERE event_id IS NOT NULL