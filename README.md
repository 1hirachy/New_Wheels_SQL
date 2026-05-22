# New Wheels Project

## 📌 Project Overview
New-Wheels is a vehicle resale company that recently launched an end-to-end app platform to list, sell, and ship pre-owned vehicles while capturing after-sales customer feedback. However, sales have been dipping steadily, and a drop in new customers has been observed quarter-over-quarter due to critical online feedback.

### 🎯 Objective
As the Data Analyst, the goal of this project is to analyze the database dump, track key performance indicators (KPIs), answer critical business operations questions, and compile a quarterly report for the CEO to drive strategic decision-making.

---


## 📊 Business Metrics Overview
The following high-level operational KPIs were calculated using targeted SQL queries:


| Total Revenue | Total Orders | Total Customers | Average Rating |
| :--- | :--- | :--- | :--- |
| 124,714,086.32 | 1,000 | 994 | 3.1350 |

| Last Quarter Revenue | Last quarter Orders | Average Days to Ship | % Good Feedback |
| :--- | :--- | :--- | :--- |
| 23,346,779.63 | 199 | 97.96 | 21.50 |


---

## 🔍 Key Insights & Observations

### 1. Operations & Shipping Crisis ⚠️
* **The Bottleneck:** The average shipping duration more than tripled over the year, escalating from **57 days in Q1 to 174 days in Q4**.
* **The Correlation:** This drastic logistical slowdown directly mirrors a crash in customer satisfaction. Average ratings dropped every single quarter (from **3.55 in Q1 down to 2.39 in Q4**).
* **Financial Impact:** Revenue plummeted alongside satisfaction, dropping from **$39M in Q1 to $23M in Q4** (a $16M quarterly turnover loss). Q4 saw a sharp **-20.18%** revenue decline.

### 2. Geographic Footprint 🗺️
* **Market Leaders:** California and Texas are core drivers with the highest customer reach, followed closely by Florida, New York, and the District of Columbia.
* **Low Penetration:** Wyoming, Vermont, Maine, Mississippi, and North Dakota represent cold markets with minimal footprints.

### 3. Inventory & Brand Preferences 🚗
* **Top Makers:** Chevrolet, Ford, Toyota, Dodge, and Pontiac are customer favorites. Chevrolet is the most dominant maker across the majority of states.

---

## 💡 Strategic Business Recommendations

1. **Urgently Overhaul Logistics:** Audit the end-to-end shipping pipeline immediately to reduce the 174-day Q4 average bottleneck. Implement order tracking transparency to rebuild customer trust.
2. **Strengthen After-Sales Support:** Q4 closed with roughly 48% negative feedback. Dedicate customer support teams to proactively handle post-sale follow-ups and mitigate customer churn risk entering the new year.
3. **Dynamic Pricing Segmentation:** Currently, discounts are uniform across all credit card types (averaging ~0.6%). Introduce targeted card rewards, loyalty cashbacks, or referral incentives to drive higher order volumes from high-value customers.
4. **Targeted Regional Campaigns:** Launch localized marketing and financing incentives in low-penetration states (WY, VT, ME, MS, ND) to expand geographic market share.

---

## 🛠️ SQL Scripts Included
The `SQL_Queries.sql` file contains solution queries covering:
* Customer distribution across states (`GROUP BY`, `COUNT DISTINCT`)
* Top preferred vehicle makers (`RANK() OVER (PARTITION BY...)`)
* Quarterly sentiment analytics (`CASE WHEN` conditional mapping)
* Quarter-over-Quarter revenue growth percentages (`LAG() Window Function`)
