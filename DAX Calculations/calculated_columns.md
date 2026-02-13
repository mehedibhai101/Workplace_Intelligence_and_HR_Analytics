# 📊 Calculated Tables & Columns: Workplace Intelligence and HR Analysis

This documentation provides a comprehensive overview of all DAX calculated tables and columns. It is organized by their location in the data model, providing the logic, strategic intent, and analytical purpose for each calculation.

---

### Calculated Tables

* **🎯 Recruitment Funnel**: Creates a dedicated table for funnel visualization by pairing stage names with their respective measures and a sort order.
    * **Formula**:
    ```dax
    Recruitment Funnel = 
    {
        ("Total Applications", [Total Applications], 1),
        ("Total Interviews", [Total Interviews], 2),
        ("Total Offers Sent", [Total Offers Sent], 3),
        ("Total Hires", [Total Hires], 4)
    }
    ```



---

### Calculated Columns: dim_employees

* **📅 Tenure**: Calculates the length of service in years. If the employee is still active, it defaults to the end of the 2023 fiscal year.
  * **Formula**:
    ```dax
    Tenure = 
    DATEDIFF(
        dim_employees[joining_date],
        IF(
            dim_employees[exit_date] <> BLANK(), 
            dim_employees[exit_date], 
            DATE(2023, 12, 31)
        ),
        DAY
    ) / 365
    ```


* **🤝 Latest Survey Score**: Captures the most recent sentiment score provided by the employee from the survey fact table.
    * **Formula**:
    ```dax
    Latest Survey Score = 
    VAR LastSurveyDate = CALCULATE(MAX(fact_survey[date])) 
    RETURN 
        CALCULATE(
            MAX(fact_survey[score]), 
            fact_survey[date] = LastSurveyDate 
        )
    ```


* ** Time-to-Promotion**: Measures the duration (in years) between an employee's joining date and their most recent promotion.
    * **Formula**:
    ```dax
    Time-to-Promotion = 
    DATEDIFF(
        dim_employees[joining_date],
        MAXX(RELATEDTABLE(fact_promotions), fact_promotions[prom_date]), 
        DAY
    ) / 365
    ```


* **⚡ Onboarding Days**: Calculates the gap between the joining date and the completion of the mandatory "Orientation" program (ID 101).
    * **Formula**:
    ```dax
    Onboarding Days = 
    DATEDIFF(
        dim_employees[joining_date],
        LOOKUPVALUE(
            fact_training[training_date], 
            fact_training[employee_id], dim_employees[employee_id], 
            fact_training[program_id], 101
        ), 
        DAY
    )
    ```


* **🎯 Potential**: Converts the "Potential Label" into a numeric scale (1-3) for matrix ranking and 9-box positioning.
    * **Formula**:
    ```dax
    Potential = 
    SWITCH(TRUE(), 
        [Potential Label] = "High", 3, 
        [Potential Label] = "Moderate", 2,
        [Potential Label] = "Low", 1, 
        0
    )
    ```


* **🌟 Performance**: Converts the "Performance Label" into a numeric scale (1-3) for quantitative assessment.
    * **Formula**:
    ```dax
    Performance = 
    SWITCH(TRUE(), 
        [Performance Label] = "High", 3, 
        [Performance Label] = "Moderate", 2,
        [Performance Label] = "Low", 1, 
        0
    )
    ```


* **🎂 Joining Age**: Determines how old the employee was on the day they were hired.
    * **Formula**:
    ```dax
    Joining Age = 
    DATEDIFF(
        dim_employees[dob],
        dim_employees[joining_date], 
        YEAR
    )
    ```


* **💵 Compa Ratio**: A row-level calculation of the salary band penetration, used for individual pay equity analysis.
    * **Formula**: `CALCULATE([Avg Salary Band Penetration])`

---

### Calculated Columns: Fact Tables

* **review_date (fact_performance)**: Normalizes annual performance reviews to the end of their respective calendar year for time-series alignment.
    * **Formula**: `DATE(fact_performance[year], 12, 31)`
* **Time-to-Fill (fact_recruitment)**: Measures the speed of the sourcing phase (from posting to application).
    * **Formula**:
    ```dax
    Time-to-Fill = 
    DATEDIFF(
        fact_recruitment[posting_date],
        fact_recruitment[apply_date], 
        DAY
    )
    ```


* **Time-to-Hire (fact_recruitment)**: Measures the speed of the selection phase (from application to joining).
    * **Formula**:
    ```dax
    Time-to-Hire = 
    DATEDIFF(
        fact_recruitment[apply_date],
        fact_recruitment[joining_date], 
        DAY
    )
    ```


* **Absent Days (calendar)**: Contextualizes the calendar table by flagging the total absenteeism volume per date.
    * **Formula**: `CALCULATE([Absent Days])`

---

**🧠 Explanation of Complex Logics**

**Lifecycle Event Tracking**: Columns like `Onboarding Days` and `Time-to-Promotion` are strategic because they transform static dates into "Duration" metrics. This allows HR to identify bottlenecks in the employee experience—for example, spotting if onboarding takes significantly longer in specific departments.

**Numeric Mapping for Visuals**: The `Potential` and `Performance` columns are essential for the 9-Box grid. By converting text labels into integers (1, 2, 3), we enable Power BI to plot employees on a scatter chart or a heat map where the X and Y axes represent these specific numeric ranks.

**Normalized Performance Timelines**: In the `fact_performance` table, using a calculated `review_date` ensures that performance data can "talk" to the central Calendar table. Without this, annual ratings would exist in a vacuum; with it, we can correlate year-end performance with monthly survey trends or salary hikes.
