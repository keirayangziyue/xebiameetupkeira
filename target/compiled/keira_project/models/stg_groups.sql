


WITH stggroups AS(
    SELECT
      group_id, 
      name AS group_name,
      EXTRACT(YEAR FROM TIMESTAMP_SECONDS(CAST(created / 1000 AS INT64))) AS group_created_year, 
      EXTRACT(MONTH FROM TIMESTAMP_SECONDS(CAST(created / 1000 AS INT64))) AS group_created_month,
      description AS group_description,
      city AS group_city,
      lat AS group_lat,
      lon AS group_lon   
    FROM `keira-xebia`.`meetupservice`.`source_groups`
)

SELECT 
  group_id, --unique identifier of a group
  group_name,
  group_created_year,
  group_created_month,
  group_description,
  group_city,
  group_lat,
  group_lon
FROM stggroups