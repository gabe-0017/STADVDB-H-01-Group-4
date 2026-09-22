USE sakila;

EXPLAIN FORMAT=JSON
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
SELECT ct.customer_id,
       ct.first_name,
       ct.last_name,
       ct.store_id,
       ct.customer_total
FROM customer_totals ct
JOIN store_avg sa ON sa.store_id = ct.store_id
WHERE ct.customer_total > sa.avg_customer_total;