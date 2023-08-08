/****** Create [BPC].[aasp_manage_BPASessionlogpartitions] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[aasp_manage_BPASessionlogpartitions]',N'P')) IS NULL
BEGIN
DECLARE @aasp_manage_BPASessionlogpartitions NVARCHAR(MAX) = '

-- =============================================
-- Description: Master stored procedure that calls BPASessionlog partition management SPs
-- Script execution Example: BPC.aasp_manage_BPASessionlogpartitions
-- =============================================

CREATE PROCEDURE [BPC].[aasp_manage_BPASessionlogpartitions]

AS
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition] 
   @tablename = ''[dbo].[BPASessionLog_NonUnicode]''
  ,@partitionfunction = ''PF_Dynamic_NU''


-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] 
   @tableschema = ''dbo''
  ,@tablename = ''BPASessionLog_NonUnicode''
  ,@partitionfunction = ''PF_Dynamic_NU''
  ,@partitionsretained = 5
  '

EXECUTE SP_EXECUTESQL @aasp_manage_BPASessionlogpartitions
END