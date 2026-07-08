CREATE DATABASE AirbnbDW;
USE AirbnbDW;
SHOW tables;

DESCRIBE Fact_Airbnb;
DESCRIBE Dim_City;
DESCRIBE Dim_Room;
DESCRIBE Dim_Host;
DESCRIBE Dim_Week;
DESCRIBE Dim_Location;


# primary keys:

# city
ALTER TABLE Dim_City
ADD PRIMARY KEY (city_id);

# room
ALTER TABLE Dim_Room
ADD PRIMARY KEY (room_id);

# host
ALTER TABLE Dim_Host
ADD PRIMARY KEY (host_id);

# week time
ALTER TABLE Dim_Week
ADD PRIMARY KEY (week_id);

# location
ALTER TABLE Dim_Location
ADD PRIMARY KEY (location_id);

# fact airbnb
ALTER TABLE Fact_Airbnb
ADD PRIMARY KEY (listing_id);


# Foreign Keys:

# city
ALTER TABLE Fact_Airbnb
ADD CONSTRAINT fk_city
FOREIGN KEY (city_id)
REFERENCES Dim_City(city_id);

# romm
ALTER TABLE Fact_Airbnb
ADD CONSTRAINT fk_room
FOREIGN KEY (room_id)
REFERENCES Dim_Room(room_id);

# host
ALTER TABLE Fact_Airbnb
ADD CONSTRAINT fk_host
FOREIGN KEY (host_id)
REFERENCES Dim_Host(host_id);

# week time
ALTER TABLE Fact_Airbnb
ADD CONSTRAINT fk_week
FOREIGN KEY (week_id)
REFERENCES Dim_Week(week_id);

# location
ALTER TABLE Fact_Airbnb
ADD CONSTRAINT fk_location
FOREIGN KEY (location_id)
REFERENCES Dim_Location(location_id);



# SQL Analysis Quiries:

# Getting Ranking Average Price by City
SELECT
    c.city,
    ROUND(AVG(f.realSum),2) AS avg_price,
    RANK() OVER(
        ORDER BY AVG(f.realSum) DESC
    ) AS city_rank
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
GROUP BY c.city;

# Getting Price by Week Time
SELECT
    w.week_time,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_Week w
ON f.week_id = w.week_id
GROUP BY w.week_time;

# Getting Price by Room Type
SELECT
    r.room_type,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_Room r
ON f.room_id = r.room_id
GROUP BY r.room_type
ORDER BY avg_price DESC;

# Getting City + Week Time + Price
SELECT
    c.city,
    w.week_time,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
JOIN Dim_Week w
ON f.week_id = w.week_id
GROUP BY
    c.city,
    w.week_time
ORDER BY
    c.city,
    avg_price DESC;
    
# getting City + Room Type + Price
SELECT
    c.city,
    r.room_type,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
JOIN Dim_Room r
ON f.room_id = r.room_id
GROUP BY
    c.city,
    r.room_type
ORDER BY avg_price DESC;

# Getting Superhost + Week Time + Price
SELECT
    h.host_is_superhost,
    w.week_time,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_Host h
ON f.host_id = h.host_id
JOIN Dim_Week w
ON f.week_id = w.week_id
GROUP BY
    h.host_is_superhost,
    w.week_time;
    
# getting Superhost + Multi + Price
SELECT
    h.host_is_superhost,
    h.multi,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_Host h
ON f.host_id = h.host_id
GROUP BY
    h.host_is_superhost,
    h.multi;
    
# getting City + Superhost + Price
SELECT
    c.city,
    h.host_is_superhost,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
JOIN Dim_Host h
ON f.host_id = h.host_id
GROUP BY
    c.city,
    h.host_is_superhost
ORDER BY avg_price DESC;

# Central vs Non-Central
SELECT
    l.is_central,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_Location l
ON f.location_id = l.location_id
GROUP BY l.is_central;

# Near Metro vs Far From Metro
SELECT
    l.near_metro,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_Location l
ON f.location_id = l.location_id
GROUP BY l.near_metro;

# Average Price by Number of Bedrooms
SELECT
    bedrooms,
    ROUND(AVG(realSum),2) AS avg_price
FROM Fact_Airbnb
GROUP BY bedrooms
ORDER BY bedrooms;

# Best Guest Satisfaction Cities
SELECT
    c.city,
    ROUND(AVG(f.guest_satisfaction_overall),2) AS avg_satisfaction
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
GROUP BY c.city
ORDER BY avg_satisfaction DESC;

# Cleanliness vs Price
SELECT
    ROUND(AVG(cleanliness_rating),2) AS avg_cleanliness,
    ROUND(AVG(realSum),2) AS avg_price
FROM Fact_Airbnb;

# Average Attraction Index by City
SELECT
    c.city,
    ROUND(AVG(l.attr_index_norm),2) AS avg_attraction
FROM Fact_Airbnb f
JOIN Dim_City c
    ON f.city_id = c.city_id
JOIN Dim_Location l
    ON f.location_id = l.location_id
GROUP BY c.city
ORDER BY avg_attraction DESC;


# Getting Top 5 Most Expensive Cities
SELECT
    c.city,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
GROUP BY c.city
ORDER BY avg_price DESC
LIMIT 5;

# Getting Most Expensive Room Type in Each City
SELECT
    c.city,
    r.room_type,
    ROUND(AVG(f.realSum),2) AS avg_price
FROM Fact_Airbnb f
JOIN Dim_City c
ON f.city_id = c.city_id
JOIN Dim_Room r
ON f.room_id = r.room_id
GROUP BY
    c.city,
    r.room_type
ORDER BY
    c.city,
    avg_price DESC;
    
    
    SELECT
    COUNT(*) AS total_listings,
    ROUND(AVG(realSum),2) AS avg_price,
    ROUND(MAX(realSum),2) AS max_price,
    ROUND(MIN(realSum),2) AS min_price,
    ROUND(AVG(guest_satisfaction_overall),2) AS avg_satisfaction
FROM Fact_Airbnb;





