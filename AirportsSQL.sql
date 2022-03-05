--creating the table

CREATE TABLE IF NOT EXISTS public.airports
(
    origin_airport text,
    destination_airport text,
    origin_city text,
    destination_city text,
    passengers integer,
    seats integer,
    flights integer,
    distance integer,
    fly_date date,
    origin_population bigint,
    destination_population bigint,
    org_airport_lat numeric,
    org_airport_long numeric,
    dest_airport_lag numeric,
    dest_airport_long numeric
);

ALTER TABLE public.airports
    OWNER to postgres;

--loading the csv file 
COPY airports
FROM 'C:\Users\Andreas Pap\Desktop\Airports2.csv'
WITH 
(FORMAT csv, HEADER,DELIMITER ',' , NULL 'NA')

--  TOTAL flights per year
SELECT COUNT(*),extract(year from fly_date) as Year
FROM airports
GROUP BY Year


-- top 10 airports with the most passengers 
SELECT DISTINCT(origin_airport),sum(passengers) AS total_passengers 
FROM airports
GROUP BY origin_airport
ORDER BY sum(passengers) DESC
LIMIT 10;

-- top 10 airports with highest passenger arrivals
SELECT destination_airport,sum(passengers) AS total_passengers
FROM airports
GROUP BY destination_airport
ORDER BY total_passengers DESC
LIMIT 10;

--LOAD RATE FOR POPULAR ROUTES
WITH t1 AS
(SELECT LEAST(origin_airport, destination_airport) AS airport1, 
GREATEST(destination_airport, origin_airport) AS airport2, 
SUM(flights) AS flights,SUM(passengers) AS passengers,SUM(seats) AS seats
FROM airports
GROUP BY LEAST(origin_airport, destination_airport), GREATEST(destination_airport, origin_airport)
ORDER BY 1,2)
SELECT t.*,ROUND(passengers*100/NULLIF(seats,0),2) AS load_rate
FROM t1 t
ORDER BY flights DESC, seats DESC, passengers DESC, load_rate DESC
LIMIT 20;


--Routes with most flights 
WITH t1 AS
(SELECT LEAST(origin_airport, destination_airport) AS airport1, 
GREATEST(destination_airport, origin_airport) AS airport2, 
SUM(flights) AS flights
FROM airports
GROUP BY LEAST(origin_airport, destination_airport), GREATEST(destination_airport, origin_airport)
ORDER BY 1,2)
SELECT t.*,flights DESC
FROM t1 t
ORDER BY flights DESC
LIMIT 10;

-- average distances for routes with most flights
with t1 AS 
(SELECT LEAST(Origin_airport, Destination_airport) AS Airport1, 
GREATEST(Destination_airport, Origin_airport) AS Airport2, 
AVG(distance) AS Distance,
SUM(Flights) AS Flights
FROM airports
GROUP BY LEAST(Origin_airport, Destination_airport),  GREATEST(Destination_airport, Origin_airport)
ORDER BY 1,2)
SELECT t.*
FROM t1 t
ORDER BY  Flights DESC
LIMIT 20;
