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

ALTER PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition20231004]
@partitionfunction NVARCHAR(50) = 'PF_Dynamic_NU_New'

AS

DECLARE @nextPartitionID BIGINT,
		@LoggingType BIT,
		@sessionlogtable NVARCHAR(50),
		@partitionscheme NVARCHAR(50),
		@strnextusedpartitionprimary NVARCHAR(200),
		@str@alterpartation NVARCHAR(200)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SELECT @nextPartitionID = IDENT_CURRENT(@sessionlogtable)

SELECT @partitionscheme = ps.name 
FROM sys.tables t
INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    AND i.type IN (0,1)
INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions pf
	ON ps.function_id = pf.function_id
WHERE pf.name = @partitionfunction AND t.name = @sessionlogtable

select @partitionscheme,@nextPartitionID

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
SET @strnextusedpartitionprimary = 'ALTER PARTITION SCHEME '+@partitionscheme +' NEXT used [primary];'
SET @str@alterpartation = 'ALTER PARTITION FUNCTION '+@partitionfunction +'() SPLIT RANGE('+convert(nvarchar(50),@nextPartitionID)+');'

print @strnextusedpartitionprimary
print @str@alterpartation
EXEC sp_executesql @strnextusedpartitionprimary
EXEC sp_executesql @str@alterpartation

END
ELSE
BEGIN
PRINT 'Partition already exists';
END
END





