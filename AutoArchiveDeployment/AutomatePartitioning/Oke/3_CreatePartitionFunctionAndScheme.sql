DECLARE @maxlogidout BIGINT,
		@params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT',
		@strMaxLogid NVARCHAR(400), 
		@createPartitionFunction NVARCHAR(400),
		@createPartitionScheme NVARCHAR(400),
		@loggingType BIT ,
		@sessionlogtable NVARCHAR(50),
		@nextPartitionID BIGINT, --Maximum logid or seed value in BPASessionLog Table
		@partitionseedValue BIGINT --Partition function seed value
		


SET NOCOUNT ON;



SELECT @loggingType = unicodeLogging FROM BPASysConfig

IF @loggingType = 0 
SET @sessionlogtable = 'dbo.BPASessionLog_NonUnicodeCopy'
ELSE SET @sessionlogtable = 'dbo.BPASessionLog_UnicodeCopy'

SET @strMaxLogid = 'select @maxlogid = max(logid) from ' +@sessionlogtable

EXEC sp_executeSQL @strMaxLogid, @params, @maxlogid = @maxlogidout OUTPUT;


IF @maxlogidout is null SET @nextPartitionID = 0 ELSE SET @nextPartitionID =  @maxlogidout + 1


/**Create partition function and scheme **/

IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
SET @createPartitionFunction = 'CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES('+CONVERT(NVARCHAR(20),@nextPartitionID)+')'	

EXEC (@createPartitionFunction);


END


IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
SET @createPartitionScheme = 'CREATE PARTITION SCHEME [PS_Dynamic_NU] AS PARTITION PF_Dynamic_NU ALL TO ([PRIMARY])'


EXEC (@createPartitionScheme);


END


