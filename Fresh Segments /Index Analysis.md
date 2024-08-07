## **Solutions**

### Case Study Questions:

The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.

```sql
--Create a table with avg composition
with cte as (
	select *, round(cast(composition as numeric) / cast(index_value as numeric), 2) AS avg_composition
 	from interest_metrics 
 	)
select * into index_table from cte
```
month | year | month_year | interest_id | composition | index_value | ranking | percentile_ranking | avg_composition
---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
7 |	2018 |	2018-07-01 |	32486 |	11.89	| 6.19	| 1	| 99.86	| 1.92
7 |	2018 |	2018-07-01 |	6106 |	9.93	| 5.31	| 2	| 99.73	| 1.87
7 |	2018 |	2018-07-01 |	18923 |	10.85	| 5.29	| 3	| 99.59	| 2.05
7 |	2018 |	2018-07-01 |	6344 |	10.32	| 5.1	| 4	| 99.45	| 2.02
7 |	2018 |	2018-07-01 |	100 |	10.77	| 5.04	| 5	| 99.31	| 2.14
7 |	2018 |	2018-07-01 |	69 |	10.82	| 5.03	| 6	| 99.18	| 2.15
7 |	2018 |	2018-07-01 |	79 |	11.21	| 4.97	| 7	| 99.04	| 2.26
7 |	2018 |	2018-07-01 |	6111 |	10.71	| 4.83	| 8	| 98.9 | 2.22
7 |	2018 |	2018-07-01 |	6214 |	9.71	| 4.83	| 8	| 98.9 | 2.01
7 |	2018 |	2018-07-01 |	19422 |	10.11	| 4.81	| 10 | 98.63 | 2.10
7 |	2018 |	2018-07-01 |	6110 |	11.57	| 4.79	| 11 | 98.49 | 2.42
7 |	2018 |	2018-07-01 |	4895 |	9.47	| 4.67	| 12 | 98.35 | 2.03
7 |	2018 |	2018-07-01 |	6217 |	10.8	| 4.62	| 13 | 98.22 | 2.34

_These are not all data._

#### 1. What is the top 10 interests by the average composition for each month?

```sql
with rank_cte as (
	select ima.id, ima.interest_name, month_year, avg_composition,
	extract (month from month_year) as month,
	rank() over (partition by month_year order by avg_composition desc) as rank
	from index_table i
	join interest_map ima on cast (i.interest_id as integer) = ima.id
	)
select * from rank_cte
where rank <=10
```
Result:  
![image](https://github.com/user-attachments/assets/3917962b-e5dc-4b43-a4a5-9919a778e975)
_These are not all data._

#### 2. For all of these top 10 interests - which interest appears the most often?

```sql
with rank_cte as (
	select ima.id, ima.interest_name, month_year, avg_composition,
	extract (month from month_year) as month,
	rank() over (partition by month_year order by avg_composition desc) as rank
	from index_table i
	join interest_map ima on cast (i.interest_id as integer) = ima.id
	), 
top_10_cte as (
    select *
    from rank_cte
    where rank <= 10
),
count_cte as (
    select interest_name, count(*) as count_id
    from top_10_cte
    group by interest_name
),
max_count_cte as (
    select interest_name, count_id
    from count_cte
    order by count_id desc
    limit 1
)
select *
from max_count_cte
```
Result:  
![image](https://github.com/user-attachments/assets/78cdbdc8-fcd3-4368-a436-1a96b81b95f4)

#### 3. What is the average of the average composition for the top 10 interests for each month?

```sql
with rank_cte as (
	select ima.id, ima.interest_name, month_year, avg_composition,
	extract (month from month_year) as month,
	rank() over (partition by month_year order by avg_composition desc) as rank
	from index_table i
	join interest_map ima on cast (i.interest_id as integer) = ima.id
	), 
top_10_cte as (
    select *
    from rank_cte
    where rank <= 10
)
select month_year, avg(avg_composition) as "Average of avg_composition"
from top_10_cte
group by month_year
order by 1
```
Result:  
![image](https://github.com/user-attachments/assets/5808d4e0-8959-4ed5-a415-a25516d62f91)

#### 4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.

```sql
--first find the max avg_composition for each month
with month_comp as(
	 select  month_year,round(max(avg_composition),2) as max_avg_comp
	 from index_table
	 group by month_year
 	), 
rolling_avg as (
--getting the interests which gave the max avg_comp and rolling avg for 3 months
	 select i.month_year,interest_id,interest_name,max_avg_comp as max_index_composition, 
	 round(avg(max_avg_comp)over(order by i.month_year rows between 2 preceding and current row),2) as "3_month_moving_avg"
	 from index_table i join month_comp m on i.month_year=m.month_year
	 join interest_map ima on cast (i.interest_id as integer) =ima.id
	 where avg_composition =max_avg_comp 
--order by 1 asc
 	),
month_1_lag as(
	 select *, concat(lag(interest_name)over( order by month_year), ' : ',lag(max_index_composition)over(order by month_year)) as "1_month_ago"
	 from rolling_avg
	 ),
month_2_lag as (
	 select *, lag("1_month_ago")over(order by month_year) as "2_month_ago"
	 from  month_1_lag
	 )
select * from month_2_lag
where month_year  between '2018-09-01' and '2019-08-01'
```
Result:  

month_year | interest_id | interest_name | max_index_composition | 3_month_moving_avg | 1_month_ago | 2_month_ago
--- | --- | ---| --- | --- | --- | --- | 
2018-09-01 |	21057 |	Work Comes First Travelers |	8.26 |	7.61 | Las Vegas Trip Planners : 7.21 | Las Vegas Trip Planners : 7.36
2018-10-01 |	21057 |	Work Comes First Travelers |	9.14 |	8.20 | Work Comes First Travelers : 8.26  | Las Vegas Trip Planners : 7.21
2018-11-01 |	21057 |	Work Comes First Travelers |	8.28 |	8.56 | Work Comes First Travelers : 9.14 | 	Work Comes First Travelers : 8.26
2018-12-01 |	21057 |	Work Comes First Travelers |	8.31 |	8.58 | Work Comes First Travelers : 8.28 | 	Work Comes First Travelers : 9.14
2019-01-01 |	21057 |	Work Comes First Travelers |	7.66 |	8.08 | Work Comes First Travelers : 8.31 | 	Work Comes First Travelers : 8.28
2019-02-01 |	21057 |	Work Comes First Travelers |	7.66 |	7.88 | Work Comes First Travelers : 7.66 | 	Work Comes First Travelers : 8.31
2019-03-01 |	7541 |	Alabama Trip Planners |	6.54 | 7.29 |	Work Comes First Travelers : 7.66 |	Work Comes First Travelers : 7.66
2019-04-01 |	6065 |	Solar Energy Researchers |	6.28 |	6.83 | Alabama Trip Planners : 6.54 |	Work Comes First Travelers : 7.66
2019-05-01 |	21245 |	Readers of Honduran Content |	4.41 |	5.74 | Solar Energy Researchers : 6.28 | Alabama Trip Planners : 6.54
2019-06-01 |	6324 |	Las Vegas Trip Planners |	2.77 |	4.49 | Readers of Honduran Content : 4.41 | Solar Energy Researchers : 6.28
2019-07-01 |	6324 |	Las Vegas Trip Planners |	2.82 |	3.33 | Las Vegas Trip Planners : 2.77 | Readers of Honduran Content : 4.41
2019-08-01 |	4898 |	Cosmetics and Beauty Shoppers |	2.73 |	2.77 | Las Vegas Trip Planners : 2.82 |	Las Vegas Trip Planners : 2.77

#### 5. Provide a possible reason why the max average composition might change from month to month? Could it signal something is not quite right with the overall business model for Fresh Segments?

Max average composition value is dependent on index value. If index value is 8.26 that means composition value is 8.26x the average composition value for all Fresh Segments clients’ customer for this particular interest in that particular month. 
These values are bound to change depending on the interest of the customers based on seasonal changes, market trends, external factors, customer based changes, etc. Therefore, nothing is wrong with the business model, we have to figure out a way to maintain
how to get maximum composition value for the interest according to these changes. We can figure out a way to focus on 20% of products based on the market-trends and keep an average composition value for rest of the products. 
