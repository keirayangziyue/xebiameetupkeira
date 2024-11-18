

WITH group_topics AS (
    SELECT
        group_id,
        topic
    FROM `keira-xebia`.`meetupservice`.`source_groups`,
    UNNEST(topics) AS topic
)

SELECT
    group_id,
    topic
FROM group_topics