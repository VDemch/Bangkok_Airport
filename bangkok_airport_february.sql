CREATE DATABASE bangkok_airport;
USE bangkok_airport;
SELECT * FROM departures;
SELECT * FROM arrivals;


ALTER TABLE arrivals 
ADD COLUMN arrival_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE departures 
ADD COLUMN departure_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

UPDATE departures
SET flight_status = 'Unknown'
WHERE flight_status is NULL;

UPDATE arrivals
SET flight_status = 'Unknown'
WHERE flight_status is NULL;



ALTER TABLE arrivals
MODIFY COLUMN arrival_time_actual DATETIME,
MODIFY COLUMN arrival_time_scheduled DATETIME,
MODIFY COLUMN departure_time_actual DATETIME,
MODIFY COLUMN departure_time_scheduled DATETIME;

ALTER TABLE departures
MODIFY COLUMN arrival_time_actual DATETIME,
MODIFY COLUMN arrival_time_scheduled DATETIME,
MODIFY COLUMN departure_time_actual DATETIME,
MODIFY COLUMN departure_time_scheduled DATETIME;

--Creating_table_aircrafts
CREATE TABLE aircrafts (
aircraft_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
aircraft_name VARCHAR(30),
aircraft_model VARCHAR(30),
full_passenger_capacity INT,
estimated_capacity INT
);

INSERT INTO aircrafts (aircraft_name)
SELECT DISTINCT TRIM(aircraft_name) AS aircraft_name 
FROM (
    SELECT aircraft_name FROM arrivals
    UNION 
    SELECT aircraft_name FROM departures
) AS unique_aircrafts;


--Adding_aircraft_id_to_table_aircrafts_and_adding_Foreign Key
ALTER TABLE arrivals 
ADD COLUMN aircraft_id INT NOT NULL;

UPDATE arrivals a
JOIN aircrafts ai ON a.aircraft_name = ai.aircraft_name
SET a.aircraft_id = ai.aircraft_id;

ALTER TABLE arrivals 
ADD FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id);

ALTER TABLE departures
ADD COLUMN aircraft_id INT NOT NULL;

UPDATE departures d
JOIN aircrafts ai ON d.aircraft_name = ai.aircraft_name
SET d.aircraft_id = ai.aircraft_id;

ALTER TABLE departures 
ADD FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id);
select * from aircrafts;

--Filling_in_empty_columns_in_the_aircrafts_table
UPDATE aircrafts
SET full_passenger_capacity = 
	CASE
	WHEN aircraft_name = 'Airbus A320-100/200' THEN 160
        WHEN aircraft_name = 'Airbus A318/A319/A320/' THEN 130
	WHEN aircraft_name = 'Boeing B787-8 Dreamliner' THEN 242
        WHEN aircraft_name = 'Airbus A330-300' THEN 277
        WHEN aircraft_name = 'Boeing 777-200/200ER PAX' THEN 314
        WHEN aircraft_name = 'Airbus A350-900' THEN 325
        WHEN aircraft_name = 'Airbus A319' THEN 124
        WHEN aircraft_name = 'Boeing B787-9 Dreamliner' THEN 292
        WHEN aircraft_name = 'Boeing 737-800 pax' THEN 162
        WHEN aircraft_name = 'Airbus A320 neo' THEN 165
        WHEN aircraft_name = 'Boeing 737-700 pax' THEN 126
        WHEN aircraft_name = 'Airbus A321 neo' THEN 190
        WHEN aircraft_name = 'Airbus A321-100/200' THEN 185
        WHEN aircraft_name = 'ATR72-201202' THEN 70
        WHEN aircraft_name = 'Boeing B777-300ER' THEN 396
        WHEN aircraft_name = 'ATR42-400' THEN 48
        WHEN aircraft_name = 'Boeing 787-10 Dreamliner' THEN 330
        WHEN aircraft_name = 'Cessna 208 Caravan' THEN 12
        WHEN aircraft_name = 'Boeing 737 Max 8' THEN 178
	WHEN aircraft_name = 'BAE-125-700-900/Hawker 900' THEN 10
	WHEN aircraft_name = 'Airbus A380-800' THEN 525
        WHEN aircraft_name = 'Boeing 777-300' THEN 368
        WHEN aircraft_name = 'Airbus A330-900 (Neo)' THEN 287
        WHEN aircraft_name = 'Boeing 737-300 pax' THEN 126
        WHEN aircraft_name = 'Boeing 777-200 LR/Freighter' THEN 301
        WHEN aircraft_name = 'Boeing 737-900 pax' THEN 180
        WHEN aircraft_name = 'Airbus A330' THEN 275
        WHEN aircraft_name = 'Boeing 767-300 (Winglets)' THEN 218
        WHEN aircraft_name = 'Airbus A340-600' THEN 380
        WHEN aircraft_name = 'Embraer 190' THEN 100
        WHEN aircraft_name = 'Airbus A330-200 Freighter' THEN 0
        WHEN aircraft_name = 'Gulfstream G200' THEN 9
        WHEN aircraft_name = 'Airbus A350-1000' THEN 369
        WHEN aircraft_name = 'Airbus A340-300' THEN 295
        WHEN aircraft_name = 'Cessna Citation Mustang' THEN 5
        WHEN aircraft_name = 'Beechcraft King Air 350' THEN 10
        WHEN aircraft_name = 'Cessna750 Citation10/Citation' THEN 10
        WHEN aircraft_name = 'Gulfstream V G-5SP G550' THEN 16
	ELSE NULL
END;

UPDATE aircrafts
SET estimated_capacity = 0.8 * full_passenger_capacity;

--Splitting_the_aircraft_name_into_name_and_model
UPDATE aircrafts
SET aircraft_model = TRIM(SUBSTRING(aircraft_name, INSTR(aircraft_name, ' ') + 1)),
    aircraft_name = TRIM(SUBSTRING_INDEX(aircraft_name, ' ', 1));
    
UPDATE aircrafts
SET aircraft_name = 'ATR',
    aircraft_model = '72-201202'
WHERE aircraft_name = 'ATR72-201202';

UPDATE aircrafts
SET aircraft_name = 'ATR',
    aircraft_model = '42-400'
WHERE aircraft_name = 'ATR42-400';

UPDATE aircrafts
SET aircraft_name = 'BAE',
    aircraft_model = '125-700-900/Hawker 900'
WHERE aircraft_name = 'BAE-125-700-900/Hawker';

UPDATE aircrafts
SET aircraft_name = 'Cessna',
    aircraft_model = '750 Citation10/Citation'
WHERE aircraft_name = 'Cessna750';

--Видалення стовпця aircraft_name із таблиць arrivals та departures

ALTER TABLE arrivals
DROP COLUMN aircraft_name;

ALTER TABLE departures
DROP COLUMN aircraft_name;


--Creating_table_countries

CREATE TABLE countries (
country_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
country VARCHAR(45) NOT NULL
);


INSERT INTO countries (country)
VALUES
('Argentina'),
('Australia'),
('Austria'),
('Bangladesh'),
('Belgium'),
('Bhutan'),
('Brazil'),
('Brunei'),
('Cambodia'),
('Canada'),
('China'),
('Denmark'),
('Egypt'),
('Ethiopia'),
('Finland'),
('France'),
('Germany'),
('Hong Kong'),
('India'),
('Indonesia'),
('Iran'),
('Israel'),
('Italy'),
('Japan'),
('Jordan'),
('Kazakhstan'),
('Kenya'),
('Kuwait'),
('Laos'),
('Macao'),
('Malaysia'),
('Maldives'),
('Mongolia'),
('Myanmar'),
('Nepal'),
('Netherlands'),
('New Caledonia'),
('Norway'),
('Oman'),
('Pakistan'),
('Philippines'),
('Poland'),
('Qatar'),
('Réunion'),
('Russia'),
('Saudi Arabia'),
('Singapore'),
('South Korea'),
('Spain'),
('Sri Lanka'),
('Sweden'),
('Switzerland'),
('Taiwan'),
('Thailand'),
('Turkey'),
('Turkmenistan'),
('United Arab Emirates'),
('United Kingdom'),
('United States'),
('Uzbekistan'),
('Vietnam');

--Creating_table_cities

CREATE TABLE cities (
    city_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,     
    city VARCHAR(45) NOT NULL,            
    country_id INT,                            
    FOREIGN KEY (country_id) REFERENCES countries(country_id) 
);

INSERT INTO cities (city, country_id) VALUES
('Abu Dhabi', 57),
('Addis Ababa', 14),
('Ahmedabad', 19),
('Almaty', 26),
('Amman', 25),
('Amsterdam', 36),
('Ashkhabad', 56),
('Bahrain', 43),
('Bandar Seri Begawan', 8),
('Beijing', 11),
('Beijing Daxing', 11),
('Bengaluru', 19),
('Bhubaneshwar', 19),
('Brussels', 5),
('Buri Ram', 54),
('Busan', 48),
('Cairo', 13),
('Cebu', 41),
('Changchun', 11),
('Changsha', 11),
('Changzhou', 11),
('Chengdu/Tianfu', 11),
('Chennai', 19),
('Chiang Mai', 54),
('Chiang Rai', 54),
('Chongqing', 11),
('Cochin', 19),
('Colombo', 50),
('Copenhagen', 12),
('Cordoba', 1),
('Cuneo', 23),
('Daegu', 48),
('Dali', 11),
('Danang', 61),
('Dayong', 11),
('Denpasar', 20),
('Dhaka', 4),
('Doha', 43),
('Don Mueang', 54),
('Dubai', 57),
('Frankfurt', 17),
('Fukuoka', 24),
('Fuzhou', 11),
('Gaya', 19),
('General-Santos', 41),
('Guangzhou', 11),
('Guilin', 11),
('Guiyang', 11),
('Guwahati', 19),
('Haikou', 11),
('Hangzhou', 11),
('Hanoi', 61),
('Harbin', 11),
('Hat Yai', 54),
('Hefei', 11),
('Helsinki', 15),
('Ho Chi Minh City', 61),
('Hohhot', 11),
('Hong Kong', 18),
('Hyderabad', 19),
('Incheon', 48),
('Irkutsk', 45),
('Islamabad', 40),
('Istanbul', 55),
('Jaipur', 19),
('Jakarta', 20),
('Jeddah', 46),
('Jieyang/Chaoshan', 11),
('Jinan', 11),
('Jinjiang', 11),
('Johore Bahru', 31),
('Kaohsiung', 53),
('Karachi', 40),
('Kathmandu', 35),
('Katowice', 42),
('Khabarovsk', 45),
('Khon Kaen', 54),
('Koh Mai Si', 54),
('Kolkata', 19),
('Krabi', 54),
('Krasnoyarsk', 45),
('Kuala Lumpur', 31),
('Kunming', 11),
('Kuwait', 28),
('Lahore', 40),
('Lampang', 54),
('Lanzhou', 11),
('London/Gatwick', 58),
('London/Heathrow', 58),
('Luang Prabang', 29),
('Lucknow', 19),
('Luzon Island', 41),
('Macao', 30),
('Mae Hong Son', 54),
('Male', 32),
('Mandalay', 34),
('Manila', 41),
('Medina', 46),
('Melbourne', 2),
('Milan', 23),
('Moscow', 45),
('Muan', 48),
('Mumbai', 19),
('Munich', 17),
('Muscat', 39),
('Nagoya', 24),
('Naha', 24),
('Nairobi', 27),
('Nakhon Si Thammarat', 54),
('Nanchang', 11),
('Nanjing', 11),
('Nanning', 11),
('New Delhi', 19),
('Ningbo', 11),
('Noumea', 37),
('Novosibirsk', 45),
('Osaka', 24),
('Oslo', 38),
('Palma De Mallorca', 49),
('Paris', 16),
('Paro', 6),
('Penang', 31),
('Perth', 2),
('Phnom Penh', 9),
('Phu Quoc', 61),
('Phuket', 54),
('Pune', 19),
('Qingdao', 11),
('Reunion', 44),
('Riyadh', 46),
('Rome', 23),
('Samui', 54),
('Sankt Petersburg', 45),
('Sao Paulo', 7),
('Sapporo', 24),
('Savannakhet', 29),
('Shanghai', 11),
('Sharjah', 57),
('Shenyang', 11),
('Shenzhen', 11),
('Shijiazhuang', 11),
('Siem Reap', 9),
('Singapore', 47),
('Stockholm', 51),
('Sukhothai', 54),
('Surat', 19),
('Surat Thani', 54),
('Suvarnabhumi', 54),
('Sydney', 2),
('Taipei', 53),
('Taiyuan', 11),
('Tashkent', 60),
('Tehran', 21),
('Tel Aviv', 22),
('Tokyo', 24),
('Trat', 54),
('Ubon Ratchathani', 54),
('Udon Thani', 54),
('Ulaanbaatar', 33),
('Urumqi', 11),
('Vancouver', 10),
('Vienna', 3),
('Vientiane', 29),
('Warsaw', 42),
('Washington', 59),
('Wenzhou', 11),
('Wuhan', 11),
('Wuxi', 11),
('Xiamen', 11),
('Xian', 11),
('Xuzhou', 11),
('Yancheng', 11),
('Yangon', 34),
('Yantai', 11),
('Yekaterinburg', 45),
('Yuncheng', 11),
('Zhengzhou', 11),
('Zurich', 52);

--Adding_city_id, country_id, Foreign_Key (for arrivals and departures)
ALTER TABLE arrivals 
ADD COLUMN arrival_city_id INT,
ADD COLUMN departure_city_id INT;

ALTER TABLE arrivals
ADD FOREIGN KEY (arrival_city_id) REFERENCES cities(city_id),
ADD FOREIGN KEY (departure_city_id) REFERENCES cities(city_id);

UPDATE arrivals a
JOIN cities c ON a.arrival_city = c.city
SET a.arrival_city_id = c.city_id;

UPDATE arrivals a
JOIN cities c ON a.departure_city = c.city
SET a.departure_city_id = c.city_id;

ALTER TABLE arrivals 
ADD COLUMN arrival_country_id INT,
ADD COLUMN departure_country_id INT;

ALTER TABLE arrivals
ADD FOREIGN KEY (arrival_country_id) REFERENCES countries(country_id),
ADD FOREIGN KEY (departure_country_id) REFERENCES countries(country_id);


UPDATE arrivals a
JOIN cities d_city ON a.departure_city_id = d_city.city_id
JOIN countries d_country ON d_city.country_id = d_country.country_id
SET a.departure_country_id = d_country.country_id;

UPDATE arrivals a
JOIN cities ar_city ON a.arrival_city_id = ar_city.city_id
JOIN countries ar_country ON ar_city.country_id = ar_country.country_id
SET a.arrival_country_id = ar_country.country_id;

ALTER TABLE departures
ADD COLUMN arrival_city_id INT,
ADD COLUMN departure_city_id INT;

ALTER TABLE departures
ADD FOREIGN KEY (arrival_city_id) REFERENCES cities(city_id),
ADD FOREIGN KEY (departure_city_id) REFERENCES cities(city_id);

UPDATE departures d
JOIN cities c ON d.arrival_city = c.city
SET d.arrival_city_id = c.city_id;

UPDATE departures d
JOIN cities c ON d.departure_city = c.city
SET d.departure_city_id = c.city_id;



ALTER TABLE departures
ADD COLUMN arrival_country_id INT,
ADD COLUMN departure_country_id INT;

ALTER TABLE departures
ADD FOREIGN KEY (arrival_country_id) REFERENCES countries(country_id),
ADD FOREIGN KEY (departure_country_id) REFERENCES countries(country_id);

UPDATE departures d
JOIN cities dep_city ON d.departure_city_id = dep_city.city_id
JOIN countries dep_country ON dep_city.country_id = dep_country.country_id
SET d.departure_country_id = dep_country.country_id;

UPDATE departures d
JOIN cities a_city ON d.arrival_city_id = a_city.city_id
JOIN countries a_country ON a_city.country_id = a_country.country_id
SET d.arrival_country_id = a_country.country_id;

--Delete columns arrival_city, departure_city
ALTER TABLE arrivals
DROP COLUMN arrival_city, 
DROP COLUMN departure_city;

ALTER TABLE departures
DROP COLUMN arrival_city, 
DROP COLUMN departure_city;