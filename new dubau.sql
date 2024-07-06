-- Create the database
CREATE DATABASE IF NOT EXISTS DubaiRealEstateGoldmine;
-- Create the table
CREATE TABLE UAE_Rentals_Markets (
    Address VARCHAR(255),
    Rent DECIMAL(10, 2),
    Beds INT,
    Baths INT,
    `Type` VARCHAR(50),
    Area_in_sqft DECIMAL(10, 2),
    Rent_per_sqft DECIMAL(10, 2),
    Rent_category VARCHAR(50),
    Frequency VARCHAR(50),
    Furnishing VARCHAR(50),
    Purpose VARCHAR(50),
    Posted_date DATE,
    Age_of_listing_in_days INT,
    Location VARCHAR(255),
    City VARCHAR(50),
    Latitude DECIMAL(10, 6),
    Longitude DECIMAL(10, 6)
);

-- Insert data into the table
INSERT INTO UAE_Rentals_Markets (
    Address, Rent, Beds, Baths, `Type`, Area_in_sqft, Rent_per_sqft,
    Rent_category, Frequency, Furnishing, Purpose, Posted_date,
    Age_of_listing_in_days, Location, City, Latitude, Longitude)
Select Address, Rent, Beds, Baths, `Type`, Area_in_sqft, Rent_per_sqft,
    Rent_category, Frequency, Furnishing, Purpose, Posted_date,
    Age_of_listing_in_days, Location, City, Latitude, Longitude
FROM dubai_properties;

Select * from UAE_Rentals_Markets;
Describe UAE_Rentals_Markets;
-- Rent distribution across different rent categories
SELECT Rent_category, COUNT(*) AS Count, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Rent_category;

-- Distribution of rents by city and rent category
SELECT City, Rent_category, COUNT(*) AS Count, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY City, Rent_category;
-- Average rent per month
SELECT DATE_FORMAT(Posted_date, '%Y-%m') AS Month, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Month
ORDER BY Month;

-- Count of new listings per month
SELECT DATE_FORMAT(Posted_date, '%Y-%m') AS Month, COUNT(*) AS New_Listings
FROM UAE_Rentals_Markets
GROUP BY Month
ORDER BY Month;

-- Correlation between rent and property size
SELECT Area_in_sqft, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Area_in_sqft
ORDER BY Area_in_sqft;

-- Average rent by number of beds
SELECT Beds, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Beds
ORDER BY Beds;

-- Average rent by number of baths
SELECT Baths, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Baths
ORDER BY Baths;

-- Average rent by furnishing status
SELECT Furnishing, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Furnishing;

-- Count of listings by furnishing status and city
SELECT City, Furnishing, COUNT(*) AS Count
FROM UAE_Rentals_Markets
GROUP BY City, Furnishing;

-- Average rent by age of listing
SELECT Age_of_listing_in_days, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Age_of_listing_in_days
ORDER BY Age_of_listing_in_days;

-- Distribution of property listings by age category
SELECT 
  CASE 
    WHEN Age_of_listing_in_days < 30 THEN 'Less than 1 month'
    WHEN Age_of_listing_in_days BETWEEN 30 AND 60 THEN '1-2 months'
    WHEN Age_of_listing_in_days BETWEEN 61 AND 90 THEN '2-3 months'
    ELSE 'More than 3 months'
  END AS Age_Category,
  COUNT(*) AS Count
FROM UAE_Rentals_Markets
GROUP BY Age_Category;

-- Average rent by location
SELECT Location, AVG(Rent) AS Average_Rent
FROM UAE_Rentals_Markets
GROUP BY Location
ORDER BY Average_Rent DESC;

-- Count of listings by location and type
SELECT Location, Type, COUNT(*) AS Count
FROM UAE_Rentals_Markets
GROUP BY Location, Type
ORDER BY Location, Count DESC;

-- Detailed insights on luxury properties
SELECT City, Address, Rent, Beds, Baths, Area_in_sqft, Furnishing, Posted_date
FROM UAE_Rentals_Markets
WHERE Rent_category = 'High'
ORDER BY Rent DESC;

-- Detailed insights on economy properties
SELECT City, Address, Rent, Beds, Baths, Area_in_sqft, Furnishing, Posted_date
FROM UAE_Rentals_Markets
WHERE Rent_category = 'Low'
ORDER BY Rent ASC;

-- Identify potential outliers in rent prices by city
SELECT City, Address, Rent, Beds, Baths, Area_in_sqft, Furnishing, Posted_date
FROM UAE_Rentals_Markets
WHERE Rent > (SELECT AVG(Rent) + 2 * STDDEV(Rent) FROM UAE_Rentals_Markets WHERE City = UAE_Rentals_Markets.City)
   OR Rent < (SELECT AVG(Rent) - 2 * STDDEV(Rent) FROM UAE_Rentals_Markets WHERE City = UAE_Rentals_Markets.City)
ORDER BY City, Rent DESC;

-- Average rent and area for each property type
SELECT Type, AVG(Rent) AS Average_Rent, AVG(Area_in_sqft) AS Average_Area
FROM UAE_Rentals_Markets
GROUP BY Type
ORDER BY Average_Rent DESC;

-- Count of listings by property type and city
SELECT City, Type, COUNT(*) AS Count
FROM UAE_Rentals_Markets
GROUP BY City, Type
ORDER BY City, Count DESC;

SELECT COUNT(*) AS TotalRows FROM UAE_Rentals_Markets;


   