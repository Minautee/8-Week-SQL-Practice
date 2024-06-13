## Case Study #5 - Data Mart 🛒

![Data Mart](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/fe52207d-a01c-4d35-a1a9-e3369fc8a236)


### **Introduction** 🛍️
<hr>
Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

### **Problem Statement** 👚👜
<hr>
Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the following:

What was the quantifiable impact of the changes introduced in June 2020?
Which platform, region, segment and customer types were the most impacted by this change?
What can we do about future introduction of similar sustainability updates to the business to minimise impact on sales?

Danny has shared with you 3 key datasets for this case study:

1. *[weekly_sales](https://github.com/Minautee/8-Week-SQL-Practice/blob/b409c95fd4d1f0591cf81847f3e48d1320f695ca/Data%20Mart%20/Schema.sql)* : The columns are pretty self-explanatory based on the column names but here are some further details about the dataset:

Data Mart has international operations using a multi-region strategy
Data Mart has both, a retail and online platform in the form of a Shopify store front to serve their customers
Customer segment and customer_type data relates to personal age and demographics information that is shared with Data Mart
transactions is the count of unique purchases made through Data Mart and sales is the actual dollar amount of purchases
Each record in the dataset is related to a specific aggregated slice of the underlying sales data rolled up into a week_date value which represents the start of the sales week.

### **ERD** 🔀
<hr> 
<p align="center">
<img width="491" alt="image" src="https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/f5e7bb51-7863-4eba-83ee-9718e5fc5344">

### **Solutions** ✔️
<hr>

View the case study solutions here

1. [Data Cleaning](https://github.com/Minautee/8-Week-SQL-Practice/blob/b409c95fd4d1f0591cf81847f3e48d1320f695ca/Data%20Mart%20/Data%20Cleaning.md)
2. [Data Exploration](https://github.com/Minautee/8-Week-SQL-Practice/blob/b409c95fd4d1f0591cf81847f3e48d1320f695ca/Data%20Mart%20/Data%20Exploration.md)
3. [Before and After Analysis](https://github.com/Minautee/8-Week-SQL-Practice/blob/b409c95fd4d1f0591cf81847f3e48d1320f695ca/Data%20Mart%20/Before%20and%20After%20Analysis.md)
4. [Bonus Question](https://github.com/Minautee/8-Week-SQL-Practice/blob/b409c95fd4d1f0591cf81847f3e48d1320f695ca/Data%20Mart%20/Bonus%20Question.md)
