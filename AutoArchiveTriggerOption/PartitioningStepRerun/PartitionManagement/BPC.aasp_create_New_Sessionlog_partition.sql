/****** Object:  StoredProcedure [BPC].[aasp_create_New_Sessionlog_partition]    Script Date: 19/04/2023 11:22:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Oke Akoro
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] '[ARCH].[BPASessionLog_NonUnicodeOATest]','PF_dynamicBPASessionLogPartition'
-- variable description: 
--	@tablename - Partitioned table name, 
--  @partitionfuntion - partition function
-- =============================================

CREATE procedure [BPC].[aasp_create_New_Sessionlog_partition]
@tablename nvarchar(400),@partitionfuntion nvarchar(50)

as

declare @nextPartitionID bigint
select @nextPartitionID = IDENT_CURRENT(@tablename)
select @nextPartitionID 'NextPartiton'



---Test if partitiopn already exist and create the next partiton
if not exists(
select prv.value
from sys.partition_functions as pf
join sys.partition_range_values as prv on pf.function_id = prv.function_id
where pf.name = @partitionfuntion and prv.value = @nextPartitionID
)
begin
alter partition scheme PS_dynamicBPASessionLogPartition next used [primary];
alter partition function PF_dynamicBPASessionLogPartition() split range(@nextPartitionID);
end
else
begin
Print 'Partition already exists';
end
GO


