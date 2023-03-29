--#region 1 CREATE DATABASE AND IMPORT DATA TABLES

--CREAT DATABASE LakeviewHotelsDB

CREATE DATABASE LakeviewHotelsDB

--Import all tables into the DATABASE LakeviewHotelsDB and preview first 3 rows of each table

SELECT TOP 3 * 
FROM bookings

SELECT TOP 3 * 
FROM requests

SELECT TOP 3 * 
FROM food_orders

SELECT TOP 3 * 
FROM menu

SELECT TOP 3 * 
FROM rooms

--#endregion

--#region 2  WRITING JOIN QUERIES TO CREATE DATA INSIGHT

--Using JOIN syntax to consolidate data from relevant tables

select * 
FROM requests AS re
JOIN bookings AS bk ON             --This is our 1st JOIN between Requests AND Bookings Table
re.request_id = bk.request_id

JOIN rooms AS rs ON                --This is our 2nd JOIN between Requests AND Rooms Table
re.room_type = rs.room_type

RIGHT JOIN food_orders AS fd ON    --This is our 3rd JOIN between Bookings AND Food_orders Table
bk.room = fd.bill_room

FULL OUTER JOIN menu AS mn ON      --This is our 4th JOIN between Food_orders AND Menu Table
fd.menu_id = mn.menu_id


--Joining Foodorder + Menu table

SELECT bk.request_id, bk.room, fo.dest_room, fo.bill_room, fo.order_date, fo.order_time, fo.no_of_orders, mn.category, mn.menu_name, (fo.no_of_orders * mn.price) as cost_of_orders
FROM food_orders as fo
JOIN Menu as mn
ON mn.menu_id = fo.menu_id
JOIN bookings as bk
ON bk.room = fo.bill_room

--Using CTE
SELECT * 
FROM (SELECT fo.dest_room, fo.bill_room, fo.order_date, fo.order_time, fo.no_of_orders, mn.category, mn.menu_name, (fo.no_of_orders * mn.price) as cost_of_orders
FROM food_orders as fo
JOIN Menu as mn
ON mn.menu_id = fo.menu_id) AS Food_Menu_Table


--Joining Booking + Request + Room tables

select bk.booking_id, re.request_id, re.client_name, re.request_type as room_request_type, bk.room, re.room_type, re.start_date, re.end_date, 
        (DATEDIFF(DAY,re.start_date,re.end_date)) as duration_of_stay,
        (DATEDIFF(DAY,re.start_date,re.end_date)*rm.price_per_day) AS cost_of_stay,
        re.no_of_adults, re.no_of_children
        FROM Bookings AS bk 
        JOIN Requests AS re ON        --This is 1st JOIN
        re.request_id = bk.request_id
        JOIN Rooms AS rm ON           --This is 2nd JOIN
        re.room_type = rm.room_type

--Using CTE
        SELECT * 
        FROM (select bk.booking_id, re.request_id, re.client_name, re.request_type as room_request_type, bk.room, re.room_type, re.start_date, re.end_date, 
        (DATEDIFF(DAY,re.start_date,re.end_date)) as duration_of_stay,
        (DATEDIFF(DAY,re.start_date,re.end_date)*rm.price_per_day) AS cost_of_stay,
        re.no_of_adults, re.no_of_children
        FROM Bookings AS bk 
        JOIN Requests AS re ON        --This is 1st JOIN
        re.request_id = bk.request_id
        JOIN Rooms AS rm ON           --This is 2nd JOIN
        re.room_type = rm.room_type) AS Room_Booking_Table







--#endregion











