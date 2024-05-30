## **Solutions**

### Case Study Questions:

#### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
select 
	extract('week' from registration_date) as registration_week,
    count(runner_id) as number_of_runners
from runners
where registration_date >= '2021-01-01' 
group by extract('week' from registration_date)
order by registration_week;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/2b6cb3ef-5d44-4fe4-a235-c22221b1ed5e)

#### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
select total_time.runner_id, avg(total_minutes) as avg_pickup_time
from(
	select runner_id,
	extract(epoch from (pickup_time - order_time)) / 60 as total_minutes
	from cleaned_runner_orders cro
	join cleaned_customer_orders cco on cco.order_id = cro.order_id) as total_time
group by total_time.runner_id
order by runner_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/bdb6d17a-2c25-4083-81df-074fb4c05419)

#### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
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
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e20986f0-e238-41f6-9213-840155cd5978)

#### 4. What was the average distance travelled for each customer?

```sql
select cco.customer_id, 
	avg(cro.distance) as avg_distance
from cleaned_customer_orders cco
join cleaned_runner_orders cro on cro.order_id = cco.order_id
group by cco.customer_id
order by cco.customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/8137e63a-8689-4711-a4bf-0987fd19614d)

#### 5. What was the difference between the longest and shortest delivery times for all orders?

```sql
select 
	(max(duration) - min(duration)) as time_difference
from cleaned_runner_orders; 
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1856580b-4c8d-4ee1-a424-08807218ed30)

#### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
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
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/cfc8b2d5-0b55-4daf-908b-c77658ccf768)

#### 7. What is the successful delivery percentage for each runner?

```sql
select runner_id,	
	count(order_id) as total_orders,
	count(pickup_time) as total_orders_delivered,
	cast(count(pickup_time) as float) / cast(count(order_id) as float) * 100 
		as successful_delivery_percent
from cleaned_runner_orders
group by runner_id
order by runner_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/9f3066cb-f6c9-4587-88df-5ec8ea17f781)
