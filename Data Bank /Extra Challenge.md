## **Solution**

### Case Study Questions

Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.

If the annual interest rate is set at **6%** and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?

```sql
with transaction_amt_cte as (
	select customer_id, txn_date, txn_type, txn_amount,
	extract (day from txn_date) as txn_day,
	extract (month from txn_date) as txn_month,
	sum(case when txn_type = 'deposit' then txn_amount else -txn_amount end) as net_transaction_amt
	from customer_transactions
	group by customer_id, txn_date, txn_type, txn_amount
	order by customer_id, txn_date),
	running_customer_bal_cte as (
	select customer_id, txn_date, txn_type, txn_amount, txn_day, txn_month,
	sum(net_transaction_amt) over (partition by customer_id order by txn_day rows between unbounded preceding and current row) as running_customer_balance
	from transaction_amt_cte),
	interest_cte as (
	select *,
	(case when running_customer_balance > 0 then running_customer_balance else 0 end) * 0.06/365 as interest
	from running_customer_bal_cte
	group by customer_id, txn_date, txn_type, txn_amount, txn_day, txn_month, running_customer_balance)
select txn_month, sum(interest) as data_required_per_month
from interest_cte
group by txn_month
order by txn_month
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/b901fcf2-69d2-4ac8-95aa-962546e46eb7)
