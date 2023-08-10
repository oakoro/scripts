DECLARE @maxlogidout BIGINT,
		@params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT',
		@strMaxLogid NVARCHAR(400), 
		@createPartitionFunction NVARCHAR(400),
		@createPartitionScheme NVARCHAR(400),
		@loggingType BIT ,
		@sessionlogtable NVARCHAR(50),
		@nextPartitionID BIGINT, --Maximum logid or seed value in BPASessionLog Table
		@partitionseedValue BIGINT, --Partition function seed value
		@debug BIT = 1


SET NOCOUNT ON;

/*                                          
Creating Partition logging table
*/
IF @debug  = 0
BEGIN
IF (OBJECT_ID(N'[DBO].[PartitionAuditLog]',N'U')) IS NULL
BEGIN
CREATE TABLE PartitionAuditLog(
[StepNo] TINYINT IDENTITY(1,1),
[ActionPerformed] VARCHAR(200),
[TimeStamp] DATETIME DEFAULT getdate()
)
END
END


SELECT @loggingType = unicodeLogging FROM BPASysConfig
--set @LoggingType = 1
IF @loggingType = 0 
SET @sessionlogtable = 'dbo.BPASessionLog_NonUnicode'
ELSE SET @sessionlogtable = 'dbo.BPASessionLog_Unicode'

SET @strMaxLogid = 'select @maxlogid = max(logid) from ' +@sessionlogtable

EXEC sp_executeSQL @strMaxLogid, @params, @maxlogid = @maxlogidout OUTPUT;

IF @maxlogidout is null SET @nextPartitionID = 0 ELSE SET @nextPartitionID =  @maxlogidout


/**Create partition function and scheme **/

IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
SET @createPartitionFunction = 'CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES('+CONVERT(NVARCHAR(20),@nextPartitionID)+')'	

IF @debug = 1
BEGIN
PRINT (@createPartitionFunction)
END
ELSE
BEGIN
EXEC (@createPartitionFunction);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('Create Partition Function');
END

END
IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
SET @createPartitionScheme = 'CREATE PARTITION SCHEME [PS_Dynamic_NU] AS PARTITION PF_Dynamic_NU ALL TO ([PRIMARY])'

IF @debug = 1
BEGIN
PRINT (@createPartitionScheme)
END
ELSE
BEGIN
EXEC (@createPartitionScheme);

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES('Create Partition Scheme');
END

END


