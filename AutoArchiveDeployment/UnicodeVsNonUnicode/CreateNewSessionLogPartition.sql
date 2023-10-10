--@partitionfunction NVARCHAR(50) NVARCHAR(50) = 'PF_Dynamic_NU'

--AS

DECLARE @nextPartitionID BIGINT,
		@LoggingType BIT,
		@sessionlogtable NVARCHAR(50),
		@partitionscheme NVARCHAR(50),
		@strnextusedpartitionprimary NVARCHAR(200),
		@str@alterpartation NVARCHAR(200),
		@partitionfunction NVARCHAR(50)

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	--SET @LoggingType = 1
	IF @LoggingType = 0
	BEGIN
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	SET @partitionfunction = 'PF_Dynamic_NU_New'
	END
	ELSE 
	BEGIN
	SET @sessionlogtable = 'BPASessionLog_UnicodeTest1'
	SET @partitionfunction = 'PF_Dynamic_NUTest'
	END

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
SET @str@alterpartation = 'ALTER PARTITION FUNCTION '+@partitionfunction +'() SPLIT RANGE('+CONVERT(NVARCHAR(50),@nextPartitionID)+');'

PRINT @strnextusedpartitionprimary
PRINT @str@alterpartation
END
ELSE
BEGIN
PRINT 'Partition already exists';
END
END