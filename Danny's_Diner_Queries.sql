CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
 
CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
select * from sales
select * from menu
select * from members

-- 1. What is the total amount each customer spent at the restaurant?

select customer_id, sum(price) as total_spent
from menu m
join sales s on s.product_id = m.product_id
group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?

select customer_id, count(DISTINCT order_date) as visits
from sales
group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?

with cte as (
	select customer_id, order_date, product_name as first_purchase,
	row_number() over (partition by customer_id order by order_date) as rnk
	from menu m
	join sales s on s.product_id = m.product_id)
select customer_id, first_purchase
from cte
where rnk = 1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select m.product_name, count(s.product_id) as most_purchased
from menu m
join sales s on s.product_id=m.product_id
group by m.product_name
order by most_purchased desc;

-- 5. Which item was the most popular for each customer?

with cte as (
	select s.customer_id, m.product_name, count(s.product_id) as most_ordered,
	rank() over (partition by s.customer_id order by count(s.product_id) desc) as rnk
	from menu m
	join sales s on s.product_id = m.product_id
	group by s.customer_id, m.product_name)
select customer_id, product_name, most_ordered
from cte
where rnk = 1

-- 6. Which item was purchased first by the customer after they became a member?

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

-- 7. Which item was purchased just before the customer became a member?

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

-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id, count(m.product_id) as total_items, sum(m.price) as total_price
from menu m
join sales s on s.product_id = m.product_id
join members ms on ms.customer_id = s.customer_id
where s.order_date < ms.join_date
group by s.customer_id

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select customer_id,
	sum(case
	   when s.product_id=1 then price*20
	   else price*10
	 end) as total_points
from menu m
join sales s on s.product_id = m.product_id
group by customer_id; 

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH cte AS (
    SELECT *,
           join_date + INTERVAL '6 days' AS valid_date,
           DATE_TRUNC('month', '2022-01-01'::DATE) + INTERVAL '1 month - 1 day' AS last_date
    FROM members
)
SELECT s.customer_id, 
       SUM(CASE WHEN s.order_date BETWEEN cte.join_date AND cte.valid_date THEN m.price * 20 ELSE m.price * 10 END) AS total_points
FROM cte
JOIN sales s ON s.customer_id = cte.customer_id
JOIN menu m ON s.product_id = m.product_id
where s.order_date <= cte.last_date
GROUP BY s.customer_id;


with cte as(
	select s.customer_id, s.order_date, m.product_name, m.price,
		(case 
		when s.order_date >= mb.join_date then 'Y'
		else 'N'
		end) as member
	from sales s
	left join members mb on mb.customer_id = s.customer_id
	join menu m on s.product_id = m.product_id)
select * from cte

select *,
	case when member = 'N' then NULL
	else dense_rank() over(partition by customer_id, member order by order_date)
	end as rnk
from cte