{{ config(
    materialized='table' 
) }}

SELECT 
    user_id, 
    user_country,
    user_city,
    user_hometown
FROM {{ ref('stg_users') }}


