drop table if exists zepto;

create table zepto(
sku_id serial primary key,
Category varchar(120),
Name varchar(150) not null,
MRP numeric(8,2),
Discount_Percent numeric(5,2),
Available_Quantity integer,
Discount_Selling_Price numeric(8,2),
Weight_in_gms integer,
OutofStock boolean,
quantity integer
);

--data exploration

--count of rows 
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE category IS NULL OR
name IS NULL OR
mrp IS NULL OR
discount_percent IS NULL OR
available_quantity IS NULL OR
discount_selling_price IS NULL OR
weight_in_gms IS NULL OR
outofstock IS NULL OR
quantity IS NULL;

--different product categories 
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outofstock,COUNT(sku_id) from zepto
GROUP BY outofstock;   

--product names present multiple times
SELECT name,COUNT(sku_id) as "Number od SKUs"
FROM zepto
GROUP BY name
having COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--data cleaning

--products with price=0
SELECT * FROM zepto
WHERE discount_selling_price=0 or mrp=0;

DELETE FROM zepto
WHERE mrp=0; 

--convert paise to rupees
UPDATE zepto 
SET mrp=mrp/100.0,
discount_selling_price=discount_selling_price/100.0;

SELECT mrp,discount_selling_price FROM zepto;

--Q1.Find the top 10 best value products based on the discount percentage.

SELECT DISTINCT name,mrp,discount_percent FROM zepto
ORDER BY discount_percent DESC
LIMIT 10;

--Q2.What are the Products with high MRP but out of stock.

SELECT DISTINCT name,mrp,outofstock FROM zepto
where outofstock=TRUE AND mrp>300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category.

SELECT category,SUM(discount_selling_price*availabe_quantity) AS Estimated_Revenue FROM zepto
GROUP BY category;

--Q4.Find all products where MRP is greater than 500 and discount is less than 10%.

SELECT DISTINCT name,mrp,discount_percent FROM zepto
WHERE mrp>500 AND discount_percent<10;

--Q5.Identify the top 5 categories offering the highest average discount percentage.

SELECT category,AVG(discount_percent) FROM zepto
GROUP BY category
ORDER BY AVG(discount_percent) DESC 
LIMIT 5;

--Q6.Find the price per grams for products above 100g and sort by best value.

SELECT DISTINCT name,(discount_selling_price)/(weight_in_gms) AS price_per_gms FROM zepto
WHERE weight_in_gms>= 100
ORDER BY price_per_gms;

--Q7.Group the products into categories like low , medium , bulk.

SELECT DISTINCT name,
CASE WHEN quantity<=500 THEN 'low'
     WHEN quantity>=500 AND quantity<=1000 THEN 'medium'
	 WHEN quantity>=1000 THEN 'bulk' 
END AS category
FROM zepto;

--Q8.What is the total inventory weight per category.

SELECT category,SUM(weight_in_gms*available_quantity) AS Total_inventory_weight FROM zepto
GROUP BY category
ORDER BY Total_inventory_weight;