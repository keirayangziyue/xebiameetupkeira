

WITH users AS (
    SELECT
        user_id,
        country AS user_country,
        city AS user_city,
        hometown AS user_hometown,
        membership.group_id AS join_group_id,
        EXTRACT(YEAR FROM TIMESTAMP_SECONDS
        (CAST(membership.joined / 1000 AS INT64))) AS join_group_year, 
        EXTRACT(MONTH FROM TIMESTAMP_SECONDS
        (CAST(membership.joined / 1000 AS INT64))) AS join_group_month,
    FROM `keira-xebia`.`meetupservice`.`source_users`,
    UNNEST(memberships) AS membership
)

SELECT 
    user_id, 
    user_country,
    user_city,
    user_hometown,
    join_group_id,
    join_group_year,
    join_group_month
FROM users