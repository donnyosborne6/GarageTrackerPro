/***************************************************************************************************************************
  Title: Garage Tracker Pro (GTP) DDL - OnPrem Data Warehouse Project                                                              
 Author: Donny Osborne                                                                              
   Date: 12/03/2025                                                                                 
Purpose: Creates a data warehouse for a fictional BI product called the Garage Tracker Pro used by related Power BI report     
Details: 1) Create folder "C:\GarageTracker_RawTSVImports" and provide read access to "NT SERVICE\SQLSERVERAGENT"
         2) Create sub-folder "\dw_mock_data" and deposit the TSV files from the GitHub repo
         3) Execute script to create the databases, tables, procedures and SQL Agent Job, then runs the job to load the DW
****************************************************************************************************************************/

USE [master]
GO

-- Recreate DataWarehouse database
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'GTP_DW')
BEGIN
	CREATE DATABASE [GTP_DW]
END
GO

-- Recreate Logging database
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'GTP_Logging')
BEGIN
	CREATE DATABASE [GTP_Logging]
END
GO

-- Recreate Processing database
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'GTP_Processing')
BEGIN
	CREATE DATABASE [GTP_Processing]
END
GO

-- Recreate Staging database
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'GTP_Staging')
BEGIN
	CREATE DATABASE [GTP_Staging]
END
GO

-----------------------------------
/********* CREATE TABLES *********/
-----------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Event Logging table
DROP TABLE IF EXISTS [GTP_Logging]..[EventLoggingTable]
CREATE TABLE [GTP_Logging]..[EventLoggingTable]
(
	[EventDT]     DATETIME      NULL,
	[EventLayer]  NVARCHAR(100) NULL,
	[EventDesc]   NVARCHAR(100) NULL,
	[EventStatus] NVARCHAR(100) NULL,
	[EventNotes]  NVARCHAR(4000) NULL
) ON [PRIMARY]
GO

-- Customer staging table
DROP TABLE IF EXISTS [GTP_Staging]..[stg_CustomerRawData]
CREATE TABLE [GTP_Staging]..[stg_CustomerRawData]
(
	[CustomerID]   NVARCHAR(100) NULL,
	[CustomerName] NVARCHAR(100) NULL,
	[PhoneNumber]  NVARCHAR(100) NULL,
	[Address]      NVARCHAR(100) NULL,
	[Email]        NVARCHAR(100) NULL,
	[CreatedOn]    NVARCHAR(100) NULL,
	[LoadDT]       DATETIME      NULL
) ON [PRIMARY]
GO

-- Payment staging table
DROP TABLE IF EXISTS [GTP_Staging]..[stg_PaymentRawData]
CREATE TABLE [GTP_Staging]..[stg_PaymentRawData]
(
	[CustomerID]        NVARCHAR(100) NULL,
	[WorkOrderID]       NVARCHAR(100) NULL,
	[PaymentID]         NVARCHAR(100) NULL,
	[PaymentListString] NVARCHAR(100) NULL,
	[PaymentDate]       NVARCHAR(100) NULL,
	[PaymentType]       NVARCHAR(100) NULL,
	[PaymentAmount]     NVARCHAR(100) NULL,
	[LoadDT]			DATETIME      NULL
)
GO

-- Vehicle staging table
DROP TABLE IF EXISTS [GTP_Staging]..[stg_VehicleRawData]
CREATE TABLE [GTP_Staging]..[stg_VehicleRawData]
(
	[CustomerID]              NVARCHAR(100) NULL,
	[VehicleID]               NVARCHAR(100) NULL,
	[VehicleName]             NVARCHAR(100) NULL,
	[VehicleMake]             NVARCHAR(100) NULL,
	[VehicleModel]            NVARCHAR(100) NULL,
	[VehicleYear]             NVARCHAR(100) NULL,
	[VehicleVinLicenseNumber] NVARCHAR(100) NULL,
	[LoadDT]                  DATETIME      NULL
) ON [PRIMARY]
GO

-- Work Order staging table
DROP TABLE IF EXISTS [GTP_Staging]..[stg_WorkOrderRawData]
CREATE TABLE [GTP_Staging]..[stg_WorkOrderRawData]
(
	[CustomerID]         NVARCHAR(100) NULL,
	[WorkOrderID]        NVARCHAR(100) NULL,
	[VehicleID]          NVARCHAR(100) NULL,
	[OrderDate]          NVARCHAR(100) NULL,
	[OrderServiceType]   NVARCHAR(100) NULL,
	[OrderIssueDesc]     NVARCHAR(100) NULL,
	[OrderParts]         NVARCHAR(100) NULL,
	[OrderPartsCost]     NVARCHAR(100) NULL,
	[OrderPartsMarkup]   NVARCHAR(100) NULL,
	[OrderHoursSpent]    NVARCHAR(100) NULL,
	[OrderShopRate]      NVARCHAR(100) NULL,
	[OrderPartsEstimate] NVARCHAR(100) NULL,
	[OrderHoursEstimate] NVARCHAR(100) NULL,
	[OrderWhichVehicle]  NVARCHAR(100) NULL,
	[OrderResolution]    NVARCHAR(100) NULL,
	[OrderDiscounts]     NVARCHAR(100) NULL,
	[MilesOnVehicle]     NVARCHAR(100) NULL,
	[LoadDT]             DATETIME      NULL
) ON [PRIMARY]
GO

-- Customer processing table
DROP TABLE IF EXISTS [GTP_Processing]..[prc_Customer]
CREATE TABLE [GTP_Processing]..[prc_Customer]
(
	[CustomerID]   INT NULL,
	[CustomerName] NVARCHAR(100) NULL,
	[PhoneNumber]  NVARCHAR(100) NULL,
	[Address]      NVARCHAR(100) NULL,
	[City]         NVARCHAR(128) NULL,
	[State]        NVARCHAR(2)   NULL,
	[ZipCode]      NVARCHAR(5)   NULL,
	[Email]        NVARCHAR(100) NULL,
	[CreatedOn]    DATE          NULL,
	[LoadDT]       DATETIME NOT  NULL
) ON [PRIMARY]
GO

-- Payment processing table
DROP TABLE IF EXISTS [GTP_Processing]..[prc_Payment]
CREATE TABLE [GTP_Processing]..[prc_Payment]
(
	[CustomerID]        INT           NULL,
	[WorkOrderID]       INT           NULL,
	[PaymentID]         INT           NULL,
	[PaymentListString] NVARCHAR(100) NULL,
	[PaymentDate]       DATE          NULL,
	[PaymentType]       NVARCHAR(100) NULL,
	[PaymentAmount]     FLOAT         NULL,
	[LoadDT]            DATETIME      NOT NULL
) ON [PRIMARY]
GO

-- Vehicle processing table
DROP TABLE IF EXISTS [GTP_Processing]..[prc_Vehicle]
CREATE TABLE [GTP_Processing]..[prc_Vehicle]
(
	[CustomerID]              INT           NULL,
	[VehicleID]               INT           NULL,
	[VehicleName]             NVARCHAR(100) NULL,
	[VehicleMake]             NVARCHAR(100) NULL,
	[VehicleModel]            NVARCHAR(100) NULL,
	[VehicleYear]             INT           NULL,
	[VehicleVinLicenseNumber] NVARCHAR(100) NULL,
	[LoadDT]                  DATETIME      NOT NULL
) ON [PRIMARY]
GO

-- Work Order processing table
DROP TABLE IF EXISTS [GTP_Processing]..[prc_WorkOrder]
CREATE TABLE [GTP_Processing]..[prc_WorkOrder]
(
	[CustomerID]         INT           NULL,
	[WorkOrderID]        INT           NULL,
	[VehicleID]          INT           NULL,
	[OrderDate]          DATE          NULL,
	[OrderServiceType]   NVARCHAR(100) NULL,
	[OrderIssueDesc]     NVARCHAR(100) NULL,
	[OrderParts]         NVARCHAR(100) NULL,
	[OrderPartsCost]     FLOAT         NULL,
	[OrderPartsMarkup]   FLOAT         NULL,
	[OrderHoursSpent]    FLOAT         NULL,
	[OrderShopRate]      FLOAT         NULL,
	[OrderPartsEstimate] FLOAT         NULL,
	[OrderHoursEstimate] FLOAT         NULL,
	[OrderWhichVehicle]  NVARCHAR(100) NULL,
	[OrderResolution]    NVARCHAR(100) NULL,
	[OrderDiscount]      FLOAT         NULL,
	[MilesOnVehicle]     INT           NULL,
	[LoadDT]             DATETIME      NOT NULL
) ON [PRIMARY]
GO

-- Customer dimension table
DROP TABLE IF EXISTS [GTP_DW]..[dim_Customer]
CREATE TABLE [GTP_DW]..[dim_Customer]
(
	[CustomerID]   INT NULL,
	[CustomerName] NVARCHAR(100) NULL,
	[PhoneNumber]  NVARCHAR(20)  NULL,
	[Email]        NVARCHAR(100) NULL,
	[Address]      NVARCHAR(150) NULL,
	[City]         NVARCHAR(100) NULL,
	[State]        CHAR(2)       NULL,
	[ZipCode]      VARCHAR(10)   NULL,
	[CreatedOn]    DATE          NULL,
	[LoadDT]       DATETIME      NULL
) ON [PRIMARY]
GO

ALTER TABLE [GTP_DW]..[dim_Customer] ADD DEFAULT (GETDATE()) FOR [LoadDT]
GO

-- Date dimension table
DROP TABLE IF EXISTS [GTP_DW]..[dim_Date]
CREATE TABLE [GTP_DW]..[dim_Date]
(
	[DateKey]       INT         NULL,
	[DateValue]     DATE        NOT NULL,
	[Day]           TINYINT     NULL,
	[Month]         TINYINT     NULL,
	[MonthName]     VARCHAR(20) NULL,
	[Quarter]       TINYINT     NULL,
	[Year]          SMALLINT  NULL,
	[DayOfWeekName] VARCHAR(10) NULL,
	[IsWeekend]     BIT         NULL,
	[IsHoliday]     BIT         NULL
) ON [PRIMARY]
GO

ALTER TABLE [GTP_DW]..[dim_Date] ADD DEFAULT ((0)) FOR [IsHoliday]
GO

-- Payment Type dimension table
DROP TABLE IF EXISTS [GTP_DW]..[dim_PaymentType]
CREATE TABLE [GTP_DW]..[dim_PaymentType]
(
	[PaymentTypeID]   INT          NULL,
	[PaymentTypeName] NVARCHAR(50) NULL,
	[LoadDT]          DATETIME     NULL
) ON [PRIMARY]
GO

ALTER TABLE [GTP_DW]..[dim_PaymentType] ADD DEFAULT (GETDATE()) FOR [LoadDT]
GO

-- Service Type dimension table
DROP TABLE IF EXISTS [GTP_DW]..[dim_ServiceType]
CREATE TABLE [GTP_DW]..[dim_ServiceType]
(
	[ServiceTypeID]   INT           NULL,
	[ServiceTypeName] NVARCHAR(100) NULL,
	[LoadDT]          DATETIME      NULL
) ON [PRIMARY]
GO

ALTER TABLE [GTP_DW]..[dim_ServiceType] ADD  DEFAULT (GETDATE()) FOR [LoadDT]
GO

-- Vehicle dimension table
DROP TABLE IF EXISTS [GTP_DW]..[dim_Vehicle]
CREATE TABLE [GTP_DW]..[dim_Vehicle]
(
	[VehicleID]               INT           NOT NULL,
	[CustomerID]              INT           NULL,
	[VehicleName]             NVARCHAR(100) NULL,
	[VehicleMake]             NVARCHAR(50)  NULL,
	[VehicleModel]            NVARCHAR(50)  NULL,
	[VehicleYear]             INT           NULL,
	[VehicleVinLicenseNumber] VARCHAR(30)   NULL,
	[LoadDT]                  DATETIME      NULL
)
GO

ALTER TABLE [GTP_DW]..[dim_Vehicle] ADD  DEFAULT (GETDATE()) FOR [LoadDT]
GO

-- Payment fact table
DROP TABLE IF EXISTS [GTP_DW]..[fact_Payment]
CREATE TABLE [GTP_DW]..[fact_Payment]
(
	[PaymentID]         INT            NULL,
	[WorkOrderID]       INT            NULL,
	[CustomerID]        INT            NULL,
	[PaymentDateKey]    INT            NULL,
	[PaymentTypeID]     INT            NULL,
	[PaymentAmount]     DECIMAL(10, 2) NULL,
	[PaymentListString] NVARCHAR(200)  NULL,
	[LoadDT]            DATETIME       NULL
) ON [PRIMARY]
GO

ALTER TABLE [GTP_DW]..[fact_Payment] ADD  DEFAULT (GETDATE()) FOR [LoadDT]
GO

-- Work Order fact table
DROP TABLE IF EXISTS [GTP_DW]..[fact_WorkOrder]
CREATE TABLE [GTP_DW]..[fact_WorkOrder]
(
	[WorkOrderID]        INT            NULL,
	[CustomerID]         INT            NULL,
	[VehicleID]          INT            NULL,
	[OrderDateKey]       INT            NULL,
	[ServiceTypeID]      INT            NULL,
	[OrderIssueDesc]     NVARCHAR(500)  NULL,
	[OrderParts]         NVARCHAR(500)  NULL,
	[OrderPartsCost]     DECIMAL(10, 2) NULL,
	[OrderPartsMarkup]   DECIMAL(5, 2)  NULL,
	[OrderHoursSpent]    DECIMAL(5, 2)  NULL,
	[OrderShopRate]      DECIMAL(10, 2) NULL,
	[OrderPartsEstimate] DECIMAL(10, 2) NULL,
	[OrderHoursEstimate] DECIMAL(5, 2)  NULL,
	[OrderWhichVehicle]  NVARCHAR(100)  NULL,
	[OrderResolution]    NVARCHAR(500)  NULL,
	[OrderDiscount]      DECIMAL(10, 2) NULL,
	[MilesOnVehicle]     INT            NULL,
	[LoadDT]             DATETIME       NULL
) ON [PRIMARY]
GO

ALTER TABLE [GTP_DW]..[fact_WorkOrder] ADD  DEFAULT (GETDATE()) FOR [LoadDT]
GO

-------------------------------------------
/********* CREATE ALL PROCEDURES *********/
-------------------------------------------

-- LOGGING: Centralized Procedure
USE [GTP_Logging]
GO

DROP PROCEDURE IF EXISTS [sp_LogEvent]
GO

CREATE PROCEDURE [sp_LogEvent]
	@EventLayer  NVARCHAR(100),
	@EventDesc   NVARCHAR(100),
	@EventStatus NVARCHAR(100),
	@EventNotes  NVARCHAR(100) = NULL
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		INSERT INTO [GTP_Logging]..[EventLoggingTable] 
		(
			[EventDT],
			[EventLayer],
			[EventDesc],
			[EventStatus],
			[EventNotes]
		)
		VALUES 
		(
			GETDATE(),
			@EventLayer,
			@EventDesc,
			@EventStatus,
			@EventNotes
		)
	END TRY
	BEGIN CATCH
		-- Don't let logging failures break the pipeline further.
		-- Swallow errors here so the original error is what bubbles up.
		RETURN
	END CATCH
END
GO

-- STAGING PROCEDURES
USE [GTP_Staging]
GO

-- CREATE PROCEDURE sp_GTP_ExtractCustomerData_Staging
DROP PROCEDURE IF EXISTS [sp_Extract_Customers_Staging]
GO

CREATE PROCEDURE [sp_Extract_Customers_Staging]
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		-- Rebuild table (add LoadDT after import)
		DROP TABLE IF EXISTS [GTP_Staging]..[stg_CustomerRawData]
		CREATE TABLE [GTP_Staging]..[stg_CustomerRawData]
		(
			[CustomerID]   NVARCHAR(100) NULL,
			[CustomerName] NVARCHAR(100) NULL,
			[PhoneNumber]  NVARCHAR(100) NULL,
			[Address]      NVARCHAR(100) NULL,
			[Email]        NVARCHAR(100) NULL,
			[CreatedOn]    NVARCHAR(100) NULL
		)

		-- Read from TSV
		BULK INSERT [GTP_Staging]..[stg_CustomerRawData]
		FROM 'C:\GarageTracker_RawTSVImports\dw_mock_data\Customers.txt'
		WITH 
		(
			FIELDTERMINATOR = '\t',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		)

		-- Create consistent load dt stamp
		DECLARE @LoadDT DATETIME
		SET @LoadDT = GETDATE() 

		-- Add LoadDT column
		ALTER TABLE [GTP_Staging]..[stg_CustomerRawData]
		ADD [LoadDT] DATETIME NULL

		-- Add value to column
		UPDATE [GTP_Staging]..[stg_CustomerRawData]
		SET [LoadDT] = @LoadDT

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Customer Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Extracted Customer data successfully.'
	END TRY
	BEGIN CATCH
		-- Update Logging Table
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Customer Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
	END CATCH
END
GO

-- CREATE PROCEDURE [sp_ExtractPaymentData_Staging]
DROP PROCEDURE IF EXISTS [sp_Extract_Payments_Staging]
GO

CREATE PROCEDURE [sp_Extract_Payments_Staging]
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		-- Rebuild table (add LoadDT after import)
		DROP TABLE IF EXISTS [GTP_Staging]..[stg_PaymentRawData]
		CREATE TABLE [GTP_Staging]..[stg_PaymentRawData]
		(
			[CustomerID]        NVARCHAR(100) NULL,
			[WorkOrderID]       NVARCHAR(100) NULL,
			[PaymentID]         NVARCHAR(100) NULL,
			[PaymentListString] NVARCHAR(100) NULL,
			[PaymentDate]       NVARCHAR(100) NULL,
			[PaymentType]       NVARCHAR(100) NULL,
			[PaymentAmount]     NVARCHAR(100) NULL
		)

		-- Read from TSV
		BULK INSERT [GTP_Staging]..[stg_PaymentRawData]
		FROM 'C:\GarageTracker_RawTSVImports\dw_mock_data\Payments.txt'
		WITH 
		(
			FIELDTERMINATOR = '\t',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		)

		-- Create consistent load dt stamp
		DECLARE @LoadDT DATETIME
		SET @LoadDT = GETDATE() 

		-- Add LoadDT column
		ALTER TABLE [GTP_Staging]..[stg_PaymentRawData]
		ADD [LoadDT] DATETIME NULL

		-- Add value to column
		UPDATE [GTP_Staging]..[stg_PaymentRawData]
		SET [LoadDT] = @LoadDT

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Payment Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Extracted Payment data successfully.'
	END TRY
	BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Payment Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
	END CATCH
END
GO

-- CREATE PROCEDURE sp_GTP_ExtractVehicleData_Staging
DROP PROCEDURE IF EXISTS [sp_Extract_Vehicles_Staging]
GO

CREATE PROCEDURE [sp_Extract_Vehicles_Staging]
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		-- Rebuild table (add LoadDT after import)
		DROP TABLE IF EXISTS [GTP_Staging]..[stg_VehicleRawData]
		CREATE TABLE [GTP_Staging]..[stg_VehicleRawData]
		(
			[CustomerID]              NVARCHAR(100) NULL,
			[VehicleID]               NVARCHAR(100) NULL,
			[VehicleName]             NVARCHAR(100) NULL,
			[VehicleMake]             NVARCHAR(100) NULL,
			[VehicleModel]            NVARCHAR(100) NULL,
			[VehicleYear]             NVARCHAR(100) NULL,
			[VehicleVinLicenseNumber] NVARCHAR(100) NULL
		)

		-- Read from TSV
		BULK INSERT [GTP_Staging]..[stg_VehicleRawData]
		FROM 'C:\GarageTracker_RawTSVImports\dw_mock_data\Vehicles.txt'
		WITH 
		(
			FIELDTERMINATOR = '\t',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		)

		-- Create consistent load dt stamp
		DECLARE @LoadDT DATETIME
		SET @LoadDT = GETDATE() 

		-- Add LoadDT column
		ALTER TABLE [GTP_Staging]..[stg_VehicleRawData]
		ADD [LoadDT] DATETIME NULL

		-- Add value to column
		UPDATE [GTP_Staging]..[stg_VehicleRawData]
		SET [LoadDT] = @LoadDT

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Vehicle Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Extracted Vewhicle data successfully.'
	END TRY
	BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Vehicle Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
	END CATCH
END
GO

-- CREATE PROCEDURE sp_GTP_ExtractWorkOrderData_Staging
DROP PROCEDURE IF EXISTS [sp_Extract_WorkOrders_Staging]
GO

CREATE PROCEDURE [sp_Extract_WorkOrders_Staging]
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		-- Rebuild table (add LoadDT after import)
		DROP TABLE IF EXISTS [GTP_Staging]..[stg_WorkOrderRawData]
		CREATE TABLE [GTP_Staging]..[stg_WorkOrderRawData]
		(
			[CustomerID]         NVARCHAR(100) NULL,
			[WorkOrderID]        NVARCHAR(100) NULL,
			[VehicleID]          NVARCHAR(100) NULL,
			[OrderDate]          NVARCHAR(100) NULL,
			[OrderServiceType]   NVARCHAR(100) NULL,
			[OrderIssueDesc]     NVARCHAR(100) NULL,
			[OrderParts]         NVARCHAR(100) NULL,
			[OrderPartsCost]     NVARCHAR(100) NULL,
			[OrderPartsMarkup]   NVARCHAR(100) NULL,
			[OrderHoursSpent]    NVARCHAR(100) NULL,
			[OrderShopRate]      NVARCHAR(100) NULL,
			[OrderPartsEstimate] NVARCHAR(100) NULL,
			[OrderHoursEstimate] NVARCHAR(100) NULL,
			[OrderWhichVehicle]  NVARCHAR(100) NULL,
			[OrderResolution]    NVARCHAR(100) NULL,
			[OrderDiscounts]     NVARCHAR(100) NULL,
			[MilesOnVehicle]     NVARCHAR(100) NULL
		)

		-- Read from TSV
		BULK INSERT [GTP_Staging]..[stg_WorkOrderRawData]
		FROM 'C:\GarageTracker_RawTSVImports\dw_mock_data\WorkOrders.txt'
		WITH 
		(
			FIELDTERMINATOR = '\t',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2
		)

		-- Create consistent load dt stamp
		DECLARE @LoadDT DATETIME
		SET @LoadDT = GETDATE() 

		-- Add LoadDT column
		ALTER TABLE [GTP_Staging]..[stg_WorkOrderRawData]
		ADD [LoadDT] DATETIME NULL

		-- Add value to column
		UPDATE [GTP_Staging]..[stg_WorkOrderRawData]
		SET [LoadDT] = @LoadDT

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Work Order Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Extracted Work Order data successfully.'
	END TRY
	BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Staging',
			@EventDesc   = 'Extract Work Order Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
	END CATCH
END
GO

-- PROCESSING TRANSFORM PROCEDURES
USE [GTP_Processing]
GO

-- Customer proc
DROP PROCEDURE IF EXISTS [sp_Transform_Customers_Processing]
GO

CREATE PROCEDURE [sp_Transform_Customers_Processing]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
        TRUNCATE TABLE [GTP_Processing]..[prc_Customer]

		-- Transform Customer data
		INSERT INTO [GTP_Processing]..[prc_Customer]
		(
			[CustomerID],
			[CustomerName],
			[PhoneNumber], 
			[Address],     
			[City],        
			[State],       
			[ZipCode],     
			[Email],       
			[CreatedOn],   
			[LoadDT]      
		)
        SELECT CAST([CustomerID] AS INT) AS [CustomerID]
              ,[CustomerName]
              ,[PhoneNumber]
              ,[Address]
              ,REVERSE(LTRIM(RTRIM(PARSENAME(REPLACE(REVERSE([Address]), ',', '.') , 2)))) 
                                            AS [City]
              ,LEFT(RIGHT([Address], 8), 2) AS [State]
              ,RIGHT([Address], 5)          AS [ZipCode]
              ,[Email]
              ,CAST([CreatedOn] AS DATE)    AS [CreatedOn]
              ,GETDATE()                    AS [LoadDT]
        FROM [GTP_Staging].[dbo].[stg_CustomerRawData]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transform Customer Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Customer data transformed successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transform Customer Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- CREATE PROCEDURE sp_GTP_TransformPaymentData_Processing
DROP PROCEDURE IF EXISTS [sp_Transform_Payments_Processing]
GO

CREATE PROCEDURE [sp_Transform_Payments_Processing]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
        -- Truncate data
		TRUNCATE TABLE [GTP_Processing]..[prc_Payment]

		INSERT INTO [GTP_Processing]..[prc_Payment]
		(
			[CustomerID],        
			[WorkOrderID],       
			[PaymentID],         
			[PaymentListString], 
			[PaymentDate],       
			[PaymentType],      
			[PaymentAmount],     
			[LoadDT]            
		)
        SELECT CAST([CustomerID] AS INT)      AS [CustomerID]
              ,CAST([WorkOrderID] AS INT)     AS [WorkOrderID]
              ,CAST([PaymentID] AS INT)       AS [PaymentID]
              ,[PaymentListString]
              ,CAST([PaymentDate] AS DATE)    AS [PaymentDate]
              ,[PaymentType]
              ,CAST([PaymentAmount] AS FLOAT) AS [PaymentAmount]
              ,GETDATE()                      AS [LoadDT]
        FROM [GTP_Staging]..[stg_PaymentRawData]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transform Payment Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Payment data transformed successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transforming Payment Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- CREATE PROCEDURE sp_GTP_TransformVehicleData_Processing
DROP PROCEDURE IF EXISTS [sp_Transform_Vehicles_Processing]
GO

CREATE PROCEDURE [sp_Transform_Vehicles_Processing]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
        -- Truncate data
		TRUNCATE TABLE [GTP_Processing]..[prc_Vehicle]

		INSERT INTO [GTP_Processing]..[prc_Vehicle]
		(
			[CustomerID],              
			[VehicleID],               
			[VehicleName],             
			[VehicleMake],             
			[VehicleModel],            
			[VehicleYear],             
			[VehicleVinLicenseNumber],
			[LoadDT]
		)
        SELECT CAST([CustomerID] AS INT)  AS [CustomerID]
              ,CAST([VehicleID] AS INT)   AS [VehicleID]
              ,[VehicleName]
              ,[VehicleMake]
              ,[VehicleModel]
              ,CAST([VehicleYear] AS INT) AS [VehicleYear]
              ,[VehicleVinLicenseNumber]
              ,GETDATE()                  AS [LoadDT]
        FROM [GTP_Staging]..[stg_VehicleRawData]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transform Vehicle Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Vehicle data transformed successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transforming Vehicle Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- CREATE PROCEDURE sp_GTP_TransformWorkOrderData_Processing
DROP PROCEDURE IF EXISTS [sp_Transform_WorkOrders_Processing]
GO

CREATE PROCEDURE [sp_Transform_WorkOrders_Processing]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
        TRUNCATE TABLE [GTP_Processing]..[prc_WorkOrder]

		INSERT INTO [GTP_Processing]..[prc_WorkOrder]
		(
			[CustomerID],         
			[WorkOrderID],        
			[VehicleID],          
			[OrderDate],          
			[OrderServiceType],   
			[OrderIssueDesc],     
			[OrderParts],        
			[OrderPartsCost],     
			[OrderPartsMarkup],   
			[OrderHoursSpent],    
			[OrderShopRate],      
			[OrderPartsEstimate], 
			[OrderHoursEstimate], 
			[OrderWhichVehicle],  
			[OrderResolution],    
			[OrderDiscount],      
			[MilesOnVehicle],     
			[LoadDT]             
		)
        SELECT CAST([CustomerID] AS INT)           AS [CustomerID]
              ,CAST([WorkOrderID] AS INT)          AS [WorkOrderID]
              ,CAST([VehicleID] AS INT)            AS [VehicleID]
              ,CAST([OrderDate] AS DATE)           AS [OrderDate]
              ,[OrderServiceType]
              ,[OrderIssueDesc]
              ,[OrderParts]
              ,CAST([OrderPartsCost] AS FLOAT)     AS [OrderPartsCost]
              ,CAST(REPLACE([OrderPartsMarkup], '%', '') / 100.0 AS FLOAT) AS [OrderPartsMarkup]
              ,CAST([OrderHoursSpent] AS FLOAT)    AS [OrderHoursSpent]
              ,CAST([OrderShopRate] AS FLOAT)      AS [OrderShopRate]
              ,CAST([OrderPartsEstimate] AS FLOAT) AS [OrderPartsEstimate]
              ,CAST([OrderHoursEstimate] AS FLOAT) AS [OrderHoursEstimate]
              ,[OrderWhichVehicle]
              ,[OrderResolution]
              ,CAST([OrderDiscounts] AS FLOAT)     AS [OrderDiscount]
              ,CAST([MilesOnVehicle] AS INT)       AS [MilesOnVehicle]
              ,GETDATE()                           AS [LoadDT]
        FROM [GTP_Staging]..[stg_WorkOrderRawData]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transform Work Orders Data',
			@EventStatus = 'Pass',
			@EventNotes  = 'Work Orders data transformed successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'Processing',
			@EventDesc   = 'Transforming Work Orders Data',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- DW LOAD PROCEDURES
USE [GTP_DW]
GO

-- Customer dimension proc
DROP PROCEDURE IF EXISTS [sp_Load_DimCustomer_DW]
GO 

CREATE PROCEDURE [sp_Load_DimCustomer_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[dim_Customer]

		-- Load Customer dimension table
		INSERT INTO [GTP_DW]..[dim_Customer] 
		(
			[CustomerID], 
			[CustomerName], 
			[PhoneNumber], 
			[Address], 
			[Email], 
			[City], 
			[State], 
			[ZipCode], 
			[CreatedOn], 
			[LoadDT]
		)
		SELECT [CustomerID],
			   [CustomerName],
			   [PhoneNumber],
			   [Address],
			   [Email],
			   [City],
			   [State],
			   [ZipCode],
			   [CreatedOn],
			   GETDATE()
		FROM [GTP_Processing]..[prc_Customer]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Customer Dimension',
			@EventStatus = 'Pass',
			@EventNotes  = 'Customer dimension table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Customer Dimension',
			@EventStatus = 'Fail',
			@EventNotes  = @ErrorMessage
    END CATCH
END
GO

-- Date dimension proc
DROP PROCEDURE IF EXISTS [sp_Load_DimDate_DW]
GO

CREATE PROCEDURE [sp_Load_DimDate_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[dim_Date]

		-- Load Date dimension table with center context on today +/- 10 years
		DECLARE @StartDate DATE = DATEADD(YEAR, -10, GETDATE())
		DECLARE @EndDate DATE = DATEADD(YEAR, 10, GETDATE())

		WHILE @StartDate <= @EndDate
		BEGIN
			INSERT INTO [GTP_DW]..[dim_Date] 
			(
				[DateKey],
				[DateValue],
				[Day],
				[Month],
				[MonthName],
				[Quarter],
				[Year],
				[DayOfWeekName],
				[IsWeekend]
			)
			VALUES (
				CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
				@StartDate,
				DATEPART(DAY, @StartDate),
				DATEPART(MONTH, @StartDate),
				DATENAME(MONTH, @StartDate),
				DATEPART(QUARTER, @StartDate),
				DATEPART(YEAR, @StartDate),
				DATENAME(WEEKDAY, @StartDate),
				CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END
			)

			SET @StartDate = DATEADD(DAY, 1, @StartDate)
		END    

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Date Dimension',
			@EventStatus = 'Pass',
			@EventNotes  = 'Date dimension table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Date Dimension',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- Payment Type dimension proc
DROP PROCEDURE IF EXISTS [sp_Load_DimPaymentType_DW]
GO 

CREATE PROCEDURE [sp_Load_DimPaymentType_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[dim_PaymentType]

		-- Load Payment Type dimension table
		INSERT INTO [GTP_DW]..[dim_PaymentType] 
		(
			[PaymentTypeID], 
			[PaymentTypeName], 
			[LoadDT]
		)
		SELECT DISTINCT
			DENSE_RANK() OVER (ORDER BY PaymentType) AS [PaymentTypeID],
			[PaymentType],
			GETDATE()
		FROM [GTP_Processing]..[prc_Payment]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Payment Type Dimension',
			@EventStatus = 'Pass',
			@EventNotes  = 'Payment Type dimension table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Payment Type Dimension',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- Service Type dimension proc
DROP PROCEDURE IF EXISTS [sp_Load_DimServiceType_DW]
GO 

CREATE PROCEDURE [sp_Load_DimServiceType_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[dim_ServiceType]

		-- Load Service Type dimension table
		INSERT INTO [GTP_DW]..[dim_ServiceType] 
		(
			[ServiceTypeID], 
			[ServiceTypeName], 
			[LoadDT]
		)
		SELECT DISTINCT
			DENSE_RANK() OVER (ORDER BY OrderServiceType) AS [ServiceTypeID],
			[OrderServiceType],
			GETDATE()
		FROM [GTP_Processing]..[prc_WorkOrder]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Service Type Dimension',
			@EventStatus = 'Pass',
			@EventNotes  = 'Service Type dimension table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Service TYpe Dimension',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- Vehicle dimension proc
DROP PROCEDURE IF EXISTS [sp_Load_DimVehicle_DW]
GO  

CREATE PROCEDURE [sp_Load_DimVehicle_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[dim_Vehicle]

		-- Load Vehicle dimension table (note: semi-normalized for easier human reads/query joins)
		INSERT INTO [GTP_DW]..[dim_Vehicle] 
		(
			[VehicleID],
			[CustomerID],
			[VehicleName],
			[VehicleMake],
			[VehicleModel],
			[VehicleYear],
			[VehicleVinLicenseNumber],
			[LoadDT]
		)
		SELECT [VehicleID],
			   [CustomerID],
			   [VehicleName],
			   [VehicleMake],
			   [VehicleModel],
			   [VehicleYear],
			   [VehicleVinLicenseNumber],
			   GETDATE()
		FROM [GTP_Processing]..[prc_Vehicle]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Vehicle Dimension',
			@EventStatus = 'Pass',
			@EventNotes  = 'Vehicle Dimension table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Vehicle Dimension',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- Payment fact proc
DROP PROCEDURE IF EXISTS [sp_Load_FactPayment_DW]
GO 

CREATE PROCEDURE [sp_Load_FactPayment_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[fact_Payment]

		-- Load Payment fact table
		INSERT INTO [GTP_DW]..[fact_Payment]
		(
			[PaymentID],
			[WorkOrderID],
			[CustomerID],
			[PaymentDateKey],
			[PaymentTypeID],
			[PaymentAmount],
			[PaymentListString],
			[LoadDT]
		)
		SELECT
			[A].[PaymentID],
			[A].[WorkOrderID],
			[A].[CustomerID],
			CAST(FORMAT([A].[PaymentDate], 'yyyyMMdd') AS INT),
			[B].[PaymentTypeID],
			[A].[PaymentAmount],
			[A].[PaymentListString],
			GETDATE()
		FROM [GTP_Processing]..[prc_Payment]  AS [A]
		LEFT JOIN [GTP_DW]..[dim_PaymentType] AS [B] ON [A].[PaymentType] = [B].[PaymentTypeName]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Payment Fact Table',
			@EventStatus = 'Pass',
			@EventNotes  = 'Payment fact table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Payment Fact Table',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-- Work Order fact proc
DROP PROCEDURE IF EXISTS [sp_Load_FactWorkOrder_DW]
GO 

CREATE PROCEDURE [sp_Load_FactWorkOrder_DW]
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		-- Truncate data
		TRUNCATE TABLE [GTP_DW]..[fact_WorkOrder]

		-- Load Work Order fact table
		INSERT INTO [GTP_DW]..[fact_WorkOrder] 
		(
			[WorkOrderID],
			[CustomerID],
			[VehicleID],
			[OrderDateKey],
			[ServiceTypeID],
			[OrderIssueDesc],
			[OrderParts],
			[OrderPartsCost],
			[OrderPartsMarkup],
			[OrderHoursSpent],
			[OrderShopRate],
			[OrderPartsEstimate],
			[OrderHoursEstimate],
			[OrderWhichVehicle],
			[OrderResolution],
			[OrderDiscount],
			[MilesOnVehicle],
			[LoadDT]
		)
		SELECT
			[A].[WorkOrderID],
			[A].[CustomerID],
			[A].[VehicleID],
			CAST(FORMAT([A].[OrderDate], 'yyyyMMdd') AS INT),
			[B].[ServiceTypeID],
			[A].[OrderIssueDesc],
			[A].[OrderParts],
			[A].[OrderPartsCost],
			[A].[OrderPartsMarkup],
			[A].[OrderHoursSpent],
			[A].[OrderShopRate],
			[A].[OrderPartsEstimate],
			[A].[OrderHoursEstimate],
			[A].[OrderWhichVehicle],
			[A].[OrderResolution],
			[A].[OrderDiscount],
			[A].[MilesOnVehicle],
			GETDATE()
		FROM [GTP_Processing]..[prc_WorkOrder] AS [A]
		LEFT JOIN [GTP_DW]..[dim_ServiceType]  AS [B] ON [A].[OrderServiceType] = [B].[ServiceTypeName]

		-- Update Logging Table (pass)
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Work Order Fact Table',
			@EventStatus = 'Pass',
			@EventNotes  = 'Work Order fact table loaded successfully.'
    END TRY
    BEGIN CATCH
		-- Update Logging Table (fail)
		DECLARE @ErrorMessage NVARCHAR(100)
		SET @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		EXEC [GTP_Logging]..[sp_LogEvent]
			@EventLayer  = 'DW',
			@EventDesc   = 'Load Work Order Fact Table',
			@EventStatus = 'Fail',
			@EventNotes = @ErrorMessage
    END CATCH
END
GO

-------------------------
/***** REBUILD JOB *****/
-------------------------
USE [msdb]
GO

/****** Object:  Job [Process DW for Garage Tracker Pro]    Script Date: 12/3/2025 12:51:16 PM ******/
DECLARE @job_id UNIQUEIDENTIFIER

SELECT @job_id = [job_id]
FROM [sysjobs]
WHERE [name] = N'Process DW for Garage Tracker Pro'

IF @job_id IS NOT NULL
BEGIN
	EXEC sp_delete_job @job_id=@job_id, @delete_unused_schedule=1
END
GO

/****** Object:  Job [Process DW for Garage Tracker Pro]    Script Date: 12/3/2025 12:51:16 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/3/2025 12:51:16 PM ******/
IF NOT EXISTS (SELECT [name] FROM [syscategories] WHERE name=N'[Uncategorized (Local)]' AND [category_class]=1)
BEGIN
EXEC @ReturnCode = [sp_add_category] @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  sp_add_job @job_name=N'Process DW for Garage Tracker Pro', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Log Process Start Time]    Script Date: 12/4/2025 9:09:02 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Log Process Start Time', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Update Logging Table (pass)
EXEC [sp_LogEvent]
	@EventLayer  = ''Logging'',
	@EventDesc   = ''Refresh DW Start Time'',
	@EventStatus = ''N/A'',
	@EventNotes  = ''Refresh Job Started Successfully.''', 
		@database_name=N'GTP_Logging', 
		@flags=0
/****** Object:  Step {Extract Customer Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Extract Customers Data', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Extract_Customers_Staging]', 
		@database_name=N'GTP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step {Extract Payment Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Extract Payments Data', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Extract_Payments_Staging]', 
		@database_name=N'GTP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step {Extract Vehicle Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Extract Vehicles Data', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Extract_Vehicles_Staging]', 
		@database_name=N'GTP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step {Extract Work Order Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Extract Work Orders Data', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Extract_WorkOrders_Staging]', 
		@database_name=N'GTP_Staging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Transform Customer Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Transform Customers Data', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Transform_Customers_Processing]', 
		@database_name=N'GTP_Processing', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Transform Payment Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Transform Payments Data', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Transform_Payments_Processing]', 
		@database_name=N'GTP_Processing', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Transform Vehicles Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Transform Vehicles Data', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Transform_Vehicles_Processing]', 
		@database_name=N'GTP_Processing', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Transform Work Orders Data]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Transform Work Orders Data', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Transform_WorkOrders_Processing]', 
		@database_name=N'GTP_Processing', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Rebuild Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Load Customer Dimension Table', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_DimCustomer_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Rebuild Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = sp_add_jobstep @job_id=@jobId, @step_name=N'Load Date Dimension Table', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_DimDate_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Load Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Payment Type Dimension Table', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_DimPaymentType_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Load Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Service Type Dimension Table', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_DimServiceType_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Load Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Vehicle Dimension Table', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_DimVehicle_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Load Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Payment Fact Table', 
		@step_id=15, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_FactPayment_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Load Fact and Dimension Tables]    Script Date: 12/3/2025 12:51:16 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Work Order Fact Table', 
		@step_id=16, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [sp_Load_FactWorkOrder_DW]', 
		@database_name=N'GTP_DW', 
		@flags=0
/****** Object:  Step [Log Process End Time]    Script Date: 12/4/2025 9:09:02 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Log Process End Time', 
		@step_id=17, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Update Logging Table (pass)
EXEC [sp_LogEvent]
	@EventLayer  = ''Logging'',
	@EventDesc   = ''Refresh DW End Time'',
	@EventStatus = ''N/A'',
	@EventNotes  = ''Refresh Job Finished Successfully.''', 
		@database_name=N'GTP_Logging', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

-- Notify user that the DDL is created and to trigger the SQL Agent Job to run the load process
PRINT 'Garage Tracker Pro databases, tables, procedure and job created successfully!'
PRINT 'Please start the SQL Agent job "Process DW for Garage Tracker Pro" to load the data.' 

-- RUN THE SQL AGENT JOB TO LOAD THE DATA WAREHOUSE DATA
--EXEC [sp_start_job] @job_name = 'Process DW for Garage Tracker Pro'
