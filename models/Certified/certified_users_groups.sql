{{ config(
    materialized='table' 
) }}

WITH usergroup AS(
    SELECT 
        user_id, 
        join_group_id,
        DATE(FORMAT_TIMESTAMP('%Y-%m-%d', join_group_time)) AS join_group_date
    FROM {{ ref('stg_users_groups') }}
),

userevent AS(
    SELECT 
        g.user_id,
        g.join_group_id,
        g.join_group_date,
        SUM( CASE WHEN e.final_response = 'yes' THEN 1 ELSE 0 END ) AS accept_event_cnt,
        SUM( CASE WHEN e.final_response != 'yes' THEN 1 ELSE 0 END ) AS decline_event_cnt
    FROM usergroup g
    LEFT JOIN {{ ref ('certified_events_users_rsvp') }} e
    ON g.user_id = e.rsvp_user_id
    AND g.join_group_id = e.group_id
    WHERE e.event_date >= g.join_group_date
    GROUP BY g.user_id, g.join_group_id, g.join_group_date
),

staging AS (
    SELECT 
        user_id,
        join_group_id,
        join_group_date,
        accept_event_cnt,
        decline_event_cnt,
        accept_event_cnt + decline_event_cnt AS total_event_cnt,
        accept_event_cnt * 1.00 / (accept_event_cnt + decline_event_cnt) AS group_event_accept_rate
    FROM userevent
)

SELECT 
    user_id,
    join_group_id,
    join_group_date,
    accept_event_cnt,
    decline_event_cnt,
    total_event_cnt,
    group_event_accept_rate
FROM staging


