
-- 1. Create churn_summary table
DROP TABLE IF EXISTS churn_summary;

CREATE TABLE churn_summary AS
SELECT
  u.user_id,
  u.signup_date,
  u.platform,
  u.plan_type,
  MAX(a.activity_date) AS last_active_date,
  COUNT(DISTINCT a.activity_date) AS days_active,
  CASE
    WHEN MAX(a.activity_date) < DATE('2024-01-24') THEN 1
    ELSE 0
  END AS churned
FROM users u
LEFT JOIN user_activity a ON u.user_id = a.user_id
GROUP BY u.user_id, u.signup_date, u.platform, u.plan_type;

-- ======================================
-- 2. Churn Rate by Platform
SELECT
  platform,
  churned,
  COUNT(*) AS user_count
FROM churn_summary
GROUP BY platform, churned
ORDER BY platform, churned;

-- ======================================
-- 3. Daily Active Users (DAU)
SELECT
  activity_date,
  COUNT(DISTINCT user_id) AS dau
FROM user_activity
GROUP BY activity_date
ORDER BY activity_date;

-- ======================================
-- 4. Feature Usage Summary
SELECT
  action_type,
  COUNT(*) AS usage_count
FROM user_activity
GROUP BY action_type
ORDER BY usage_count DESC;

-- ======================================
-- 5. Churn Rate by Plan Type
SELECT
  plan_type,
  churned,
  COUNT(*) AS user_count
FROM churn_summary
GROUP BY plan_type, churned
ORDER BY p
