## **Solutions**

### Case Study Questions

To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

* Option 1: data is allocated based off the amount of money at the end of the previous month
* Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
* Option 3: data is updated real-time

For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:

* running customer balance column that includes the impact each transaction
* customer balance at the end of each month
* minimum, average and maximum values of the running balance for each customer
  
Using all of the data available - how much data would have been required for each option on a monthly basis?

1. Running Customer balances that includes the impact each transaction
   
```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_month rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte)
select *
from running_customer_bal_cte;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/9c4e26a1-3807-4999-a34d-20521e9106bd)

2. Customer balance at the end of each month

```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_month rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte),
	month_end_balance_cte as (
	select *, 
	last_value(running_customer_balance) over (partition by customer_id, txn_month order by txn_month) as month_end_balance
	from running_customer_bal_cte
	group by customer_id, txn_month, txn_date, txn_type, txn_amount, running_customer_balance)
select customer_id, txn_month, month_end_balance
from month_end_balance_cte;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f8fee5f3-eddb-44fb-92f4-86d3e9aea597)


3. Minimum, Average and Maximum values of the running balance for each customer

```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_month rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte
	group by customer_id, txn_date, txn_type, txn_amount, txn_month, net_transaction_amt)
select customer_id,
min(running_customer_balance), max(running_customer_balance),
round(avg(running_customer_balance), 2) as "avg(running_customer_balance)"
from running_customer_bal_cte
group by customer_id
order by customer_id;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e6c224b1-8721-41ec-9816-cd121ee1e072)

Based on these divisions, 
1. Data is allocated based off the amount of money at the end of the previous month

```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_month rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte),
	month_end_balance_cte as (
	select *, 
	last_value(running_customer_balance) over (partition by customer_id, txn_month order by txn_month) as month_end_balance
	from running_customer_bal_cte
	group by customer_id, txn_month, txn_date, txn_type, txn_amount, running_customer_balance),
	customer_month_end_balance_cte as (
	select customer_id, txn_month, month_end_balance
	from month_end_balance_cte
	group by customer_id, txn_month, month_end_balance)
select txn_month, sum(case when month_end_balance > 0 then month_end_balance else 0 end) as data_required_per_month
from customer_month_end_balance_cte
group by txn_month
order by txn_month
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/cd25649b-286f-40a1-9354-194c0551f96c)

2. Data is allocated on the average amount of money kept in the account in the previous 30 days

```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_month rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte),
	avg_running_balance_cte as (
	select customer_id, txn_month,
		avg(running_customer_balance) over (partition by customer_id) as "avg_running_customer_balance"
	from running_customer_bal_cte
	group by customer_id, txn_month, running_customer_balance)
select txn_month, sum(avg_running_customer_balance) as data_required_per_month
from avg_running_balance_cte
group by txn_month
order by txn_month
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/041edb88-2829-4ec1-bbe5-452ca4e5fb11)

3. Data is allocated real-time

```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_month rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte)
select txn_month, sum(running_customer_balance) as data_required_per_month
from running_customer_bal_cte
group by txn_month
order by txn_month
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/cd5900b2-a7aa-4c04-9fa8-c52d55919655)
