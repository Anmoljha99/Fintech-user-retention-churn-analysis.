# CODE
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the data
users = pd.read_csv("users.csv", parse_dates=["signup_date"])
activity = pd.read_csv("user_activity.csv", parse_dates=["activity_date"])
churn = pd.read_csv("churn_summary.csv", parse_dates=["signup_date"])

# Set plot style
sns.set(style="whitegrid")

# 1. Daily Active Users (DAU)
dau = activity.groupby("activity_date")["user_id"].nunique().reset_index(name="DAU")

plt.figure(figsize=(10, 4))
sns.lineplot(data=dau, x="activity_date", y="DAU", marker="o")
plt.title(" Daily Active Users (DAU)")
plt.xlabel("Date")
plt.ylabel("Unique Users")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
plt.savefig("dau_plot.png")
plt.close()

# 2. Churn Rate by Platform
platform_churn = churn.groupby("platform")["churned"].mean().reset_index(name="churn_rate")

plt.figure(figsize=(6, 4))
sns.barplot(data=platform_churn, x="platform", y="churn_rate")
plt.title("Churn Rate by Platform")
plt.ylabel("Churn Rate")
plt.ylim(0, 1)
plt.tight_layout()
plt.show()
plt.savefig("churn_by_platform.png")
plt.close()

# --- 3. Retention Curve (Days Since Signup) ---
# Merge signup date into activity log
activity = activity.merge(users[["user_id", "signup_date"]], on="user_id")
activity["day_since_signup"] = (activity["activity_date"] - activity["signup_date"]).dt.days
activity = activity[activity["day_since_signup"] >= 0]

retention = (
    activity.groupby("day_since_signup")["user_id"]
    .nunique().reset_index(name="retention_count")
)
retention["retention_rate"] = retention["retention_count"] / users.shape[0]

plt.figure(figsize=(8, 4))
sns.lineplot(data=retention, x="day_since_signup", y="retention_rate", marker="o")
plt.title("User Retention Curve (Day Since Signup)")
plt.xlabel("Day Since Signup")
plt.ylabel("Retention Rate")
plt.ylim(0, 1)
plt.tight_layout()
plt.show()
plt.savefig("retention_curve.png")
plt.close()

print("Analysis complete. Charts saved as PNG.")
