/****** Object:  StoredProcedure [BPC].[aasp_create_New_Sessionlog_partition]    Script Date: 20/09/2023 17:39:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] 
-- variable description: 
--	@sessionlogtable - Partitioned table name, 
--  @partitionfunction - partition function
-- Automate for unicode and non-unicode
-- ==============================================

ALTER PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition]
@partitionfunction NVARCHAR(50) = 'PF_Dynamic_NU'

AS

DECLARE @nextPartitionID BIGINT,
		@LoggingType BIT,
		@sessionlogtable NVARCHAR(50)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SELECT @nextPartitionID = IDENT_CURRENT(@sessionlogtable)

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
PRINT 'Partition already exists';
END
END
GO


