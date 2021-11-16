-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Just to look overall:
SELECT * FROM crime_scene_reports;
-- To find exactly what happend on Chamberlin street on 28.07.2020:
SELECT description FROM crime_scene_reports
WHERE street LIKE "%Chamberlin%"
AND day = 28 AND month = 7 and year = 2020;
-- Now I know the exact time of the theft 10:15 am and want to find 3 witnesses interview transcripts:
SELECT * FROM interviews WHERE transcript LIKE "%courthouse%"
AND day = 28 AND month = 7 AND year = 2020;
-- Now I have three leads (ATM, parking, airport) and I want to investigate them.
-- (PARKING) First I'll check for license plates of them who left courthouse between 15 and 35 minutes
SELECT * FROM courthouse_security_logs WHERE hour = 10 AND minute > 15 AND minute < 35
AND day = 28 AND month = 7 AND year = 2020;
-- Now I need info about them
SELECT * FROM people WHERE license_plate = "5P2BI95" OR license_plate = "94KL13X"
OR license_plate = "6P58WS2" OR license_plate = "4328GD8" OR license_plate = "G412CB7"
OR license_plate = "L93JTIZ" OR license_plate = "322W7JE" OR license_plate = "0NTHK55";
-- Now I have their names and phones and passport numbers.
-- (ATM) Now I'll the ATM case
SELECT * FROM atm_transactions WHERE day = 28 AND month = 7 AND year = 2020
AND atm_location LIKE "%Fifer%";
-- Now I hove some bank accounts. One of them maybe belongs to a theft
-- Lets convert them into person_ids to find their names and numbers
SELECT * FROM people WHERE id IN (SELECT person_id FROM bank_accounts WHERE account_number = "28500762" OR account_number = "28296815"
OR account_number = "76054385" OR account_number = "49610011" OR account_number = "16153065"
OR account_number = "25506511" OR account_number = "81061156" OR account_number = "26013199");
-- Now I have narrowed down the number of suspected candidates to 4
-- (AIRPORT CALL) Now lets look at phone callers
SELECT * FROM phone_calls WHERE day = 28 AND month = 7 AND year = 2020 AND duration < 61;
-- Now I have narrowed down the number of suspected candidates to 2 (Russel or Ernest)
-- Now I want to check who of those 2 call recievers will buy tickets on 29.07.2020
-- 1st I need to know their names and IDs
SELECT * FROM people
WHERE phone_number = "(375) 555-8161" OR phone_number = "(725) 555-3243";
-- It must be Ernest or Russel
-- Ernest got a one way tickect on 29.07 (flight_id 36) with a seat 4A:
SELECT * FROM passengers WHERE passport_number = 5773159633;
-- !!! And this is the earliest flight out of Fiftyville tomorrow !!! thanks to Raymond's description:
-- So, it is Ernest and Berthold helped him

SELECT * FROM flights WHERE day = 29 AND month = 7 AND year = 2020;
-- Lets check his destination point
SELECT * FROM flights WHERE id = 36;
-- destination airport ID wsa 4
SELECT * FROM airports WHERE id = 4;
-- London !!!


-- Also, I tried to check Russel+Philip case.
-- Here is why not Russel and Philip:
-- WRONG WAY:
-- One of them: Philip | 3391710505, lets check his flights (Russels friend)
SELECT * FROM passengers WHERE passport_number = 3391710505;
SELECT * FROM flights WHERE id = 10 OR id = 28 OR id = 47;
-- He bought some tickets
-- Now lets check for Russels tickets too:
SELECT * FROM passengers WHERE passport_number = 3592750733;
SELECT * FROM flights WHERE id = 18 OR id = 24 OR id = 54;
-- He bought 3 different tickets:
SELECT * FROM airports WHERE id = 8 OR id = 5 OR id = 6 OR id = 7 OR id = 6;
-- So it looks like they feel free to come back to Fiftyville and not trying to escape somewhere.
-- !!! And also, what is more important, his flight on 29.07 from Fiftyville was not the earliest !!!