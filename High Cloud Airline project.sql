Create database Airlines;

Use Airlines;

-- 1.Creating the datafield
SELECT 
    CAST(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', Day) AS DATE) AS DateField,
    Year,
    Month AS MonthNo,
    MONTHNAME(CAST(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', Day) AS DATE)) AS MonthFullName,
    CONCAT('Q', QUARTER(CAST(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', Day) AS DATE))) AS Quarter,
    CONCAT(Year, '-', LEFT(MONTHNAME(CAST(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', Day) AS DATE)), 3)) AS YearMonth,
    DAYOFWEEK(CAST(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', Day) AS DATE)) AS WeekdayNo,
    DAYNAME(CAST(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', Day) AS DATE)) AS WeekdayName,
    CASE 
        WHEN Month IN (4, 5, 6, 7, 8, 9, 10, 11, 12) THEN Month - 3 
        ELSE Month + 9 
    END AS FinancialMonth,
    CASE 
        WHEN Month IN (4, 5, 6) THEN 'FQ1'
        WHEN Month IN (7, 8, 9) THEN 'FQ2'
        WHEN Month IN (10, 11, 12) THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter
FROM maindata;





-- 2. Load Factor Percentage on a Yearly, Quarterly, Monthly Basis
SELECT 
    Year,
    QUARTER(CAST(CONCAT(Year, '-', Month, '-', Day) AS DATE)) AS Quarter,
    MONTHNAME(CAST(CONCAT(Year, '-', Month, '-', Day) AS DATE)) AS MonthFullName,
    SUM(TransportedPassengers) / SUM(AvailableSeats) * 100 AS LoadFactorPercentage
FROM maindata
GROUP BY Year, Quarter, MonthFullName;


-- 3. Load Factor Percentage on a Carrier Name Basis
SELECT 
    "Carrier Name",
    SUM(TransportedPassengers) / SUM(AvailableSeats) * 100 AS LoadFactorPercentage
FROM maindata
GROUP BY "Carrier Name";


-- 4.Identify Top 10 Carrier Names Based on Passenger Preferences
SELECT 
    "Carrier Name", 
    SUM(TransportedPassengers) AS TotalPassengers
FROM maindata
GROUP BY "Carrier Name"
ORDER BY TotalPassengers DESC
LIMIT 10;


-- 5.Display Top Routes (From-To City) Based on Number of Flights
SELECT 
    CONCAT("Origin City", ' - ', "Destination City") AS Route,
    COUNT(*) AS FlightCount
FROM maindata
GROUP BY Route
ORDER BY FlightCount DESC
LIMIT 10;


-- 6.Load Factor on Weekend vs Weekdays
SELECT 
    CASE 
        WHEN DAYOFWEEK(CAST(CONCAT(Year, '-', Month, '-', Day) AS DATE)) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    SUM(TransportedPassengers) / SUM(AvailableSeats) * 100 AS LoadFactorPercentage
FROM maindata
GROUP BY DayType;

-- 7.Number of Flights Based on Distance Group
SELECT 
    CASE 
        WHEN Distance < 500 THEN 'Short Distance (<500)'
        WHEN Distance BETWEEN 500 AND 1500 THEN 'Medium Distance (500-1500)'
        ELSE 'Long Distance (>1500)'
    END AS DistanceGroup,
    COUNT(*) AS FlightCount
FROM maindata
GROUP BY DistanceGroup;


select * from maindata;

