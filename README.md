# End-To-End Auto Shop Analytics Pipeline

## Overview
Showcasing a work sample containing a complete data analytics pipeline and reporting solution for a hypothetical auto shop system using Excel as a front-end, SQL Server as the processing engine, and Power BI for reporting. I appreciate you viewing my project, and should you have any questions, please feel free to reach me on LinkedIn at https://www.linkedin.com/in/donny-osborne-559481350/

## LinkedIn Image Samples (Right-Click, Open In New Tab)
- [Excel/VBA UI](https://media.licdn.com/dms/image/v2/D562DAQFPS3hlnJ3QwA/profile-treasury-image-shrink_8192_8192/B56ZgZiWa_HUAk-/0/1752775092757?e=1765494000&v=beta&t=q_GxZKAlyIssAdvwoJSaZoGO26G5DfN0x_26bk09qyU)
- [Power BI Summary Page](https://media.licdn.com/dms/image/v2/D562DAQFo_he3YWPRFw/profile-treasury-image-shrink_800_800/B56ZgZjMvoHMAc-/0/1752775314796?e=1765494000&v=beta&t=6y8pQgjP9e2pTvPNeil7k2sliTzn6qtbXLcva2LPmMM)
- [Power BI Payments Page](https://media.licdn.com/dms/image/v2/D562DAQFo_he3YWPRFw/profile-treasury-image-shrink_800_800/B56ZgZjMvoHMAc-/0/1752775314796?e=1765494000&v=beta&t=6y8pQgjP9e2pTvPNeil7k2sliTzn6qtbXLcva2LPmMM)
- [GTP_DW Database Diagram Fact/Dim](https://media.licdn.com/dms/image/v2/D562DAQGJV2XUjHHDfA/profile-treasury-image-shrink_800_800/B56ZgZjB80HcAg-/0/1752775270622?e=1765494000&v=beta&t=w-E3wBpEqHYda3_aEzwmrCn1amhkNnaEd1alQNIj7UM)

## Components
- <strong>Excel UI:</strong> Uses ActiveX controls and shapes/images for a unique UI/UX experience designed for visually stunning interface that is extendable to other business types, like landscaping, bookkeeping, house cleaning, etc.
- <strong>SQL Server Data Warehouse:</strong>Code samples, stored procedures, and SQL Agent job for automated ETL.
- <strong>Normalized Star Schema:</strong>
  - <strong>Fact Tables:</strong>
    - fact_WorkOrder
    - fact_Payment
  - <strong>Dimension Tables:</strong>
    - dim_Customer
    - dim_Vehicle
    - dim_Date
    - dim_PaymentType
    - dim_ServiceType
- <strong>Calculated Billing Logic:</strong>
  - Parts
  - Markup
  - Labor
  - Tax
  - Discounts
  - Payments
- <strong>Technologies Used:</strong>
  - Excel (VBA)
  - SQL Server (T-SQL, Agent)
  - Power BI (DAX, Modeling and Reporting Layer)
  - Tabular Design with Star Schema
  - On-Premises Data Warehouse Architecture
- <strong>Business Outcome:</strong>
  - Enabled structured reporting from an semi-structured Excel process
  - Delivered automated, scalable analytics in two clean Power BI views

## Master DDL Script
This solution has a master DDL script you can execute in one step to launch the data warehouse once the TSV files have been stored to your machine. In addition, there's seperate single files for each one of the pieces of the solution. Once you load the files and download the master DDL script, you just need to run it with F5 and then trigger the SQL Agent Job "" to begin the data import.

## Single Scripts
In addition to the master DDL script, each individual component of that script is stored in separate files in this repo for viewing if needed.

<table style="border-collapse: collapse; width: 100%;">
	<thead>
		<tr style="background-color:#003366; color:#ffffff;">
			<th style="border:1px solid #cccccc; padding:8px; text-align:left;">Component</th>
			<th style="border:1px solid #cccccc; padding:8px; text-align:left;">File Name</th>
			<th style="border:1px solid #cccccc; padding:8px; text-align:left;">Description</th>
		</tr>
	</thead>
	<tbody>
		<tr style="background-color:#e6f2ff;">
			<td style="border:1px solid #cccccc; padding:8px;">Staging DDL</td>
			<td style="border:1px solid #cccccc; padding:8px;"><code>ddl_staging.sql</code></td>
			<td style="border:1px solid #cccccc; padding:8px;">Creates all staging tables used to land raw TSV data.</td>
		</tr>
		<tr style="background-color:#ffffff;">
			<td style="border:1px solid #cccccc; padding:8px;">Processing DDL</td>
			<td style="border:1px solid #cccccc; padding:8px;"><code>ddl_processing.sql</code></td>
			<td style="border:1px solid #cccccc; padding:8px;">Creates processing layer tables used for transformations.</td>
		</tr>
		<tr style="background-color:#e6f2ff;">
			<td style="border:1px solid #cccccc; padding:8px;">DW DDL</td>
			<td style="border:1px solid #cccccc; padding:8px;"><code>ddl_dw.sql</code></td>
			<td style="border:1px solid #cccccc; padding:8px;">Creates all fact and dimension tables in the warehouse.</td>
		</tr>
		<tr style="background-color:#ffffff;">
			<td style="border:1px solid #cccccc; padding:8px;">SQL Agent Job</td>
			<td style="border:1px solid #cccccc; padding:8px;"><code>ddl_job.sql</code></td>
			<td style="border:1px solid #cccccc; padding:8px;">Creates the <code>Process DW for Garage Tracker Pro</code> SQL Agent job.</td>
		</tr>
	</tbody>
</table>

## Loading TSV Data Files
Please follow these steps to ensure the data for this project is available to the SQL Server Agent for ingestion into the data warehouse.
  - Create a folder with the following name and location: "C:\GarageTracker_RawTSVImports" and add read access to the folder for the SQL Agent "NT SERVICE\SQLSERVERAGENT"
  - Create a sub-folder within this new folder: "C:\GarageTracker_RawTSVImports\dw_mock_data"
  - Locate the TSV files in this repo for Customers, Payments, Vehicles and WorkOrders datasets stored with the .txt extensions and place in the dw_mock_data folder
  - This folder source is now configured and you can execute the master DDL script

