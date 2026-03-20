-- Answer all the questions below with aggegate SQL queries
-- don't forget to add a screenshot of the result from BigQuery directly in the basics/ folder

-- 1. What was the total revenue and order count for 2018?

SELECT
  2018 AS year,
  COUNT(DISTINCT o.order_id) AS order_count_2018,
  SUM(IFNULL(oi.price, 0) + IFNULL(oi.freight_value, 0)) AS total_revenue_2018
FROM `bronze.olist_orders` AS o
LEFT JOIN `bronze.olist_order_items` AS oi
  ON o.order_id = oi.order_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018;


-- 2. What is the total_sales, average_order_sales, and first_order_date by customer? 
-- Round the values to 2 decimal places & order by total_sales descending
-- limit to 1000 results

SELECT
  c.customer_id,
  c.customer_unique_id,
  ROUND(SUM(IFNULL(oi.price, 0) + IFNULL(oi.freight_value, 0)), 2) AS total_sales,
  ROUND(AVG(IFNULL(oi.price, 0) + IFNULL(oi.freight_value, 0)), 2) AS average_order_sales,
  MIN(o.order_purchase_timestamp) AS first_order_date
FROM `bronze.olist_customer` AS c
LEFT JOIN `bronze.olist_orders` AS o
  ON c.customer_id = o.customer_id
LEFT JOIN `bronze.olist_order_items` AS oi
  ON o.order_id = oi.order_id
GROUP BY
  c.customer_id,
  c.customer_unique_id
ORDER BY
  total_sales DESC
LIMIT 1000;



-- 3. Who are the top 10 most successful sellers?

SELECT
  s.seller_id,
  s.seller_city,
  s.seller_state,
  ROUND(SUM(IFNULL(oi.price, 0) + IFNULL(oi.freight_value, 0)), 2) AS total_sales
FROM `bronze.olist_sellers` AS s
LEFT JOIN `bronze.olist_order_items` AS oi
  ON s.seller_id = oi.seller_id
GROUP BY
  s.seller_id,
  s.seller_city,
  s.seller_state
ORDER BY
  total_sales DESC
LIMIT 10;

-- 4. What’s the preferred payment method by product category?

WITH payment_counts AS (
  SELECT
    p.product_category_name,
    op.payment_type,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM `bronze.olist_products` AS p
  LEFT JOIN `bronze.olist_order_items` AS oi
    ON p.product_id = oi.product_id
  LEFT JOIN `bronze.olist_orders` AS o
    ON oi.order_id = o.order_id
  LEFT JOIN `bronze.olist_order_payments` AS op
    ON o.order_id = op.order_id
  WHERE
    p.product_category_name IS NOT NULL
    AND op.payment_type IS NOT NULL
  GROUP BY
    p.product_category_name,
    op.payment_type
)
SELECT
  product_category_name,
  payment_type,
  order_count
FROM payment_counts
QUALIFY
  ROW_NUMBER() OVER (
    PARTITION BY product_category_name
    ORDER BY
      order_count DESC,
      payment_type
  ) = 1
ORDER BY
  order_count DESC;
