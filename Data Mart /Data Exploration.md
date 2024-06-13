## **Solutions**

### Case Study Questions

#### 1. What day of the week is used for each week_date value?

```sql
select distinct(to_char(date, 'Day')) as day
from weekly_sales_cleaned;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/fed6f282-2339-4157-b35e-b5a4f34a5735)

#### 2. What range of week numbers are missing from the dataset?

```sql
with all_weeks_cte as (
	select generate_series(1, 52) as week_number)
select distinct w.week_number
from all_weeks_cte w
left join weekly_sales_cleaned s on s.week_number = w.week_number
where s.week_number is null;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/3bfdd92d-36c4-42a3-990c-833b8b4d79f8)

There are total 28 week numbers missing from the dataset i.e. 1-12 and 37-52.

#### 3. How many total transactions were there for each year in the dataset?

```sql
select calendar_year as year, sum(transactions) as total_transactions
from weekly_sales_cleaned
group by calendar_year;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/4ea4c455-3cd4-4821-bf21-9fd43ad2a3e1)

#### 4. What is the total sales for each region for each month?

```sql
select month_number, region, sum(sales) as total_sales
from weekly_sales_cleaned
group by month_number, region
order by month_number;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1253a33f-4efd-420c-9b98-8ec9975a5cc3)

#### 5. What is the total count of transactions for each platform?

```sql
select platform, sum(transactions) as transactions_count
from weekly_sales_cleaned
group by platform;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f8c704e8-5877-4751-bd9a-b62c386e4e0d)

#### 6. What is the percentage of sales for Retail vs Shopify for each month?

```sql
with sales_contribution_cte as
  (select calendar_year,
          month_number,
          platform,
          sum(sales) as sales_contribution
   from weekly_sales_cleaned
   group by calendar_year, month_number, platform
   order by calendar_year, month_number),
     total_sales_cte as
  (select *,
          sum(sales_contribution) over(partition by calendar_year, month_number) as total_sales
   from sales_contribution_cte)
select calendar_year,
       month_number,
       round(sales_contribution/total_sales*100, 2) as retail_percent,
       100-round(sales_contribution/total_sales*100, 2) as shopify_percent
from total_sales_cte
where platform = 'Retail'
order by calendar_year, month_number;
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/aaaab0c7-23d5-4d77-ac66-7294c008d9b1)

#### 7. What is the percentage of sales by demographic for each year in the dataset?

```sql
with sales_cte as (
	select calendar_year, demographics,
	sum(sales) as total_sales
	from weekly_sales_cleaned
	group by calendar_year, demographics
	order by calendar_year),
	yearly_sales_cte as
	(select *,
	 sum(total_sales) over (partition by calendar_year) as sales_per_year
	 from sales_cte)
select calendar_year, demographics,
	round(total_sales/sales_per_year * 100, 2) as "Percentage of Sales"
from yearly_sales_cte
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/fcbfc467-2687-4910-b31e-cd37026f925e)

#### 8. Which age_band and demographic values contribute the most to Retail sales?

```sql
select age_band, demographics,
	sum(sales) as sales_contribution,
	round(100* sum(sales)/
		 (select sum(sales)
		 from weekly_sales_cleaned
		 where platform = 'Retail'), 2)as sales_percentage
from weekly_sales_cleaned
where platform = 'Retail'
group by age_band, demographics
order by sales_contribution desc
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/95444291-222e-42d5-bec5-5db4f2843375)

#### 9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

```sql
select calendar_year, platform,
	round(avg(avg_transaction), 0) as avg_transaction_row,
	round(sum(sales)/sum(transactions),2) as avg_transaction_group
from weekly_sales_cleaned
group by calendar_year, platform
order by calendar_year, platform
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/eb6bf682-a865-4533-abbc-7977399a8527)

No, we cannot use avg_transaction column to find the avg transaction size as it is already a column of averages and summing up the average and taking the average of that is not the right method to find avg size. Instead sum of sales divided upon sum of transactions gives us the avg transaction size.
