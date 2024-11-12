/*
	Name:			CleanupInBatches - BPAWorkQueueItem - SpecificQueues - Monitor.sql
	Author:			Blue Prism
	Date:			20221019
	Description:	This script is to be used to monitor the execution of the "CleanupInBatches - BPAWorkQueueItem - SpecificQueues.sql" script
					The script returns 3 result sets; 
						1 - How many Work Queue Item records are left to clean up
						2 - The size of the Blue Prism database transaction log file 
						3 - The free disk space
	BP Version(s):	N/A
	Usage:			The "Blue Prism Database Name Here" needs replacing with the name of your Blue Prism database

	*** The script is to be tested in lower route to live environments (Development / Test / UAT / SIT) and the results verified before being run against a Production environment ***

	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
*/
-- Set database context
USE [Blue Prism Database Name Here];
GO

-- Set transaction isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declare variables
DECLARE @DatabaseID INT;

-- Set @DatabaseID to the database id of the Blue Prism database
SELECT @DatabaseID = DB_ID();

-- Show how many records are left to delete
SELECT COUNT(WQI.id) AS RecordsToDelete
FROM BPAWorkQueueItem AS WQI
INNER JOIN DeletedWorkQueueItems_Maintenance AS WM
    ON WM.WorkQueueItemID = WQI.id;

-- Show the Blue Prism database transaction log file size
SELECT DB_NAME(database_id) AS DatabaseName,
	Left(physical_name, 3) AS TransactionLogDrive,
	((size * 8) / 1024) AS TransactionLogFileSizeMB
FROM sys.master_files
WHERE database_id = @DatabaseID
	AND [type] = 1;

-- Show the disk free space
EXEC xp_fixeddrives;
GO