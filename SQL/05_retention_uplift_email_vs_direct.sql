-- Potential revenue uplift if Email repeat rate reaches Direct level

WITH user_orders AS (
  SELECT
    u.acquisition_channel,
    o.user_id,
    COUNT(*) AS order_count,
    AVG(o.total_amount) AS avg_order_value
  FROM `ecommerce-portfolio-bq.ecommerce.orders` o
  JOIN `ecommerce-portfolio-bq.ecommerce.users` u
    ON o.user_id = u.user_id
  WHERE o.order_status = 'completed'
  GROUP BY u.acquisition_channel, o.user_id
),

channel_stats AS (
  SELECT
    acquisition_channel,
    COUNT(*) AS total_users,
    COUNTIF(order_count >= 2) AS repeat_users,
    COUNTIF(order_count >= 2) / COUNT(*) AS repeat_rate,
    AVG(avg_order_value) AS avg_aov
  FROM user_orders
  GROUP BY acquisition_channel
),

direct_stats AS (
  SELECT repeat_rate AS direct_repeat
  FROM channel_stats
  WHERE acquisition_channel = 'Direct'
),

email_stats AS (
  SELECT *
  FROM channel_stats
  WHERE acquisition_channel = 'Email'
)

SELECT
  e.total_users,
  e.repeat_rate AS email_repeat_rate,
  d.direct_repeat AS direct_repeat_rate,
  (d.direct_repeat - e.repeat_rate) AS uplift_rate,
  e.total_users * (d.direct_repeat - e.repeat_rate) AS potential_additional_repeat_users,
  e.total_users * (d.direct_repeat - e.repeat_rate) * e.avg_aov AS potential_additional_revenue
FROM email_stats e
CROSS JOIN direct_stats d;
