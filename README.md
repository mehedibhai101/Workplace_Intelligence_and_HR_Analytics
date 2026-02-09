# Project Background: Workplace Intelligence at BanglaBazaar

BanglaBazaar.com is a leading e-commerce enterprise in Bangladesh, currently employing over **1,100 professionals** across diverse functions including Logistics, Technology, and Sales. As the company scales toward a potential IPO, the "Human Capital" element has shifted from a support function to a primary strategic lever.

This project focuses on **Workplace Intelligence**—moving beyond basic headcount reporting to understand the "Silent Attrition" and "Value Leakage" within the organization. While our overall turnover remains stable, we identified critical vulnerabilities in how we retain our most expensive and high-potential talent. This analysis serves as a roadmap for the Executive Leadership Team to transition from reactive hiring to a **Retention-First** talent strategy.

**DAX queries for HR metrics (Attrition, Comp-Ratio, etc.) can be found here [[Link to Script]](https://www.google.com/search?q=%23).**

**The Interactive People Analytics Dashboard can be found here [[Link to Dashboard]](https://www.google.com/search?q=%23).**

---

# Data Structure & Initial Checks

The HR Data Warehouse is built on a relational schema designed to track the entire employee lifecycle—from the initial job posting to the exit interview.

* **`dim_employees`:** A master table of 1,300+ current and former staff, including demographics, tenure, and education.
* **`fact_salary` & `fact_promotions`:** Chronological logs of every pay increase and level change, used to calculate internal pay equity.
* **`fact_performance` & `fact_survey`:** Integrated datasets linking annual performance ratings (1-5) with monthly employee engagement/NPS scores.
* **`fact_recruitment`:** Tracks sourcing channels (Bdjobs, LinkedIn, Referrals) and "Time-to-Hire" efficiency.

### HR Analytics Schema

---

# Executive Summary

### Overview of Findings

BanglaBazaar is a "Healthy Organization with a Pricing Problem." Our annual attrition rate is a manageable **5.07% - 6.9%**, significantly lower than the industry average. However, the data reveals a **"Value Retention" crisis**: we are losing mid-tenured, high-performing employees—our "Culture Carriers"—due to market-lagging compensation for legacy staff. Additionally, while we have strong female representation at the top, a **"Broken Rung"** exists at the Senior Manager level (Level 4), where female talent drops to 25%.

[**Visualization: Attrition vs. Performance - The "High Potential" Flight Risk**]

---

# Insights Deep Dive

### Category 1: The "Legacy Tax" & Compensation Misalignment

* **Tenure vs. Pay Paradox.** Data shows that tenured high performers (those with the company 3+ years) are often paid **15-20% less** than new external hires for the same roles. This "Legacy Tax" is the https://www.google.com/search?q=%231 driver of flight risk among our top 10% talent.
* **The "Better Salary" Trigger.** 62% of high-performing "Resigned" staff cited "Better Salary" as the primary reason, but cross-referencing with engagement surveys shows they only began looking for external roles *after* their 2-year anniversary without a market correction.
* **Payroll Concentration.** Our total monthly payroll cost of **51M BDT** is heavily weighted toward new hire acquisition rather than existing talent preservation.

[**Visualization: Comp-Ratio Distribution by Performance Rating & Tenure**]

### Category 2: The "Broken Rung" & Gender Diversity Pipeline

* **Leadership Paradox.** BanglaBazaar has achieved a total gender split of **57% Male / 43% Female**, with an impressive 53% female representation at the Director level (Level 5).
* **The Level 4 Bottleneck.** A critical drop-off occurs at the **Senior Manager (Level 4)** tier, where female representation plummets to **25%**.
* **Pipeline Leakage.** Exit data indicates that women at Level 3 are leaving at a 2x higher rate than their male counterparts, citing "Work-Life Balance" or "Growth Path" concerns, effectively starving the leadership pipeline.

[**Visualization: Gender Funnel by Job Level (Entry to Executive)**]

### Category 3: Recruitment Efficiency & Channel Risk

* **The Bdjobs Dependency.** **45% of our successful hires** originate from https://www.google.com/search?q=Bdjobs.com. While effective for volume, this creates a "Single Point of Failure" in our talent sourcing strategy.
* **LinkedIn vs. Referrals.** LinkedIn hires show the highest "Average Starting Salary" but also the **shortest average tenure (1.8 years)**, whereas Employee Referrals show a 30% higher retention rate over 3 years.
* **Recruitment ROI.** The cost-per-hire for technical roles via agencies is 4x higher than internal moves, yet our "Internal Fill Rate" for Senior Engineer roles is currently below 10%.

[**Visualization: Channel Effectiveness - Cost per Hire vs. Retention Rate**]

### Category 4: Operational Burnout & L&D ROI

* **Sales Burnout Hotspots.** "Work Pressure" is a localized exit reason, concentrated almost entirely (85%) within the **Sales & Marketing** department following the Q4 "Big Sale" period.
* **L&D Misallocation.** We are currently spending significant budget on "Compliance" training which has **0.0 correlation** with performance uplift. In contrast, "Technical Upskilling" shows a direct 0.4 correlation with improved performance ratings in the subsequent year.
* **Engagement & Productivity.** Teams with an Average Survey Score below **7.5** show a 15% lower efficiency in meeting logistics KPIs.

[**Visualization: Training Spend vs. Performance Rating Improvement**]

---

# Recommendations:

Based on the analysis, the following "Strategic Pillars" are recommended for the 2024-2025 fiscal year:

* **Surgical Market Correction:** Implement a **"Value Retention" fund** specifically for employees with 3+ years of tenure and a performance rating of 4 or 5. Adjust their salaries to the 60th percentile of the current market to preempt poaching.
* **The "Sponsorship" Program:** To fix the Level 4 Broken Rung, pair high-potential Level 3 women with Level 5 Directors for **active sponsorship** (not just mentorship). Aim to increase Level 4 female representation to 35% within 18 months.
* **Referral Diversification:** Launch a **"Referral Bonus" program** that pays 2x for "Hard-to-Fill" technical and senior roles. This reduces the Bdjobs/LinkedIn dependency and improves culture fit.
* **Q1 Decompression Policy:** Introduce a mandatory **"Sales Recharge" week** in January. Managers in Sales will be KPI’d on their team's leave utilization to prevent the post-Q4 burnout cycle.
* **Pivot to Technical L&D:** Redirect 20% of the Compliance training budget into **Technical & Leadership Academies**. This builds internal talent for Senior roles, reducing high external recruitment costs.

---

# Assumptions and Caveats:

* **Assumption 1:** Market salary benchmarks were estimated using current "New Hire" offer data as a proxy for the external market rate in Dhaka.
* **Assumption 2:** "Flight Risk" (currently 37 employees) was calculated using a weighted model of Tenure (>2 yrs), Last Promotion (>1.5 yrs), and Engagement Score (<7.0).
* **Assumption 3:** Survey scores are assumed to be anonymous and honest; however, "Neutral" scores (7/10) were treated as "Passive Risk" in the attrition model.
