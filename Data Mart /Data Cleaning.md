In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

* Convert the week_date to a **DATE** format

* Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc

* Add a month_number with the calendar month for each week_date value as the 3rd column

* Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values

* Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value  

Segment  | Age_band
------------- | -------------
1 | Young Adults
2  | Middle Aged
3 or 4 | Retirees

* Add a new demographic column using the following mapping for the first letter in the segment values:
  
Segment       | 	Demographic
--------------| --------------
C	  |    Couples
F	  |    Families

Ensure all null string values with an **"unknown"** string value in the original segment column as well as the new age_band and demographic columns

* Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record

```sql
drop table if exists weekly_sales_cleaned;
create temp table weekly_sales_cleaned as(
select to_date(week_date, 'dd-mm-YY') as date,
	date_part('week', to_date(week_date, 'dd-mm-YY')) as week_number,
	extract(month from to_date(week_date, 'dd-mm-YY')) as month_number,
	extract(year from to_date(week_date, 'dd-mm-YY')) as calendar_year,
	segment,
	case
		when right(segment, 1) = '1' then 'Young Adults'
		when right(segment, 1) = '2' then 'Middle Aged'
		when right(segment, 1) in('3', '4') then 'Retirees'
		else 'unknown'
	end as age_band,
	case
		when left(segment, 1) = 'C' then 'Couples'
		when left(segment, 1) = 'F' then 'Family'
		else 'unknown'
	end as demographics,
	sales, transactions,
	round(sales/transactions, 2) as avg_transaction,
	region,
	platform,
	customer_type
from weekly_sales);

select * from weekly_sales_cleaned
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1e5068c6-a0a5-4045-a1d9-c9a33997a49b)
