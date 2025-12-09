-- Create Database
CREATE DATABASE airline_delay;

-- Use Database
USE airline_delay;


-- Create Airlines Table
CREATE TABLE airlines (
    IATA_CODE VARCHAR(10) PRIMARY KEY,
    AIRLINE VARCHAR(100)
);

-- Create Airports Table
CREATE TABLE airports (
    IATA_CODE VARCHAR(10) PRIMARY KEY,
    AIRPORT VARCHAR(200),
    CITY VARCHAR(100),
    STATE VARCHAR(50),
    COUNTRY VARCHAR(50),
    LATITUDE FLOAT,
    LONGITUDE FLOAT
);

--Create Flights Table
CREATE TABLE flights (
    YEAR INT,
    MONTH INT,
    DAY INT,
    DAY_OF_WEEK INT,
    AIRLINE VARCHAR(10),
    FLIGHT_NUMBER INT,
    TAIL_NUMBER VARCHAR(20),
    ORIGIN_AIRPORT VARCHAR(10),
    DESTINATION_AIRPORT VARCHAR(10),

    SCHEDULED_DEPARTURE INT,
    DEPARTURE_TIME INT,
    DEPARTURE_DELAY INT,

    TAXI_OUT INT,
    WHEELS_OFF INT,
    SCHEDULED_TIME INT,
    ELAPSED_TIME INT,
    AIR_TIME INT,
    DISTANCE INT,

    WHEELS_ON INT,
    TAXI_IN INT,
    SCHEDULED_ARRIVAL INT,
    ARRIVAL_TIME INT,
    ARRIVAL_DELAY INT,

    DIVERTED BIT,
    CANCELLED BIT,
    CANCELLATION_REASON VARCHAR(10),

    AIR_SYSTEM_DELAY INT,
    SECURITY_DELAY INT,
    AIRLINE_DELAY INT,
    LATE_AIRCRAFT_DELAY INT,
    WEATHER_DELAY INT
);


--ANALYSIS QUESTIONS 
--Q1. Which airline has the highest average delays?
SELECT 
    f.AIRLINE,
    a.AIRLINE AS airline_name,
    COUNT(*) AS total_flights,
    AVG(COALESCE(f.DEPARTURE_DELAY, 0)) AS avg_dep_delay,
    AVG(COALESCE(f.ARRIVAL_DELAY, 0)) AS avg_arr_delay
FROM flights f
JOIN airlines a ON f.AIRLINE = a.IATA_CODE
GROUP BY f.AIRLINE, a.AIRLINE
ORDER BY avg_arr_delay DESC;

-- Q2. Which airports have the worst departure delays?
SELECT 
    f.ORIGIN_AIRPORT,
    ap.AIRPORT,
    AVG(COALESCE(f.DEPARTURE_DELAY, 0)) AS avg_dep_delay,
    COUNT(*) AS flights_count
FROM flights f
JOIN airports ap ON f.ORIGIN_AIRPORT = ap.IATA_CODE
GROUP BY f.ORIGIN_AIRPORT, ap.AIRPORT
HAVING COUNT(*) > 500
ORDER BY avg_dep_delay DESC;
 -- Q3. Which routes (Origin → Destination) suffer the worst delays?
SELECT 
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    COUNT(*) AS total_flights,
    AVG(COALESCE(ARRIVAL_DELAY, 0)) AS avg_arr_delay
FROM flights
GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT
HAVING COUNT(*) > 200
ORDER BY avg_arr_delay DESC;
-- Q4. What are the peak congestion hours?
SELECT 
    SCHEDULED_DEPARTURE / 100 AS dep_hour,
    COUNT(*) AS total_flights,
    AVG(COALESCE(DEPARTURE_DELAY, 0)) AS avg_delay
FROM flights
GROUP BY SCHEDULED_DEPARTURE / 100
ORDER BY avg_delay DESC;
--Q5. What are the top cancellation reasons?
SELECT 
    CANCELLATION_REASON,
    COUNT(*) AS total_cancelled
FROM flights
WHERE CANCELLED = 1
GROUP BY CANCELLATION_REASON
ORDER BY total_cancelled DESC;
--Q6. Which airlines have the highest cancellation rates?
SELECT 
    AIRLINE,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(100.0 * SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate
FROM flights
GROUP BY AIRLINE
ORDER BY cancellation_rate DESC;
--Q7. Which airports have the highest cancellation counts?
SELECT 
    ORIGIN_AIRPORT,
    COUNT(*) AS total_flights,
    SUM(CANCELLED) AS total_cancelled
FROM flights
GROUP BY ORIGIN_AIRPORT
ORDER BY total_cancelled DESC;
--Q8. Rank airlines by worst average delays (Window Function)
SELECT 
    AIRLINE,
    AVG(COALESCE(ARRIVAL_DELAY, 0)) AS avg_delay,
    DENSE_RANK() OVER (ORDER BY AVG(COALESCE(ARRIVAL_DELAY, 0)) DESC) AS delay_rank
FROM flights
GROUP BY AIRLINE
ORDER BY delay_rank;
--Q9. What days of the week experience the highest delays?
SELECT 
    DAY_OF_WEEK,
    AVG(COALESCE(ARRIVAL_DELAY, 0)) AS avg_delay
FROM flights
GROUP BY DAY_OF_WEEK
ORDER BY avg_delay DESC;
-- Q10. What months experience the highest delays?
SELECT 
    MONTH,
    AVG(COALESCE(ARRIVAL_DELAY, 0)) AS avg_delay
FROM flights
GROUP BY MONTH
ORDER BY avg_delay DESC;
--Q11. Does longer distance reduce or increase delays?
SELECT 
    CASE 
        WHEN DISTANCE > 1500 THEN 'Long Haul'
        ELSE 'Short Haul'
    END AS flight_type,
    AVG(COALESCE(ARRIVAL_DELAY, 0)) AS avg_delay
FROM flights
GROUP BY CASE WHEN DISTANCE > 1500 THEN 'Long Haul' ELSE 'Short Haul' END;
--Q12. Which destinations receive the most diverted flights?
SELECT 
    DESTINATION_AIRPORT,
    COUNT(*) AS total_flights,
    SUM(DIVERTED) AS total_diverted
FROM flights
GROUP BY DESTINATION_AIRPORT
ORDER BY total_diverted DESC;
--Q13. On-time performance by airline (punctuality score)?
SELECT 
    AIRLINE,
    ROUND(
        100.0 * SUM(CASE WHEN ARRIVAL_DELAY <= 0 THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS on_time_percentage
FROM flights
GROUP BY AIRLINE
ORDER BY on_time_percentage DESC;
--Q14. Compare Taxi Out Time vs Departure Delay?
SELECT 
    AIRLINE,
    AVG(TAXI_OUT) AS avg_taxi_out,
    AVG(DEPARTURE_DELAY) AS avg_dep_delay
FROM flights
GROUP BY AIRLINE
ORDER BY avg_taxi_out DESC;
-- Q15. Top 20 worst routes using window functions?
WITH route_delay AS (
    SELECT 
        ORIGIN_AIRPORT,
        DESTINATION_AIRPORT,
        COUNT(*) AS flights_count,
        AVG(ARRIVAL_DELAY) AS avg_delay
    FROM flights
    GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT
    HAVING COUNT(*) > 200
)
SELECT *,
       DENSE_RANK() OVER (ORDER BY avg_delay DESC) AS delay_rank
FROM route_delay
ORDER BY delay_rank
FETCH FIRST 20 ROWS ONLY;

