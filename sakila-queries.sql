USE sakila;

-- Q1: Who are our highest-value customers?
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- Q2: Which film categories generate the most revenue at each store?
SELECT g.store_id, cat.name AS category, g.revenue
FROM (
    SELECT i.store_id,
           fc.category_id,
           SUM(p.amount) AS revenue
    FROM payment p
    JOIN rental r        ON p.rental_id = r.rental_id
    JOIN inventory i     ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    GROUP BY i.store_id, fc.category_id
) AS g
JOIN category cat ON cat.category_id = g.category_id
ORDER BY g.store_id, g.revenue DESC;

-- Q3: Which customers spend more than the average customer at their store?
WITH customer_totals AS (
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           c.store_id,
           SUM(p.amount) AS customer_total
    FROM customer c
    JOIN payment p ON p.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.store_id
),
store_avg AS (
    SELECT store_id, AVG(customer_total) AS avg_customer_total
    FROM customer_totals
    GROUP BY store_id
)
SELECT ct.customer_id, ct.first_name, ct.last_name, ct.store_id, ct.customer_total
FROM customer_totals ct
JOIN store_avg sa ON sa.store_id = ct.store_id
WHERE ct.customer_total > sa.avg_customer_total;
             
-- Q4: Who are the least active rental customers?
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_rentals,
       MAX(r.rental_date) AS last_rental_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals ASC, last_rental_date ASC
LIMIT 10;