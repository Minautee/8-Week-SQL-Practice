CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
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
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

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
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
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
  (12, 'Tomato Sauce');
  
select * from runners;
select * from customer_orders;
select * from runner_orders;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;

--Data Cleaning

select order_id, customer_id, pizza_id,
	case
		when exclusions in ('null', '') then null
		else exclusions
	end as exclusions,
	case 
		when extras in ('null', '') then null
		else extras
	end as extras,
	order_time
into cleaned_customer_orders
from customer_orders

select 
    order_id,
    runner_id,
    cast(case 
        when pickup_time = 'null' then null
        else pickup_time
    end as timestamp) as pickup_time,
    cast(case 
        when distance = 'null' then null
        else trim('km' from distance)
    end as float) as distance,
    cast(case
        when duration = 'null' then null
        else substring(duration, 1, 2)
    end as int)as duration,
    case
        when cancellation in ('null', '') then null
        else cancellation
end as cancellation
into cleaned_runner_orders
from runner_orders;

select * from cleaned_customer_orders
select * from cleaned_runner_orders


--Pizza Metrics
-- 1. How many pizzas were ordered?

select count(*) as number_of_pizzas_ordered
from cleaned_customer_orders;

-- 2. How many unique customer orders were made?

select count(distinct order_id) as unique_orders
from cleaned_customer_orders;

-- 3. How many successful orders were delivered by each runner?

select runner_id, count(order_id) as delivered_orders
from cleaned_runner_orders
where cancellation is null
group by runner_id;

-- 4. How many of each type of pizza was delivered?

select pn.pizza_name, pn.pizza_id, count(cco.order_id) as delivered
from cleaned_customer_orders cco
left join pizza_names pn on pn.pizza_id = cco.pizza_id
join cleaned_runner_orders cro on cro.order_id = cco.order_id
where cro.cancellation is null
group by pn.pizza_name, pn.pizza_id

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id,
	sum(case when pizza_id = 1 then 1 else 0 end) as vegetarian_count,
	sum(case when pizza_id = 2 then 1 else 0 end) as meatlovers_count	
from cleaned_customer_orders
group by customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?

select max(number_of_pizzas) as max_delivered
from( 
	select order_id, count(pizza_id) as number_of_pizzas
	from cleaned_customer_orders
	group by order_id) as pizza_counts 
join cleaned_runner_orders cro on cro.order_id = pizza_counts.order_id
where cro.cancellation is null

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select cco.customer_id,
	sum(case when exclusions is not null or extras is not null then 1 else 0 end) as atleast_1_change,
	sum(case when exclusions is null and extras is null then 1 else 0 end) as no_changes
from cleaned_customer_orders cco
join cleaned_runner_orders cro on cro.order_id = cco.order_id
where cro.cancellation is null
group by cco.customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?

select count(pizza_id) as pizzas_with_both
from cleaned_customer_orders cco
join cleaned_runner_orders cro on cro.order_id = cco.order_id
where cro.cancellation is null and exclusions is not null and extras is not null;

-- 9. What was the total volume of pizzas ordered for each hour of the day?

select 
	extract(hour from order_time) as hour_of_day,
	count(pizza_id) as total_volume
from cleaned_customer_orders
group by extract(hour from order_time)
order by extract(hour from order_time);

-- 10. What was the volume of orders for each day of the week?

select 
	extract(DOW from order_time) as day_of_week,
	count(pizza_id) as total_volume
from cleaned_customer_orders
group by extract(DOW from order_time)
order by extract(DOW from order_time);

-- Runner and Customer Experience

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select 
	extract('week' from registration_date) as registration_week,
    count(runner_id) as number_of_runners
from runners
where registration_date >= '2021-01-01' 
group by extract('week' from registration_date)
order by registration_week;
	
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select total_time.runner_id, avg(total_minutes) as avg_pickup_time
from(
	select runner_id,
	extract(epoch from (pickup_time - order_time)) / 60 as total_minutes
	from cleaned_runner_orders cro
	join cleaned_customer_orders cco on cco.order_id = cro.order_id) as total_time
group by total_time.runner_id
order by runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

with cte as (
	select cco.order_id, count(cco.pizza_id) as number_of_pizzas,
	extract(epoch from (cro.pickup_time - cco.order_time))/60 as total_time_taken,
	extract(epoch from (cro.pickup_time - cco.order_time))/60 / count(cco.pizza_id) as total_time_taken_per_pizza
	from cleaned_customer_orders cco
	join cleaned_runner_orders cro on cco.order_id = cro.order_id
	group by cco.order_time, cco.order_id, cro.pickup_time)
select cte.number_of_pizzas, 
	avg(cte.total_time_taken) as avg_total_time_taken,
	avg(cte.total_time_taken_per_pizza) as avg_total_time_taken_per_pizza
from cte
group by number_of_pizzas
order by number_of_pizzas;

-- 4. What was the average distance travelled for each customer?

select cco.customer_id, 
	avg(cro.distance) as avg_distance
from cleaned_customer_orders cco
join cleaned_runner_orders cro on cro.order_id = cco.order_id
group by cco.customer_id
order by cco.customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?

select 
	(max(duration) - min(duration)) as time_difference
from cleaned_runner_orders; 

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

with cte as (
	select runner_id, order_id,
	avg(distance/(duration/60.0)) as avg_speed
	from cleaned_runner_orders
	where cancellation is null
	group by runner_id, order_id)
select runner_id, cte.avg_speed
from cte
group by runner_id, cte.avg_speed
order by runner_id;

-- 7. What is the successful delivery percentage for each runner?

select runner_id,	
	count(order_id) as total_orders,
	count(pickup_time) as total_orders_delivered,
	cast(count(pickup_time) as float) / cast(count(order_id) as float) * 100 
		as successful_delivery_percent
from cleaned_runner_orders
group by runner_id
order by runner_id;

-- Data Cleaning

select pr.pizza_id,
	trim(t.value) as topping_id,
	pt.topping_name
into cleaned_pizza_toppings
from pizza_recipes as pr
cross join lateral unnest(string_to_array(pr.toppings, ',')) as t(value)
join pizza_toppings as pt on trim(t.value) = cast(pt.topping_id as text);

select * from cleaned_pizza_toppings;

alter table cleaned_customer_orders
add column record_id serial;

select * from cleaned_customer_orders;

-- to generate extras table
select		
	cco.record_id,
	trim(e.value) as topping_id
into extras
from 
	cleaned_customer_orders as cco
	cross join lateral unnest(string_to_array(cco.extras, ',')) as e(value);

-- to generate exclusions table
select		
	cco.record_id,
	trim(e.value) as topping_id
into exclusions
from 
	cleaned_customer_orders as cco
	cross join lateral unnest(string_to_array(cco.exclusions, ',')) as e(value);
	
select * from extras;
select * from exclusions;

-- Ingredients Optimisation

-- 1. What are the standard ingredients for each pizza?

select p.pizza_name,
string_agg(t.topping_name,',') as toppings
from pizza_names p
join cleaned_pizza_toppings t on t.pizza_id = p.pizza_id
group by p.pizza_name;

-- 2. What was the most commonly added extra?

select topping_name,
	count(e.topping_id) as num_of_addition
from extras e
join cleaned_pizza_toppings cpt on cpt.topping_id = e.topping_id
group by topping_name
order by 2 desc;

-- 3. What was the most common exclusion?

select topping_name,
	count(e.topping_id) as num_of_addition
from exclusions e
join cleaned_pizza_toppings cpt on cpt.topping_id = e.topping_id
group by topping_name
order by 2 desc;

-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
--Meat Lovers
--Meat Lovers - Exclude Beef
--Meat Lovers - Extra Bacon
--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

with cte_extras as (
	select record_id,
	'Extra' || string_agg(cpt.topping_name, ',') as record_options
	from extras e
	join cleaned_pizza_toppings cpt on cpt.topping_id = e.topping_id
	group by record_id),
cte_exclusions as (
	select record_id,
	'Exclude' || string_agg(cpt.topping_name, ',') as record_options
	from exclusions e
	join cleaned_pizza_toppings cpt on cpt.topping_id = e.topping_id
	group by record_id),
cte_union as (
	select * from cte_extras
	union
	select * from cte_exclusions)
select cco.record_id,
	concat_ws('-', p.pizza_name, string_agg(cu.record_options, '-'))
from cleaned_customer_orders cco
join pizza_names p on p.pizza_id = cco.pizza_id
left join cte_union cu on cu.record_id = cco.record_id
group by cco.record_id, p.pizza_name
order by 1;

-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

with cte_ingredients as (
	select cco.record_id,
	p.pizza_name,
	case
		when cpt.topping_id in (select topping_id from extras e where e.record_id = cco.record_id) then '2x' || cpt.topping_name
		else cpt.topping_name
	end as topping
	from cleaned_customer_orders cco
	join pizza_names p on p.pizza_id = cco.pizza_id
	join cleaned_pizza_toppings cpt on cpt.pizza_id = cco.pizza_id
	where cpt.topping_id not in (select topping_id from exclusions e where e.record_id = cco.record_id))
select record_id, 
	concat(pizza_name || ':', string_agg(topping, ',')) as ingredients_list
from cte_ingredients
group by record_id, pizza_name
order by 1;

-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

with cte_ingredients as (
	select cco.record_id, cpt.topping_name,
	case
		when cpt.topping_id in (select topping_id from extras e where e.record_id = cco.record_id) then 2
		when cpt.topping_id in (select topping_id from exclusions e where e.record_id = cco.record_id) then 0
		else 1
	end as times_used
	from cleaned_customer_orders cco
	join cleaned_pizza_toppings cpt on cpt.pizza_id = cco.pizza_id)
select topping_name, sum(times_used) as total_times_used
from cte_ingredients
group by topping_name
order by 2 desc;

-- Pricing and Ratings

-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
-- 2. What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra
-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
--Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
-- 4. Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?