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
