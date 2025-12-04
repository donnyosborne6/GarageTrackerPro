# End-To-End Auto Shop Analytics Pipeline

## Overview
This repository showcases a complete data analytics pipeline and reporting solution for a hypothetical auto shop system using Excel as a UI, SQL Server as the processing engine, and Power BI for reporting. 

If you have any questions, feel free to contact me on [LinkedIn](https://www.linkedin.com/in/donny-osborne-559481350/)

## LinkedIn Image Samples:
- [Excel/VBA UI](https://media.licdn.com/dms/image/v2/D562DAQFPS3hlnJ3QwA/profile-treasury-image-shrink_8192_8192/B56ZgZiWa_HUAk-/0/1752775092757?e=1765494000&v=beta&t=q_GxZKAlyIssAdvwoJSaZoGO26G5DfN0x_26bk09qyU)
- [Power BI Summary Page](https://media.licdn.com/dms/image/v2/D562DAQFo_he3YWPRFw/profile-treasury-image-shrink_800_800/B56ZgZjMvoHMAc-/0/1752775314796?e=1765494000&v=beta&t=6y8pQgjP9e2pTvPNeil7k2sliTzn6qtbXLcva2LPmMM)
- [Power BI Payments Page](https://media.licdn.com/dms/image/v2/D562DAQFo_he3YWPRFw/profile-treasury-image-shrink_800_800/B56ZgZjMvoHMAc-/0/1752775314796?e=1765494000&v=beta&t=6y8pQgjP9e2pTvPNeil7k2sliTzn6qtbXLcva2LPmMM)
- [GTP_DW Database Diagram Fact/Dim](https://media.licdn.com/dms/image/v2/D562DAQGJV2XUjHHDfA/profile-treasury-image-shrink_800_800/B56ZgZjB80HcAg-/0/1752775270622?e=1765494000&v=beta&t=w-E3wBpEqHYda3_aEzwmrCn1amhkNnaEd1alQNIj7UM)

## Components
### **Excel UI**
- Custom-built UI using ActiveX controls, shapes, and image-based navigation with custom dialog windows.
- Expandable design suitable for other small-business verticals (landscaping, housekeeping, bookkeeping, etc.).

### **SQL Server Data Warehouse**
- Full implementation including staging, processing and warehouse layers.
- Automated ETL managed through a SQL Server Agent job.

### **Star Schema**
**Fact Tables:**
- 'fact_WorkOrder'
- 'fact_Payment'
  
**Dimension Tables:**
- 'dim_Customer'
- 'dim_Vehicle'
- 'dim_Date'
- 'dim_PaymentType'
- 'dim_ServiceType'

### **Billing Logic Includes**
- Parts
- Markup
- Labor
- Discounts
- Taxes
- Payments

### **Technologies Used**
- Excel (VBA)
- SQL Server (T-SQL, SQL Agent)
- Power BI (DAX, Modeling)
- On-Premises Data Warehouse Design

### **Business Outcome:**
- Converts semi-structured operational data into a structured analytics pipeline.
- Provides clean, automated Power BI reporting dashboards.

## Master DDL Script

This repository includes a **single master DDL script** that:
- Creates all databases
- Creates all tables
- Creates all stored procedures
- Creates the SQL Agent job
- Optionally triggers the DW load

After placing the TSV files, simply run the master script in SSMSS (F5).
Then execute the SQL Agent job:

**'Process DW for Garage Tracker Pro'**

## Single Scripts
In addition to the master DDL script, each individual component of that script is stored in separate files in this repo for viewing if needed.

<table style="border-collapse: collapse; width: 100%;">
	<thead>
		<tr style="background-color:#333333; color:#ffffff;">
			<th style="border:1px solid #555; padding:8px; text-align:left;">Component</th>
			<th style="border:1px solid #555; padding:8px; text-align:left;">File Name</th>
			<th style="border:1px solid #555; padding:8px; text-align:left;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr style="background-color:#f2f2f2;">
			<td style="border:1px solid #ccc; padding:8px;">Database DDL</td>
			<td style="border:1px solid #ccc; padding:8px;"><code>CreateAllDatabases.sql</code></td>
			<td style="border:1px solid #ccc; padding:8px;">Creates all databases used in the warehouse.</td>
		</tr>
		<tr style="background-color:#ffffff;">
			<td style="border:1px solid #ccc; padding:8px;">Table DDL</td>
			<td style="border:1px solid #ccc; padding:8px;"><code>CreateAllTables.sql</code></td>
			<td style="border:1px solid #ccc; padding:8px;">Creates all tables used in the warehouse</td>
		</tr>
		<tr style="background-color:#f2f2f2;">
			<td style="border:1px solid #ccc; padding:8px;">Procedures DDL</td>
			<td style="border:1px solid #ccc; padding:8px;"><code>CreateAllProcedures.sql</code></td>
			<td style="border:1px solid #ccc; padding:8px;">Creates all prcedures used in the warehouse.</td>
		</tr>
		<tr style="background-color:#ffffff;">
			<td style="border:1px solid #ccc; padding:8px;">SQL Agent Job</td>
			<td style="border:1px solid #ccc; padding:8px;"><code>CreateSQLAgentLoadingJob.sql</code></td>
			<td style="border:1px solid #ccc; padding:8px;">Creates the <code>Process DW for Garage Tracker Pro</code> SQL Agent job.</td>
		</tr>
	</tbody>
</table>

## Loading TSV Data Files
Please follow these steps to ensure the data for this project is available to the SQL Server Agent for ingestion into the data warehouse.
1. Create this folder: **C:\GarageTracker_RawTSVImports**
2. Grant read access to: **NT SERVICE\SQLSERVERAGENT**
3. Create a sub-folder: **C:\GarageTracker_RawTSVImports\dw_mock_data**
4. Place the following TSV files into "dw_mock_data':
- 'Customers.txt'
- 'Payments.txt'
- 'Vehicles.txt'
- 'WorkOrders.txt'

You may now run the master DDL script and trigger the SQL Agent job.

# License

This project is licensed under the MIT License.

**Copyright (c) 2025 Donny Osborne (donnyosborne6)

