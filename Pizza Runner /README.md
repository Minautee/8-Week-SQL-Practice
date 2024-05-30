## Case Study #2 - Pizza Runner 🍕

![Pizza Runner](https://8weeksqlchallenge.com/images/case-study-designs/2.png)


### **Introduction** 🫒
<hr>
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!" Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

### **Problem Statement** 🧅
<hr>
Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth. He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

Danny has shared with you 3 key datasets for this case study:

1. *[runners](https://github.com/Minautee/8-Week-SQL-Practice/blob/86a1b82f5de67e441fac67226db725ce02430476/Pizza%20Runner%20/Schema.sql)* : The runners table shows the registration_date for each new runner
2. *[customer_orders](https://github.com/Minautee/8-Week-SQL-Practice/blob/86a1b82f5de67e441fac67226db725ce02430476/Pizza%20Runner%20/Schema.sql)* : Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.
*Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!*
The exclusions and extras columns will need to be cleaned up before using them in your queries.
3. *[runner_orders](https://github.com/Minautee/8-Week-SQL-Practice/blob/86a1b82f5de67e441fac67226db725ce02430476/Pizza%20Runner%20/Schema.sql)* : After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.
There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!
4. *[pizza_names](https://github.com/Minautee/8-Week-SQL-Practice/blob/86a1b82f5de67e441fac67226db725ce02430476/Pizza%20Runner%20/Schema.sql)* : At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
5. *[pizza_recipes](https://github.com/Minautee/8-Week-SQL-Practice/blob/86a1b82f5de67e441fac67226db725ce02430476/Pizza%20Runner%20/Schema.sql)* : Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
6. *[pizza_toppings](https://github.com/Minautee/8-Week-SQL-Practice/blob/86a1b82f5de67e441fac67226db725ce02430476/Pizza%20Runner%20/Schema.sql)* : This table contains all of the topping_name values with their corresponding topping_id value

### **ERD** 🔀  
<hr> 
<p align="center">
<img width="491" alt="image" src="https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/454e2161-6b01-4184-80c8-22074f45ca00">

### **Solutions** ✔️
<hr>

View the case study solutions here:
1. [Pizza Metrics](https://github.com/Minautee/8-Week-SQL-Practice/blob/e71380c2e2696b896cf8bf754f8674aca781fa17/Pizza%20Runner%20/Pizza%20Metrics.md)
2. [Runner and Customer Experience](https://github.com/Minautee/8-Week-SQL-Practice/blob/e71380c2e2696b896cf8bf754f8674aca781fa17/Pizza%20Runner%20/Runner%20and%20Customer%20Experience.md)
3. [Ingredient Opetimisation](https://github.com/Minautee/8-Week-SQL-Practice/blob/e71380c2e2696b896cf8bf754f8674aca781fa17/Pizza%20Runner%20/Ingredient%20Optimisation.md)

