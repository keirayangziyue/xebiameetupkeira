


WITH rsvp AS (
    SELECT 
        venue_id,
        group_id,
        name AS event_name,
        TIMESTAMP_SECONDS(CAST(time / 1000 AS INT64)) AS event_start_time, --timestamp
        rsvp.user_id AS rsvp_user_id,
        rsvp.response AS rsvp_response,
        TIMESTAMP_SECONDS(CAST(rsvp.when / 1000 AS INT64)) AS rsvp_response_time, --timestamp
        rsvp.guests AS rsvp_guests,
        status AS event_status,
        duration AS event_duration,
        rsvp_limit AS rsvp_total_limit,
        TIMESTAMP_SECONDS(CAST(created / 1000 AS INT64)) AS event_create_time, --timestamp
        description AS event_description
    FROM 
      `keira-xebia`.`meetupservice`.`source_events`,
      UNNEST(rsvps) AS rsvp
),

eventid AS(
    SELECT 
        CAST(FARM_FINGERPRINT(
            CONCAT(event_name, CAST(group_id AS STRING), CAST(venue_id AS STRING), CAST(event_start_time AS STRING))) 
            AS STRING) AS event_id,
        *
    FROM rsvp
)

SELECT 
    event_id,
    event_name,
    event_start_time,
    group_id,
    venue_id,
    event_status,
    event_duration,
    rsvp_total_limit,
    event_create_time,
    event_description,
    rsvp_user_id,
    rsvp_response,
    rsvp_response_time,
    rsvp_guests
FROM eventid