


SELECT
    trip_id,
    rider_id,
    driver_id,
    trip_date,
    pickup_location,
    drop_location,
    distance_km,
    fare,
    trip_status,
    payment_method
FROM dbo.trips
ORDER BY trip_id;

SELECT COUNT(*) AS total_trips
FROM dbo.trips;

SELECT COUNT(*) AS completed_trips
FROM dbo.trips
WHERE trip_status = 'Completed';

SELECT COUNT(*) AS cancelled_trips
FROM dbo.trips
WHERE trip_status = 'Cancelled';

SELECT COUNT(CASE WHEN trip_status = 'Cancelle' THEN 1 END) * 100.0 / COUNT(*) AS Cancellation_rate
FROM dbo.trips;

SELECT trip_status,
       COUNT(*) AS trip_count
FROM dbo.trips
GROUP BY trip_status;

SELECT(SELECT COUNT(*)
       FROM dbo.trips
	   WHERE trip_status = 'Cancelled') *100.0 / (SELECT COUNT(*) FROM dbo.trips) AS cancellation_rate;

SELECT SUM(fare) AS total_revenue
FROM dbo.trips
WHERE trip_status = 'Completed';


SELECT AVG(fare) AS average_trip_fare
FROM dbo.trips
WHERE trip_status = 'Completed';


SELECT AVG(distance_km) AS average_trip_distance_km
FROM dbo.trips
WHERE trip_status = 'Completed';



SELECT driver_id, 
       SUM(fare) AS total_revenue
FROM dbo.trips
WHERE trip_status = 'Completed'
GROUP BY driver_id;




SELECT d.driver_name,
       SUM(t.fare) AS total_revenue
FROM dbo.trips AS t
INNER JOIN dbo.drivers AS d
     ON t.driver_id = d.driver_id
WHERE t.trip_status = 'Completed'
Group BY d.driver_name
ORDER BY total_revenue DESC;





SELECT d.city,
       SUM(t.fare) AS total_revenue
FROM dbo.trips AS t
INNER JOIN dbo.drivers AS d
      ON t.driver_id = d.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.city
ORDER BY total_revenue DESC;



SELECT 
      d.driver_name,
	  COUNT(t.trip_id) AS total_trips
FROM dbo.trips AS t
INNER JOIN dbo.drivers AS d
     ON t.driver_id = d.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.driver_name
ORDER BY total_trips DESC;



SELECT 
      r.rider_name,
	  COUNT(t.trip_id) AS total_trips
FROM dbo.trips AS t
INNER JOIN dbo.riders AS r
     ON t.rider_id = r.rider_id
WHERE t.trip_status = 'Completed'
GROUP BY r.rider_name
ORDER BY total_trips DESC;



SELECT 
      payment_method,
	  COUNT(*) AS total_trips
FROM dbo.trips
GROUP BY payment_method
ORDER BY total_trips DESC;


SELECT
      DATEPART(Hour, trip_date) AS booking_hour, COUNT(*) AS total_trips 
FROM dbo.trips
GROUP BY DATEPART(Hour, trip_date)
ORDER BY total_trips DESC;



SELECT 
      SUM(fare) / SUM(distance_km) AS 
average_fare_per_km
FROM dbo.trips
WHERE trip_status = 'Completed';



SELECT
      pickup_location,
	  COUNT(*) AS total_trips
FROM dbo.trips
GROUP BY pickup_location
ORDER BY total_trips DESC;



SELECT 
     drop_location,
	 COUNT(*) AS total_trips
FROM dbo.trips
GROUP BY drop_location
ORDER BY total_trips DESC;



SELECT 
      pickup_location,
	  drop_location,
	  SUM(fare) AS total_revenue,
	  COUNT(trip_id) AS total_trips
FROM dbo.trips
WHERE trip_status = 'Completed'
GROUP BY pickup_location,
drop_location
ORDER BY SUM(fare) DESC;



SELECT
      d.vehicle_type,
	  SUM(fare) AS total_revenue,
	  COUNT(t.trip_id) AS total_trips
FROM dbo.trips AS t
INNER JOIN dbo.drivers AS d
     ON t.driver_id = d.driver_id
WHERE t.trip_status = 'Completed'
Group BY d.vehicle_type
ORDER BY SUM(t.fare) DESC;


SELECT
      d.driver_name,
	  COUNT(t.trip_id) AS completed_trips,
	  SUM(t.fare) AS total_revenue,
	  AVG(t.fare) AS average_fare
FROM dbo.drivers AS d
INNER JOIN dbo.trips As t
     ON d.driver_id = t.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.driver_name
ORDER BY total_revenue DESC;


SELECT
    d.driver_name,
    COUNT(t.trip_id) AS total_trips,
    SUM(CASE WHEN t.trip_status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN t.trip_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_trips
FROM dbo.drivers AS d
LEFT JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
GROUP BY d.driver_name
ORDER BY cancelled_trips DESC;



SELECT
    r.rider_name,
    COUNT(t.trip_id) AS completed_trips,
    SUM(t.fare) AS total_revenue,
    AVG(t.fare) AS average_fare
FROM dbo.riders AS r
INNER JOIN dbo.trips AS t
    ON r.rider_id = t.rider_id
WHERE t.trip_status = 'Completed'
GROUP BY r.rider_name
ORDER BY total_revenue DESC;



SELECT
    d.city,
    COUNT(t.trip_id) AS total_trips,
    SUM(CASE
        WHEN t.trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,
    SUM(CASE
        WHEN t.trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(t.trip_id) AS cancellation_rate
FROM dbo.drivers AS d
INNER JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
GROUP BY d.city
ORDER BY cancellation_rate DESC;


SELECT
    CAST(trip_date AS DATE) AS trip_day,
    COUNT(*) AS total_trips
FROM dbo.trips
GROUP BY CAST(trip_date AS DATE)
ORDER BY trip_day;



SELECT
    CAST(trip_date AS DATE) AS trip_day,
    SUM(fare) AS daily_revenue
FROM dbo.trips
WHERE trip_status = 'Completed'
GROUP BY CAST(trip_date AS DATE)
ORDER BY trip_day;


SELECT
    payment_method,
    COUNT(*) AS total_trips,
    SUM(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE 0
    END) AS total_revenue
FROM dbo.trips
GROUP BY payment_method
ORDER BY total_revenue DESC;



SELECT
    d.driver_name,
    SUM(t.fare) AS total_revenue,
    RANK() OVER (ORDER BY SUM(t.fare) DESC) AS revenue_rank
FROM dbo.drivers AS d
INNER JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.driver_name
ORDER BY revenue_rank;



WITH DriverRevenue AS
(
    SELECT
        d.driver_name,
        SUM(t.fare) AS total_revenue
    FROM dbo.drivers AS d
    INNER JOIN dbo.trips AS t
        ON d.driver_id = t.driver_id
    WHERE t.trip_status = 'Completed'
    GROUP BY d.driver_name
)
SELECT
    driver_name,
    total_revenue
FROM DriverRevenue
WHERE total_revenue > 700
ORDER BY total_revenue DESC;


WITH DriverRanking AS
(
    SELECT
        d.driver_name,
        SUM(t.fare) AS total_revenue,
        RANK() OVER (ORDER BY SUM(t.fare) DESC) AS revenue_rank
    FROM dbo.drivers AS d
    INNER JOIN dbo.trips AS t
        ON d.driver_id = t.driver_id
    WHERE t.trip_status = 'Completed'
    GROUP BY d.driver_name
)
SELECT
    driver_name,
    total_revenue,
    revenue_rank
FROM DriverRanking
WHERE revenue_rank <= 3
ORDER BY revenue_rank;


WITH RiderRanking AS
(
    SELECT
        r.rider_name,
        SUM(t.fare) AS total_spent,
        RANK() OVER (ORDER BY SUM(t.fare) DESC) AS spending_rank
    FROM dbo.riders AS r
    INNER JOIN dbo.trips AS t
        ON r.rider_id = t.rider_id
    WHERE t.trip_status = 'Completed'
    GROUP BY r.rider_name
)
SELECT
    rider_name,
    total_spent,
    spending_rank
FROM RiderRanking
ORDER BY spending_rank;


SELECT
    d.driver_name,
    COUNT(t.trip_id) AS total_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,
    SUM(CASE
        WHEN t.trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips
FROM dbo.drivers AS d
LEFT JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
GROUP BY d.driver_name
ORDER BY completed_trips DESC;


SELECT
    d.vehicle_type,
    COUNT(t.trip_id) AS completed_trips,
    AVG(t.fare) AS average_fare,
    SUM(t.fare) AS total_revenue
FROM dbo.drivers AS d
INNER JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.vehicle_type
ORDER BY average_fare DESC;



SELECT
    d.vehicle_type,
    SUM(t.fare) AS total_revenue,
    SUM(t.distance_km) AS total_distance_km,
    SUM(t.fare) / SUM(t.distance_km) AS revenue_per_km
FROM dbo.drivers AS d
INNER JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.vehicle_type
ORDER BY revenue_per_km DESC;



SELECT
    r.rider_name,
    COUNT(t.trip_id) AS completed_trips
FROM dbo.riders AS r
INNER JOIN dbo.trips AS t
    ON r.rider_id = t.rider_id
WHERE t.trip_status = 'Completed'
GROUP BY r.rider_name
HAVING COUNT(t.trip_id) > 1
ORDER BY completed_trips DESC;



SELECT
    d.vehicle_type,
    COUNT(t.trip_id) AS completed_trips,
    AVG(t.distance_km) AS average_distance_km
FROM dbo.drivers AS d
INNER JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.vehicle_type
ORDER BY average_distance_km DESC;



SELECT
    pickup_location,
    drop_location,
    COUNT(trip_id) AS total_trips,
    SUM(fare) AS total_revenue
FROM dbo.trips
WHERE trip_status = 'Completed'
GROUP BY
    pickup_location,
    drop_location
ORDER BY total_trips DESC, total_revenue DESC;




SELECT
    r.rider_name,
    COUNT(t.trip_id) AS total_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,
    SUM(CASE
        WHEN t.trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN t.fare
        ELSE 0
    END) AS total_spent
FROM dbo.riders AS r
LEFT JOIN dbo.trips AS t
    ON r.rider_id = t.rider_id
GROUP BY r.rider_name
ORDER BY total_spent DESC;



SELECT
    COUNT(*) AS total_trips,

    SUM(CASE
        WHEN trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,

    SUM(CASE
        WHEN trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,

    SUM(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE 0
    END) AS total_revenue,

    AVG(CASE
        WHEN trip_status = 'Completed' THEN fare
    END) AS average_fare,

    AVG(CASE
        WHEN trip_status = 'Completed' THEN distance_km
    END) AS average_distance_km,

    SUM(CASE
        WHEN trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*) AS cancellation_rate

FROM dbo.trips;




SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;



SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('riders', 'drivers', 'trips')
ORDER BY TABLE_NAME, ORDINAL_POSITION;



SELECT
    COUNT(*) AS total_rows,
    COUNT(trip_id) AS trip_id_present,
    COUNT(rider_id) AS rider_id_present,
    COUNT(driver_id) AS driver_id_present,
    COUNT(trip_date) AS trip_date_present,
    COUNT(fare) AS fare_present,
    COUNT(distance_km) AS distance_present,
    COUNT(trip_status) AS status_present,
    COUNT(payment_method) AS payment_present
FROM dbo.trips;



SELECT
    trip_id,
    COUNT(*) AS id_count
FROM dbo.trips
GROUP BY trip_id
HAVING COUNT(*) > 1;


SELECT
    trip_id,
    fare,
    distance_km
FROM dbo.trips
WHERE fare <= 0
   OR distance_km <= 0;


SELECT t.trip_id, t.rider_id
FROM dbo.trips AS t
LEFT JOIN dbo.riders AS r
    ON t.rider_id = r.rider_id
WHERE r.rider_id IS NULL;



SELECT t.trip_id, t.driver_id
FROM dbo.trips AS t
LEFT JOIN dbo.drivers AS d
    ON t.driver_id = d.driver_id
WHERE d.driver_id IS NULL;



SELECT
    trip_status,
    COUNT(*) AS total_trips
FROM dbo.trips
GROUP BY trip_status;


SELECT
    payment_method,
    COUNT(*) AS total_trips
FROM dbo.trips
GROUP BY payment_method;


SELECT
    trip_id,
    pickup_location,
    drop_location
FROM dbo.trips
WHERE pickup_location IS NULL
   OR drop_location IS NULL
   OR LTRIM(RTRIM(pickup_location)) = ''
   OR LTRIM(RTRIM(drop_location)) = '';


   SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trip_id) AS unique_trip_ids,
    COUNT(DISTINCT rider_id) AS unique_riders,
    COUNT(DISTINCT driver_id) AS unique_drivers,
    COUNT(DISTINCT pickup_location) AS unique_pickup_locations,
    COUNT(DISTINCT drop_location) AS unique_drop_locations
FROM dbo.trips;


EXEC sp_rename
    'dbo.trips.drop_location',
    'drop_location',
    'COLUMN';


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'trips'
ORDER BY ORDINAL_POSITION;


SELECT
    trip_id,
    rider_id,
    driver_id,
    trip_date,
    pickup_location,
    drop_location,
    distance_km,
    fare,
    trip_status,
    payment_method
FROM dbo.trips
ORDER BY trip_id;


SELECT
    pickup_location,
    drop_location,
    COUNT(trip_id) AS total_trips,
    SUM(fare) AS total_revenue
FROM dbo.trips
WHERE trip_status = 'Completed'
GROUP BY pickup_location, drop_location
ORDER BY total_revenue DESC;


USE ride_sharing_db;
GO



SELECT
    COUNT(*) AS total_trips,
    SUM(CASE
        WHEN trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,
    SUM(CASE
        WHEN trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,
    SUM(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE 0
    END) AS total_revenue,
    AVG(CASE
        WHEN trip_status = 'Completed' THEN fare
    END) AS average_fare,
    AVG(CASE
        WHEN trip_status = 'Completed' THEN distance_km
    END) AS average_distance_km,
    SUM(CASE
        WHEN trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*) AS cancellation_rate
FROM dbo.trips;




 
-- 1. OVERALL BUSINESS KPIs


SELECT
    COUNT(*) AS total_trips,

    SUM(CASE
        WHEN trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,

    SUM(CASE
        WHEN trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,

    SUM(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE 0
    END) AS total_revenue,

    AVG(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE NULL
    END) AS average_fare,

    AVG(CASE
        WHEN trip_status = 'Completed' THEN distance_km
        ELSE NULL
    END) AS average_distance_km,

    SUM(CASE
        WHEN trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*) AS cancellation_rate

FROM dbo.trips;


GO


-- 2. DRIVER ANALYSIS


SELECT
    d.driver_name,
    d.city,
    d.vehicle_type,
    COUNT(t.trip_id) AS total_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,
    SUM(CASE
        WHEN t.trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN t.fare
        ELSE 0
    END) AS total_revenue
FROM dbo.drivers AS d
LEFT JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
GROUP BY
    d.driver_name,
    d.city,
    d.vehicle_type
ORDER BY total_revenue DESC;


GO


-- 3. RIDER ANALYSIS


SELECT
    r.rider_name,
    COUNT(t.trip_id) AS total_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_trips,
    SUM(CASE
        WHEN t.trip_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_trips,
    SUM(CASE
        WHEN t.trip_status = 'Completed' THEN t.fare
        ELSE 0
    END) AS total_spent
FROM dbo.riders AS r
LEFT JOIN dbo.trips AS t
    ON r.rider_id = t.rider_id
GROUP BY r.rider_name
ORDER BY total_spent DESC;



GO


-- 4. REVENUE & PAYMENT ANALYSIS

SELECT
    payment_method,
    COUNT(*) AS total_trips,
    SUM(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE 0
    END) AS total_revenue
FROM dbo.trips
GROUP BY payment_method
ORDER BY total_revenue DESC;



GO


-- 5. ROUTE ANALYSIS


SELECT
    pickup_location,
    drop_location,
    COUNT(trip_id) AS total_trips,
    SUM(fare) AS total_revenue,
    SUM(distance_km) AS total_distance_km
FROM dbo.trips
WHERE trip_status = 'Completed'
GROUP BY
    pickup_location,
    drop_location
ORDER BY total_revenue DESC;


GO

-- 6. TRIP & CANCELLATION ANALYSIS

SELECT
    trip_status,
    COUNT(*) AS total_trips,
    SUM(fare) AS total_fare
FROM dbo.trips
GROUP BY trip_status
ORDER BY total_trips DESC;


GO


-- 7. DAILY TREND ANALYSIS


SELECT
    CAST(trip_date AS DATE) AS trip_day,
    COUNT(*) AS total_trips,
    SUM(CASE
        WHEN trip_status = 'Completed' THEN fare
        ELSE 0
    END) AS daily_revenue
FROM dbo.trips
GROUP BY CAST(trip_date AS DATE)
ORDER BY trip_day;


GO


-- 8. VEHICLE PERFORMANCE ANALYSIS


SELECT
    d.vehicle_type,
    COUNT(t.trip_id) AS completed_trips,
    SUM(t.fare) AS total_revenue,
    AVG(t.fare) AS average_fare,
    AVG(t.distance_km) AS average_distance_km,
    SUM(t.fare) / NULLIF(SUM(t.distance_km), 0) AS revenue_per_km
FROM dbo.drivers AS d
INNER JOIN dbo.trips AS t
    ON d.driver_id = t.driver_id
WHERE t.trip_status = 'Completed'
GROUP BY d.vehicle_type
ORDER BY total_revenue DESC;


