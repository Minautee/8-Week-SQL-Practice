## **Solutions**

### Case Study Questions

Generate a table that has 1 single row for every unique visit_id record and has the following columns:

* user_id
* visit_id
* visit_start_time: the earliest event_time for each visit
* page_views: count of page views for each visit
* cart_adds: count of product cart add events for each visit
* purchase: 1/0 flag if a purchase event exists for each visit
* campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
* impression: count of ad impressions for each visit
* click: count of ad clicks for each visit
* (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)

```sql
select u.user_id,
	e.visit_id,
	min(e.event_time) as visit_start_time,
	count(case when e.event_type = 1 then visit_id end) as page_views,
	count(case when e.event_type = 2 then visit_id end) as cart_adds,
	max(case when e.event_type = 3 then 1 else 0 end) as purchase,
	ci.campaign_name,
	count(case when e.event_type = 4 then visit_id end) as impression,
	count(case when e.event_type = 5 then visit_id end) as click,
	string_agg(case when e.event_type = 2 and product_id is not null then ph.page_name else null end,','
        order by e.sequence_number) as cart_products
from clique_bait.users u
join clique_bait.events e on e.cookie_id = u.cookie_id
left join clique_bait.campaign_identifier ci on e.event_time between ci.start_date and ci.end_date
left join clique_bait.page_hierarchy ph on ph.page_id = e.page_id
group by u.user_id, e.visit_id, ci.campaign_name
```
Result:  

user_id | visit_id | visit_start_time | page_views | cart_adds | purchase | campaign_name | impression | click | cart_products
--------|----------|------------------|------------|-----------|----------|---------------|------------|-------|---------------
1	| 02a5d5	| 2020-02-26 16:57:26.260871 |	4 |	0	| 0	| Half Off - Treat Your Shellf(ish) |	0	| 0 | null
1	| 0826dc	| 2020-02-26 05:58:37.918618 |	1 |	0	| 0	| Half Off - Treat Your Shellf(ish) |	0 |	0 | null
1	| 0fc437	| 2020-02-04 17:49:49.602976 | 10 |	6	| 1	| Half Off - Treat Your Shellf(ish) |	1 |	1 | Tuna,Russian Caviar,Black Truffle,Abalone,Crab,Oyster
1	| 30b94d	| 2020-03-15 13:12:54.023936 |	9	| 7	| 1	| Half Off - Treat Your Shellf(ish) |	1	| 1 | Salmon,Kingfish,Tuna,Russian Caviar,Abalone,Lobster,Crab
