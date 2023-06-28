/****** Create [BPC].[aasp_create_New_Sessionlog_partition] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[aasp_create_New_Sessionlog_partition]',N'P')) IS NULL
BEGIN
DECLARE @aasp_create_New_Sessionlog_partition NVARCHAR(MAX) = 


'
-- =============================================
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] ''[dbo].[BPASessionLog_NonUnicode]'',''PF_Dynamic_NU''
-- variable description: 
--	@tablename - Partitioned table name, 
--  @partitionfunction - partition function
-- =============================================

CREATE PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition]
@tablename NVARCHAR(400),@partitionfunction NVARCHAR(50)

AS

DECLARE @nextPartitionID BIGINT
SELECT @nextPartitionID = IDENT_CURRENT(@tablename)




---Test if partitiopn already exist and create the next partiton
IF @nextPartitionID IS NOT NULL
BEGIN
IF NOT EXISTS(
SELECT prv.value
FROM sys.partition_functions AS pf
join sys.partition_range_values AS prv ON pf.function_id = prv.function_id
WHERE pf.name = @partitionfunction AND prv.value = @nextPartitionID
)
BEGIN
alter partition scheme PS_Dynamic_NU next used [primary];
alter partition function PF_Dynamic_NU() split range(@nextPartitionID);
END
ELSE
BEGIN
PRINT ''Partition already exists'';
END
END
'
EXECUTE SP_EXECUTESQL @aasp_create_New_Sessionlog_partition
END
