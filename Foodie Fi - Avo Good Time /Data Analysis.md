## **Solutions**

### Case Study Questions:

#### 1. How many customers has Foodie-Fi ever had?

```sql
select count(distinct customer_id) as total_customers
from subscriptions;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f4bed89b-d564-41cf-a663-82cbd636f6a3)

#### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
select extract(month from start_date) as month, count(distinct customer_id) as monthly_distribution
from subscriptions s
join plans p on p.plan_id = s.plan_id
where p.plan_id = 0
group by extract(month from start_date)
```
Result:   
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/5349c117-2a47-4937-95d9-0d14f0a51caa)

#### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
select p.plan_name, count(s.plan_id) as number_of_plans_after_2020
from subscriptions s
join plans p on p.plan_id = s.plan_id
where extract(year from start_date) > 2020
group by p.plan_name
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/8b0c2e9f-e2a6-4e1b-a606-e6dd808b58ec)

#### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
select count(distinct s.customer_id) as churned_customer_count, 
	   round(100*count(distinct s.customer_id)/total_customer_count.total_customers, 1) as churned_customer_percentage
from subscriptions s
join plans p on p.plan_id = s.plan_id
cross join (select count(distinct customer_id) as total_customers
		   from subscriptions) as total_customer_count
where p.plan_name = 'churn'
group by total_customer_count.total_customers;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1b783912-3753-4d93-bdf3-5bf278cc0bc8)

#### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
with next_plan_cte as (
    select *,
           lead(plan_id, 1) over (partition by customer_id order by start_date) as next_plan
    from subscriptions
),
churners as (
    select *
    from next_plan_cte
    where next_plan = 4
      and plan_id = 0
)
select
    count(customer_id) as "churn after trial count",
    round(100.0 * count(customer_id) / (
        select count(distinct customer_id)
        from subscriptions
    ), 2) as "churn percentage"
from
    churners;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/567dd50e-fe46-4efe-b20b-94b165576477)

#### 6. What is the number and percentage of customer plans after their initial free trial?

```sql
select p.plan_name, 
	   count(distinct s.customer_id) as customers,
	   round(100.0 * count(customer_id) / (
        select count(distinct customer_id)
        from subscriptions
    ), 2) as "customers percentage"
from subscriptions s
join plans p on p.plan_id = s.plan_id
where plan_name != 'trial'
group by p.plan_name
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/4f797c77-92d4-4b30-8fbb-f11f2adfcf41)

#### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```sql
with latest_plan_cte as (
		select *,
		row_number() over (partition by s.customer_id order by s.start_date desc) as latest_plan
		from subscriptions s
		join plans p on p.plan_id = s.plan_id
		where start_date <= '2020-12-31')
select plan_name, 
	   count(distinct customer_id) as customers,
	   round(100.0 * count(customer_id) / (
        select count(distinct customer_id)
        from subscriptions
    ), 2) as "customers percentage"
from latest_plan_cte
where latest_plan = 1
group by plan_name;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/aa0b1e11-30df-47c7-b051-5418ae33eaf7)

#### 8. How many customers have upgraded to an annual plan in 2020?

```sql
select count(distinct s.customer_id) as "annual plan customers"
from subscriptions s
join plans p on p.plan_id = s.plan_id
where plan_name = 'pro annual' and extract(year from start_date) = 2020
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/5e31b31f-82d5-487e-b54f-b21f223a6dc4)

#### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql
with initial_plan_cte as (
	select *
	from subscriptions s
	join plans p on p.plan_id = s.plan_id
	where p.plan_id = 0),
	annual_plan_cte as (
	select *
	from subscriptions s
	join plans p on p.plan_id = s.plan_id
	where p.plan_id = 3)
select round(avg((a.start_date - i.start_date)),2) as average_days_to_annual_plan 
from initial_plan_cte i
join annual_plan_cte a on a.customer_id = i.customer_id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/db509a5f-00a7-4584-bf8d-3a321602b26a)

#### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```sql
with plan_change_cte as (
	select *,
	lead(start_date, 1) over (partition by customer_id order by start_date) as updated_plan_start_date,
	lead(plan_id, 1) over (partition by customer_id order by start_date) as updated_plan
	from subscriptions),
	window_cte as (
	select *,
	(updated_plan_start_date - start_date) as days,
	round((updated_plan_start_date - start_date)/30) as window_30_days
	from plan_change_cte
	where updated_plan = 3)
select window_30_days,
	count(distinct customer_id) as Customers
from window_cte
group by window_30_days
order by window_30_days
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/8a27ec27-1e17-49b8-b31b-c0faf10a135d)

#### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
with cte_plan_change as (
	select plan_id as current_plan,
	lead(plan_id, 1) over (partition by customer_id order by start_date) as downgraded_plan,
	lead(start_date, 1) over (partition by customer_id order by start_date) as downgraded_plan_start_date
	from subscriptions
	)
select count(*) as customers
from cte_plan_change
where current_plan = 2 and downgraded_plan = 1 and extract(year from downgraded_plan_start_date) = 2020
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/50710e3a-84c0-4542-bd84-67dddc0eb4a1)
