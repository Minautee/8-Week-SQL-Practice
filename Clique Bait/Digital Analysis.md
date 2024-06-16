## **Solutions**

### Case Study Questions

#### 1. How many users are there?

```sql
select count(distinct user_id) as "Number of Users"
from clique_bait.users;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/65981d00-6775-4e08-b957-74974375b61d)

#### 2. How many cookies does each user have on average?

```sql
with cookie_count as (
	select user_id, 
		count(cookie_id) as "Number of Cookies"
	from clique_bait.users
	group by user_id
	order by user_id)
select round(avg("Number of Cookies"), 0) as "Avg Cookies"
from cookie_count
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/fde922c9-47a6-4798-9de9-0b34a9704c2b)

#### 3. What is the unique number of visits by all users per month?

```sql
select 
	extract(month from event_time) as month,
	count(distinct visit_id) as unique_visit_count
from clique_bait.events
group by month;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/9caa38da-e5c0-4134-aabf-e0202db66186)

#### 4. What is the number of events for each event type?

```sql
select event_type, count(*) as event_count
from clique_bait.events
group by event_type
order by event_type;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/3e2d7ddd-8243-4606-8bb6-eb6bc6c737c3)

#### 5. What is the percentage of visits which have a purchase event?

```sql
select 100 * count(distinct e.visit_id) / (
	select count(distinct visit_id) from clique_bait.events) as percentage_visits
from clique_bait.events e
join clique_bait.event_identifier ei on e.event_type = ei.event_type
where ei.event_name = 'Purchase'
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/5c7e8b2c-80c8-4649-a89f-f7181f629a7e)

#### 6. What is the percentage of visits which view the checkout page but do not have a purchase event?

```sql
with checkout_cte as (
	select visit_id,
	max(case when event_type = 1 and page_id = 12 then 1 else 0 end) as checkout,
	max(case when event_type = 3 then 1 else 0 end) as purchase
	from clique_bait.events
	group by visit_id)
select round(100 * (1-(sum(purchase)::numeric/sum(checkout))),2) as percentage_checkout_no_purchase
from checkout_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/76a77d0e-8b2b-4dbf-9c8d-d53d3770c345)

#### 7. What are the top 3 pages by number of views?

```sql
select ph.page_name,
	count(visit_id) as page_views
from clique_bait.events e
join clique_bait.page_hierarchy ph on ph.page_id = e.page_id
group by ph.page_name
order by page_views desc
limit 3;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/0a9f2f66-71f3-453e-8170-b5cc9ad53f58)

#### 8. What is the number of views and cart adds for each product category?

```sql
select ph.product_category,
	sum(case when e.event_type = 1 then 1 else 0 end) as views,
	sum(case when e.event_type = 2 then 1 else 0 end) as cart_add
from clique_bait.events e
join clique_bait.page_hierarchy ph on ph.page_id = e.page_id
where ph.product_category is not null
group by ph.product_category
order by ph.product_category
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/b832100b-f8ac-4d2e-a6d6-c10d8f73b898)

#### 9. What are the top 3 products by purchases?

```sql
with cte as (
  select distinct visit_id as purchase_id
  from clique_bait.events 
  where event_type = 3
),
cte2 as (
  select 
    ph.page_name,
    ph.page_id,
    e.visit_id 
  from clique_bait.events e
  left join clique_bait.page_hierarchy ph on ph.page_id = e.page_id
  where ph.product_id is not null 
    and e.event_type = 2
)
select 
  page_name as Product,
  count(*) as Quantity_purchased
from cte 
left join cte2 on visit_id = purchase_id 
group by page_name
order by count(*) desc 
limit 3;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/28f6c4f1-630a-4123-883e-bfaa41f5107d)
