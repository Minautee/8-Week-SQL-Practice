## **Solutions**

### Case Study Questions:

#### 1. What was the total quantity sold for all products?

```sql
select sum(s.qty) as total_quantity
from balanced_tree.sales s
join balanced_tree.product_details pd on pd.product_id = s.prod_id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/926cd2ac-538a-442d-8540-4a34b22d3edf)

#### 2. What is the total generated revenue for all products before discounts?

```sql
select sum(s.price * s.qty) as revenue
from balanced_tree.sales s
join balanced_tree.product_details pd on pd.product_id = s.prod_id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/807f21bc-6764-4d69-b6a1-e548bcf1b99e)

#### 3. What was the total discount amount for all products?

```sql
select round(sum((discount*(qty*s.price)/100.0)),2) as Total_Discount
from balanced_tree.sales s join balanced_tree.product_details pd
on s.prod_id=pd.product_id
```
Result:  
![image](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/1e7e5f3d-f7f8-4b07-8441-1cc5f8eab496)
