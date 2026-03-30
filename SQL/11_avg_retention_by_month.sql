-- Average retention by month number across cohorts

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
),

cohort_counts AS (
  SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT user_id) AS users_count
  FROM user_cohorts
  GROUP BY cohort_month, month_number
),

cohort_size AS (
  SELECT
    cohort_month,
    users_count AS cohort_users
  FROM cohort_counts
  WHERE month_number = 0
),

retention_table AS (
  SELECT
    c.cohort_month,
    c.month_number,
    c.users_count,
    s.cohort_users,
    SAFE_DIVIDE(c.users_count, s.cohort_users) AS retention_rate
  FROM cohort_counts c
  JOIN cohort_size s
    ON c.cohort_month = s.cohort_month
)

SELECT
  month_number,
  AVG(retention_rate) AS avg_retention_rate
FROM retention_table
GROUP BY month_number
ORDER BY month_number;
