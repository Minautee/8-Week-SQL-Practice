## **Solutions**

### Case Study Questions:

#### 1. Which interests have been present in all month_year dates in our dataset?

```sql
-- Calculate total months
select count(distinct month_year) as total_month_year
from interest_metrics
```
![image](https://github.com/user-attachments/assets/e863c771-7524-4157-9885-f12c41998b13)

```sql
select ima.id, ima.interest_name
from interest_map ima
join interest_metrics ime on cast(ime.interest_id as integer)= ima.id
group by id, interest_name
having count(distinct ime.month_year) = 14
```
Result:  
![image](https://github.com/user-attachments/assets/1efda7cc-c3c8-4c85-9505-273c852e0d41)
_These are not all records._

#### 2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?

```sql
with months_count as(
select distinct interest_id, count(month_year) as month_count
from interest_metrics 
group by interest_id
--order by 2 desc
)
, interests_count as
(
select month_count, count(interest_id) as interest_count
from months_count
group by month_count
)
, cumulative_percentage as
(
select *, round(sum(interest_count)over(order by month_count desc) *100.0/(select sum(interest_count) from interests_count),2) as cumulative_percent
from interests_count
group by month_count, interest_count
)
select *
from cumulative_percentage
where cumulative_percent >90
```
Result:  
![image](https://github.com/user-attachments/assets/9869af03-c796-4385-b362-649a5762b33e)

#### 3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?

```sql
with lower_month_counts as (
	select count(distinct month_year) as total_months, interest_id
	from interest_metrics
	group by interest_id
	having count(distinct month_year) < 6)
select count(interest_id) as interest_id_to_remove
from interest_metrics
where interest_id in (select interest_id from lower_month_counts)
```
Result:  
![image](https://github.com/user-attachments/assets/3445636c-51ba-4e01-955b-eb5da3f8bd20)

#### 4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.

```sql
with month_counts as
(
select interest_id, count(distinct month_year) as month_count
from 
interest_metrics
group by interest_id
having count(distinct month_year) <6 
)
select removed.month_year,  present_interest,removed_interest, round(removed_interest*100.0/(removed_interest+present_interest),2) as removed_prcnt
from
(
select month_year, count(*) as removed_interest
from interest_metrics
where interest_id in (select interest_id from month_counts) 
group by month_year
) removed
join 
(
select month_year, count(*) as present_interest
from interest_metrics
where interest_id not in (select interest_id from month_counts) 
group by month_year
) present
on removed.month_year= present.month_year
order by removed.month_year
```
Result:  
![image](https://github.com/user-attachments/assets/4711c748-f932-43f5-b09a-a530cd2a9cad)

Yes, we can remove them as the removed percentage is not so significant.

#### 5. After removing these interests - how many unique interests are there for each month?

```sql
with lower_month_counts as (
	select count(distinct month_year) as total_months, interest_id
	from interest_metrics
	group by interest_id
	having count(distinct month_year) < 6)
select month_year, count(interest_id) as unique_ids_present
from interest_metrics
where interest_id not in (select interest_id from lower_month_counts)
group by month_year
order by month_year
```
Result:  
![image](https://github.com/user-attachments/assets/17016356-f6da-46c2-8012-458f821b1b25)
