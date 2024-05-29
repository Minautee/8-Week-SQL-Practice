## **Solutions**

### Case Study Questions:

#### 1. How many pizzas were ordered?

```sql
select count(*) as number_of_pizzas_ordered
from cleaned_customer_orders;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/bfdc1d32-2a3e-4192-abbb-c3cce0adc800)

#### 2. How many unique customer orders were made?

```sql
select count(distinct order_id) as unique_orders
from cleaned_customer_orders;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/d329c892-532b-416f-bebf-841c01125749)

#### 3. How many successful orders were delivered by each runner?

```sql
select runner_id, count(order_id) as delivered_orders
from cleaned_runner_orders
where cancellation is null
group by runner_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f5d46f79-b66a-430f-9cf5-d166a64080d9)

#### 4. How many of each type of pizza was delivered?

```sql
select pn.pizza_name, pn.pizza_id, count(cco.order_id) as delivered
from cleaned_customer_orders cco
left join pizza_names pn on pn.pizza_id = cco.pizza_id
join cleaned_runner_orders cro on cro.order_id = cco.order_id
where cro.cancellation is null
group by pn.pizza_name, pn.pizza_id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/6778171d-7beb-43bf-97c0-5108d970b63c)

#### 5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
select customer_id,
	sum(case when pizza_id = 1 then 1 else 0 end) as vegetarian_count,
	sum(case when pizza_id = 2 then 1 else 0 end) as meatlovers_count	
from cleaned_customer_orders
group by customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ffa4da73-a525-41af-8a54-b04715b7458a)

#### 6. What was the maximum number of pizzas delivered in a single order? 

```sql
select max(number_of_pizzas) as max_delivered
from( 
	select order_id, count(pizza_id) as number_of_pizzas
	from cleaned_customer_orders
	group by order_id) as pizza_counts 
join cleaned_runner_orders cro on cro.order_id = pizza_counts.order_id
where cro.cancellation is null
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/260f723d-17ba-4c97-8ea2-20dc42d2209a)

#### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
select cco.customer_id,
	sum(case when exclusions is not null or extras is not null then 1 else 0 end) as atleast_1_change,
	sum(case when exclusions is null and extras is null then 1 else 0 end) as no_changes
from cleaned_customer_orders cco
join cleaned_runner_orders cro on cro.order_id = cco.order_id
where cro.cancellation is null
group by cco.customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e368a9a1-7e3a-4a70-8582-7b29fb7b3303)

#### 8. How many pizzas were delivered that had both exclusions and extras?

```sql
select count(pizza_id) as pizzas_with_both
from cleaned_customer_orders cco
join cleaned_runner_orders cro on cro.order_id = cco.order_id
where cro.cancellation is null and exclusions is not null and extras is not null;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/49791a5a-6fec-4aaf-8159-26535f0bd86b)

#### 9. What was the total volume of pizzas ordered for each hour of the day?

```sql
select 
	extract(hour from order_time) as hour_of_day,
	count(pizza_id) as total_volume
from cleaned_customer_orders
group by extract(hour from order_time)
order by extract(hour from order_time);
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1e344ff5-9ea5-43c5-aa8c-6ba84716b92b)

#### 10. What was the volume of orders for each day of the week?

```sql
select 
	extract(DOW from order_time) as day_of_week,
	count(pizza_id) as total_volume
from cleaned_customer_orders
group by extract(DOW from order_time)
order by extract(DOW from order_time);
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/cf1b9560-d9dd-490e-8643-f0089c3e2e36)
