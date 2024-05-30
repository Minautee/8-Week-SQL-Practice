## **Solutions**

### Case Study Questions:

#### 1. What are the standard ingredients for each pizza?

```sql
select p.pizza_name,
string_agg(t.topping_name,',') as toppings
from pizza_names p
join cleaned_pizza_toppings t on t.pizza_id = p.pizza_id
group by p.pizza_name;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/66d78090-1f15-4336-b08c-483c5515cdf9)

#### 2. What was the most commonly added extra?

```sql
select topping_name,
	count(e.topping_id) as num_of_addition
from extras e
join cleaned_pizza_toppings cpt on cpt.topping_id = e.topping_id
group by topping_name
order by 2 desc;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/5e002cbb-57f6-471f-b3b3-9aa70fbf4908)

#### 3. What was the most common exclusion?

```sql
select topping_name,
	count(e.topping_id) as num_of_addition
from exclusions e
join cleaned_pizza_toppings cpt on cpt.topping_id = e.topping_id
group by topping_name
order by 2 desc;
```
Result:    
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/5b3bcf49-ee1f-439c-9aff-4b97c035ced7)

#### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
* Meat Lovers
* Meat Lovers - Exclude Beef
* Meat Lovers - Extra Bacon
* Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql
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
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/c71e5f05-4913-462a-b4fa-ba72f46d0cba)

#### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
#### For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

```sql
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
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/3477b727-8f32-4f3c-b6b6-31d90b530a9b)

#### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql
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
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/23600009-dd8e-47c8-adad-e5eb67008565)
