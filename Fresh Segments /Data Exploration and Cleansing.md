## **Solution**

### Case Study Questions:

#### 1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month

```sql
alter table interest_metrics
alter column month_year type date using to_date(month_year, 'mm-yyyy')
```
Result:  
![image](https://github.com/user-attachments/assets/27307413-01bc-49c0-b340-472572097704)

#### 2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?

```sql
select month_year, count(*) as records
from interest_metrics
group by month_year
order by month_year desc
```
Result:  
![image](https://github.com/user-attachments/assets/d85fef30-211a-42fb-acab-92f538c91f86)

#### 3. What do you think we should do with these null values in the fresh_segments.interest_metrics?

```sql
select * from interest_metrics
where month_year is null
delete from interest_metrics where month_year is null
```
We can delete these records. 

#### 4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?

```sql
--Interest IDs in interest_metrics

select count(distinct ime.interest_id) as interest_id_in_interest_metrics
from interest_metrics ime
left join interest_map ima on cast(ime.interest_id as integer)= ima.id
```
Result:  
![image](https://github.com/user-attachments/assets/26936b1f-3cfd-45fb-b818-09f5ee2b0475)

```sql
--Interest IDs in interest_metrics

select count(distinct ima.id) as interest_id_in_interest_map
from interest_map ima
left join interest_metrics ime on cast(ime.interest_id as integer)= ima.id
```
Result:  
![image](https://github.com/user-attachments/assets/ff3c7952-81ee-4a6b-a05e-1602b345d2b3)

There's a difference of 7 Ids which are present in interest_metrics but not in interest_map

#### 5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table.

```sql
select count(ima.id) as id_count, ima.interest_name
from interest_map ima
left join interest_metrics ime on cast(ime.interest_id as integer)= ima.id
group by ima.interest_name
order by 2
```
Result:  
![image](https://github.com/user-attachments/assets/7d0317a2-0029-4cfd-a5d3-0a704af2bab9)

_These are not all records._

#### 6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.

```sql
select _month, _year, interest_id, composition, index_value, ranking, percentile_ranking,
month_year, interest_name, interest_summary, created_at, last_modified
from interest_metrics ime
join interest_map ima on cast(ime.interest_id as integer)= ima.id
where interest_id = '21246'
```
Result:  
month | year | interest_id | composition | index_value | ranking | percentile_ranking | month_year | interest_name | interest_summary | created_at | last_modified  
---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |  
4 | 2019 |	21246 |	1.58 |	0.63 |	1092 | 0.64	| 2019-04-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04  
3 | 2019 | 21246 |	1.75	| 0.67	| 1123 | 1.14	| 2019-03-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04  
2 | 2019 | 21246 |	1.84	| 0.68	| 1109 | 1.07	| 2019-02-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04  
1 | 2019 | 21246 |	2.05	| 0.76	| 954	| 1.95	| 2019-01-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04
12 | 2018 | 21246 |	1.97	| 0.7	 | 983	| 1.21	| 2018-12-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04
11 | 2018 | 21246 |	2.25	| 0.78	| 908	| 2.16	| 2018-11-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04
10 | 2018 | 21246 |	1.74	| 0.58	| 855	| 0.23	| 2018-10-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04
9 | 2018 | 21246 |	2.06	| 0.61	| 774	| 0.77	| 2018-09-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04
8 | 2018 | 21246 |	2.13	| 0.59	| 765	| 0.26	| 2018-08-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04
7 | 2018 | 21246 |	2.26	| 0.65	| 722	| 0.96	| 2018-07-01 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |	2018-06-11 17:50:04 |	2018-06-11 17:50:04

Inner join is performed to get all the records for analysis

#### 7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?

```sql
select _month, _year, interest_id, composition, index_value, ranking, percentile_ranking,
month_year, interest_name, interest_summary, created_at, last_modified
from interest_metrics ime
join interest_map ima on cast(ime.interest_id as integer)= ima.id
where month_year < created_at
```
Result:  
month | year | interest_id | composition | index_value | ranking | percentile_ranking | month_year | interest_name | interest_summary | created_at | last_modified  
---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | 
7 |	2018 |	32704 |	8.04	| 2.27	| 225	| 69.14	| 2018-07-01 |	Major Airline Customers | People visiting sites for major airline brands to plan and view travel itinerary. |	2018-07-06 14:35:04	| 2018-07-06 14:35:04
7 |	2018 |	33191 |	3.99	| 2.11	| 283	| 61.18	| 2018-07-01 |	Online Shoppers | People who spend money online |	2018-07-17 10:40:03 |	2018-07-17 10:46:58
7 | 2018 |	32703 |	5.53	| 1.8	| 375	| 48.56	| 2018-07-01 |	School Supply Shoppers | Consumers shopping for classroom supplies for K-12 students. |	2018-07-06 14:35:04	| 2018-07-06 14:35:04
7 |	2018 |	32701 |	4.23	| 1.41	| 483	| 33.74	| 2018-07-01 |	Womens Equality Advocates | People visiting sites advocating for womens equal rights. | 2018-07-06 14:35:03 | 2018-07-06 14:35:03
7 |	2018 |	32705 |	4.38	| 1.34	| 505	| 30.73	 | 2018-07-01 |	Certified Events Professionals | Professionals reading industry news and researching products and services for event management. | 2018-07-06 14:35:04 | 2018-07-06 14:35:04
7 |	2018 |	32702 |	3.56	| 1.18	| 580	| 20.44	| 2018-07-01 |	Romantics | People reading about romance and researching ideas for planning romantic moments. | 2018-07-06 14:35:04 | 2018-07-06 14:35:04
8 |	2018 |	34465 |	3.34	| 2.34	| 12	| 98.44	| 2018-08-01 |	Toronto Blue Jays Fans | People reading news about the Toronto Blue Jays and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04 | 2018-08-15 18:00:04
8 |	2018 |	34463 |	3.06	| 2.1	| 36	| 95.31	| 2018-08-01 |	Boston Red Sox Fans | People reading news about the Boston Red Sox and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04 | 2018-08-15 18:00:04
8 |	2018 |	34464 |	3	| 1.91	| 57	| 92.57	| 2018-08-01 |	New York Yankees Fans | People reading news about the New York Yankees and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04 | 2018-08-15 18:00:04
8 |	2018 |	33959 |	2.54	| 1.86	| 67	| 91.26	| 2018-08-01 |	Boston Bruins Fans | People reading news about the Boston Bruins and watching games. These consumers are more likely to spend money on team gear. | 2018-08-02 16:05:03 | 2018-08-02 16:05:03

There are more records. Yes, these records are valid as when we converted the month_year column to date type then it automatically took 1st as the date for many records due to which they are before created_at.
