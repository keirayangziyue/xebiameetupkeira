
  
    

    create or replace table `keira-xebia`.`meetupservice`.`certified_group_topics`
      
    
    

    OPTIONS()
    as (
      

WITH topics AS(
    SELECT
        group_id,
        topic,
    FROM `keira-xebia`.`meetupservice`.`stg_group_topics`
),

topicgroup AS(
    SELECT 
        t.topic,
        COUNT (DISTINCT t.group_id) AS topic_group_cnt,
        COUNT (u.user_id) AS topic_user_cnt
    FROM `keira-xebia`.`meetupservice`.`stg_group_topics` t
    JOIN `keira-xebia`.`meetupservice`.`certified_users_groups` u
    ON t.group_id = u.join_group_id 
    GROUP BY t.topic
),

staging AS(
    SELECT
        t.group_id,
        t.topic,
        g.topic_group_cnt,
        g.topic_user_cnt
    FROM topics t
    JOIN topicgroup g
    ON t.topic = g.topic 
)


SELECT
    group_id,
    topic,
    topic_group_cnt, 
    topic_user_cnt
FROM staging
    );
  