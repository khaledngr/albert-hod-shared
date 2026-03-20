-- Answer all the questions below with basics SQL queries
-- don't forget to add a screenshot of the result from BigQuery directly in the basics/ folder

--1. What are the possible values of an order status?
SELECT DISTINCT order_status
FROM `bronze.olist_orders`
ORDER BY order_status;

-- 2. Who are the 5 last customers that purchased a DELIVERED order (order with status DELIVERED)?
SELECT
  c.customer_id,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state,
  o.order_id,
  o.order_purchase_timestamp
FROM `bronze.olist_orders` AS o
JOIN `bronze.olist_customer` AS c
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 5;


-- 3. Add a column is_sp which returns 1 if the customer is from São Paulo and 0 otherwise

SELECT
  c.customer_id,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state,
  o.order_id,
  o.order_purchase_timestamp,
  CASE
    WHEN c.customer_city = 'sao paulo' OR c.customer_city = 'São Paulo' THEN 1
    ELSE 0
  END AS is_sp
FROM `bronze.olist_orders` AS o
LEFT JOIN `bronze.olist_customer` AS c
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 5;




-- 4. add a new column: what's the product category associated to the order?

SELECT
  c.customer_id,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state,
  o.order_id,
  o.order_purchase_timestamp,
  CASE
    WHEN c.customer_city = 'sao paulo' OR c.customer_city = 'São Paulo' THEN 1
    ELSE 0
  END AS is_sp,
  p.product_category_name
FROM `bronze.olist_orders` AS o
LEFT JOIN `bronze.olist_customer` AS c
  ON o.customer_id = c.customer_id
LEFT JOIN `bronze.olist_order_items` AS oi
  ON o.order_id = oi.order_id
LEFT JOIN `bronze.olist_products` AS p
  ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 5;