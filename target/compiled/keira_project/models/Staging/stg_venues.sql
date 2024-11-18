

SELECT 
    venue_id,
    name AS venue_name,
    LOWER(city) AS venue_city,
    LOWER(country) AS venue_country,
    lat AS venue_lat,
    lon AS venue_lon
FROM `keira-xebia`.`meetupservice`.`source_venues`