USE sakila;

EXPLAIN SELECT s.store_id, cat.name AS category, SUM(p.amount) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY s.store_id, cat.name
ORDER BY s.store_id, revenue DESC;