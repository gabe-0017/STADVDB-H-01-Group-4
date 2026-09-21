USE sakila;

EXPLAIN SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_rentals,
       MAX(r.rental_date) AS last_rental_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals ASC, last_rental_date ASC
LIMIT 10;