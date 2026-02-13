# 📊 Measures & Calculations: Workplace Intelligence and HR Analysis

This documentation provides a comprehensive overview of all DAX measures. It is organized by functional area, providing the logic, strategic intent, and formatting for each calculation.

---

### 👥 Workforce Demographics & Baseline Metrics

* **Total Headcount**: Calculates the number of active employees at any point in time based on joining and exit dates.
    * **Formula**:
    ```dax
    Total Headcount = 
    CALCULATE(
        COUNTROWS(dim_employees),
        dim_employees[status] = "Active",
        -- Filter to ensure joining date is before or on the selected date
        dim_employees[joining_date] <= MAX('calendar'[Date]),
        -- Ensure the employee hasn't left yet, or left after the selected date
        (
            dim_employees[exit_date] > MAX('calendar'[Date]) || 
            ISBLANK(dim_employees[exit_date])
        )
    )
    ```
    
    
    * **Formatting**: `0`
* **Total Employees**: A cumulative count of all individuals who have ever joined up to the selected date.
    * **Formula**:
    ```dax
    Total Employees = 
    CALCULATE(
        COUNTROWS(dim_employees),
        dim_employees[joining_date] <= MAX('calendar'[Date])
    )
    ```
    
    
    * **Formatting**: `0`
* **Total Turnovers**: Counts employees who resigned, utilizing an inactive relationship for exit dates.
    * **Formula**:
    ```dax
    Total Turnovers = 
    CALCULATE(
        COUNTROWS(dim_employees),
        dim_employees[status] = "Resigned",
        dim_employees[joining_date] <= MAX('calendar'[Date]),
        -- Switch active relationship to use exit_date for calculation
        USERELATIONSHIP('calendar'[Date], dim_employees[exit_date])
    )
    ```
    
    
    * **Formatting**: `0`
* **Turnover Rate**: The percentage of turnovers relative to the total employee base.
    * **Formula**: `DIVIDE([Total Turnovers], [Total Employees], 0)`
    * **Formatting**: `0.00%`
* **Avg Tenure**: Average years of service for currently active employees.
    * **Formula**: `CALCULATE(AVERAGE(dim_employees[Tenure]), dim_employees[exit_date]=BLANK())`
    * **Formatting**: `General Number`
* **Avg Tenure(Leavers)**: Average years of service for employees who have exited.
    * **Formula**: `CALCULATE(AVERAGE(dim_employees[Tenure]), dim_employees[exit_date]<>BLANK())`
    * **Formatting**: `General Number`
* **Diversity Ratio**: Tracks the representation of females in leadership roles (Job Level > 4).
    * **Formula**:
    ```dax
    Diversity Ratio = 
    VAR _div = CALCULATE([Total Headcount], dim_employees[job_level] > 4, dim_employees[gender] = "Female")
    VAR _total = CALCULATE([Total Headcount], dim_employees[job_level] > 4)
    RETURN 
        DIVIDE(_div, _total)
    ```
    
    
    * **Formatting**: `0.0%`
* **Cumulative Headcount**: Tracks workforce growth over time using the joining date relationship.
    * **Formula**:
    ```dax
    Cumulative Headcount = 
    CALCULATE(
        [Total Headcount],
        USERELATIONSHIP('calendar'[Date], dim_employees[joining_date]),
        dim_employees[joining_date] <= MAX('calendar'[Date])
    )
    ```
    
    
    * **Formatting**: `0`
* **Vs PY Headcount**: Measures Year-over-Year percentage change in headcount.
    * **Formula**:
    ```dax
    Vs PY Headcount = 
    VAR _current = [Total Headcount]
    VAR _pv = CALCULATE([Total Headcount], SAMEPERIODLASTYEAR('calendar'[Date]))
    RETURN 
        DIVIDE(_current - _pv, _pv)
    ```
    
    
    * **Formatting**: `0.00%`
* **Male Employees**: Headcount of male staff (formatted as negative for population pyramids).
    * **Formula**: `-CALCULATE([Total Headcount], dim_employees[gender]="Male")`
    * **Formatting**: `0`
* **Female Employees**: Headcount of female staff.
    * **Formula**: `CALCULATE([Total Headcount], dim_employees[gender]="Female")`
    * **Formatting**: `0`
* **Avg Joining Age**: The average age of employees at their time of hire.
    * **Formula**: `AVERAGE(dim_employees[Joining Age])`
    * **Formatting**: `General Number`

---

### 📢 Talent Acquisition & Pipeline Velocity

* **Total Hires**: The total number of successful recruitment completions.
    * **Formula**: `COUNT(fact_recruitment[employee_id])`
    * **Formatting**: `0`
* **Total Hires YTD**: Recruitment count from the start of the year to the current date.
    * **Formula**: `CALCULATE([Total Hires], DATESYTD('calendar'[Date]))`
    * **Formatting**: `0`
* **Avg Time-to-Fill**: Average days elapsed from job posting to filling the role.
    * **Formula**: `AVERAGE(fact_recruitment[Time-to-Fill])`
    * **Formatting**: `General Number`
* **Avg Time-to-Hire**: Average days from an applicant's first contact to hire.
    * **Formula**: `AVERAGE(fact_recruitment[Time-to-Hire])`
    * **Formatting**: `General Number`
* **Referral Conversion Rate**: Percentage of total hires that originated from employee referrals.
    * **Formula**:
    ```dax
    Referral Conversion Rate = 
    VAR _ref = CALCULATE([Total Hires], fact_recruitment[source] = "Employee Referral") 
    RETURN 
        DIVIDE(_ref, [Total Hires])
    ```
    
    
    * **Formatting**: `0.00%`
* **Total Vacancies**: Sum of open positions across all job postings.
    * **Formula**: `SUM(fact_job_postings[vacancies])`
    * **Formatting**: `0`
* **Total Applications**: Total count of candidates who applied for roles.
    * **Formula**: `SUM(fact_job_postings[applications])`
    * **Formatting**: `0`
* **Total Interviews**: Total count of interviews conducted.
    * **Formula**: `SUM(fact_job_postings[interviews])`
    * **Formatting**: `0`
* **Total Offers Sent**: Total number of employment offers extended to candidates.
    * **Formula**: `SUM(fact_job_postings[offers])`
    * **Formatting**: `0`
* **Offer Acceptance Rate**: Percentage of extended offers that resulted in a hire.
    * **Formula**: `DIVIDE([Total Hires], [Total Offers Sent])`
    * **Formatting**: `0.00%`
* **Unhired Applicants**: The difference between total applications and total hires.
    * **Formula**: `[Total Applications] - [Total Hires]`
    * **Formatting**: `0`

---

### 🚨 Attrition Dynamics & Retention Health

* **Avg Headcount**: The average workforce size used to standardize attrition rates.
    * **Formula**:
    ```dax
    Avg Headcount = 
    VAR PeriodStartDate = IF(ISFILTERED('calendar'[Date]), MIN('calendar'[Date]), DATE(2020,01,01))
    VAR PeriodEndDate = MAX('calendar'[Date]) 
    VAR HeadcountStart = 
        CALCULATE(
            COUNTROWS(dim_employees),
            dim_employees[joining_date] <= PeriodStartDate,
            (dim_employees[exit_date] > PeriodStartDate || ISBLANK(dim_employees[exit_date]))
        )
    VAR HeadcountEnd = 
        CALCULATE(
            COUNTROWS(dim_employees),
            dim_employees[joining_date] <= PeriodEndDate,
            (dim_employees[exit_date] > PeriodEndDate || ISBLANK(dim_employees[exit_date]))
        )
    RETURN 
        DIVIDE(HeadcountStart + HeadcountEnd, 2)
    ```
    
    
    * **Formatting**: `General Number`
* **Attrition Count**: Resignations that occurred within the specific selected period.
    * **Formula**:
    ```dax
    Attrition Count = 
    VAR PeriodStartDate = IF(ISFILTERED('calendar'[Date]), MIN('calendar'[Date]), DATE(2020,01,01))
    VAR PeriodEndDate = MAX('calendar'[Date]) 
    RETURN 
        CALCULATE(
            COUNTROWS(dim_employees),
            dim_employees[status] = "Resigned",
            USERELATIONSHIP(dim_employees[exit_date], 'calendar'[Date]),
            dim_employees[exit_date] > PeriodStartDate && 
            dim_employees[exit_date] < PeriodEndDate
        )
    ```
    
    
    * **Formatting**: `0`
* **Attrition Rate YTD**: Annualized attrition rate for the current calendar year.
    * **Formula**: `DIVIDE(CALCULATE([Attrition Count], DATESYTD('calendar'[Date])), [Avg Headcount])`
    * **Formatting**: `0.00%`
* **Predictive Attrition Risk**: Headcount of active employees with survey scores indicating dissatisfaction.
    * **Formula**: `CALCULATE([Total Headcount], dim_employees[Latest Survey Score] < 6.5)`
    * **Formatting**: `0%`
* **Retention Rate**: The inverse of the attrition rate.
    * **Formula**: `1 - [Attrition Rate YTD]`
    * **Formatting**: `0.00%`
* **Flight Risk Count**: Identifies high-value employees showing a combination of burnout and stagnation.
    * **Formula**:
    ```dax
    Flight Risk Count = 
    VAR SelectedDate = MAX('calendar'[Date]) 
    RETURN 
    COUNTROWS(
        FILTER(
            dim_employees,
            dim_employees[status] = "Active" &&
            -- Logic A: Identify High Performers
            VAR LatestRating = CALCULATE(MAX(fact_performance[rating]), fact_performance[year] = MAX(fact_performance[year]))
            -- Logic B: Low Engagement Score
            VAR LatestSurveyScore = CALCULATE(MAX(fact_survey[score]), TOPN(1, fact_survey, fact_survey[date], DESC))
            -- Logic C: Salary Stagnation (No hike > 2 years)
            VAR LastHikeDate = CALCULATE(MAX(fact_salary[effective_date]), fact_salary[effective_date] <= SelectedDate)
            VAR DaysSinceHike = DATEDIFF(LastHikeDate, SelectedDate, DAY)
            -- Logic D: Sick Leave frequency spike
            VAR SickDaysTaken = CALCULATE(SUM(fact_leave[days]), fact_leave[type] = "Sick Leave", fact_leave[status] = "Approved", DATESINPERIOD('calendar'[Date], SelectedDate, -1, YEAR))
    
            RETURN 
                LatestRating >= 4 && (LatestSurveyScore <= 6 || DaysSinceHike > 730 || SickDaysTaken > 5)
        )
    )
    ```
    
    
    * **Formatting**: `0`
* **Cumulative Attrition %**: Running total percentage of exits for Pareto analysis of reasons.
    * **Formula**:
    ```dax
    Cumulative Attrition % = 
    VAR CurrentExitCount = [Attrition Count] 
    VAR TotalExits = CALCULATE([Attrition Count], ALLSELECTED(dim_employees)) 
    VAR CumulativeSum = 
         SUMX(
             FILTER(
                 ALLSELECTED(dim_employees[exit_reason]), 
                 [Attrition Count] >= CurrentExitCount
             ), 
             [Attrition Count]
         ) 
    RETURN 
         DIVIDE(CumulativeSum, TotalExits)
    ```
    
    
    * **Formatting**: `0.00%`
* **Early Attrition**: Percentage of resignations that occurred within the first year of employment.
    * **Formula**: `DIVIDE(CALCULATE([Total Turnovers], dim_employees[Tenure] < 1), [Total Turnovers])`
    * **Formatting**: `0.00%`

---

### 📈 Performance & Promotions

* **Avg Rating**: The average performance rating across the selected employee group.
    * **Formula**: `AVERAGE(fact_performance[rating])`
    * **Formatting**: `General Number`
* **Avg Survey Score**: The average employee satisfaction score.
    * **Formula**: `AVERAGE(fact_survey[score])`
    * **Formatting**: `General Number`
* **Avg Survey Score (Active)**: Survey scores for current employees only.
    * **Formula**: `CALCULATE([Avg Survey Score], dim_employees[status]="Active")`
    * **Formatting**: `General Number`
* **Avg Survey Score Leavers**: Survey scores of employees prior to their resignation.
    * **Formula**: `CALCULATE([Avg Survey Score], dim_employees[status]="Resigned")`
    * **Formatting**: `General Number`
* **Avg Survey Score (Latest)**: Most recent survey rating per employee.
    * **Formula**: `AVERAGE(dim_employees[Latest Survey Score])`
    * **Formatting**: `0.00`
* **Total Promotions**: The total count of recorded promotion events.
    * **Formula**: `COUNTROWS(fact_promotions)`
    * **Formatting**: `0`
* **Promotion Rate**: The frequency of promotions relative to the total headcount.
    * **Formula**: `DIVIDE([Total Promotions], [Total Employees])`
    * **Formatting**: `0.00%`
* **Avg Time-to-Promotion**: Average tenure before an employee receives their first promotion.
    * **Formula**: `AVERAGE(dim_employees[Time-to-Promotion])`
    * **Formatting**: `General Number`
* **Salary Hike%**: Percentage increase between old and new salaries during promotions.
    * **Formula**:
    ```dax
    Salary Hike% = 
    VAR _old = SUM(fact_promotions[old_sal]) 
    VAR _new = SUM(fact_promotions[new_sal]) 
    RETURN 
        DIVIDE(_new - _old, _old)
    ```
    
    
    * **Formatting**: `0.00%`
* **Internal Mobility Count**: Total transfers and promotions within a period.
    * **Formula**:
    ```dax
    Internal Mobility Count = 
    VAR PeriodStartDate = IF(ISFILTERED('calendar'[Date]), MIN('calendar'[Date]), DATE(2020,01,01)) 
    VAR PeriodEndDate = MAX('calendar'[Date]) 
    RETURN 
        CALCULATE(
            COUNTROWS(fact_promotions), 
            fact_promotions[prom_date] < PeriodEndDate && 
            fact_promotions[prom_date] > PeriodStartDate
        )
    ```
    
    
    * **Formatting**: `0`
* **Internal Mobility Rate**: Mobility count relative to the average headcount.
    * **Formula**: `DIVIDE([Internal Mobility Count], [Avg Headcount])`
    * **Formatting**: `General Number`
* **Performance Label**: Categorical grouping based on average rating.
    * **Formula**:
    ```dax
    Performance Label = 
    VAR Rating = [Avg Rating] 
    RETURN 
        SWITCH(
            TRUE(), 
            Rating >= 4, "High", 
            Rating >= 3, "Moderate", 
            "Low"
        )
    ```
    
    
    * **Formatting**: `Text`
* **9-Box Category**: Maps talent into a 9-segment grid based on Performance and Potential labels.
    * **Formula**:
    ```dax
    9-Box Category = 
    VAR Perf = [Performance Label] 
    VAR Pot = [Potential Label] 
    RETURN 
    SWITCH( TRUE(),
        Pot = "High" && Perf = "High", "Future Leader",
        Pot = "High" && Perf = "Moderate", "Emerging Talent",
        Pot = "High" && Perf = "Low", "Rough Diamond",
        Pot = "Moderate" && Perf = "High", "High Impact Performer",
        Pot = "Moderate" && Perf = "Moderate", "Core Contributor",
        Pot = "Moderate" && Perf = "Low", "Inconsistent Player",
        Pot = "Low" && Perf = "High", "Trusted Specialist",
        Pot = "Low" && Perf = "Moderate", "Solid Citizen",
        Pot = "Low" && Perf = "Low", "Talent Risk",
        "Unclassified"
    ) & " " & [Total Headcount]
    ```
    
    
    * **Formatting**: `Text`
   ㅤㅤ
    <img width="706" height="402" alt="Image" src="https://github.com/user-attachments/assets/11b0e8be-16ad-432e-bc6f-c5e36bc92825" />

---

### 📅 Attendance & Leave

* **Absent Days**: Total count of daily attendance records marked as 'Absent'.
    * **Formula**: `CALCULATE(COUNTROWS('fact_attendance'), 'fact_attendance'[status] = "Absent")`
    * **Formatting**: `0`
* **Total WorkDays**: Total scheduled workdays, excluding weekends.
    * **Formula**: `CALCULATE(COUNTROWS('fact_attendance'), 'fact_attendance'[status] <> "Weekend")`
    * **Formatting**: `0`
* **Absenteeism Rate**: The ratio of absent days to total working days.
    * **Formula**: `DIVIDE([Absent Days], [Total WorkDays])`
    * **Formatting**: `0.00%`
* **Leave Count**: Total number of leave requests submitted.
    * **Formula**: `COUNTROWS(fact_leave)`
    * **Formatting**: `0`
* **Unscheduled Absence%**: Ratio of leave requests to total absent days.
    * **Formula**: `DIVIDE([Leave Count], [Absent Days])`
    * **Formatting**: `0.00%`
* **Leave Days**: Sum of days for all approved leave requests.
    * **Formula**: `CALCULATE(SUM('fact_leave'[days]), 'fact_leave'[status] = "Approved")`
    * **Formatting**: `0`
* **Total Leave Entitlement**: Theoretical maximum leave days based on a quota per employee.
    * **Formula**: `VAR AnnualQuota = 39 RETURN [Avg Headcount] * AnnualQuota`
    * **Formatting**: `General Number`
* **Leave Utilization Rate**: Percentage of the leave quota actually used.
    * **Formula**: `DIVIDE([Leave Days], [Total Leave Entitlement])`
    * **Formatting**: `0.00%`
* **Leave Rejection Rate**: Percentage of leave requests that were denied.
    * **Formula**:
    ```dax
    Leave Rejection Rate = 
    VAR _rej =
        CALCULATE(
            COUNTROWS(fact_leave), 
            fact_leave[status]="Rejected"
        )
    VAR _total = COUNTROWS(fact_leave)
    RETURN 
        DIVIDE(_rej, _total)
    ```
    * **Formatting**: `0.00%`
* **Avg Leave per Employee**: Average number of approved leave days taken per staff member.
    * **Formula**: `DIVIDE([Leave Days], [Total Employees])`
    * **Formatting**: `General Number`
* **Sick Leaves**: Total approved leave days classified specifically as 'Sick Leave'.
    * **Formula**: `CALCULATE([Leave Days], fact_leave[type]="Sick Leave")`
    * **Formatting**: `0`
* **Sick Leave Frequency**: Ratio of sick leaves to total employees.
    * **Formula**: `DIVIDE([Sick Leaves], [Total Employees])`
    * **Formatting**: `General Number`
* **Present Days**: Total daily records marked as 'Present'.
    * **Formula**: `CALCULATE(COUNTROWS('fact_attendance'), 'fact_attendance'[status] = "Present")`
    * **Formatting**: `0`
* **WFH Days**: Total daily records marked as 'Work From Home'.
    * **Formula**: `CALCULATE(COUNTROWS(fact_attendance), fact_attendance[status]="WFH")`
    * **Formatting**: `0`
* **R**: Count of rejected leave applications.
    * **Formula**: `CALCULATE(COUNTROWS(fact_leave), fact_leave[status]="Rejected")`
    * **Formatting**: `0`
* **Pandemic WFH Impact**: Percentage of workdays conducted via WFH.
    * **Formula**:
    ```dax
    Pandemic WFH Impact = 
    VAR _wfh = CALCULATE(COUNTROWS(fact_attendance), fact_attendance[status] = "WFH") 
    RETURN 
        DIVIDE(_wfh, [Total WorkDays])
    ```
    
    
    * **Formatting**: `0.00%`

---

### 🎓 Training Programs 

* **Avg Training Score**: The average score achieved in training assessments.
    * **Formula**: `AVERAGE(fact_training[score])`
    * **Formatting**: `General Number`
* **Total Training Participants**: Total count of unique training enrollments.
    * **Formula**: `COUNTROWS(fact_training)`
    * **Formatting**: `0`
* **Training Completion Rate**: Percentage of training enrollments marked as 'Completed'.
    * **Formula**: `VAR _com = CALCULATE([Total Training Participants], fact_training[status]="Completed") RETURN DIVIDE(_com, [Total Training Participants])`
    * **Formatting**: `0.00%`
* **Total Training Cost**: Sum of expenses for all training programs.
    * **Formula**: `SUM(fact_training[cost])`
    * **Formatting**: `0`
* **Avg Training Cost (per emp)**: Total training expenditure relative to total headcount.
    * **Formula**: `DIVIDE([Total Training Cost], [Total Employees])`
    * **Formatting**: `General Number`
* **Compliance Adherence**: Tracks completion for specific mandatory regulatory programs (ID 102/103).
    * **Formula**:
    ```dax
    Compliance Adherence = 
    VAR _com = 
        CALCULATE(
            DISTINCTCOUNT(fact_training[employee_id]), 
            fact_training[program_id] IN {102,103}
        )
    RETURN 
        DIVIDE(_com, [Total Employees])
    ```
    * **Formatting**: `0.00%`
* **Avg Onboarding Days**: Average duration of the onboarding process for new hires.
    * **Formula**: `AVERAGE(dim_employees[Onboarding Days])`
    * **Formatting**: `General Number`
* **Avg Performance Uplift**: Compares performance ratings before and after a training date to measure ROI.
    * **Formula**:
    ```dax
    Avg Performance Uplift = 
    AVERAGEX(
        SUMMARIZE('fact_training', 'fact_training'[employee_id], 'fact_training'[training_date]),
        VAR CurrentEmp = 'fact_training'[employee_id]
        VAR TrainDate = 'fact_training'[training_date]
        -- Rating Before
        VAR RatingBefore = CALCULATE(AVERAGE('fact_performance'[rating]), 'fact_performance'[employee_id] = CurrentEmp, 'fact_performance'[review_date] < TrainDate, REMOVEFILTERS('calendar'))
        -- Rating After
        VAR RatingAfter = CALCULATE(AVERAGE('fact_performance'[rating]), 'fact_performance'[employee_id] = CurrentEmp, 'fact_performance'[review_date] >= TrainDate, REMOVEFILTERS('calendar'))
        RETURN 
            IF(NOT ISBLANK(RatingBefore) && NOT ISBLANK(RatingAfter), RatingAfter - RatingBefore, 0)
    )
    ```
    
    
    * **Formatting**: `0.00%`

---

### 💰 Salary & Pay Equity

* **Total Payroll Cost**: Dynamically calculates total salary liability for active staff at the report date.
    * **Formula**:
    ```dax
    Total Payroll Cost = 
    VAR PeriodEndDate = MAX('calendar'[Date]) 
    RETURN 
    SUMX(
        FILTER(
            dim_employees,
            dim_employees[joining_date] <= PeriodEndDate && 
            (ISBLANK(dim_employees[exit_date]) || dim_employees[exit_date] > PeriodEndDate)
        ),
        VAR LatestSalaryDate = CALCULATE(MAX(fact_salary[effective_date]), fact_salary[effective_date] <= PeriodEndDate) 
        RETURN 
            CALCULATE(MAX(fact_salary[salary]), fact_salary[effective_date] = LatestSalaryDate) 
    )
    ```
    
    
    * **Formatting**: `#,0"৳";-#,0"৳";#,0"৳"`
* **Average Salary**: Total payroll cost divided by the current active headcount.
    * **Formula**: `DIVIDE([Total Payroll Cost], [Total Headcount])`
    * **Formatting**: `#,0.00"৳";-#,0.00"৳";#,0.00"৳"`
* **Avg Salary Band Penetration**: Measures where an employee's pay sits relative to their role's Min/Max pay bracket.
    * **Formula**:
    ```dax
    Avg Salary Band Penetration = 
    VAR PeriodEndDate = MAX('calendar'[Date]) 
    RETURN 
    AVERAGEX(
        FILTER(dim_employees, dim_employees[joining_date] <= PeriodEndDate && (ISBLANK(dim_employees[exit_date]) || dim_employees[exit_date] > PeriodEndDate)),
        VAR LatestSalaryDate = CALCULATE(MAX(fact_salary[effective_date]), fact_salary[effective_date] <= PeriodEndDate) 
        VAR CurrentSal = CALCULATE(MAX(fact_salary[salary]), fact_salary[effective_date] = LatestSalaryDate) 
        VAR JobMin = RELATED(dim_jobs[min_salary]) 
        VAR JobMax = RELATED(dim_jobs[max_salary]) 
        RETURN 
            DIVIDE(CurrentSal - JobMin, JobMax - JobMin) 
    )
    ```
    
    
    * **Formatting**: `0.00%`
* **Male**: Salary penetration for male employees.
    * **Formula**: `CALCULATE([Avg Salary Band Penetration], dim_employees[gender]="Male")`
    * **Formatting**: `0.00%`
* **Female**: Salary penetration for female employees.
    * **Formula**: `CALCULATE([Avg Salary Band Penetration], dim_employees[gender]="Female")`
    * **Formatting**: `0.00%`
* **Pay Equity Gap**: The variance in salary band penetration between male and female staff.
    * **Formula**: `[Male] - [Female]`
    * **Formatting**: `0.00%`
* **Potential Label**: Categorical grouping of "Potential" based on salary penetration (Lower penetration = higher growth room).
    * **Formula**:
    ```dax
    Potential Label = 
    VAR Penetration = [Avg Salary Band Penetration] 
    RETURN 
        SWITCH(
            TRUE(), 
            Penetration <= 0.40, "High", 
            Penetration <= 0.70, "Moderate", 
            "Low"
        )
    ```
    
    
    * **Formatting**: `Text`

---

**🧠 Explanation of Complex Logics**

**Flight Risk Analysis**: The `Flight Risk Count` uses a multi-variant filter context. It doesn't just look for low performers; it specifically flags high-value talent (Rating >= 4) who show objective symptoms of "disengagement" (low survey scores) or "burnout" (sick leave spikes), allowing HR to move from reactive exits to proactive stay-interviews.

**Dynamic Payroll Snapshots**: The `Total Payroll Cost` measure addresses the common challenge of fluctuating salaries. By using `SUMX` combined with a salary effective date filter, it accurately reconstructs the organization's financial liability at any historical point, accounting for raises and promotions that occurred mid-year.

**Talent Mapping (9-Box)**: The `9-Box Category` logic bridges the gap between financial data and HR performance labels. By using Salary Penetration as a proxy for "Potential" (under the assumption that those with high performance but low salary penetration have the most room for upward mobility), it automates a traditionally manual and subjective talent review process.
