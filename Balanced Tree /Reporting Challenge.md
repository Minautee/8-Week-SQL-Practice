Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

```sql
with monthly_analysis_cte as (
	select 
	pd.product_id, pd.product_name, pd.segment_name, pd.category_name,
	sum(s.qty) as quantity_sold, 
	sum(s.qty * s.price) as revenue_before_discount,
	sum(s.qty * s.price * (1 - s.discount * 0.01)) as revenue_after_discount,
	sum((s.qty * s.price) * s.discount / 100.0) as discount,
	sum(case when member = true then 1 else 0 end) as members_transactions,
	sum(case when member = false then 1 else 0 end) as non_members_transactions,
	count(s.txn_id) as total_transactions,
	count(distinct s.txn_id) as unique_total_transactions
	from balanced_tree.sales s
	join balanced_tree.product_details pd on pd.product_id = s.prod_id
	where extract (month from start_txn_time) = 1
	group by pd.category_name, pd.segment_name, pd.product_id, pd.product_name
	)
select category_name, segment_name, product_id, product_name, 
quantity_sold, revenue_before_discount, revenue_after_discount, discount,
(100 * revenue_before_discount / (select sum(qty * price) from balanced_tree.sales)) as percentage_revenue_before_discount,
(100 * revenue_after_discount / (select sum(qty * price * (1-discount * 0.01)) from balanced_tree.sales)) as percentage_revenue_after_discount,
(100 * members_transactions / total_transactions) as percentage_member_transactions,
(100 * non_members_transactions / total_transactions) as percentage_non_member_transactions,
(100 * unique_total_transactions / (select count(distinct txn_id) from balanced_tree.sales)) as transaction_penetration
from monthly_analysis_cte
```
Result:  
category_name | segment_name | product_id | product_name | quantity_sold | revenue_before_discount | revenue_after_discount | discount | percentage_revenue_before_discount | percentage_revenue_after_discount | percentage_member_transactions | percnetage_non_member_transactions | transaction_penetration
---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
Mens |	Shirt |	2a2353 |	Blue Polo Shirt - Mens |	1214 |	69198 |	60674.22 | 8523.78000000000000000000 | 5 | 5.3541248240219721 |	62 | 37 | 16
Mens |	Shirt |	5d267b |	White Tee Shirt - Mens |	1256 |	50240 |	44074.40 | 6165.60000000000000000000 | 3 | 3.8892933299162974	| 58 | 41 | 16
Mens |  Shirt |	c8d436 |	Teal Button Up Shirt - Mens |	1220 |	12200 |	10661.00 | 1539.00000000000000000000 | 0 | 0.94076734317966090125 | 57 | 42 | 16
Mens |	Socks |	2feb6b |	Pink Fluro Polkadot Socks - Mens |	1157 |	33553 |	29461.39 | 4091.61000000000000000000 | 2 | 2.5997855357546037 |	62 | 37 | 15
Mens |	Socks |	b9a74d |	White Striped Socks - Mens |	1150 |	19550 |	17192.27 | 2357.73000000000000000000 | 1 | 1.5171115440509698 | 60 | 39 | 15
Mens |	Socks |	f084eb |	Navy Solid Socks - Mens |	1264 |	45504 |	39946.68 | 5557.32000000000000000000 | 3 | 3.5250475576820276 | 58 | 41 | 16
Womens |	Jacket |	72f5d4 |	Indigo Rain Jacket - Womens |	1225 |	23275 |	20422.72 | 2852.28000000000000000000 | 1 | 1.8021787857520049 |	58 | 41 | 16
Womens |	Jacket |	9ec847 |	Grey Fashion Jacket - Womens |	1300 |	70200 |	61619.40 | 8580.60000000000000000000 | 5 | 5.4375311158732574	| 61 | 38 | 17
Womens |	Jacket |	d5e9a6 |	Khaki Suit Jacket - Womens |	1225 |	28175 |	24736.50 | 3438.50000000000000000000 | 2 | 2.1828432027543084 | 57 | 42 | 16
Womens |	Jeans |	c4a632 |	Navy Oversized Jeans - Womens |	1257 |	16341 |	14317.16 | 2023.84000000000000000000 | 1 | 1.2634008606207780 | 59 | 40 | 16
Womens |	Jeans |	e31d39 |	Cream Relaxed Jeans - Womens |	1282 |	12820 |	11224.20 | 1595.80000000000000000000 | 0 | 0.99046626144987804969 | 60 | 39 | 17
Womens |	Jeans |	e83aa3 |  Black Straight Jeans - Womens |	1238 |	39616 |	34752.96 | 4863.04000000000000000000 | 3 | 3.0667338755115869 | 58 | 41 | 16
