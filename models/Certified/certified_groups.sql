{{ config(
    materialized='table' 
) }}


SELECT 
    group_id, --unique identifier of a group
    group_name,
    group_created_year,
    group_created_month,
    group_description,
    group_city,
    group_lat,
    group_lon
FROM {{ ref('stg_groups') }} 
   


