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
@partitionfunction NVARCHAR(50) = ''PF_Dynamic_NU''

AS

DECLARE @nextPartitionID BIGINT,
		@LoggingType BIT,
		@sessionlogtable NVARCHAR(50)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = ''BPASessionLog_NonUnicode''
	ELSE SET @sessionlogtable = ''BPASessionLog_Unicode''

SELECT @nextPartitionID = IDENT_CURRENT(@sessionlogtable)

---Test if partitiopn already exist and create the next partiton
IF @nextPartitionID IS NOT NULL 
BEGIN
IF NOT EXISTS(
SELECT prv.value
FROM sys.partition_functions AS pf
JOIN sys.partition_range_values AS prv ON pf.function_id = prv.function_id
WHERE pf.name = @partitionfunction AND prv.value = @nextPartitionID
)
BEGIN
ALTER PARTITION SCHEME PS_Dynamic_NU NEXT used [primary];
ALTER PARTITION FUNCTION PF_Dynamic_NU() SPLIT RANGE(@nextPartitionID);
END
ELSE
BEGIN
PRINT ''Partition already exists'';
END
END
'
EXECUTE SP_EXECUTESQL @aasp_create_New_Sessionlog_partition
END
ELSE
BEGIN
DECLARE @alter_aasp_create_New_Sessionlog_partition NVARCHAR(MAX) = '

-- =============================================
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] 
-- variable description: 
--	@sessionlogtable - Partitioned table name, 
--  @partitionfunction - partition function
-- Automate for unicode and non-unicode
-- ==============================================

ALTER PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition]
@partitionfunction NVARCHAR(50) = ''PF_Dynamic_NU''

AS

DECLARE @nextPartitionID BIGINT,
		@LoggingType BIT,
		@sessionlogtable NVARCHAR(50)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = ''BPASessionLog_NonUnicode''
	ELSE SET @sessionlogtable = ''BPASessionLog_Unicode''

SELECT @nextPartitionID = IDENT_CURRENT(@sessionlogtable)

---Test if partitiopn already exist and create the next partiton
IF @nextPartitionID IS NOT NULL 
BEGIN
IF NOT EXISTS(
SELECT prv.value
FROM sys.partition_functions AS pf
JOIN sys.partition_range_values AS prv ON pf.function_id = prv.function_id
WHERE pf.name = @partitionfunction AND prv.value = @nextPartitionID
)
BEGIN
ALTER PARTITION SCHEME PS_Dynamic_NU NEXT used [primary];
ALTER PARTITION FUNCTION PF_Dynamic_NU() SPLIT RANGE(@nextPartitionID);
END
ELSE
BEGIN
PRINT ''Partition already exists'';
END
END'

EXECUTE SP_EXECUTESQL @alter_aasp_create_New_Sessionlog_partition
END