


WITH userrsvp AS (
    SELECT 
        event_id,
        event_name,
        event_date,
        group_id,
        venue_id,
        COUNT(rsvp_user_id) AS total_user,
        SUM(final_response_guests) AS total_guests,
        SUM(CASE WHEN final_response = 'yes' THEN 1 ELSE 0 END) AS accept_user_cnt,
        SUM(CASE WHEN final_response != 'yes' THEN 1 ELSE 0 END) AS decline_user_cnt,
        SUM(CASE WHEN response_changed = 1 THEN 1 ELSE 0 END) * 1.00 / 
            COUNT(rsvp_user_id) AS response_change_rate,
        AVG(first_response_to_start) AS avg_first_response_to_start,
        AVG(final_response_to_start) AS avg_final_response_to_start,
        SUM(CASE WHEN user_venue_same_location = 'yes' THEN 1 ELSE 0 END) AS location_same_cnt,
        SUM(CASE WHEN user_venue_same_location != 'yes' THEN 1 ELSE 0 END) AS location_diff_cnt,
        SUM(CASE WHEN final_response = 'yes' AND user_venue_same_location = 'yes' THEN 1 ELSE 0 END)
            AS location_same_accept_cnt,
        SUM(CASE WHEN final_response = 'no' AND user_venue_same_location = 'yes' THEN 1 ELSE 0 END)
            AS location_same_decline_cnt
    FROM `keira-xebia`.`meetupservice`.`certified_events_users_rsvp`
    GROUP BY event_id, event_name, event_date, group_id, venue_id
),

events AS (
    SELECT 
        event_id,
        event_name,
        group_id,
        venue_id,
        DATE(FORMAT_TIMESTAMP('%Y-%m-%d', event_start_time)) AS event_date,
        event_status,
        event_duration,
        CASE
            WHEN event_duration IS NULL THEN 'unknown'
            WHEN event_duration <= 3600000 THEN 'less than 1h'  -- less than 1 hour
            WHEN event_duration > 3600000 AND event_duration <= 7200000 THEN '1-2h'  -- 1-2 hours
            WHEN event_duration > 7200000 AND event_duration <= 10800000 THEN '2-3h'  -- 2-3 hours
            WHEN event_duration > 10800000 THEN 'more than 3h'  -- more than 3 hours
            ELSE NULL
        END AS event_duration_level,
        DATE(FORMAT_TIMESTAMP('%Y-%m-%d', event_create_time)) AS event_create_date,
        DATE_DIFF(DATE(FORMAT_TIMESTAMP('%Y-%m-%d', event_start_time)),
            DATE(FORMAT_TIMESTAMP('%Y-%m-%d', event_create_time)), DAY) AS create_to_start_duration,
        event_description,
        rsvp_total_limit,
        venue_name,
        venue_country,
        venue_city,
        venue_lat,
        venue_lon
    FROM `keira-xebia`.`meetupservice`.`stg_events`
),

staging AS (
    SELECT 
        e.event_id,
        e.event_name,
        e.group_id,
        e.venue_id,
        e.event_date,
        e.event_status,
        e.event_description,
        e.event_duration,
        e.event_duration_level,
        e.event_create_date,
        e.create_to_start_duration,
        e.rsvp_total_limit,
        e.venue_name,
        e.venue_country,
        e.venue_city,
        r.total_user,
        r.total_guests,
        r.accept_user_cnt,
        r.accept_user_cnt * 1.00 / r.total_user AS accept_rate,
        r.decline_user_cnt,
        r.decline_user_cnt * 1.00 / r.total_user AS decline_rate,
        r.response_change_rate,
        r.avg_first_response_to_start,
        1- (r.avg_first_response_to_start * 1.00 / NULLIF (create_to_start_duration, 0)) AS first_response_indicator,
        r.avg_final_response_to_start,
        1- (r.avg_final_response_to_start * 1.00 / NULLIF (create_to_start_duration, 0)) AS final_response_indicator,
        r.location_same_cnt,
        r.location_same_cnt * 1.00 / r.total_user AS location_same_rate,
        r.location_diff_cnt,
        r.location_diff_cnt * 1.00 / r.total_user AS location_diff_rate,
        r.location_same_accept_cnt,
        r.location_same_decline_cnt
    FROM events e
    JOIN userrsvp r 
        ON e.event_id = r.event_id
)

SELECT
    event_id,
    event_name,
    group_id,
    venue_id,
    event_date,
    event_status,
    event_description,
    event_duration,
    event_duration_level,
    event_create_date,
    create_to_start_duration,
    rsvp_total_limit,
    venue_name,
    venue_country,
    venue_city,
    total_user,
    total_guests,
    accept_user_cnt,
    accept_rate,
    decline_user_cnt,
    decline_rate,
    response_change_rate,
    avg_first_response_to_start,
    first_response_indicator,
    avg_final_response_to_start,
    final_response_indicator,
    location_same_cnt,
    location_same_rate,
    location_diff_cnt,
    location_diff_rate,
    location_same_accept_cnt,
    location_same_decline_cnt
FROM staging