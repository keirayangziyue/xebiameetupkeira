{{ config(
    materialized='table' 
) }}

WITH usergroup AS (
    SELECT
        user_id,
        membership.group_id AS join_group_id,
        TIMESTAMP_SECONDS(CAST(membership.joined / 1000 AS INT64)) AS join_group_time --timestamp
    FROM {{ source('meetupservice', 'source_users') }},
    UNNEST(memberships) AS membership
)

SELECT 
    user_id, 
    join_group_id,
    join_group_time
FROM usergroup
