{{ config(
    materialized='table' 
) }}

WITH users AS (
    SELECT
        user_id,
        LOWER(country) AS user_country,
        LOWER(city) AS user_city,
        LOWER(hometown) AS user_hometown
    FROM {{ source('meetupservice', 'source_users') }}   
)

SELECT 
    user_id, 
    user_country,
    user_city,
    user_hometown
FROM users


