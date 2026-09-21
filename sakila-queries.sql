USE sakila;

-- Q1: Who are our highest-value customers?
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- Q2: Which film categories generate the most revenue at each store?
SELECT s.store_id, cat.name AS category, SUM(p.amount) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY s.store_id, cat.name
ORDER BY s.store_id, revenue DESC;

-- Q3: Which customers spend more than the average customer at their store?
SELECT c.customer_id, c.first_name, c.last_name, c.store_id,
       (SELECT SUM(p.amount) FROM payment p WHERE p.customer_id = c.customer_id) AS customer_total
FROM customer c
WHERE (SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = c.customer_id)
    > (SELECT AVG(store_totals.total)
       FROM (SELECT c2.customer_id, SUM(p3.amount) AS total
             FROM customer c2
             JOIN payment p3 ON c2.customer_id = p3.customer_id
             WHERE c2.store_id = c.store_id
             GROUP BY c2.customer_id) AS store_totals);
             
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