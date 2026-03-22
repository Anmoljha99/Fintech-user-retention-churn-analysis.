-- ============================================================
--  FinTech User Retention & Churn Analysis — SQL Queries
--  Author : Anmol Jha
--  GitHub : https://github.com/Anmoljha99
-- ============================================================

-- ── 1. Build Churn Summary Table ─────────────────────────────────────────────
-- Aggregates per-user activity into a single churn record.
-- A user is marked churned if their last activity was before the final 7 days.

DROP TABLE IF EXISTS churn_summary;

CREATE TABLE churn_summary AS
SELECT
    u.user_id,
    u.signup_date,
    u.platform,
    u.plan_type,
    MAX(a.activity_date)                          AS last_active_date,
    COUNT(DISTINCT a.activity_date)               AS days_active,
    CASE
        WHEN MAX(a.activity_date) < DATE('2024-01-24') THEN 1
        ELSE 0
    END                                           AS churned
FROM users u
LEFT JOIN user_activity a ON u.user_id = a.user_id
GROUP BY
    u.user_id,
    u.signup_date,
    u.platform,
    u.plan_type;


-- ── 2. Overall Churn Rate ─────────────────────────────────────────────────────
SELECT
    COUNT(*)                                       AS total_users,
    SUM(churned)                                   AS churned_users,
    ROUND(100.0 * SUM(churned) / COUNT(*), 2)      AS churn_rate_pct
FROM churn_summary;


-- ── 3. Churn Rate by Platform ─────────────────────────────────────────────────
SELECT
    platform,
    COUNT(*)                                       AS total_users,
    SUM(churned)                                   AS churned_users,
    ROUND(100.0 * SUM(churned) / COUNT(*), 2)      AS churn_rate_pct
FROM churn_summary
GROUP BY platform
ORDER BY churn_rate_pct DESC;


-- ── 4. Churn Rate by Plan Type ────────────────────────────────────────────────
SELECT
    plan_type,
    COUNT(*)                                       AS total_users,
    SUM(churned)                                   AS churned_users,
    ROUND(100.0 * SUM(churned) / COUNT(*), 2)      AS churn_rate_pct
FROM churn_summary
GROUP BY plan_type
ORDER BY churn_rate_pct DESC;


-- ── 5. Daily Active Users (DAU) ───────────────────────────────────────────────
SELECT
    activity_date,
    COUNT(DISTINCT user_id)                        AS dau
FROM user_activity
GROUP BY activity_date
ORDER BY activity_date;


-- ── 6. Feature Usage Summary ──────────────────────────────────────────────────
SELECT
    action_type,
    COUNT(*)                                       AS usage_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS usage_pct
FROM user_activity
GROUP BY action_type
ORDER BY usage_count DESC;


-- ── 7. Avg Session Duration by Plan Type ─────────────────────────────────────
SELECT
    u.plan_type,
    ROUND(AVG(a.session_duration_min), 2)          AS avg_session_min,
    COUNT(DISTINCT a.user_id)                      AS active_users
FROM user_activity a
JOIN users u ON a.user_id = u.user_id
GROUP BY u.plan_type
ORDER BY avg_session_min DESC;


-- ── 8. Retention by Day Since Signup ─────────────────────────────────────────
-- Uses a subquery to compute days-since-signup per activity event
SELECT
    day_since_signup,
    COUNT(DISTINCT user_id)                        AS users_active,
    ROUND(100.0 * COUNT(DISTINCT user_id) /
          (SELECT COUNT(*) FROM users), 2)         AS retention_rate_pct
FROM (
    SELECT
        a.user_id,
        CAST(JULIANDAY(a.activity_date) - JULIANDAY(u.signup_date) AS INTEGER) AS day_since_signup
    FROM user_activity a
    JOIN users u ON a.user_id = u.user_id
    WHERE a.activity_date >= u.signup_date
) sub
GROUP BY day_since_signup
ORDER BY day_since_signup;


-- ── 9. High-Risk Users (Churned, Free Plan, Low Activity) ────────────────────
-- Identifies users most in need of a re-engagement campaign
SELECT
    user_id,
    plan_type,
    platform,
    days_active,
    last_active_date
FROM churn_summary
WHERE churned = 1
  AND plan_type = 'Free'
  AND days_active <= 3
ORDER BY last_active_date ASC
LIMIT 20;


-- ── 10. Platform × Plan Churn Breakdown ──────────────────────────────────────
SELECT
    platform,
    plan_type,
    COUNT(*)                                       AS total_users,
    SUM(churned)                                   AS churned_users,
    ROUND(100.0 * SUM(churned) / COUNT(*), 2)      AS churn_rate_pct
FROM churn_summary
GROUP BY platform, plan_type
ORDER BY churn_rate_pct DESC;
