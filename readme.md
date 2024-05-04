## Overview:
This repository contains scripts and tools developed to analyze and reconcile data for a Finmid business challenge. The scripts are organized into two main folders: `eda_scripts` and `tasks_sql_scripts`. 
Each folder contains scripts designed to address different aspects of the challenge in addition to performing some data restructuring during exploration. Below is a detailed breakdown of the contents and their purposes.

### Challenge Initiation:
1. Docker compose file was executed to set up the environment.
2. Connected to the Postgres instance using DBeaver.
3. Created exploratory data analysis (EDA) scripts to facilitate analysis, plesae run these scripts first (except the python script) to be able to run the tasks solution.
4. SQL scripts solving the tasks should run easily once step 3 is done successful.
5. Used Google Sheets and Looker for visualization, links are provided in txt file.

## EDA Scripts

a. `bank_partner_export`

#### Description: 
SQL script to create a table in Postgres for loading the bank export CSV data for analysis against Postgres data.

b. `exchange_rate_modified_view`

#### Description: 
SQL script to create a view adjusting the exchange rate table. This script adds exchange rates for 2024 to resolve null values for 2024-01-01. Values for this date are carried forward from 2023-12-31, ensuring a consistent calendar year of exchange rates. 
> This process can be automated to maintain a full calendar year of exchange rates even if no transactions occurred on certain dates.

c. `postgres_data_view`

#### Description: 
SQL script creating a view for Postgres data in the same data structure as the bank export. This facilitates ease of analysis and comparison.

d. `line_items_flattened`

#### Description: 
SQL script creating a view for the line items table while flattening the JSONB for easier analysis, particularly when performing transaction basket analysis.

e. `reconciliation_transactions`

#### Description:
 
> Python script to perform reconciliation checks for missing transactions. This script identifies discrepancies greater than the cumulative sum amount of item prices. 
For example, one case with date = `2023-06-01` and currency = `GBP` where the discrepancy = `1006.220`. 
> In real-life scenarios, more extensive logging of metadata would be needed for better transaction reconciliation, including the type of transaction and reasons for discrepancies (e.g., coupon code applied).

## SQL Scripts

a. `monthly_revenue_per_customer_in_euros`

#### Description: 
SQL script to calculate monthly revenue per customer in euros.

b. `transaction_basket_analysis`

#### Description: 
SQL script to calculate monthly transaction analysis for customers, including the number of transactions and their total value in euros.

c. `mismatches_and_missing_transactions_from_bank_data`

#### Description:
1. SQL script to calculate the cumulative sum for each date and each currency to identify transactions missing from bank data.
2. SQL script to fetch mismatches between Postgres data and bank data and determine discrepancies.
