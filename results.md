Query results
Computed from the supplied sample data. Questions 1–10 correspond to analysis.sql.
1. Total spending by customer
customer_id	total_spent
A	76
B	74
C	36
2. Distinct visit days by customer
customer_id	days_visited
A	4
B	6
C	2
3. Items purchased on each customer's first visit
customer_id	product_name
A	curry
A	sushi
B	curry
C	ramen
4. Most purchased menu item
product_name	times_purchased
ramen	8
5. Most popular items for each customer, including ties
customer_id	product_name	times_purchased
A	ramen	3
B	curry	2
B	ramen	2
B	sushi	2
C	ramen	3
6. First purchase date on or after joining
customer_id	order_date	product_name
A	2021-01-07	curry
B	2021-01-11	sushi
7. Last purchase date before joining
customer_id	order_date	product_name
A	2021-01-01	curry
A	2021-01-01	sushi
B	2021-01-04	sushi
8. Items and spending before membership
customer_id	total_items	total_spent
A	2	25
B	3	40
9. Points with the sushi multiplier
customer_id	total_points
A	860
B	940
C	360
10. January points with the seven-day welcome offer
customer_id	total_points
A	1370
B	820
