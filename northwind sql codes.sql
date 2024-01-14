USE northwind_sales;
SELECT * FROM northwind_order_details, northwind_orders;
#1. Write a query to find the top 5 customers by total number of orders made in the Northwind dataset.
	
SELECT count(order_id) AS totalorder, customer_id
FROM northwind_orders
GROUP BY customer_id
ORDER BY totalorder DESC
LIMIT 5;

#2.	For each order, what is the total quantity of products ordered and the total amount of discount applied?
SELECT order_id, COUNT(order_id) AS totalorder, SUM(quantity) AS totalqtt, SUM(discount) AS totaldiscount
FROM northwind_order_details
GROUP BY order_id;

#3.	What is the average unit price of products in each order?
SELECT AVG(unit_price) AS average_unit, order_id
FROM northwind_order_details
GROUP BY order_id;

#4.	How many products were ordered in each order?
SELECT order_id, COUNT(product_id) AS total_product
FROM northwind_order_details
GROUP BY order_id;

#5.	In how many orders was a product_id 28 sold?
SELECT DISTINCT COUNT(order_id), product_id
FROM northwind_order_details
WHERE product_id = "28" ;

#6.	What is the average quantity of products ordered for each customer?
SELECT AVG(quantity) AS average_prdct_ordered, customer_id
FROM northwind_order_details
INNER JOIN northwind_orders
ON northwind_order_details.order_id=northwind_orders.order_id
GROUP BY customer_id;

#7.	Identify the top 3 customers who made the most orders.
SELECT COUNT(order_id), customer_id
FROM northwind_orders
GROUP BY customer_id DESC
LIMIT 3;

#8.	Calculate the total freight cost for each shipper (ship_via).
SELECT ship_name, SUM(freight) AS total_freight_cost
FROM northwind_orders
GROUP BY ship_name;

#9.	List the orders that were shipped before the required date.
SELECT order_id, shipped_date, required_date
FROM northwind_orders
WHERE shipped_date<required_date;

#10. How many orders were placed in each year?
SELECT YEAR(order_date) AS order_year , COUNT(*) AS numberoforders
FROM northwind_orders
GROUP BY order_year;

#11. Find the orders placed by CHOPS
SELECT customer_id, order_id
FROM northwind_orders
WHERE customer_id= "CHOPS";

#12. Identify the orders that were not shipped on time.
SELECT order_id, shipped_date, required_date
FROM northwind_orders
WHERE shipped_date>required_date;

#13. List the orders that were shipped to Switzerland.
SELECT order_id, ship_country
FROM northwind_orders
WHERE ship_country="Switzerland";

#14. Calculate the average freight cost for orders that were shipped to each city (ship_city).
SELECT DISTINCT ship_city, AVG(freight) AS average_freight
FROM northwind_orders
GROUP BY ship_city;

#15. Show the orders that were placed on weekends.
SELECT 
order_id,
order_date,
NOT WEEKDAY (order_date) AS WEEKEND
FROM northwind_orders;

#16. List the orders where the quantity of a specific product (identified by product_id) is 
#     greater than the average quantity ordered for that product
SELECT order_id,product_id, quantity
FROM northwind_order_details
WHERE quantity > (
SELECT AVG(quantity)
from northwind_order_details
);

#17. Identify the orders where the total cost (unit_price * quantity) exceeds a certain value.
select order_id,unit_price, quantity, (unit_price*quantity) AS total_cost
from northwind_order_details
where unit_price*quantity> 100;

#18. Find the orders that were shipped using a specific shipper (ship_via).
select order_id, ship_via
from northwind_orders
where ship_via=1;

#19.Calculate the total sales amount for each product based on the unit price, quantity, and discount.
select order_id, unit_price, quantity, discount, (unit_price*quantity + (discount/100)) AS total_sales
from northwind_order_details;

#20. List the orders where the customer's city and the order's shipping city are different.
select order_id, ship_region
from northwind_orders;

update northwind_orders
set ship_region= 
	case
		when ship_region = 'WA' then 'Walla Walla'
		when ship_region = 'SP' then 'Sao Paulo'
		when ship_region = 'RJ' then 'Rio de Janeiro'
		else ship_region
    end;

#21.	Show the orders with the longest duration between order_date and shipped_date.
select order_id, order_date, shipped_date, DATEDIFF (shipped_date,order_date) AS time_diff
from northwind_orders
order by time_diff DESC;

#22. Identify the orders where the same product was ordered in consecutive orders.
    
WITH RankedOrders AS (
    SELECT 
        od.order_id, 
        od.product_id, 
        ROW_NUMBER() OVER (PARTITION BY od.product_id ORDER BY o.order_date) AS OrderRank
    FROM 
        northwind_order_details od
    JOIN
        northwind_orders o ON od.order_id = o.order_id
 )
 SELECT  
     o1.order_id AS first_order_id, 
     o1.product_id, 
     o2.order_id AS next_order_id
     
 FROM 
     RankedOrders o1
     JOIN RankedOrders o2 ON o1.product_id = o2.product_id 
     AND o1.OrderRank = o2.OrderRank - 1;
#23. Determine the orders with the highest and lowest total quantity of products ordered.
(select order_id, SUM(quantity) AS total_qtt
from northwind_order_details
group by order_id
order by total_qtt desc
limit 1)
UNION ALL 
(select order_id, SUM(quantity) AS total_qtt
from northwind_order_details
group by order_id
order by total_qtt asc
limit 1);

#24. Show the orders that had the highest and lowest total cost (including freight).
(select order_id, freight
from northwind_orders
order by freight asc
limit 1)
union all
(select order_id, freight
from northwind_orders
order by freight desc
limit 1);

#25. Identify the last order date for each customer.

WITH RankedOrders AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM 
        northwind_orders
)
SELECT 
    customer_id, 
    order_date
FROM 
    RankedOrders
WHERE 
    rn = 1;

#26. Calculate the average quantity of products ordered for each employee.

select employee_id, AVG(quantity) as average_qtt
from northwind_orders
inner join northwind_order_details
on northwind_order_details.order_id=northwind_orders.order_id
group by employee_id;

#27. List the orders where the total cost (unit_price * quantity) is within a certain range.
select order_id, unit_price, quantity
from northwind_order_details
where unit_price*quantity>10
and unit_price*quantity<50;

