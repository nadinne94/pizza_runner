/*Criando Banco de Dados*/
CREATE DATABASE pizza_runner
GO

/*Acessando o banco de dados*/
USE pizza_runner
GO

/*Criando as tabelas*/

CREATE TABLE runners (
	runner_id INT,
	registration_date DATE
)
GO

CREATE TABLE customer_orders (
	order_id INT,
	customer_id INT,
	pizza_id INT, 
	exclusions VARCHAR(4),
	extras VARCHAR(4),
	order_date NVARCHAR(19)
)
GO

CREATE TABLE runner_orders (
	order_id INT,
	runner_id INT,
	pickup_time VARCHAR(19),
	distance VARCHAR(7),
	duration VARCHAR(10),
	cancellation VARCHAR(23)
)
GO

CREATE TABLE pizza_name (
	pizza_id INT,
	pizza_name TEXT 
)
GO

CREATE TABLE pizza_recipes (
	pizza_id INT,
	toppings TEXT 
)
GO

CREATE TABLE pizza_toppings (
	topping_id INT,
	topping_name TEXT 
)
GO

/*Inserindo os dados*/
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15')
GO


INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_date")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49')
GO
SELECT * FROM customer_orders

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null')
GO
SELECT * FROM runner_orders

INSERT INTO pizza_name
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian')
GO

INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12')
GO

INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce')
GO

/*Analisando os dados*/	

SELECT * FROM customer_orders
GO

SELECT* FROM runner_orders
GO

/*Limpeza dos dados*/	
--temp_table customer_id

DROP TABLE IF EXISTS #temp_customer_orders
SELECT 
	order_id, 
	customer_id,
	pizza_id, 
    CASE
      WHEN exclusions is null OR exclusions = 'null' THEN ''
      ELSE exclusions
    END AS exclusions,
    CASE
      WHEN extras is null OR extras = 'null' THEN ''
      ELSE extras
    END AS extras,
    order_date
INTO #temp_customer_orders
FROM customer_orders
GO

SELECT * FROM #temp_customer_orders
GO

--temp_table runner_id

DROP TABLE IF EXISTS #temp_runner_orders
SELECT 
	order_id, 
	runner_id,
    CASE
      WHEN pickup_time = 'null' THEN ''
      ELSE pickup_time
    END AS pickup_time,
    CASE
      WHEN distance = 'null' THEN ''
	  WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
      ELSE distance
    END AS distance,
	CASE
      WHEN duration = 'null' THEN ''
	  WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
	  WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
	  WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
      ELSE duration
    END AS duration,
	CASE
      WHEN cancellation is null OR cancellation = 'null' THEN ''
      ELSE cancellation
    END AS cancellation
INTO #temp_runner_orders
FROM runner_orders
GO

SELECT * FROM  #temp_runner_orders

--Case Study Questions
--A.Pizza Metrics
	-- 1. How many pizzas were ordered

SELECT COUNT(order_id) AS "pedidos"
FROM #temp_customer_orders
GO

	-- 2. How many unique customer orders were made?
	
SELECT APPROX_COUNT_DISTINCT(order_id) AS "pedidos_distintos"
FROM #temp_customer_orders
GO

	-- 3. How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(order_id) AS "pedidos_entregues"
FROM #temp_runner_orders
WHERE distance <> ''
GROUP BY runner_id
GO

	-- 4. How many of each type of pizza was delivered?

ALTER TABLE pizza_name
ALTER COLUMN pizza_name VARCHAR(30)

SELECT pizza_name, COUNT(c.pizza_id) AS "pizza_entregue"
FROM #temp_customer_orders c
INNER JOIN #temp_runner_orders r
ON r.order_id = c.order_id
INNER JOIN pizza_name p
ON c.pizza_id = p.pizza_id
WHERE distance <> ''
GROUP BY p.pizza_name
GO

	--5. How many Vegetarian and Meatlovers were ordered by each customer??

SELECT c.customer_id, p.pizza_name, COUNT(c.pizza_id) AS "pizza_entregue"
FROM #temp_customer_orders c
INNER JOIN pizza_name p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY 1
GO

	--6. What was the maximum number of pizzas delivered in a single order?

SELECT TOP 1 c.order_id, COUNT(pizza_id) AS "pizza_entregues"
FROM #temp_customer_orders c
INNER JOIN #temp_runner_orders r
ON c.order_id = r.order_id
WHERE distance <> ''
GROUP BY c.order_id
ORDER BY 2 DESC
GO

	
	--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
	c.customer_id, 
	COUNT(
		CASE
			WHEN exclusions <> '' OR extras <> '' THEN 1
		END) AS alteradas,
	COUNT(
		CASE
			WHEN exclusions = '' AND extras = '' THEN 1
		END) AS nao_alteradas
FROM #temp_customer_orders c
INNER JOIN #temp_runner_orders r
ON c.order_id = r.order_id
WHERE distance <> ''
GROUP BY c.customer_id
ORDER BY 1
GO

	--8. How many pizzas were delivered that had both exclusions and extras?

SELECT 
	COUNT(
		CASE
			WHEN exclusions <> '' AND extras <> '' THEN 1
		END) AS alteradas
FROM #temp_customer_orders c
INNER JOIN #temp_runner_orders r
ON c.order_id = r.order_id
WHERE distance <> ''
GO

	--9. What was the total volume of pizzas ordered for each hour of the day?

SELECT 
  DATEPART(HOUR, order_date) AS hora_do_dia, 
  COUNT(order_id) AS pizza
FROM #temp_customer_orders
GROUP BY DATEPART(HOUR, order_date)


	--10. What was the volume of orders for each day of the week?

SELECT 
  FORMAT(DATEADD(DAY, 2, order_date),'dddd') AS dia_da_semana, -- add 2 to adjust 1st day of the week as Monday
  COUNT(order_id) AS total_pizza
FROM #temp_customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_date),'dddd')
GO

--B.Runner and Customer Experience
	--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

--COMO 01/01/21 FOI UMA SEXTA, VAMOS CONSIDERAR A SEXTA FEIRA COMO O PRIMEIRO DIA DA SEMANA
--IMAGEM MOSTRANTO QUE POR PADRÃO DOMINGO É 7

SET DATEFIRST 5

SELECT 
	DATEPART(WEEK, registration_date) AS "semana_registro",
	COUNT(runner_id) AS "runner"
FROM runners
GROUP BY DATEPART(WEEK, registration_date)
GO

	--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH tempo_medio AS (
	SELECT  
		c.order_id,
		c.order_date,
		r.pickup_time,
		DATEDIFF(MINUTE,c.order_date,r.pickup_time) AS "minutos"
	FROM #temp_customer_orders c
	INNER JOIN #temp_runner_orders r
	ON c.order_id = r.order_id
	WHERE distance <> '0'
	GROUP BY c. order_id, c.order_date,r.pickup_time
)
SELECT AVG(minutos) as "tempo_medio"
FROM tempo_medio
WHERE minutos > 0
GO

	--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
	
WITH prep_tempo_cte AS (
	SELECT
		c.order_id,
		COUNT(c.order_id) AS "pizza_order",
		c.order_date,
		r.pickup_time,
		DATEDIFF(MINUTE, c.order_date, r.pickup_time) AS "prep_tempo"
	FROM #temp_customer_orders c
	JOIN #temp_runner_orders r
		ON c.order_id = r.order_id
	WHERE r.distance <> '0'
	GROUP BY c.order_id, c.order_date, r.pickup_time
)
SELECT pizza_order, AVG(prep_tempo) as "tempo_medio"
FROM prep_tempo_cte
WHERE prep_tempo > 0
GROUP BY pizza_order
ORDER BY 1 DESC
GO

	--4. What was the average distance travelled for each customer?

SELECT
	c.customer_id,
	ROUND(
		AVG(
			CAST(distance AS REAL)
		), 2
	) AS "distancia_media(km)"
FROM #temp_customer_orders c
JOIN #temp_runner_orders r
	ON c.order_id = r.order_id
WHERE distance <> '0'
GROUP BY c.customer_id
go

	--5. What was the difference between the longest and shortest delivery times for all orders?

WITH duration_cte AS(
	SELECT order_id, ROUND(CAST(duration AS REAL),2) AS "duration"
	FROM #temp_runner_orders
	GROUP BY order_id, ROUND(CAST(duration AS REAL),2)
)
SELECT MAX(duration) - MIN(duration) AS "amplitude"
FROM duration_cte
WHERE duration<>0

	--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

--speed=distance/duration(km/min)

WITH speed_cte AS(
	SELECT order_id, runner_id, ROUND(CAST(distance AS REAL),2) AS "distance",ROUND(CAST(duration AS REAL),2) AS "duration"
	FROM #temp_runner_orders
	GROUP BY order_id, runner_id, ROUND(CAST(distance AS REAL),2), ROUND(CAST(duration AS REAL),2)
)
SELECT order_id, runner_id, ROUND(distance/(duration/60),2) AS "velocidade(km/h)"
FROM speed_cte
WHERE distance <> 0
AND duration <> 0
GROUP BY  order_id, runner_id, ROUND(distance/(duration/60),2)
GO

--Solution - C. Ingredient Optimisation
	--1. What are the standard ingredients for each pizza?

WITH toppings_cte AS (
	SELECT
		pizza_id,
		VALUE "toppings"
	FROM pizza_recipes r
	CROSS APPLY 
		STRING_SPLIT(CONVERT(varchar,toppings),',')
)
SELECT CONVERT(varchar,n.pizza_name) AS "pizza_nome", 
		STRING_AGG(CONVERT(VARCHAR,t.topping_name), ', ') AS "ingredientes"
FROM toppings_cte c
JOIN pizza_toppings t
	ON CONVERT(INT,c.toppings) = t.topping_id
LEFT JOIN pizza_name n
	ON c.pizza_id = n.pizza_id
GROUP BY CONVERT(varchar,n.pizza_name)
GO

CREATE VIEW topping_view AS
SELECT
		pizza_id,
		VALUE "toppings"
	FROM pizza_recipes r
	CROSS APPLY 
		STRING_SPLIT(CONVERT(varchar,toppings),',')
GO
SELECT * FROM topping_view
GO

	--2. What was the most commonly added extra?

WITH extras_cte AS (
	SELECT
		order_id,
		pizza_id,
		VALUE "extras"
		FROM #temp_customer_orders
	CROSS APPLY 
		STRING_SPLIT(CONVERT(varchar,extras),',')
)
SELECT t.topping_id,CONVERT(varchar,t.topping_name) AS "extra_name", COUNT(extras) AS "total"
FROM extras_cte e
JOIN pizza_toppings t
	ON e.extras = t.topping_id
GROUP BY t.topping_id,CONVERT(varchar,t.topping_name)
ORDER BY 3 DESC
GO

DROP VIEW IF EXISTS extra_view
go
CREATE VIEW extra_view AS
SELECT
	order_id,
	pizza_id,
	VALUE "extras"
	FROM customer_orders
	CROSS APPLY 
		STRING_SPLIT(CONVERT(varchar,CASE
			WHEN extras = 'null' THEN '' 
			ELSE extras
	END),',')
GO
SELECT * FROM extra_view
GO

	--3. What was the most common exclusion?
DROP VIEW IF EXISTS exclusions_view
go
CREATE VIEW exclusions_view AS
SELECT
	order_id,
	pizza_id,
	VALUE "exclusions"
	FROM customer_orders
	CROSS APPLY 
		STRING_SPLIT(CONVERT(varchar,CASE
			WHEN exclusions = 'null' THEN '' 
			ELSE exclusions
	END),',')
GO
SELECT * FROM exclusions_view
GO

WITH exclusions_cte AS (
	SELECT
		order_id,
		pizza_id,
		VALUE "exclusions"
		FROM #temp_customer_orders
	CROSS APPLY 
		STRING_SPLIT(CONVERT(varchar,exclusions),',')
)
SELECT t.topping_id,CONVERT(varchar,t.topping_name) AS "exclusion_name", COUNT(exclusions) AS "total"
FROM exclusions_cte e
JOIN pizza_toppings t
	ON e.exclusions = t.topping_id
GROUP BY t.topping_id,CONVERT(varchar,t.topping_name)
GO

	/*4. Generate an order item for each record in the customers_orders table in the format of one of the following:
		Meat Lovers
		Meat Lovers - Exclude Beef
		Meat Lovers - Extra Bacon
		Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
	*/

SELECT CONVERT(varchar,t.topping_name)
FROM exclusions_view e
JOIN pizza_toppings t
	ON e.exclusions = t.topping_id
GO

WITH topping_name_cte AS(
	SELECT 
		t.pizza_id, t.toppings, CONVERT(VARCHAR,topping_name) AS "topping_name"
	FROM topping_view t
	JOIN pizza_toppings p
		ON t.toppings = p.topping_id
	GROUP BY t.pizza_id, t.toppings, CONVERT(VARCHAR,topping_name)	
)
SELECT	CONCAT(p.pizza_name, exclusions, extras)
FROM pizza_name p
JOIN exclusions_view exc
	ON p.pizza_id = exc.pizza_id
JOIN extra_view ext
	ON p.pizza_id = ext.pizza_id
JOIN topping_name_cte t
	ON p.pizza_id = t.pizza_id




