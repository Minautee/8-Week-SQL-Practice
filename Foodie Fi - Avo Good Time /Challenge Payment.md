## **Solution**

### Case Study Question:

#### The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

* monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
* upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
* once a customer churns they will no longer make payments

```sql
create table payments_2020 as
with recursive cte as (
 select customer_id, plan_id, plan_name, start_date, 
   laad(start_date, 1) over(partition by customer_id 
       order by start_date, plan_id) cutoff_date,
   price as amount
  from subscriptions
  join plans
  using (plan_id)
  where start_date between '2020-01-01' and '2020-12-31'
   and plan_name not in('trial', 'churn')
),
cte1 as(
 select customer_id, plan_id, plan_name, start_date, 
   coalsece(cutoff_date, '2020-12-31') cutoff_date, amount
 from cte
),
cte2 as (
  select customer_id, plan_id, plan_name, start_date, cutoff_date, 
    amount from cte1

  union all

  select customer_id, plan_id, plan_name, 
    date((start_date + interval '1 month')) start_date, 
    cutoff_date, amount from cte2
  where cutoff_date > date((start_date + interval '1 month'))
   and plan_name <> 'pro annual'
),
cte3 as (
 select *, 
   lag(plan_id, 1) over(partition by customer_id order by start_date) 
    as last_payment_plan,
   lag(amount, 1) over(partition by customer_id order by start_date) 
    as last_amount_paid,
   rank() over(partition by customer_id order by start_date) AS payment_order
 from cte2
 order by customer_id, start_date
)
select customer_id, plan_id, plan_name, start_date as payment_date, 
 (case 
   when plan_id in (2, 3) and last_payment_plan = 1 
    then (amount - last_amount_paid)
   else amount
 end) as amount, payment_order
from cte3;

select * from payments_2020
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/edfc0cf5-0336-4d57-8bb6-0dd3e0e21e25)
