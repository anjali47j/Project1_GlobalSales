# Project 1 – Global Sales & Profitability SQL Analysis

### 🎯 Objective
To analyze global sales transactions and uncover business insights 
for executives at financial/consulting firms (target: JPMorgan, Deloitte, EY, Barclays).

---

### 🛠️ Steps Performed
1. **Data Quality Checks**
   - Missing values
   - Profit vs Revenue validation
   - FX rate sanity checks

2. **KPI Analysis**
   - Total Sales, Profit, Margin %
   - Region-wise profitability
   - Incentive effectiveness

3. **Business Insights**
   - Top 10 low-margin clients (pricing opportunity)
   - Elasticity check: avg price vs. sales volume
   - Early warning system: MoM margin drop > 100 bps

---

### 📊 Key Metrics
- **Revenue** = SUM(revenue_usd)
- **Profit** = SUM(profit_usd)
- **Margin %** = Profit ÷ Revenue × 100
- **AOV (Average Order Value)** = Revenue ÷ Transactions

---

### ✅ Deliverables
- `project1_global_sales_analysis.sql` → SQL queries
- Clean dataset (optional) for demo
- Insights ready for Tableau/Power BI

---

### 📌 Next Step
This SQL project feeds into **Project 2** (Python EDA & Forecasting).
