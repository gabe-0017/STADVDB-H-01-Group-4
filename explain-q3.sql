USE sakila;

EXPLAIN SELECT c.customer_id, c.first_name, c.last_name, c.store_id,
       (SELECT SUM(p.amount) FROM payment p WHERE p.customer_id = c.customer_id) AS customer_total
FROM customer c
WHERE (SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = c.customer_id)
    > (SELECT AVG(store_totals.total)
       FROM (SELECT c2.customer_id, SUM(p3.amount) AS total
             FROM customer c2
             JOIN payment p3 ON c2.customer_id = p3.customer_id
             WHERE c2.store_id = c.store_id
             GROUP BY c2.customer_id) AS store_totals);