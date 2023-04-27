-- =============================================
-- Author:      Oke Akoro
-- Description: Master stored procedure that calls BPASessionlog partition management SPs
-- Script execution Example: BPC.aasp_manage_BPASessionlogpartitions
-- =============================================

CREATE PROCEDURE BPC.aasp_manage_BPASessionlogpartitions

AS
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition] 
   @tablename = '[dbo].[BPASessionLog_NonUnicode]'
  ,@partitionfuntion = 'PF_Dynamic_NU'


-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] 
   @tableschema = 'dbo'
  ,@tablename = 'BPASessionLog_NonUnicode'
  ,@partitionfuntion = 'PF_Dynamic_NU'
  ,@partitionsretained = 6



