## **Solutions**

### Case Study Questions:

#### 1. What is the total amount each customer spent at the restaurant?

```sql
select customer_id, sum(price) as total_spent
from menu m
join sales s on s.product_id = m.product_id
group by s.customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/8611af6a-2527-4925-9e8f-548b997acfbb)

#### 2. How many days has each customer visited the restaurant?

```sql
select customer_id, count(DISTINCT order_date) as visits
from sales
group by customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/65fa2cd4-1a7f-4e75-b600-0bf7f6a2c2a2)

#### 3. What was the first item from the menu purchased by each customer?

```sql
with cte as (
	select customer_id, order_date, product_name as first_purchase,
	row_number() over (partition by customer_id order by order_date) as rnk
	from menu m
	join sales s on s.product_id = m.product_id)
select customer_id, first_purchase
from cte
where rnk = 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f49475d0-22c5-4049-8d73-9935c6c40037)

#### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
select m.product_name, count(s.product_id) as most_purchased
from menu m
join sales s on s.product_id=m.product_id
group by m.product_name
order by most_purchased desc;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/bbce1155-c353-4c5f-a12c-59eb979fde57)

#### 5. Which item was the most popular for each customer?

```sql
with cte as (
	select s.customer_id, m.product_name, count(s.product_id) as most_ordered,
	rank() over (partition by s.customer_id order by count(s.product_id) desc) as rnk
	from menu m
	join sales s on s.product_id = m.product_id
	group by s.customer_id, m.product_name)
select customer_id, product_name, most_ordered
from cte
where rnk = 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ada8dd0e-a271-4a44-be61-feb7a227a1ab)

#### 6. Which item was purchased first by the customer after they became a member?

```sql
with cte as(
	select s.customer_id, m.product_name, order_date, join_date,
	row_number() over(partition by s.customer_id order by order_date) as rnk
	from menu m
	join sales s on s.product_id = m.product_id
	join members ms on ms.customer_id = s.customer_id
	where order_date >= join_date)
select customer_id, product_name
from cte
where rnk=1;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/7caf40af-d3fe-41bc-9db9-9b498eaffc59)

#### 7. Which item was purchased just before the customer became a member?

```sql
with cte as(
	select s.customer_id, m.product_name, order_date, join_date,
	row_number() over(partition by s.customer_id order by order_date desc) as rnk
	from menu m
	join sales s on s.product_id = m.product_id
	join members ms on ms.customer_id = s.customer_id
	where order_date < join_date)
select customer_id, product_name
from cte
where rnk=1;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ed118fb6-e18e-4e09-9b67-31db3a024d1f)

#### 8. What is the total items and amount spent for each member before they became a member?

```sql
select s.customer_id, count(m.product_id) as total_items, sum(m.price) as total_price
from menu m
join sales s on s.product_id = m.product_id
join members ms on ms.customer_id = s.customer_id
where s.order_date < ms.join_date
group by s.customer_id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/cfcdc67b-f99a-4122-91cc-a98f94fe7ae7)

#### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
select customer_id,
	sum(case
	   when s.product_id=1 then price*20
	   else price*10
	 end) as total_points
from menu m
join sales s on s.product_id = m.product_id
group by customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ad391967-e820-4dc1-abf3-310a955f0911)

#### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
with cte as (
    select *,
           join_date + interval '6 days' as valid_date,
           date_trunc('month', '2022-01-01'::date) + interval '1 month - 1 day' AS last_date
    from members
)
select s.customer_id, 
       sum(case when s.order_date between cte.join_date and cte.valid_date then m.price * 20 else m.price * 10 end) as total_points
from cte
join sales s on s.customer_id = cte.customer_id
join menu m on s.product_id = m.product_id
where s.order_date <= cte.last_date
group by s.customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1d7f2bb9-1334-4990-b9c8-2828d440bb8e)

### Bonus Questions:

Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

```sql
with cte as(
	select s.customer_id, s.order_date, m.product_name, m.price,
		(case 
		when s.order_date >= mb.join_date then 'Y'
		else 'N'
		end) as member
	from sales s
	left join members mb on mb.customer_id = s.customer_id
	join menu m on s.product_id = m.product_id)

select *,
	case when member = 'N' then NULL
	else dense_rank() over(partition by customer_id, member order by order_date)
	end as rnk
from cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/76026746-8f21-41f5-90cf-e878b61aaf1c)

