DROP SCHEMA IF EXISTS NYCflights;
CREATE SCHEMA NYCflights;

USE NYCflights;
DROP TABLE IF EXISTS flights ;
CREATE TABLE flights (
	-- nb VARCHAR(10),
	year CHAR(4) ,
	month CHAR(2), -- char(2) ne lit pas char de 1 character, donc il faut mettre VARCHAR
	day CHAR(2), -- char(2)
	dep_time SMALLINT UNSIGNED,
	sched_dep_time SMALLINT UNSIGNED,
	dep_delay SMALLINT,
	arr_time SMALLINT UNSIGNED,
	sched_arr_time SMALLINT UNSIGNED,
	arr_delay SMALLINT,
	carrier CHAR(2),
	flight VARCHAR (4), -- SMALLINT UNSIGNED,
	tailnum CHAR(6), -- normé à 6 
	origin CHAR(3),
	dest CHAR(3),
	air_time SMALLINT UNSIGNED,
	distance SMALLINT UNSIGNED,
	hour CHAR(2),
	minute CHAR(2),
	time_hour VARCHAR(20) -- year+month+day+hour (sans les minutes)
	-- PRIMARY KEY (year, month, day, hour, minute, origin, dest, flight) il pourrait poser problème 
);

ALTER TABLE flights 
ADD id_flights INT UNSIGNED AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE flights
ADD CONSTRAINT fk_flights_airlines
  FOREIGN KEY (carrier)
  REFERENCES airlines (carrier);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_airports
  FOREIGN KEY (origin)
  REFERENCES airports (faa);


-- Il y a des dest qui présente dans flights, mais n'y est pas dans table airport

SELECT DISTINCT dest from flights where dest NOT in (SELECT faa from airports);

INSERT INTO airports (faa)
SELECT DISTINCT dest from flights where dest NOT in (SELECT faa from airports);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_airports_dest
  FOREIGN KEY (dest)
  REFERENCES airports (faa);

-- Il y a des tailnum qui présente dans flights, mais n'y est pas dans le planes 


-- TESTS deux façon pour chercher des tailnum qui présente dans flights, mais n'y est pas dans le planes 
-- -- 
-- 1) 721 rows

SELECT DISTINCT tailnum FROM flights 
    WHERE tailnum NOT IN (SELECT tailnum FROM planes);
-- 2) 722 rows 

select distinct flights.tailnum from flights left join planes on planes.tailnum=flights.tailnum where planes.tailnum is null;
-- par les 722 rows Il y a un row que planes.tailnum et flights.tailnum sont tous null. ce row n'est pas intéressant 


-- Ajouter ces tailnum dans la TABLE planes
INSERT INTO planes (tailnum) 
	SELECT DISTINCT tailnum FROM flights 
    WHERE tailnum NOT IN (SELECT tailnum FROM planes);

ALTER TABLE flights
ADD CONSTRAINT fk_flights_planes
  FOREIGN KEY (tailnum)
  REFERENCES planes (tailnum);


-- Création de la table airlines :
DROP TABLE IF EXISTS airlines ;
CREATE TABLE airlines 
(
     carrier CHAR(2) PRIMARY KEY,
     name VARCHAR(30)
); 
SHOW WARNINGS ;-- Permet de capturer les erreurs et warnings générés par la rêquete précédente (en mode d'exécution manuel).



-- select count(*) from (select distinct flights.tailnum from flights left join planes on planes.tailnum=flights.tailnum where planes.tailnum is null) as A;

-- Création de la table planes :
DROP TABLE IF EXISTS planes ;
CREATE TABLE planes 
(
 tailnum CHAR (6) PRIMARY KEY,
 year char(4),
 type VARCHAR (25),
 manufacturer VARCHAR(30),
 model VARCHAR(20),
 engines TINYINT,
 seats SMALLINT,
 speed SMALLINT UNSIGNED,
 engine VARCHAR(15)    
);-- Permet de capturer les erreurs et warnings générés par la rêquete précédente (en mode d'exécution manuel).


-- Création de la table airports :
DROP TABLE IF EXISTS airports ;
CREATE TABLE airports 
(
     faa VARCHAR(3) PRIMARY KEY,
     name VARCHAR(55),
     lat SMALLINT UNSIGNED,
     lon SMALLINT,
     alt SMALLINT,
     tz TINYINT,
     dst VARCHAR(1),
     tzone VARCHAR(20)
);-- Permet de capturer les erreurs et warnings générés par la rêquete précédente (en mode d'exécution manuel).


-- Création de la table weather :
DROP TABLE IF EXISTS weather ;
CREATE TABLE weather 
(
     origin VARCHAR(3),
     year char(4),
     month CHAR(2),
     day CHAR(2),
     hour CHAR(2),
     temp DECIMAL(5,2),
     dewp DECIMAL(4,2),
     humid DECIMAL(5,2),
     wind_dir SMALLINT,
     wind_speed DECIMAL(21,17),    -- ça passe sinon decimal ?
     wind_gust DECIMAL(17,15),
     precip DECIMAL(10,5),         --
     pressure DECIMAL(10,5),
     visib DECIMAL(10,5),
     time_hour DATETIME

);-- Permet de capturer les erreurs et warnings générés par la rêquete précédente (en mode d'exécution manuel).

ALTER TABLE weather
ADD CONSTRAINT fk_weather_airport
  FOREIGN KEY (origin)
  REFERENCES airports(faa);

ALTER TABLE weather
ADD doublon int;

UPDATE weather SET doublon=0 ;

UPDATE weather SET doublon=1 where origin="EWR" AND year="2013" AND month="11" AND day="3" AND hour="1" AND temp=51.98;

ALTER TABLE weather
ADD PRIMARY KEY (origin, year, month, day, hour,doublon);

SELECT * from weather where origin="EWR" AND year="2013" AND month="11" AND day="3" AND hour="1";

SELECT * from weather where origin="JFK" AND year="2013" AND month="11" AND day="3" AND hour="1";

UPDATE weather SET doublon=1 where origin="JFK" AND year="2013" AND month="11" AND day="3" AND hour="1" AND temp=53.96;

SELECT * from weather where origin="LGA" AND year="2013" AND month="11" AND day="3" AND hour="1";

UPDATE weather SET doublon=1 where origin="LGA" AND year="2013" AND month="11" AND day="3" AND hour="1" AND temp=53.96;


CREATE INDEX ind_flights ON flights (year, month, day, hour, origin); 

SELECT DISTINCT year, month, day, hour, origin 
    FROM flights 
        WHERE (year, month, day, hour, origin) 
            NOT IN (SELECT DISTINCT year, month, day, hour, origin FROM weather);




 
-- FIN DE FICHIER SCHEMA


			
		



