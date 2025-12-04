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
