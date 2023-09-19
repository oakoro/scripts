/****** Create [BPC].[aasp_manage_BPASessionlogpartitions] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[aasp_manage_BPASessionlogpartitions]',N'P')) IS NULL
BEGIN
DECLARE @aasp_manage_BPASessionlogpartitions NVARCHAR(MAX) = '

-- ======================================================================================
-- Description: Master stored procedure that calls BPASessionlog partition management SPs
-- Script execution Example: BPC.aasp_manage_BPASessionlogpartitions
-- =====================================================================================

CREATE PROCEDURE [BPC].[aasp_manage_BPASessionlogpartitions]

AS
IF EXISTS(SELECT 1 FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in (''BPASessionLog_NonUnicode'',''BPASessionLog_Unicode''))
BEGIN
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition] 
   @tablename = ''[dbo].[BPASessionLog_NonUnicode]''
  ,@partitionfunction = ''PF_Dynamic_NU'';


-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] 
   @tableschema = ''dbo''
  ,@tablename = ''BPASessionLog_NonUnicode''
  ,@partitionfunction = ''PF_Dynamic_NU''
  ,@partitionsretained = 5;
  END
  '
EXECUTE SP_EXECUTESQL @aasp_manage_BPASessionlogpartitions
END
ELSE
BEGIN
DECLARE @alter_aasp_manage_BPASessionlogpartitions NVARCHAR(MAX) = '

-- =====================================================================================
-- Description: Master stored procedure that calls BPASessionlog partition management SPs
-- Script execution Example: BPC.aasp_manage_BPASessionlogpartitions
-- Alter statement added to change partition retention from 6 to 5
-- =======================================================================================

ALTER PROCEDURE [BPC].[aasp_manage_BPASessionlogpartitions]

AS
IF EXISTS(SELECT 1 FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in (''BPASessionLog_NonUnicode'',''BPASessionLog_Unicode''))
BEGIN
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition] 
   @tablename = ''[dbo].[BPASessionLog_NonUnicode]''
  ,@partitionfunction = ''PF_Dynamic_NU'';


-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] 
   @tableschema = ''dbo''
  ,@tablename = ''BPASessionLog_NonUnicode''
  ,@partitionfunction = ''PF_Dynamic_NU''
  ,@partitionsretained = 5;
  END'

EXECUTE SP_EXECUTESQL @alter_aasp_manage_BPASessionlogpartitions
END


