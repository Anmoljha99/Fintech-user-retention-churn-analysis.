# FinTech User Retention & Churn Analysis

I built this to understand why users drop off in a FinTech app — and what the product team can do about it. The dataset simulates 1,000 users over 30 days, segmented by plan type (Free/Trial/Paid) and platform (iOS/Android).

**Tools:** Python (Pandas, Seaborn, Matplotlib) · SQL

---

## What I looked at

- Daily active users over the 30-day window
- Churn rate by platform and plan type
- How quickly users drop off after signup (retention curve)
- Which features are actually being used
- Average session time across plan types

---

## Key Findings

- Overall churn rate is ~55% — Free plan users churn the hardest (~65%)
- Paid users have the longest sessions and lowest churn, but they're only 15% of users
- The **Invest** feature is barely touched despite being core to the app
- Most drop-off happens in the first 7 days after signup

---

## Charts

**Daily Active Users**
![DAU]

**Churn by Platform**
[Churn by Platform]

**Churn by Plan Type**
[Churn by Plan]

**Retention Curve**
Retention Curve]

**Feature Usage**
[Feature Usage]

**Retained vs Churned by Plan**
[Retained vs Churned]

**Avg Session Duration by Plan**
[Session Duration]

---

## What I'd recommend to the product team

- Free users are churning fast — add onboarding nudges at Day 3 and Day 7 showing what they're missing
- Trial users fall off around Day 10 — a well-timed upgrade prompt here could move the needle
- Invest feature needs better discoverability — move it to the home screen or surface it in onboarding
- Android churn is slightly higher — worth digging into crash logs or UX friction specific to Android

---


---

Anmol Jha · [Portfolio](https://anmol-rust.vercel.app/) · [GitHub](https://github.com/Anmoljha99) · [LinkedIn](https://linkedin.com/in/anmol-jha99)
