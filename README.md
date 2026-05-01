# 🛍️ Retail Data Warehouse & BI Analytics Project

## 📌 Overview

This project simulates a global retail business operating across multiple countries, selling consumer electronics through both physical stores and an online channel. The focus of this project is to transform raw transactional data into meaningful business insights.

It follows a structured approach:

- **Data ingestion (staging)**
- **Data modeling (warehouse – star schema)**
- **Analytical querying (SQL)**
- **Visualization (Power BI dashboards)**

---

## 🎯 Business Objective

The objective is to explore the dataset with the aim of uncovering patterns, performance trends, and potential areas of concern across four key areas:

1. **Revenue & Financial Performance**
2. **Product Performance**
3. **Customer Behavior**
4. **Store & Channel Performance**

However, raw transactional data alone does not provide clear answers. It requires proper structuring, transformation, and modeling to support decision-making.

---
## 🏗️ Data Architecture

### 1. Staging Layer (Data ingestion)
Raw CSV data was loaded into staging tables without transformation to preserve the original source data and document data quality issues before cleaning.

###  2. Warehouse Layer (Data modeling - Star Schema)

A structured warehouse was created with:

| Table | Type | Description |
|---|---|---|
| `fact_sales` | Fact | Transactional data with pre-computed financial metrics |
| `dim_date` | Dimension | Calendar table covering 2015 – 2020 |
| `dim_customer` | Dimension | Customer demographics and segmentation |
| `dim_product` | Dimension | Product catalog with pricing |
| `dim_store` | Dimension | Physical stores and online channel |
| `dim_exchange_rate` | Dimension | Daily currency exchange rates |


This design ensures:
- Scalability  
- Query performance  
- Clean separation of concerns  

---
### 3. Views Layer
A base view vw_sales_base performs a single master JOIN across all warehouse tables. Four analytical views are built on top of it; one per dashboard domain, so JOIN logic is written once and maintained in a single place.

## 📊 Analytical Approach

SQL views were created to answer specific business questions across each domain:

- Revenue Analysis  
- Product Analysis  
- Customer Analysis  
- Store Analysis  

Power BI was connected directly to the warehouse tables using a star schema model and not the views.

***The diagram below shows the star schema relationships between the fact table and all five dimension***

![Entity Relationship Diagram](2_sql%20script/ERD.gif)
---

## Analysis Scope

All dashboards and analysis are scoped to:

> **2016 – 2020**

This ensures:
- Consistency across SQL and Power BI  
- Avoid partial year distortion from the incomplete 2021 data (January - February only) 
- Accurate time-based calculations.

---

# 📈 INSIGHTS

## 1. Revenue & Financial Performance

### Business Questions
- What is total revenue, cost, and profit by year?
- Is the business growing year-over-year?
- What are the monthly trends?

#### **YoY Growth (2016 – 2020)**

![YoY Financial Performance](3_powerbi/Image/YoY%20Growth%20Analysis.png)

#### **Is the Business Growing Year-over-Year?**
 
- The business grew consistently from 2016 to 2019, with 2019 being the peak year at $18.3M revenue and 9.1K orders.
- Growth was particularly strong in 2018 at +72.3% YoY. However revenue declined sharply by 49.1% in 2020, dropping to $9.3M.
- Despite the revenue fluctuations, profit margin remained stable at 58.4 - 59.1% across all years, indicating consistent cost control regardless of revenue volume.

!['Revenue Performance Dashboard'](3_powerbi/Image/1_revenue_dashboard.gif)

#### Monthly Revenue Trends
 
- **December is consistently the strongest month**, reaching up to ~$2.5M (2019), which is a clear year-end seasonality.
- **February acts as a consistent early-year peak** before decline in April.
- **April is the weakest month across all years,**, with revenue dropping close to zero each time regardless of overall revenue scale.
- **From May onwards, revenue typically recovers and stabilises** through mid-year before year-end surge.
- **2020 Exception** 
  - Unlike previous years, **2020 did not recover after April**
  - Revenue remained suppressed from **March - November**, with only a modest uptick in December.

### Insights
- Business follows a predictable seasonal cycle (Feb peak → April dip → December surge)
- 2020 breaks this pattern, indicating a likely external disruption rather than internal seasonality.

### Recommendations
- The recurring April decline suggests a structural demand or operational issue that requires further investigation.
- Campaigns and inventory should be aligned to maximise the December peak.
- February shows a reliable early-year spike and can be leveraged with targeted promotions.
- 2020 anomaly needs to be investigated separately to understand external impact and improve resilience

---

## 2. Product Performance Analysis

### Business Questions
- What are the top 10 products by revenue?
- How do products rank within their categories?
- Which categories contribute most to revenue?
- Which products have never been sold?

![Product Performance](3_powerbi/Image/2_Product%20dashboard.gif)
 
#### Top Product Trends
- Top products are dominated by a few brands: Adventure Works, Wide World Importers, and Contoso.
- In 2016, TV & Video and Home Appliances categories dominated the top 10 product.
- By 2017 - 2020, Computers category dominated the top 10, occupying all top 10 positions in 2020
- Proseware Projector (2020) emerged as a new #1 product, signaling a possible shift in demand

**Insight:** Business performance is driven by a small number of high-performing products.
 
####  Key Insights
- **Computers dominate and continue to grow consistently**, increasing from 21.6% to 39.4% of total revenue.
- **Home Appliances and TV & Video declined significantly**, dropping from 28.9% → 11.9% and 18.2% → 9.5% respectively over 5 years.
- **Cell phones grow over the years** from 6.2% → 13.5%, making it the second overall dominating category.
- **Games & Toys remain niche**, contributing <2% despite gradual growth.

#### Unsold & Underperforming Products
- 26 products recorded zero sales across the entire 5 years, representing true dead stock with zero revenue.
- Yearly inactive products ranged 229–585, improving until 2019 before rising again in 2020.

**Insight**:
- Persistent inventory inefficiency.
- 2020 decline impacted product activity significantly.

### Recommendations
- The Computers category should remain the primary focus given its consistent growth and dominance.
- The continued decline in Home Appliances suggests a need to reassess its relevance and positioning.
- Emerging products such as the Proseware Projector indicate potential shifts in demand and warrant closer monitoring.
- The presence of unsold products highlights inefficiencies in inventory management and the need for clearance or discontinuation strategies.
- Underperforming products may require pricing or positioning adjustments to improve performance.

---

## 3. Customer Performance Analysis

### Business Questions
- Who are the most valuable customers?
- How are customers segmented (Low / Mid / High value)?
- What is the churn rate by cohort?
- How do cohorts contribute to revenue over time?
- Which customers are inactive?

![Customers Performance](3_powerbi/Image/3_Customer%20dashboard.gif)
 
 
#### Customer Segmentation (LTV-Based)
- Segmentation is based on global lifetime value (not year-specific)
- Customers remain in the same segment across all years. This enables consistent comparison across time and avoids misleading reclassification.

**Insights**
- Customer base grew steadily from 3K (2016) → 6K (2019) before dropping in 2020.
- High-value customers (~3K) contribute a disproportionate share of total revenue
- Mid-value segment (5.9K) is the largest and represents the core customer base
- Revenue is driven by a relatively small high-value segment of customers.

 
#### Churn & Retention
 - Churn exceeds active customers across all cohorts
 - Largest churn observed in 2018 - 2019 cohorts (highest acquisition years)

**Insight**: Growth is acquisition-driven rather than retention-driven, indicating a structural retention issue.
 
#### How Cohorts Contribute to Revenue Over Time
- Early cohorts (e.g., 2016) continue contributing ~18 - 22% annually.
- By 2019 - 2020, returning customers drive the majority of revenue

**Insights**:
- Strong long-term value from early customers.
- Business relies heavily on repeat purchases
 
#### Inactive Customers

- 3K customers (20%) never made a purchase.
- Represents a significant untapped revenue opportunity

#### Geographical Highlights
- United States dominates: ~$29M LTV (~50% of total)
- Australia has the highest inactivity rate (~85%)
- France shows weaker retention, with declining cohort contribution over time.

**Insight**: Customer quality and engagement vary significantly by market.
 
### Recommendations
- High churn across all cohorts indicates the need for stronger retention strategies.
- High Value customers should be prioritised through loyalty and personalised engagement.
- The 20% inactive customer base presents a clear re-engagement opportunity.
- Low-retention markets such as France require targeted performance improvement.
- High-value markets like the U.S. should remain a focus for scalable acquisition.

---

## 4. Store & Channel Performance

### Business Questions
- Which countries show the highest YoY growth?
- Which stores are most efficient?
- Which stores have no sales?
- How do online vs physical stores compare?

![Store Performance](3_powerbi/Image/4_Store%20dashboard.gif)

#### Stores Efficiency (Revenue per Sqm)

- Average revenue per sqm improved significantly from $62 → $155 (2016–2019) → 2.5x growth
- Dropped to $78 in 2020 mirroring revenue decline.
- US stores consistently outperform, generating the highest revenue regardless of size
- Australia stores underperform, with lower revenue across smaller footprints

**Insight**: Store performance varies significantly by region, with clear efficiency leaders and laggards
 
#### Underperforming Stores
 
- 9 stores recorded zero sales across all 5 years.
- Additional 10–14 stores inactive in specific years

**Insight**: Persistent operational inefficiencies and potential cost leakage
 
#### Channel Performance (Online vs Physical)
 
- Physical stores generate the vast majority of revenue across all years.
- The online channel grew modestly from 17% in 2016 to 22% in 2020; a notable increase in share but not a structural shift.

**Insight**: Physical stores remain the primary revenue driver throughout the entire period.
 
### Recommendations
- The 9 inactive stores indicate a clear operational inefficiency and should be reviewed for closure or repositioning.
- Physical stores remain the primary revenue driver and should continue to be prioritised.
- Online channel, despite its current smaller share needs to be treated as a strategic investment area, not just a supporting channel.
- High-performing markets such as the US should remain a focus for physical store expansion and optimisation.
- Underperforming regions like Australia require targeted efficiency improvements to close the performance gap.

---

## Key Analytical Decisions

- Star schema model used in Power BI with properly defined relationships (no reliance on flat views)
- Pre-computed financial metrics (revenue, cost, profit) stored at fact level following dimensional modeling best practices
- Customer segmentation based on global LTV percentiles (P25/P75); fixed segments to ensure consistency across time
- 12-month churn window applied to reflect typical electronics purchase cycles
- 2021 data excluded due to incompleteness (only partial year available)
- Inactive customers treated as static KPI (no purchase history = not time-filterable)
- Revenue per sqm limited to physical stores
- Unsold products (26) and inactive stores (9) retained to highlight operational inefficiencies  

---

## Limitations & Data Considerations

- **Static Pricing:** Product prices remain constant across all years, resulting in an inflated and stable profit margin (~58.6%) compared to real-world electronics retail (~20–40%).

- **Unsold Products:** 26 products recorded zero sales across the full period. In reality, such items would typically be discontinued or discounted.

- **Inactive Stores:** 9 physical stores show no transactions, likely reflecting data gaps rather than actual long-term inactivity.

- **Limited Operational Context**: No data on promotions, discounts, or external events, which are key drivers of real-world sales performance. 

### Interpretation Note

This dataset reflects common constraints of publicly available data. While simplified, the analysis applies real-world data modeling and business intelligence techniques, ensuring insights remain directionally valid and practically relevant.

---
## ⚙️ Tools & Technologies
 
| Tool | Purpose |
|---|---|
| PostgreSQL | Data warehouse and SQL analysis |
| pgAdmin / DBeaver / VS Code | SQL development |
| Power BI Desktop | Data visualization |
| GitHub | Version control & portfolio |
 
### SQL Scripts
- [Staging Layers](2_sql%20script/1_Staging)
- [Data Warehouse](2_sql%20script/2_Warehouse)
- [Analysis Queries](2_sql%20script/3_Analysis)
---
 
## How to Run This Project
 
### Prerequisites
- PostgreSQL 13+
- pgAdmin, DBeaver, or VSCode (SQL extension)
- Power BI Desktop

### Steps
 
1. Clone this repository
```bash
git clone https://github.com/Abbie-oye/Retail_Data_Warehouse_BI_Analytics.git
```
 
2. Run SQL scripts in order:
```
01_database_setup.sql
02_staging_ddl.sql           ← update CSV file paths before running
03_data_profiling.sql
04_warehouse_ddl.sql
05_dim_transform.sql
06_fact_transform.sql
07_views.sql
08a_revenue_analysis.sql
08b_product_analysis.sql
08c_customer_analysis.sql
08d_store_analysis.sql
```
 
3. Update the CSV file paths in `02_staging_ddl.sql` to match your local file path:
```sql
FROM 'C:/your/path/to/Sales.csv'
```
 
4. Open Power BI file
- Open `3_powerbi\Dashboard.pbix` in Power BI Desktop
- Update the PostgreSQL connection to your local machine.
---
 
**Dataset source**: *Maven Analytics - Global Electronics Retailer*