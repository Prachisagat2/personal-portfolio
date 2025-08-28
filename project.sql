-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS RETAIL_DB;

-- Use the newly created database
USE RETAIL_DB;

-- Drop the table if it already exists (note: do this *after* using the DB)
DROP TABLE IF EXISTS odi_cricket_data;

-- Create the odi_cricket_data table
CREATE TABLE odi_cricket_data (
    player_name VARCHAR(100),
    role VARCHAR(50),
    total_runs INT,
    strike_rate VARCHAR(50),
    total_balls_faced INT,
    total_wickets_taken INT,
    total_runs_conceded INT,
    total_overs_bowled INT,
    total_matches_played INT,
    matches_played_as_batter INT,
    matches_played_as_bowler INT,
    matches_won INT,
    matches_lost INT,
    player_of_match_awards INT,
    team VARCHAR(100),
    average VARCHAR(50),
    percentage VARCHAR(255)
);

-- Optional: View the table structure
DESC odi_cricket_data;

-- Optional: View contents of the table
SELECT * FROM odi_cricket_data;

-- Check if local infile is enabled (required for LOAD DATA INFILE)
SHOW VARIABLES LIKE 'local_infile';

-- Enable local infile if not already enabled (requires SUPER privileges)
SET GLOBAL local_infile = 1;

-- Load data from CSV file into the table
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ODI_data.csv"
INTO TABLE odi_cricket_data
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- First, view all data
SELECT * FROM odi_cricket_data;
-- Then, categorize players by role
SELECT 
  player_name, 
  role,
  CASE
    WHEN role = 'Batter' THEN 'Batsman'
    WHEN role = 'Bowler' THEN 'Bowler'
    ELSE 'All-Rounder'
  END AS player_category
FROM odi_cricket_data;

-- Classifying Players based on Runs Scored
SELECT
	player_name, 
	total_runs, 
    CASE
    WHEN total_runs >= 1000 THEn 'Legend'
    WHEN total_runs BETWEEN 5000 AND 9999 THEN 'Great Player'
    WHEN total_runs BETWEEN 1000 AND 4999 THEN 'Average Player'
    ELSE 'Newcomer'
END AS player_class
FROM odi_cricket_data;
-- Evaluating Bowling Performace(Wickets Taken)
SELECT
player_name,
total_wickets_Taken,
	CASE
		WHEN total_wickets_taken >=300 THEN 'Elite Bowler'
        WHEN total_wickets_taken BETWEEN 100 AND 299 THEN 'Experienced
BOWLER'
	WHEN total_wickets_taken BETWEEN 50 AND 99 THEN 'Developing 
BOWLER'
		ELSE 'part-Time Bowler'
	END AS bowling_category
FROM odi_cricket_data;
-- classifying Players by Matches won
SELECT player_name,matches_won,
	CASE
		WHEN matches_won >=300 THEN 'MATCH Winner'
        WHEN matches_won BETWEEN 100 AND 299 THEN 'consistent Perormer'
		WHEN matches_won  BETWEEN 100 AND 199 THEN 'Contributor'
        ELSE 'Less Impactful'
	END AS match_impact
FROM odi_cricket_data;
-- Categorizing Player of the Match Awards
SELECT
 player_name,
 player_of_match_Awards,
	CASE
		WHEN player_of_match_Awards >=30 THEN 'Superstar'
        WHEN player_of_match_Awards BETWEEN 15 AND 29 THEN 'Key Player'
		WHEN player_of_match_Awards BETWEEN 5 AND 14 THEN 'Occasional
Star'
        ELSE 'Rare Winner'
	END AS award_category
FROM odi_cricket_data;

-- Get top 10 batsmen by runs
SELECT player_name,
       team,
       total_runs,
       strike_rate
FROM odii_cricket_data
WHERE role = 'Batter'
ORDER BY total_runs DESC
LIMIT 10;
SELECT player_name,
       team,
       total_wickets_taken,
       total_runs_conceded,
       total_overs_bowled 
FROM odi_Cricket_data
WHERE total_wickets_taken>0 ORDER BY total_wickets_taken 
DESC LIMIT 10;
SELECT 
    player_name,
    team,
    total_wickets_taken,
    total_runs_conceded,
    total_overs_bowled
FROM 
    odi_cricket_Data
WHERE 
    total_wickets_taken > 0
ORDER BY 
    total_wickets_taken DESC
LIMIT 10;

-- Insert a new player record
INSERT INTO odi_cricket_data 
(
player_name,
role,
total_runs,
strike_rate,
total_balls_faced,
total_wickets_Taken,
total_runs_conceded,
total_overs_Bowled,
total_matches_played,
matches_played_as_batter,
matches_played_as_bowler,
matches_won,
matches_lost,player_of_match_awards,
team,
average,
percentage
)
VALUES
('NEW Player',
'Batter',5000,85.50,6000,0,0,0,200,200,0,120,80,15,'India',45.5,50.75);
-- Update strike rate for a specific player
CREATE TABLE odi_strike_cricket_data (
    player_name VARCHAR(100),
    strike_rate DECIMAL(5,2)
);
SET SQL_SAFE_UPDATES = 0;
UPDATE odi_strike_cricket_data
SET strike_rate = 90.25
WHERE player_name = 'V kholi';

SELECT * FROM odi_cricket_data WHERE player_name LIKE '%kholi%';

-- DELETE records of retired players
DELETE FROM odi_cricket_data
WHERE total_matches_played < 50;
SELECT player_name, strike_rate, average
FROM odi_cricket_data
WHERE NOT strike_rate REGEXP '^[0-9]+(\.[0-9]+)?$'
   OR NOT average REGEXP '^[0-9]+(\.[0-9]+)?$';
-- Reset strike rate and average for players with incorrect values
UPDATE odi_cricket_data
SET strike_rate = NULL,
    average = NULL
WHERE strike_rate < 0 OR average < 0;
UPDATE odi_cricket_data
SET strike_rate = NULL
WHERE strike_rate = '9.170.381.212.161.530';

-- Remove players who have never won a match
DELETE FROM odi_cricket_data WHERE matches_won=0;

/* Reset average for players with zero matches */
UPDATE odi_cricket_data
SET average = 0
WHERE total_matches_played = 0;

-- Increase total wickets taken by 5 for bowlers from a specific team
UPDATE odi_cricket_data 
SET total_wickets_taken =total_wickets_Taken+5 
WHERE ROLE = 'Bowler' AND team='Australia';

UPDATE odi_cricket_data
SET strike_rate = SUBSTRING_INDEX(strike_rate, '-', 1);

UPDATE odi_cricket_data
SET average = SUBSTRING_INDEX(average,".",2);