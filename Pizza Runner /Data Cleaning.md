#### Cleaning Customer_Orders Table

```sql
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
```
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/7f12988e-6882-4836-99cf-a1277d66ffc0)

#### Cleaning Runner_Orders Table

```sql
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
```
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/00aa64c4-e670-4d25-bede-3c2ad25e3797)

#### Seperating Orders with multiple toppings in Customer_Orders table

```sql
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
```
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ce69f4d6-c014-4eba-b18b-25068ab66ac6)

#### Creating Extras table

```sql
select		
	cco.record_id,
	trim(e.value) as topping_id
into extras
from 
	cleaned_customer_orders as cco
	cross join lateral unnest(string_to_array(cco.extras, ',')) as e(value);
```
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/554d5a67-67e5-4751-8c74-7fd63e1f26e8)

#### Creating Exclusions table

```sql
select		
	cco.record_id,
	trim(e.value) as topping_id
into exclusions
from 
	cleaned_customer_orders as cco
	cross join lateral unnest(string_to_array(cco.exclusions, ',')) as e(value);
```
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/08f5d5a5-c24e-4199-87e7-6ef2c4668cf5)
