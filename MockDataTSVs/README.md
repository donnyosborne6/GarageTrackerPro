The files in this folder are the TSV dummy data content needed to populate the data warehouse in SQL Server.

To use these files, perform the following steps:
1) Create folder "C:\GarageTracker_RawTSVImports" and provide read access to "NT SERVICE\SQLSERVERAGENT"
2) Create sub-folder "\dw_mock_data" and deposit the TSV files from the GitHub repo
3) Execute master script found in the MasterDDL_SQL folder to create the databases, tables, procedures and SQL Agent Job, then runs the job to load the DW
