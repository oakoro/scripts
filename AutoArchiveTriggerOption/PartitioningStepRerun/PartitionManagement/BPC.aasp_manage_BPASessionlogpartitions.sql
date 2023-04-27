ALTER PROCEDURE BPC.aasp_manage_BPASessionlogpartitions

AS
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition] 
   @tablename = '[ARCH].[BPASessionLog_NonUnicodeOATest]'
  ,@partitionfuntion = 'PF_dynamicBPASessionLogPartition'


-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] 
   @tableschema = 'ARCH'
  ,@tablename = 'BPASessionLog_NonUnicodeOATest'
  ,@partitionfuntion = 'PF_dynamicBPASessionLogPartition'
  ,@partitionsretained = 6



