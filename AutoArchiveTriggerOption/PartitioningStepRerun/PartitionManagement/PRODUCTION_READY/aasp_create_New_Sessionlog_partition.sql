/****** Object:  StoredProcedure [BPC].[aasp_create_New_Sessionlog_partition]    Script Date: 27/04/2023 12:45:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:      Oke Akoro
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] '[dbo].[BPASessionLog_NonUnicode]','PF_Dynamic_NU'
-- variable description: 
--	@tablename - Partitioned table name, 
--  @partitionfuntion - partition function
-- =============================================

ALTER PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition]
@tablename NVARCHAR(400),@partitionfuntion NVARCHAR(50)

AS

DECLARE @nextPartitionID BIGINT
SELECT @nextPartitionID = IDENT_CURRENT(@tablename)
--select @nextPartitionID 'NextPartiton'



---Test if partitiopn already exist and create the next partiton
IF @nextPartitionID IS NOT NULL
BEGIN
IF NOT EXISTS(
SELECT prv.value
FROM sys.partition_functions AS pf
join sys.partition_range_values AS prv ON pf.function_id = prv.function_id
WHERE pf.name = @partitionfuntion AND prv.value = @nextPartitionID
)
BEGIN
alter partition scheme PS_Dynamic_NU next used [primary];
alter partition function PF_Dynamic_NU() split range(@nextPartitionID);
END
ELSE
BEGIN
PRINT 'Partition already exists';
END
END
GO


