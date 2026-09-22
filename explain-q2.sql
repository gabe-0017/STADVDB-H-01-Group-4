USE sakila;

EXPLAIN FORMAT=JSON 
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