## Case Study #3 - Foodie Fi - Avo Good Time 🥑	

![Foodie Fi](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/c0e9a4a7-dfcf-4a65-9b89-3950335c302e)

### **Introduction** 🧑‍🍳
<hr>
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!
Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

### **Problem Statement** 📺
<hr>
Danny has shared the data design for Foodie-Fi and also short descriptions on each of the database tables - our case study focuses on only 2 tables but there will be a challenge to create a new table for the Foodie-Fi team.

Danny has shared with you 3 key datasets for this case study:

1. *[plans](https://github.com/Minautee/8-Week-SQL-Practice/blob/184477068789c7007097b6dafec994e9762612de/Foodie%20Fi%20-%20Avo%20Good%20Time%20/Schema.sql)* : Customers can choose which plans to join Foodie-Fi when they first sign up.
* Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90
* Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.
Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.
When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.
2. *[subscriptions](https://github.com/Minautee/8-Week-SQL-Practice/blob/184477068789c7007097b6dafec994e9762612de/Foodie%20Fi%20-%20Avo%20Good%20Time%20/Schema.sql)* : Customer subscriptions show the exact date where their specific plan_id starts. If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes. When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway. When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

### **ERD** 🔀
<hr> 
<p align="center">
<img width="491" alt="image" src="https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/ce34b3f0-5703-4450-9d58-56bcee39b68f">

### **Solutions** ✔️
<hr>

View the case study solutions here:
1. [Data Analysis](https://github.com/Minautee/8-Week-SQL-Practice/blob/b7e49389608dee1815e2432cdf2f4092950e7882/Foodie%20Fi%20-%20Avo%20Good%20Time%20/Data%20Analysis.md)
2. [Challenge Payment](https://github.com/Minautee/8-Week-SQL-Practice/blob/b7e49389608dee1815e2432cdf2f4092950e7882/Foodie%20Fi%20-%20Avo%20Good%20Time%20/Challenge%20Payment.md)
