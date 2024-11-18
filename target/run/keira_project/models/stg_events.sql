
  
    

    create or replace table `keira-xebia`.`meetupservice`.`stg_events`
      
    
    

    OPTIONS()
    as (
      


WITH events AS (
    SELECT 
        venue_id,
        time AS event_start_time,
        status AS event_status,
        duration AS event_duration,
        rsvp_limit AS rsvp_total_limit,
        FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP_SECONDS
        (CAST(created / 1000 AS INT64))) AS event_create_time,
        group_id,
        name AS event_name,
        description AS event_description,
        rsvp.user_id AS rsvp_user_id,
        rsvp.response AS rsvp_response,
        rsvp.when AS rsvp_response_time,
        rsvp.guests AS rsvp_guests
    FROM 
      `keira-xebia`.`meetupservice`.`source_events`,
      UNNEST(rsvps) AS rsvp
),

venues AS(
    SELECT 
        venue_id,
        name AS venue_name,
        city AS venue_city,
        country AS venue_country,
        lat AS venue_lat,
        lon AS venue_lon
    FROM `keira-xebia`.`meetupservice`.`source_venues`
),

staging AS(
    SELECT 
        e.group_id,
        e.venue_id,
        e.event_name,
        e.event_start_time,
        e.event_status,
        e.event_duration,
        e.event_create_time,
        e.event_description,
        e.rsvp_total_limit,
        e.rsvp_user_id,
        e.rsvp_response,
        e.rsvp_response_time,
        e.rsvp_guests,
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
    event_name,
    group_id,
    venue_id,
    event_start_time,
    event_status,
    event_duration,
    event_create_time,
    event_description,
    rsvp_total_limit,
    rsvp_user_id
    rsvp_response,
    rsvp_response_time,
    rsvp_guests,
    venue_name,
    venue_city,
    venue_country,
    venue_lat,
    venue_lon
FROM staging
    );
  