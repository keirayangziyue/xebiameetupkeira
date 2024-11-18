


WITH rsvp AS (
    SELECT 
        venue_id,
        group_id,
        name AS event_name,
        time AS event_start_time,
        rsvp.user_id AS rsvp_user_id,
        rsvp.response AS rsvp_response,
        rsvp.when AS rsvp_response_time,
        rsvp.guests AS rsvp_guests
    FROM 
      `keira-xebia`.`meetupservice`.`source_events`,
      UNNEST(rsvps) AS rsvp
)

SELECT 
    event_name,
    event_start_time,
    group_id,
    venue_id,
    rsvp_user_id,
    rsvp_response,
    rsvp_response_time,
    rsvp_guests
FROM rsvp