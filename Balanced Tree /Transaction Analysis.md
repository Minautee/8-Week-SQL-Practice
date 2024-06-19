## **Solutions**

### Case Study Questions:

#### 1. How many unique transactions were there?

```sql
select count(distinct txn_id) as unique_transactions
from balanced_tree.sales
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e8390334-4ede-4d58-b460-fb5ba921ac6b)

#### 2. What is the average unique products purchased in each transaction?

```sql
with purchase_cte as (
	select txn_id,
	count(distinct prod_id) as products
	from balanced_tree.sales
	group by txn_id)
select round(avg(products), 0) as avg_products
from purchase_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/c2e3077a-35c9-42a6-bc8e-156caed5a621)

#### 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

```sql
with revenue_cte as (
	select txn_id,
	(1-s.discount * 0.01)*(s.qty)*(s.price) as revenue
	from balanced_tree.sales s
	join balanced_tree.product_details pd on pd.product_id = s.prod_id
	group by txn_id, s.qty, s.price, s.discount)
select percentile_cont(0.25) within group (order by revenue) as "25th_percentile",
percentile_cont(0.5) within group (order by revenue) as "50th_percentile",
percentile_cont(0.75) within group (order by revenue) as "75th_percentile"
from revenue_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/89abc13c-0847-4eed-b4b8-829e0cbba753)

#### 4. What is the average discount value per transaction?

```sql
select round(avg(discount*qty*price*0.01),2) as avg_discount
from balanced_tree.sales
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e1d15a14-5f35-4422-83e1-4a2aeda75b41)

#### 5. What is the percentage split of all transactions for members vs non-members?

```sql
with transactions_cte as (
	select 
	sum(case when member = true then 1 else 0 end) as members_transactions,
	sum(case when member = false then 1 else 0 end) as non_members_transactions,
	count(txn_id) as total_transactions
	from balanced_tree.sales)
select round(100*members_transactions / total_transactions, 2) as members_percentage,
round(100*non_members_transactions / total_transactions, 2) as non_members_percentage
from transactions_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ff0d6323-701d-453c-9186-a060d0199a35)

#### 6. What is the average revenue for member transactions and non-member transactions?

```sql
select 
avg(case when member = true then (1-discount*0.01)*(qty*price) end) as member_revenue,
avg(case when member = false then (1-discount*0.01)*(qty*price) end) as non_member_revenue
from balanced_tree.sales
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/eb64836d-331c-47c8-b8df-dd7facaeb1a5)
