-- Danny's Diner | Tanya McGrury | PostgreSQL
-- Questions 1–10. Run schema.sql first.

-- Question 1: Total spending by customer
SELECT s.customer_id, SUM(m.price) AS total_spent
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- Question 2: Distinct visit days by customer
SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;

-- Question 3: Items purchased on each customer's first visit
WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM dannys_diner.sales
    GROUP BY customer_id
)
SELECT DISTINCT s.customer_id, m.product_name
FROM first_orders AS f
JOIN dannys_diner.sales AS s
    ON s.customer_id = f.customer_id
    AND s.order_date = f.first_order_date
JOIN dannys_diner.menu AS m ON m.product_id = s.product_id
ORDER BY s.customer_id, m.product_name;

-- Question 4: Most purchased menu item
SELECT m.product_name, COUNT(*) AS times_purchased
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY times_purchased DESC
LIMIT 1;

-- Question 5: Most popular items for each customer, including ties
WITH item_counts AS (
    SELECT s.customer_id, m.product_name, COUNT(*) AS times_purchased
    FROM dannys_diner.sales AS s
    JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
),
ranked_items AS (
    SELECT customer_id, product_name, times_purchased,
        DENSE_RANK() OVER (
            PARTITION BY customer_id
            ORDER BY times_purchased DESC
        ) AS item_rank
    FROM item_counts
)
SELECT customer_id, product_name, times_purchased
FROM ranked_items
WHERE item_rank = 1
ORDER BY customer_id, product_name;

-- Question 6: First purchase date on or after joining
WITH member_purchases AS (
    SELECT s.customer_id, s.order_date, mem.join_date, m.product_name,
        DENSE_RANK() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date ASC
        ) AS purchase_rank
    FROM dannys_diner.sales AS s
    JOIN dannys_diner.members AS mem ON s.customer_id = mem.customer_id
    JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
    WHERE s.order_date >= mem.join_date
)
SELECT customer_id, order_date, product_name
FROM member_purchases
WHERE purchase_rank = 1
ORDER BY customer_id, product_name;

-- Question 7: Last purchase date before joining
WITH member_purchases AS (
    SELECT s.customer_id, s.order_date, mem.join_date, m.product_name,
        DENSE_RANK() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC
        ) AS purchase_rank
    FROM dannys_diner.sales AS s
    JOIN dannys_diner.members AS mem ON s.customer_id = mem.customer_id
    JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
    WHERE s.order_date < mem.join_date
)
SELECT customer_id, order_date, product_name
FROM member_purchases
WHERE purchase_rank = 1
ORDER BY customer_id, product_name;

-- Question 8: Items and spending before membership
SELECT s.customer_id, COUNT(*) AS total_items, SUM(m.price) AS total_spent
FROM dannys_diner.sales AS s
JOIN dannys_diner.members AS mem ON s.customer_id = mem.customer_id
JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- Question 9: Points with the sushi multiplier
SELECT s.customer_id,
    SUM(CASE
        WHEN m.product_name = 'sushi' THEN m.price * 20
        ELSE m.price * 10
    END) AS total_points
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- Question 10: January points with the seven-day welcome offer
-- Interpretation preserves the submitted query's rule that pre-join spending
-- contributes to the balance. Welcome and sushi multipliers do not stack.
SELECT s.customer_id,
    SUM(CASE
        WHEN s.order_date BETWEEN mem.join_date
            AND mem.join_date + INTERVAL '6 days' THEN m.price * 20
        WHEN m.product_name = 'sushi' THEN m.price * 20
        ELSE m.price * 10
    END) AS total_points
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
JOIN dannys_diner.members AS mem ON s.customer_id = mem.customer_id
WHERE s.customer_id IN ('A', 'B')
    AND s.order_date >= DATE '2021-01-01'
    AND s.order_date < DATE '2021-02-01'
GROUP BY s.customer_id
ORDER BY s.customer_id;
