-- Cohort table: users count by cohort month and month number

WITH first_orders AS (
  SELECT
    user_id,
    MIN(order_date) AS first_order_date
  FROM `ecommerce-portfolio-bq.ecommerce.orders`
  WHERE order_status = 'completed'
  GROUP BY user_id
),

user_cohorts AS (
  SELECT
    o.user_id,
    DATE_TRUNC(f.first_order_date, MONTH) AS cohort_month,
    DATE_DIFF(o.order_date, f.first_order_date, MONTH) AS month_number
  FROM `ecommerce-portfolio-bq.ecommerce.orders` o
  JOIN first_orders f
    ON o.user_id = f.user_id
  WHERE o.order_status = 'completed'
)

SELECT
  cohort_month,
  month_number,
  COUNT(DISTINCT user_id) AS users_count
FROM user_cohorts
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
