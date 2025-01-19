create database Taxiii;
use Taxiii;
CREATE TABLE Bookingss (
    Date DATE,
    Time TIME,
    Booking_ID VARCHAR(100) NOT NULL,
    Booking_Status TEXT,
    Customer_ID VARCHAR(100),
    Vehicle_Type TEXT,
    Pickup_Location TEXT,
    Drop_Location TEXT,
    Avg_VAT FLOAT,
    Cancelled_Ride_by_Customers Text,
    Reason_for_Cancellation TEXT,
    Fare FLOAT,
    Payment_Type TEXT,
    Time_Needed INT,
    Driver_Ratings FLOAT,
    Customer_Ratings FLOAT,
    Reviews TEXT,
    PRIMARY KEY (Booking_ID)
);
select * from Bookingss;

-- 1. Retrieve all successful bookings:
create view Completed_Bookings as 
select * from Bookingss where Booking_Status="Completed";
select * from Completed_Bookings;

-- Find the average ride distance for each vehicle type:
create view Average_Distance as
select Vehicle_Type, avg(Time_Needed) as Average_Distance
from Bookingss group by Vehicle_Type
order by avg(Time_Needed);
select * from Average_Distance;


--  Get the total number of cancelled rides by customers:
create view Number_of_cancelled_rides as
select count(*) as Number_of_cancelled_rides 
from Bookingss
where Booking_Status="Cancelled";

-- List the top 5 customers who booked the highest number of rides:
create view Customer_Rides as
select Customer_ID, count(Booking_ID) as Customer_Rides
from Bookingss group by Customer_ID
order by count(Booking_ID) desc limit 5;
select * from Customer_Rides;

-- Get the number of rides cancelled by drivers due to High fare and Change of plans issues:
create view Cancelled_Rides as 
select count(*) as Number_of_cancelled_rides 
from Bookingss
where Reason_for_Cancellation="High fare" or Reason_for_Cancellation="Change of plans";
select * from Cancelled_Rides;


-- Find the maximum and minimum driver ratings for the vehicles
create view Ratings as 
select Vehicle_Type, max(Driver_Ratings), min(Driver_Ratings)
from Bookingss group by Vehicle_Type
order by max(Driver_Ratings), min(Driver_Ratings);
select * from Ratings;


--  Retrieve all rides where payment was made using Online
create view Payments as
select * from Bookingss
where Payment_Type="Online";
select * from Payments;

-- Find the average customer rating per vehicle type
create view Customer_Ratings as
select Vehicle_Type, round(avg(Customer_Ratings),2) as Avg_Customer_Ratings
from Bookingss
group by Vehicle_Type order by avg(Customer_Ratings) desc;
select * from Customer_Ratings;

-- Calculate the total fare value of rides completed successfully
create view Total_Fare as
select round(sum(Fare),1) as Total_Fare from Bookingss 
where Booking_Status="Completed";
select * from Total_Fare;

-- List all incomplete rides along with the reason
create view Incomplete_Rides as
select Booking_ID, Reason_for_Cancellation 
from bookingss where Booking_Status="Cancelled";
select * from Incomplete_Rides;

-- Which hour of the day ride get cancelled
create view Cancellation_Time as
select hour(Time) as Hour, count(Booking_Status) as Cancelled_Ride_Count
from bookingss
where Booking_Status="Cancelled"
group by hour(Time) order by Cancelled_Ride_Count desc;
select * from Cancellation_Time;

-- which pickup location is mostly used
create view Pickup_Location_Count as
select Pickup_Location as Pickup_location, count(Booking_Status) as Number_of_Rides
from bookingss
group by Pickup_location order by Number_of_Rides desc;
select * from Pickup_Location_Count;

-- count of cancellation
create view Cancellation_Counts as
SELECT "High fare" AS Cancellation_Reason, COUNT(*) AS Total_Cancellation
FROM Bookingss
WHERE Reason_for_Cancellation = "High fare"
UNION ALL
SELECT "Change of plans" AS Cancellation_Reason, COUNT(*) AS Total_Cancellation
FROM Bookingss
WHERE Reason_for_Cancellation = "Change of plans"
UNION ALL
SELECT "Others" AS Cancellation_Reason, COUNT(*) AS Total_Cancellation
FROM Bookingss
WHERE Reason_for_Cancellation NOT IN ("High fare", "Change of plans");
select * from Cancellation_Counts;

-- percntage of total fare
create view Percentage_Fare as
select Vehicle_Type, round((round(sum(Fare),0)/(select round(sum(Fare),0) from bookingss))*100,2)
as Total_Fare
from bookingss group by Vehicle_Type
order by Total_Fare desc;
select * from Percentage_Fare;




