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
