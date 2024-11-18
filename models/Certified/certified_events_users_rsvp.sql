{{ config(
    materialized='table' 
) }}

WITH rsvp AS (
    SELECT 
        event_id,
        venue_id,
        group_id,
        event_name,
        DATE(FORMAT_TIMESTAMP('%Y-%m-%d', event_start_time)) AS event_date, --YYYY-MM-DD
        rsvp_user_id,
        rsvp_response,
        DATE(FORMAT_TIMESTAMP('%Y-%m-%d', rsvp_response_time)) AS rsvp_response_date, --YYYY-MM-DD
        rsvp_guests,
        DATE(MIN(rsvp_response_time) OVER (
            PARTITION BY event_id, rsvp_user_id))
            AS first_response_date,
        ROW_NUMBER () OVER (
            PARTITION BY event_id, rsvp_user_id
            ORDER BY rsvp_response_time DESC ) AS row_n
    FROM 
      {{ ref ('stg_events_rsvp') }}
),

final AS(
    SELECT 
        event_id,
        venue_id,
        group_id,
        event_name,
        event_date,
        rsvp_user_id,
        rsvp_response AS final_response,
        rsvp_response_date AS final_response_date,
        rsvp_guests AS final_response_guests,
        first_response_date,
        -- time duration from the last response to event day.
        DATE_DIFF(event_date, first_response_date, DAY) AS first_response_to_start,
        DATE_DIFF(event_date, rsvp_response_date, DAY) AS final_response_to_start, 
        CASE WHEN rsvp_response_date != first_response_date THEN 1 ELSE 0 END AS response_changed
    FROM rsvp
    WHERE row_n = 1
),

staging AS(
    SELECT 
        f.event_id,
        f.event_name,
        f.event_date,
        f.group_id,
        f.venue_id,
        f.rsvp_user_id,
        f.first_response_date,
        f.final_response_date,
        f.final_response,
        f.final_response_guests,
        f.first_response_to_start,
        f.final_response_to_start,
        f.response_changed,
        u.user_country,
        u.user_city,
        v.venue_country,
        v.venue_city,
        CASE WHEN u.user_country = v.venue_country AND v.venue_city = u.user_city
        THEN 'yes' ELSE 'no' END AS user_venue_same_location
    FROM final f
    JOIN {{ ref('stg_users') }} u 
    ON f.rsvp_user_id = u.user_id
    JOIN  {{ ref('stg_venues') }} v
    ON f.venue_id = v.venue_id
)


SELECT 
    event_id,
    event_name,
    event_date,
    group_id,
    venue_id,
    rsvp_user_id,
    first_response_date,
    final_response_date,
    final_response,
    final_response_guests,
    first_response_to_start,
    final_response_to_start,
    response_changed,
    user_country,
    user_city,
    venue_country,
    venue_city,
    user_venue_same_location
FROM staging

