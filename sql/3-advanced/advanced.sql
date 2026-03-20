-- Answer all the questions below with advanced SQL queries (partitioning, CASE WHENs)
-- don't forget to add a screenshot of the result from BigQuery directly in the basics/ folder

-- 1. Where are located the clients that ordered more than the average?

WITH customer_orders AS (
	SELECT
		c.customer_id,
		c.customer_city,
		c.customer_state,
		COUNT(DISTINCT o.order_id) AS order_count,
		AVG(COUNT(DISTINCT o.order_id)) OVER () AS avg_order_count
	FROM `bronze.olist_customer` AS c
	JOIN `bronze.olist_orders` AS o
		ON c.customer_id = o.customer_id
	GROUP BY
		c.customer_id,
		c.customer_city,
		c.customer_state
)
SELECT
	customer_id,
	customer_city,
	customer_state,
	order_count,
	avg_order_count
FROM customer_orders
WHERE order_count > avg_order_count
ORDER BY
	order_count DESC;

-- 2. Segment clients in categories based on the amount spent (use CASE WHEN)

WITH customer_spend AS (
	SELECT
		c.customer_id,
		c.customer_unique_id,
		ROUND(SUM(IFNULL(oi.price, 0) + IFNULL(oi.freight_value, 0)), 2) AS total_spent
	FROM `bronze.olist_customer` AS c
	LEFT JOIN `bronze.olist_orders` AS o
		ON c.customer_id = o.customer_id
	LEFT JOIN `bronze.olist_order_items` AS oi
		ON o.order_id = oi.order_id
	GROUP BY
		c.customer_id,
		c.customer_unique_id
)
SELECT
	customer_id,
	customer_unique_id,
	total_spent,
	CASE
		WHEN total_spent < 100 THEN 'low'
		WHEN total_spent < 500 THEN 'medium'
		ELSE 'high'
	END AS spend_segment
FROM customer_spend
ORDER BY
	total_spent DESC;

-- 3. Compute the difference in days between the first and last order of a client. Compute then the average (use PARTITION BY)

WITH customer_order_dates AS (
	SELECT
		o.customer_id,
		DATE(MIN(o.order_purchase_timestamp)) OVER (PARTITION BY o.customer_id) AS first_order_date,
		DATE(MAX(o.order_purchase_timestamp)) OVER (PARTITION BY o.customer_id) AS last_order_date
	FROM `bronze.olist_orders` AS o
)
SELECT
	customer_id,
	first_order_date,
	last_order_date,
	DATE_DIFF(last_order_date, first_order_date, DAY) AS days_between_orders,
	AVG(DATE_DIFF(last_order_date, first_order_date, DAY)) OVER () AS avg_days_between_orders
FROM customer_order_dates
QUALIFY
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) = 1
ORDER BY
	days_between_orders DESC;

-- 4. Add a column to the query in basics question 2.: what was their first product category purchased?

WITH first_category AS (
	SELECT
		o.customer_id,
		p.product_category_name,
		ROW_NUMBER() OVER (
			PARTITION BY o.customer_id
			ORDER BY
				o.order_purchase_timestamp,
				o.order_id,
				p.product_category_name
		) AS rn
	FROM `bronze.olist_orders` AS o
	JOIN `bronze.olist_order_items` AS oi
		ON o.order_id = oi.order_id
	JOIN `bronze.olist_products` AS p
		ON oi.product_id = p.product_id
	WHERE o.order_status = 'delivered'
)
SELECT
	c.customer_id,
	c.customer_unique_id,
	c.customer_city,
	c.customer_state,
	o.order_id,
	o.order_purchase_timestamp,
	fc.product_category_name AS first_product_category
FROM `bronze.olist_orders` AS o
JOIN `bronze.olist_customer` AS c
	ON o.customer_id = c.customer_id
LEFT JOIN first_category AS fc
	ON o.customer_id = fc.customer_id
	AND fc.rn = 1
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 5;