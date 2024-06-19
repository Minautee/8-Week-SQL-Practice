Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.

```sql
with cat_cte as (
	select id as cat_id, level_name as category
	from balanced_tree.product_hierarchy
	where level_name = 'Category'),
	seg_cte as (
	select parent_id as cat_id, id as seg_id, level_name as segment
	from balanced_tree.product_hierarchy
	where level_name = 'Segment'),
	style_cte as (
	select parent_id as seg_id, id as style_id, level_name as style
	from balanced_tree.product_hierarchy
	where level_name = 'Style'),
	prod_final as (
	select c.cat_id as category_id, category as category_name, s.seg_id as segment_id, segment as segment_name, style_id, style as style_name
	from cat_cte c 
	join seg_cte s on s.cat_id = c.cat_id
	join style_cte st on st.seg_id = s.seg_id)
select product_id, price ,
concat(style_name,' ',segment_name,' - ',category_name) as product_name,
category_id,segment_id,style_id,category_name,segment_name,style_name 
from prod_final pf 
join balanced_tree.product_prices pp on pf.style_id=pp.id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/2699ad21-098f-471e-8a6c-35ec58108872)
