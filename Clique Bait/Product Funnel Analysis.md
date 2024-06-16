## **Solutions**

### Case Study Questions

Using a single SQL query - create a new output table which has the following details:

* How many times was each product viewed?
* How many times was each product added to cart?
* How many times was each product added to a cart but not purchased (abandoned)?
* How many times was each product purchased?
Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

```sql
drop table if exists product_info;
create table product_info as
	with all_products_cte as (
	select e.visit_id, e.cookie_id, e.event_type, ph.page_id, ph.page_name, ph.product_category, ph.product_id
	from clique_bait.events e
	join clique_bait.page_hierarchy ph on ph.page_id = e.page_id),
	views_and_cart_add_cte as (
	select page_name, product_id,
	case when event_type = 1 then visit_id end as viewed,
	case when event_type = 2 then visit_id end as cart_id
	from all_products_cte
	where product_id is not null),
	purchase_cte as (
	select visit_id as purchase_id
	from clique_bait.events
	where event_type = 3)
select page_name, product_id,
	count(viewed) as page_views,
	count(cart_id) as added_to_cart,
	count(cart_id) - count(purchase_id) as abandoned,
	count(purchase_id) as purchases
from views_and_cart_add_cte vc
left join purchase_cte p on p.purchase_id = vc.cart_id
group by page_name, product_id
order by page_name, product_id

select * from product_info
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/9a50e14e-7a16-41d6-9414-e726bb87d0e3)

```sql
drop table if exists product_category_info;
create table product_category_info as
	with all_products_cte as (
	select e.visit_id, e.cookie_id, e.event_type, ph.page_id, ph.page_name, ph.product_category, ph.product_id
	from clique_bait.events e
	join clique_bait.page_hierarchy ph on ph.page_id = e.page_id),
	views_and_cart_add_cte as (
	select product_category,
	case when event_type = 1 then visit_id end as viewed,
	case when event_type = 2 then visit_id end as cart_id
	from all_products_cte
	where product_id is not null),
	purchase_cte as (
	select visit_id as purchase_id
	from clique_bait.events
	where event_type = 3)
select product_category,
	count(viewed) as page_views,
	count(cart_id) as added_to_cart,
	count(cart_id) - count(purchase_id) as abandoned,
	count(purchase_id) as purchases
from views_and_cart_add_cte vc
left join purchase_cte p on p.purchase_id = vc.cart_id
group by product_category
order by product_category

select * from product_category_info
```
Result:
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/cab7038b-8817-4907-b49d-0b62cba0be02)

Use your 2 new output tables - answer the following questions:

#### 1. Which product had the most views, cart adds and purchases?

Most Views:
```sql
select product_id, page_name, page_views, added_to_cart, purchases
from product_info
order by page_views desc
limit 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/baa19c04-76d2-4802-aba5-934a96bf1f83)

Most Cart Adds:
```sql
select product_id, page_name, page_views, added_to_cart, purchases
from product_info
order by added_to_cart desc
limit 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e703a1fd-c214-4263-8e1e-8bff1ad851a5)

Most Purchases:
```sql
select product_id, page_name, page_views, added_to_cart, purchases
from product_info
order by purchases desc
limit 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/51cc6424-2ab2-4953-9f09-2d8ac5356287)

#### 2. Which product was most likely to be abandoned?

```sql
select product_id, page_name, abandoned
from product_info
order by abandoned desc
limit 1
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/29ab9456-c70f-4073-b1dd-c29c27fc160b)

#### 3. Which product had the highest view to purchase percentage?

```sql
select product_id, page_name, 
	100 * purchases/page_views as view_to_purchase_percentage
from product_info
order by 3 desc
limit 3
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/734a346b-be3e-400f-82e2-e33b472e81ce)

#### 4. What is the average conversion rate from view to cart add?

```sql
with conversion_cte as (
	select product_id, 100 * added_to_cart/page_views as conversion_rate
	from product_info)
select round(avg(conversion_rate),2) as avg_conversion_rate
from conversion_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/bf851a49-8cb6-4d11-8768-91af07858d26)

#### 5. What is the average conversion rate from cart add to purchase?

```sql
with conversion_cte as (
	select product_id, 100 * purchases/added_to_cart as conversion_rate
	from product_info)
select round(avg(conversion_rate),2) as avg_conversion_rate
from conversion_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/54f6b96e-cb02-4387-ae4e-621176c566d8)
