--#region 1 CREATE DATABASE AND IMPORT DATA TABLES

--CREAT DATABASE PlatosPizzaDB

CREATE DATABASE PlatosPizzaDB

--Import all tables into the DATABASE PlatosPizzaDB and preview first 5 rows of each table

SELECT TOP 5 * 
FROM pizzas

SELECT TOP 5 * 
FROM pizza_types

SELECT TOP 5 * 
FROM orders

SELECT TOP 5 * 
FROM order_details


--#endregion

--#region 2  WRITING JOIN QUERIES TO CREATE DATA INSIGHT

--Using JOIN syntax to consolidate data from relevant tables

select pz.pizza_id, pt.name, pz.pizza_type_id, pz.[size], pz.price, pt.category, pt.ingredients 
FROM pizzas AS pz
JOIN pizza_types AS pt ON                   --This is our 1st JOIN between pizzas table AND pizza_types table
pz.pizza_type_id = pt.pizza_type_id


select od.order_id, od.[date], od.[time], odt.order_details_id, odt.pizza_id, odt.quantity
FROM orders AS od
JOIN order_details AS odt ON                --This is our 2nd JOIN between orders table AND order_details table
od.order_id = odt.order_id


select pz.pizza_id, pz.pizza_type_id, pz.[size], pz.price, odt.order_details_id, odt.order_id, odt.quantity, (pz.price * odt.quantity) as Total_cost
FROM pizzas AS pz
JOIN order_details AS odt ON                --This is our 3rd JOIN between pizzas table AND order_details table
pz.pizza_id = odt.pizza_id



--Using CTE to generate a combined Pizza_Order Table

SELECT * 
FROM (select pz.pizza_id, pz.pizza_type_id, pz.[size], pz.price, odt.order_details_id, odt.order_id, odt.quantity, (pz.price * odt.quantity) as Total_cost
FROM pizzas AS pz
JOIN order_details AS odt ON 
pz.pizza_id = odt.pizza_id) AS Pizza_Orders_Table






--#endregion

