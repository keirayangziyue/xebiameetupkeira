


WITH events AS (
    SELECT DISTINCT
        event_id,
        venue_id,
        event_start_time, --timestamp
        event_status,
        event_duration,
        rsvp_total_limit,
        event_create_time, --timestamp
        group_id,
        event_name,
        event_description
    FROM 
      `keira-xebia`.`meetupservice`.`stg_events_o`
    WHERE event_id IS NOT NULL 
),

venues AS(
    SELECT 
        venue_id,
        name AS venue_name,
        LOWER(city) AS venue_city,
        LOWER(country) AS venue_country,
        lat AS venue_lat,
        lon AS venue_lon
    FROM `keira-xebia`.`meetupservice`.`source_venues`
),

staging AS(
    SELECT
        e.event_id,
        e.group_id,
        e.venue_id,
        e.event_name,
        e.event_start_time,
        e.event_status,
        e.event_duration,
        e.event_create_time,
        e.rsvp_total_limit,
        e.event_description,
        v.venue_name,
        v.venue_city,
        v.venue_country,
        v.venue_lat,
        v.venue_lon
      FROM events e
      LEFT JOIN venues v
        ON e.venue_id = v.venue_id
)


SELECT
    event_id,
    event_name,
    group_id,
    venue_id,
    event_start_time,
    event_status,
    event_duration,
    event_create_time,
    rsvp_total_limit,
    event_description,
    venue_name,
    venue_city,
    venue_country,
    venue_lat,
    venue_lon
FROM staging