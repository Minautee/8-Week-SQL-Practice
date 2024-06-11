## **Solution**

### Case Study Questions:

#### 1. How many unique nodes are there on the Data Bank system?

```sql
select count(distinct node_id) as "Unique Nodes"
from customer_nodes;
```
Result:
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/6b89b4cd-6f6c-4dff-b007-78f15ec0c61f)

#### 2. What is the number of nodes per region?

```sql
select count (node_id) as "Number of Nodes", region_name
from customer_nodes c
join regions r on r.region_id = c.region_id
group by region_name;
```
Result:
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/fddb5fe3-9d05-4032-9bb3-218010d4aedf)

#### 3. How many customers are allocated to each region?

```sql
select count (distinct customer_id) as "Number of Customers", region_name
from customer_nodes c
join regions r on r.region_id = c.region_id
group by region_name;
```
Result:
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/72cdc4be-0a12-4c88-99df-1e66a5df9be2)

#### 4. How many days on average are customers reallocated to a different node?

```sql
with avg_node_reallocation_cte as (
	select customer_id, node_id,
	(end_date - start_date) as days_diff
	from customer_nodes
	where end_date != '9999-12-31'
	group by customer_id, node_id, start_date, end_date),
total_node_days_cte as (
	select customer_id, node_id,
	sum(days_diff) as total_node_days
	from avg_node_reallocation_cte
	group by customer_id, node_id)
select round(avg(total_node_days)) as avg_days_reallocation
from total_node_days_cte;
```
Result:
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/c178f2d2-5f9b-44f6-a932-8eb1c2c4c0a7)

#### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
