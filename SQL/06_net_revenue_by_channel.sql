-- Gross revenue, refunds, and net revenue by channel

SELECT
  o.channel,
  SUM(o.total_amount) AS gross_revenue,
  SUM(COALESCE(r.refund_amount, 0)) AS total_refunds,
  SUM(o.total_amount) - SUM(COALESCE(r.refund_amount, 0)) AS net_revenue
FROM `ecommerce-portfolio-bq.ecommerce.orders` o
LEFT JOIN `ecommerce-portfolio-bq.ecommerce.refunds` r
  ON o.order_id = r.order_id
WHERE o.order_status = 'completed'
GROUP BY o.channel
ORDER BY net_revenue DESC;
