LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flights1.csv'
INTO TABLE flights
FIELDS TERMINATED BY ',' -- separateur: ;|
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- '\r\n' for windows
ignore 1 lines;	 		  -- 0 lines ça marche  
-- (col_name1, col_name2, col_name3)

(@v7,month,day,@v1,sched_dep_time,@v2,@v3,sched_arr_time,@v4,carrier,flight,@v5,origin,dest,@v6,distance,hour,minute,time_hour)
SET 
year = nullif(@v7,'NA'),
dep_time = nullif(@v1,'NA'),
dep_delay = nullif(@v2,'NA'),
arr_time = nullif(@v3,'NA'),
arr_delay = nullif(@v4,'NA'),
tailnum = nullif(@v5,'NA'),
air_time = nullif(@v6,'NA')
;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airports1.csv'
INTO TABLE airports
FIELDS TERMINATED BY ',' -- separateur: ;|
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- '\r\n' for windows
ignore 1 lines;	



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/planes1.csv'
INTO TABLE planes
FIELDS TERMINATED BY ',' -- separateur: ;|
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- '\r\n' for windows
ignore 1 lines;	

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airlines1.csv'
INTO TABLE airlines
FIELDS TERMINATED BY ',' -- separateur: ;|
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- '\r\n' for windows
ignore 1 lines;	

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/weather1.csv'
INTO TABLE weather 
FIELDS TERMINATED BY ',' -- separateur: ;|
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- '\r\n' for windows
ignore 1 lines;	


