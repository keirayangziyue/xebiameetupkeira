
  
    

    create or replace table `keira-xebia`.`meetupservice`.`certified_users`
      
    
    

    OPTIONS()
    as (
      

SELECT 
    user_id, 
    user_country,
    user_city,
    user_hometown
FROM `keira-xebia`.`meetupservice`.`stg_users`
    );
  