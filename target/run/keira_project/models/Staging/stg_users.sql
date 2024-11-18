
  
    

    create or replace table `keira-xebia`.`meetupservice`.`stg_users`
      
    
    

    OPTIONS()
    as (
      

WITH users AS (
    SELECT
        user_id,
        LOWER(country) AS user_country,
        LOWER(city) AS user_city,
        LOWER(hometown) AS user_hometown
    FROM `keira-xebia`.`meetupservice`.`source_users`   
)

SELECT 
    user_id, 
    user_country,
    user_city,
    user_hometown
FROM users
    );
  