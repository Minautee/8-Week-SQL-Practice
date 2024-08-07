## **Solutions**

### Case Study Questions: 


```sql
-- Creating Filtered Table

with filtered_interest_id_cte as (
	select count(distinct month_year) as total_months, interest_id
	from interest_metrics
	group by interest_id
	having count(distinct month_year) >= 6)
select * into filtered_table
from interest_metrics
where interest_id in (select interest_id from filtered_interest_id_cte)

select * from filtered_table
```
![image](https://github.com/user-attachments/assets/b6635fce-ba86-4a1d-b193-bfbcc0c8e6ca)
It has total of 12769 records.

#### 1. Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year

```sql
-- For top 10
select month_year,interest_id,interest_name, max(composition) as max_composition
from filtered_table f join interest_map ima on cast (f.interest_id as integer) =ima.id
group by month_year,interest_id,interest_name
order by 4 desc
limit 10
```
Result:  
![image](https://github.com/user-attachments/assets/72914f90-f626-4f57-870b-a887a5e6169c)

```sql
-- For bottom 10
select month_year,interest_id,interest_name, max(composition) as max_composition
from filtered_table f join interest_map ima on cast (f.interest_id as integer) =ima.id
group by month_year,interest_id,interest_name
order by 4 
limit 10
```
Result:  
![image](https://github.com/user-attachments/assets/c881f6c5-bcbc-46c3-be45-2a56b7c06ead)


#### 2. Which 5 interests had the lowest average ranking value?

```sql
select ima.id, ima.interest_name, round(avg(f.ranking),0) as avg_rank
from filtered_table f
join interest_map ima on cast (f.interest_id as integer) =ima.id
group by ima.id, ima.interest_name
order by 3
limit 5
```
Result:  
![image](https://github.com/user-attachments/assets/05d6ed05-ec78-4d5a-8027-907276976201)

#### 3. Which 5 interests had the largest standard deviation in their percentile_ranking value?

```sql
select ima.id, ima.interest_name, 
	stddev(f.percentile_ranking) as std_dev_ranking
from filtered_table f
join interest_map ima on cast (f.interest_id as integer) =ima.id
group by ima.id, ima.interest_name
order by 3 desc
limit 5
```
Result:  
![image](https://github.com/user-attachments/assets/a467dde8-73ca-41b1-bb92-fae881e0b623)

#### 4. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? Can you describe what is happening for these 5 interests?

```sql
with interests as
(
 select interest_id, interest_name, stddev(percentile_ranking) as stdev_ranking
 from filtered_table f
 join interest_map ima on cast (f.interest_id as integer) = ima.id
 group by interest_id,interest_name
 order by 3 desc
 limit 5
 ),
 percentiles as(
 select i.interest_id, interest_name, max(percentile_ranking) as max_percentile,min(percentile_ranking) as min_percentile
 from  filtered_table f 
 join interests i on i.interest_id=f.interest_id
 group by i.interest_id, interest_name
 ), 
 max_per as
 (
  select p.interest_id, interest_name,month_year as max_year, max_percentile
 from  filtered_table f 
 join  percentiles p on p.interest_id=f.interest_id
 where  max_percentile =percentile_ranking
 ),
 min_per as ( 
 select p.interest_id, interest_name,month_year as min_year, min_percentile
 from  filtered_table f 
 join  percentiles p on p.interest_id=f.interest_id
 where  min_percentile =percentile_ranking
 )
select mi.interest_id,mi.interest_name,min_year,min_percentile, max_year, max_percentile
from min_per mi join max_per ma on mi.interest_id= ma.interest_id
```
Result:  
![image](https://github.com/user-attachments/assets/4d685de8-58a7-440d-9082-1d8eec8f43b6)

#### 5. How would you describe our customers in this segment based off their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?

```sql
select f.interest_id, ima.interest_name, f.composition, f.ranking
from filtered_table f
join interest_map ima on cast (f.interest_id as integer) = ima.id
group by f.interest_id, ima.interest_name, f.composition, f.ranking
order by 4
limit 10
```
Result:  
![image](https://github.com/user-attachments/assets/d08de4dc-d1ba-4243-8e48-7ab440dae2da)

```sql
select f.interest_id, ima.interest_name, f.composition, f.ranking
from filtered_table f
join interest_map ima on cast (f.interest_id as integer) = ima.id
group by f.interest_id, ima.interest_name, f.composition, f.ranking
order by 4 desc
limit 10
```
Result:  
![image](https://github.com/user-attachments/assets/d5ec95ef-cab1-4fb5-889a-33efccfec655)

Based on the above observations, Fresh Segments should focus on selling more of winter, vactional and athleisure clothing and less on Entertainment and Video games.
