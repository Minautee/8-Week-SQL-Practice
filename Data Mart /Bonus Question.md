Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?

* region
* platform
* age_band
* demographic
* customer_type
  
Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?

```sql
with packaging_sales as (
	select sum(sales) as total_sales, date, week_number, region, platform, age_band, demographics, customer_type
	from weekly_sales_cleaned
	where (week_number between 13 and 37) and calendar_year = 2020
	group by date, week_number, region, platform, age_band, demographics, customer_type),
	after_before_sales_cte as ( 
	select  region, platform, age_band, demographics, customer_type,
	sum(case when week_number between 13 and 24 then total_sales end) as before_sales,
	sum(case when week_number between 25 and 37 then total_sales end) as after_sales
	from packaging_sales
	group by region, platform, age_band, demographics, customer_type)
select (after_sales - before_sales) as change_in_sales, region, platform, age_band, demographics, customer_type,
round((after_sales - before_sales)/before_sales * 100, 2) as percent_change
from after_before_sales_cte
order by round((after_sales - before_sales)/before_sales * 100, 2)
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/7ffa189e-78c1-4616-8b7b-78d2892fb297)

Based on above results, we can observe that the most impacted region with a percent_change of -42.23% was South America consisting of exisiting customers from unknown age-band and demographics ordering from Shopify. 
