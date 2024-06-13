This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

Using this analysis approach - answer the following questions:

#### 1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

Finding the week number in which '2020-06-15' is present.
```sql
select distinct week_number, date
from weekly_sales_cleaned
where date = '2020-06-15'
```
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ca64d932-b3eb-447e-9eab-c74f18b7f22e)


```sql
with packaging_sales as (
	select sum(sales) as total_sales, date, week_number
	from weekly_sales_cleaned
	where (week_number between 21 and 28) and calendar_year = 2020
	group by date, week_number),
	after_before_sales_cte as ( 
	select
	sum(case when week_number between 21 and 24 then total_sales end) as before_sales,
	sum(case when week_number between 25 and 28 then total_sales end) as after_sales
	from packaging_sales)
select (after_sales - before_sales) as change_in_sales,
round((after_sales - before_sales)/before_sales * 100, 2) as percent_change
from after_before_sales_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/3fa73e51-5b24-4a1d-9c01-f4c6950c236b)

This shows that switching to sustainable packaging did impact the sales negatively possibly due to customers not recognising the products packaging. 

#### 2. What about the entire 12 weeks before and after?

```sql
with packaging_sales as (
	select sum(sales) as total_sales, date, week_number
	from weekly_sales_cleaned
	where (week_number between 13 and 37) and calendar_year = 2020
	group by date, week_number),
	after_before_sales_cte as ( 
	select
	sum(case when week_number between 13 and 24 then total_sales end) as before_sales,
	sum(case when week_number between 25 and 37 then total_sales end) as after_sales
	from packaging_sales)
select (after_sales - before_sales) as change_in_sales,
round((after_sales - before_sales)/before_sales * 100, 2) as percent_change
from after_before_sales_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/496207a3-b050-40ad-8e83-0a0f4f5c663b)

Analysing the sales after 12 weeks of introducing the sustainable packaging shows further decrease in the sales.

#### 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

For 1st period - 4 weeks 
```sql
with packaging_sales as (
	select sum(sales) as total_sales, date, week_number, calendar_year
	from weekly_sales_cleaned
	where (week_number between 21 and 28)
	group by date, week_number, calendar_year),
	after_before_sales_cte as ( 
	select calendar_year,
	sum(case when week_number between 21 and 24 then total_sales end) as before_sales,
	sum(case when week_number between 25 and 28 then total_sales end) as after_sales
	from packaging_sales
	group by calendar_year)
select (after_sales - before_sales) as change_in_sales, calendar_year,
round((after_sales - before_sales)/before_sales * 100, 2) as percent_change
from after_before_sales_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/28eb3040-4082-4832-87f1-c995c61594cb)

We can observe that there is signficant change in sales since 2018. In 2018, sales performance was good but then in consecutive years it kept falling. It might be possible that the quality of product degraded with year. Further, the negative sales in 2020 might also be due to the onset of COVID shutting down businesses for a long period of time. 

For 2nd period - 12 weeks
```sql
with packaging_sales as (
	select sum(sales) as total_sales, date, week_number, calendar_year
	from weekly_sales_cleaned
	where (week_number between 13 and 37)
	group by date, week_number, calendar_year),
	after_before_sales_cte as ( 
	select calendar_year,
	sum(case when week_number between 13 and 24 then total_sales end) as before_sales,
	sum(case when week_number between 25 and 37 then total_sales end) as after_sales
	from packaging_sales
	group by calendar_year)
select (after_sales - before_sales) as change_in_sales, calendar_year,
round((after_sales - before_sales)/before_sales * 100, 2) as percent_change
from after_before_sales_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/96c6c4d7-a4b3-4aad-99ac-5a894e64d7ae)

In 12 weeks period, we can observe the sales variance to be quite significant outperforming in 2018 and underperforming with a change of 3.14% in 2020. Thus, sustainable packaging didn't drive the sales up. 
