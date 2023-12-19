/****** Object:  StoredProcedure [BPC].[aasp_manage_BPASessionlogpartitions]    Script Date: 11/12/2023 12:41:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =====================================================================================
-- Description: Master stored procedure that calls BPASessionlog partition management SPs
-- Script execution Example: BPC.aasp_manage_BPASessionlogpartitions
-- Alter statement added to change partition retention from 6 to 5
-- Script adjusted to check for data partitioning before run
-- Automate for unicode and non-unicode
-- Partition session log table if non partitioned
-- =======================================================================================

CREATE OR ALTER   PROCEDURE [BPC].[aasp_manage_BPASessionlogpartitions]

AS
IF EXISTS(SELECT 1 FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode'))
BEGIN
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition];

-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] @partitionsretained = 5;
END
ELSE
BEGIN
-- Partition session log table  
EXECUTE [BPC].[aasp_create_new_partition_BPASessionlog];
END
  
GO


