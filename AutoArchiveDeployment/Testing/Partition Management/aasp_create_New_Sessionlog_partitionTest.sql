/****** Object:  StoredProcedure [BPC].[aasp_create_New_Sessionlog_partition]    Script Date: 03/10/2023 10:53:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partitionTest] '[dbo].[BPASessionLog_NonUnicode]','PF_Dynamic_NU'
-- variable description: 
--	@tablename - Partitioned table name, 
--  @partitionfunction - partition function
-- =============================================

ALTER PROCEDURE [BPC].[aasp_create_New_Sessionlog_partitionTest]
@tablename NVARCHAR(400),@partitionfunction NVARCHAR(50)

AS

DECLARE @nextPartitionID BIGINT
SELECT @nextPartitionID = IDENT_CURRENT(@tablename)

DECLARE @alterpartitionscheme NVARCHAR(400), 
		@alterpartitionfunction NVARCHAR(400)




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
--alter partition scheme PS_Dynamic_NU next used [primary];
--alter partition function PF_Dynamic_NU() split range(@nextPartitionID);
SET @alterpartitionscheme = 'alter partition scheme PS_Dynamic_NU next used [primary];'
SET @alterpartitionfunction = 'alter partition function PF_Dynamic_NU() split range('+CONVERT(NVARCHAR(20),@nextPartitionID)+');'

SELECT @alterpartitionscheme '@alterpartitionscheme',@alterpartitionfunction '@alterpartitionfunction'
END
ELSE
BEGIN
PRINT 'Partition already exists';
END
END
GO


