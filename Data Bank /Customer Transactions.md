## **Solutions**

### Case Study Questions

#### 1. What is the unique count and total amount for each transaction type?

```sql
select txn_type, count(txn_type) as "Unique Count of Transactions", 
	   sum(txn_amount) as "Total Amount"
from customer_transactions
group by txn_type;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/0beeee09-cf7e-4b05-9753-501b43722b2b)

#### 2. What is the average total historical deposit counts and amounts for all customers?

```sql
with deposit_cte as (
	select customer_id, count (txn_type) as count, sum(txn_amount) as total_amount
from customer_transactions
where txn_type = 'deposit'
group by customer_id)
select round(avg(count)) as "Avg Count", round(avg(total_amount),2) as "Avg Amount"
from deposit_cte;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/5a2370eb-ef4b-4a97-b3d3-361c4d42fb9d)

#### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```sql
with monthly_transactions_cte as (
	select customer_id, 
	extract (month from txn_date) as month,
	sum(case when txn_type = 'deposit' then 1 else 0 end) as deposit_count,
	sum(case when txn_type = 'purchase' then 1 else 0 end) as purchase_count,
	sum(case when txn_type = 'withdrawal' then 1 else 0 end) as withdrawal_count
	from customer_transactions
	group by customer_id, extract (month from txn_date))
select month, count(distinct customer_id) as "Number of Customers"
from monthly_transactions_cte
where deposit_count > 1 and (purchase_count >= 1 or withdrawal_count >= 1)
group by month
order by month;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/62bd11fb-ca7c-4f23-b8c9-f2077afcaaf4)

#### 4. What is the closing balance for each customer at the end of the month?

```sql
with transactions_cte as (
	select customer_id, 
		extract (month from txn_date) as month,
		sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_balance
	from customer_transactions
	group by extract (month from txn_date), customer_id)
select customer_id, month, net_balance,
	   sum(net_balance) over (partition by customer_id order by month rows between unbounded preceding and current row) as closing_balance
from transactions_cte;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/39b50ef5-2b13-4a45-bef2-170b223da401)

#### 5. What is the percentage of customers who increase their closing balance by more than 5%?

Creating two tables customer_monthly_balances_cte and ranked_monthly_balances_cte
```sql
create temp table customer_monthly_balances as(
	with monthly_balance_cte as (
	select customer_id, 
	(date_trunc('month', txn_date) + interval '1 month - 1 day') as closing_month,
	sum (case when txn_type = 'withdrawal' or txn_type = 'purchase' then -txn_amount else txn_amount end) as transaction_balance
	from customer_transactions
	group by customer_id, txn_date), 
	monthend_series_cte as(
	select distinct customer_id,
	'2020-01-31'::Date + generate_series(0,3) * interval '1 month' as ending_month
	from customer_transactions),
	monthly_changes_cte as (
	select monthend_series_cte.customer_id, monthend_series_cte.ending_month,
	sum (monthly_balance_cte.transaction_balance) over (partition by monthend_series_cte.customer_id, monthend_series_cte.ending_month order by monthend_series_cte.ending_month) as total_monthly_change,
	sum(monthly_balance_cte.transaction_balance) over (partition by monthend_series_cte.customer_id order by monthend_series_cte.ending_month rows between unbounded preceding and current row) as ending_balance
	from monthend_series_cte
	left join monthly_balance_cte on monthend_series_cte.ending_month = monthly_balance_cte.closing_month
	and monthend_series_cte.customer_id = monthly_balance_cte.customer_id
	)
select customer_id, ending_month, 
coalesce(total_monthly_change, 0) as total_monthly_change, 
min(ending_balance) as ending_balance
from monthly_changes_cte
group by customer_id, ending_month, total_monthly_change
order by customer_id, ending_month
);

create temp table ranked_monthly_balances as (
	select customer_id, ending_month, ending_balance,
	row_number()over (partition by customer_id order by ending_month) as sequence
	from customer_monthly_balances
);
```

Calculating percentage of customers having a negative first month balance and percentage of customers having a positive first month balance
```sql
select 
	round(100 * count(customer_id)/(select count(distinct customer_id)
	from customer_monthly_balances), 1) as negative_first_month_percentage, 
	100 - round(100 * count(customer_id)/ (select count(distinct customer_id)
	from customer_monthly_balances), 1) as positive_first_month_percentage
from ranked_monthly_balances
where sequence =  1
and ending_balance::text like '-%';
```  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/3ab1f256-50aa-4f01-8873-c66e82d00a21)

```sql
with following_month_cte as (
	select customer_id, ending_month, ending_balance,
	lead(ending_balance) over (partition by customer_id order by ending_month) as following_balance
	from ranked_monthly_balances),
	variance_cte as (
	select customer_id, ending_month,
	round(100 * 
		 (following_balance - ending_balance) / ending_balance, 1) as variance
	from following_month_cte
	where ending_month = '2020-01-31'
	and following_balance::text not like '-%'
	group by customer_id, ending_month, ending_balance, following_balance
	having round(100 * (following_balance - ending_balance) / ending_balance, 1) > 5.0)
select round(100 * count(customer_id) / (select count(distinct customer_id)
		from ranked_monthly_balances), 1) as increase_5_percentage
from variance_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/dc955392-85d3-48a5-9c53-23d8b96134a3)
