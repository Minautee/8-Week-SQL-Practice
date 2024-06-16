## Case Study #6 - Clique Bait 🪝

![Clique Bait](https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/b0b4b0f3-eb5a-4eb6-b8ad-5aff6a49073f)

### **Introduction** 🎣
<hr>

Clique Bait is not like your regular online seafood store - the founder and CEO Danny, was also a part of a digital data analytics team and wanted to expand his knowledge into the seafood industry!

### **Problem Statement** 💻
<hr>

In this case study - you are required to support Danny’s vision and analyse his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.

For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.

1. *[users](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Schema.sql)* : Customers who visit the Clique Bait website are tagged via their cookie_id.
2. *[events](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Schema.sql)*: Customer visits are logged in this events table at a cookie_id level and the event_type and page_id values can be used to join onto relevant satellite tables to obtain further information about each event.
The sequence_number is used to order the events within each visit.
3. *[event_identifier](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Schema.sql)*: The event_identifier table shows the types of events which are captured by Clique Bait’s digital data systems.
4. *[campaign_identifer](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Schema.sql)*: This table shows information for the 3 campaigns that Clique Bait has ran on their website so far in 2020.
5. *[page_hierarchy](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Schema.sql)*: This table lists all of the pages on the Clique Bait website which are tagged and have data passing through from user interaction events.

### **ERD** 🔀
<hr> 
<p align="center">
<img width="491" alt="image" src="https://github.com/Minautee/8-Week-SQL-Practice/assets/68679965/e40bd62a-146c-4f3c-8cab-6e46d0406236">

### **Solutions** ✔️
<hr>

View the case study solutions here

1. [Digital Analysis](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Digital%20Analysis.md)
2. [Product Funnel Analysis](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Product%20Funnel%20Analysis.md)
3. [Campaign Analysis](https://github.com/Minautee/8-Week-SQL-Practice/blob/04a37aa43461473b74bb36a7d3a05035ad354247/Clique%20Bait/Campaign%20Analysis.md)
