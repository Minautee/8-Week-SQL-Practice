## **Solutions**

### Case Study Questions:

#### 1. What are the top 3 products by total revenue before discount?

```sql
select pd.product_name,
	sum(s.qty) * sum(s.price) as total_revenue
from balanced_tree.sales s
join balanced_tree.product_details pd on pd.product_id = s.prod_id
group by pd.product_name
order by 2 desc
limit 3;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/aa7987b8-58a5-4067-88f5-9040b0529cd5)

#### 2. What is the total quantity, revenue and discount for each segment?

```sql
select pd.segment_name, sum(s.qty) as total_quantity,
	sum(s.qty * s.price) as revenue,
	sum(s.qty * s.price * 1-s.discount*0.01) as discount
from balanced_tree.sales s
join balanced_tree.product_details pd on pd.product_id = s.prod_id
group by pd.segment_name
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/738332d9-a6e9-4489-b978-ae055d735043)

#### 3. What is the top selling product for each segment?

```sql
with top_selling_cte as (
	select pd.product_name, pd.segment_name,
		sum (s.qty) as quantity,
	rank() over (partition by segment_name order by sum(qty) desc) as rk
	from balanced_tree.sales s
	join balanced_tree.product_details pd on pd.product_id = s.prod_id
	group by pd.product_name, pd.segment_name)
select segment_name, product_name, quantity
from top_selling_cte
where rk = 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/509a6d48-bb64-48ae-9bd0-06260116577d)

#### 4. What is the total quantity, revenue and discount for each category?

```sql
select pd.category_name, sum(s.qty) as total_quantity,
	sum(s.qty * s.price) as revenue,
	sum(s.qty * s.price * (1-s.discount*0.01)) as discount
from balanced_tree.sales s
join balanced_tree.product_details pd on pd.product_id = s.prod_id
group by pd.category_name
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/bba467aa-ed6e-4f46-b331-9d22fc4f5e8e)

#### 5. What is the top selling product for each category?

```sql
with top_selling_cte as (
	select pd.product_name, pd.category_name,
		sum (s.qty) as quantity,
	rank() over (partition by category_name order by sum(qty) desc) as rk
	from balanced_tree.sales s
	join balanced_tree.product_details pd on pd.product_id = s.prod_id
	group by pd.product_name, pd.category_name)
select category_name, product_name, quantity
from top_selling_cte
where rk = 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f2f9c176-fd32-4b0a-a7d0-74ea875f9a5e)

#### 6. What is the percentage split of revenue by product for each segment?

```sql
with product_revenue_cte as (
	select pd.segment_name, pd.product_name,
	sum(s.qty*s.price * (1-s.discount*0.01)) as revenue
	from balanced_tree.product_details pd
	join balanced_tree.sales s on s.prod_id = pd.product_id
	group by pd.segment_name, pd.product_name
	order by pd.segment_name, pd.product_name)
select segment_name, product_name, 
round(100* revenue / (select sum(qty * price * (1 - discount * 0.01)) from balanced_tree.sales), 2) as percentage_revenue
from product_revenue_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/6852ef19-44f1-4355-a066-d746446d078e)

#### 7. What is the percentage split of revenue by segment for each category?

```sql
with segment_revenue_cte as (
	select pd.category_name, pd.segment_name,
	sum(s.qty*s.price * (1-s.discount*0.01)) as revenue
	from balanced_tree.product_details pd
	join balanced_tree.sales s on s.prod_id = pd.product_id
	group by pd.category_name, pd.segment_name
	order by pd.category_name, pd.segment_name)
select category_name, segment_name,
round(100* revenue / (select sum(qty * price * (1 - discount * 0.01)) from balanced_tree.sales), 2) as percentage_revenue
from segment_revenue_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/7e79c4c8-3637-4e6f-90b5-2347fc20c873)

#### 8. What is the percentage split of total revenue by category?

```sql
with category_revenue_cte as (
	select pd.category_name,
	sum(s.qty*s.price * (1-s.discount*0.01)) as revenue
	from balanced_tree.product_details pd
	join balanced_tree.sales s on s.prod_id = pd.product_id
	group by pd.category_name
	order by pd.category_name)
select category_name,
round(100* revenue / (select sum(qty * price * (1 - discount * 0.01)) from balanced_tree.sales), 2) as percentage_revenue
from category_revenue_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/63091ccd-8987-459c-b02a-8d84f37be004)

#### 9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

```sql
with transaction_penetration_cte as (
	select pd.product_name,
	count(distinct s.txn_id) as product_purchase
	from balanced_tree.sales s
	join balanced_tree.product_details pd on pd.product_id = s.prod_id
	where qty >= 1
    group by pd.product_name)
select product_name,
100 * product_purchase / (select count(distinct txn_id) from balanced_tree.sales) as transaction_penetration
from transaction_penetration_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/40dd3e6d-720d-4a74-9d42-9773f8352c6b)

#### 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

```sql
with base as (
select s.txn_id,s.prod_id,product_name
from balanced_tree.sales s
join balanced_tree.product_details pd on s.prod_id = pd.product_id
)
select a.product_name, b.product_name, c.product_name , count(*) as combination_count
from base a inner join base b
on a.txn_id = b.txn_id 
inner join base c 
on b.txn_id = c.txn_id 
where a.prod_id < b.prod_id and  b.prod_id < c.prod_id
group by a.product_name, b.product_name, c.product_name 
order by 4 desc
limit 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/c3d7a603-c6c4-4521-b8b8-8cc1600cfed0)
