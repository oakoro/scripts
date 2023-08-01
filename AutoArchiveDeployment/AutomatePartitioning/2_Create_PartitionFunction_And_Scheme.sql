DECLARE @maxlogidout BIGINT;
DECLARE @params NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT'
DECLARE @strMaxLogid NVARCHAR(400) 
DECLARE @createPartitionFunction NVARCHAR(400)
DECLARE @createPartitionScheme NVARCHAR(400)
DECLARE @loggingType BIT 
DECLARE @sessionlogtable NVARCHAR(50)
DECLARE @nextPartitionID BIGINT --Maximum logid or seed value in BPASessionLog Table
DECLARE @partitionseedValue BIGINT --Partition function seed value


/*                                          
Creating Partition logging table
*/
IF (OBJECT_ID(N'[DBO].[PartitionAuditLog]',N'U')) IS NULL
BEGIN
CREATE TABLE PartitionAuditLog(
[StepNo] tinyint IDENTITY(1,1),
[ActionPerformed] varchar(200),
[TimeStamp] datetime DEFAULT getdate()
)
END


SELECT @loggingType = unicodeLogging FROM BPASysConfig
--set @LoggingType = 1
IF @loggingType = 0 
SET @sessionlogtable = 'dbo.BPASessionLog_NonUnicode'
ELSE SET @sessionlogtable = 'dbo.BPASessionLog_Unicode'

SET @strMaxLogid = 'select @maxlogid = max(logid) from ' +@sessionlogtable
--PRINT (@strMaxLogid)

EXEC sp_executeSQL @strMaxLogid, @params, @maxlogid = @maxlogidout OUTPUT;
--select ISNULL(@maxlogidout,0) '@maxlogidout'
IF @maxlogidout is null SET @nextPartitionID = 0 ELSE SET @nextPartitionID =  @maxlogidout
--select @nextPartitionID '@nextPartitionID'

/**Create partition function and scheme **/

IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
SET @createPartitionFunction = 'CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES('+CONVERT(NVARCHAR(20),@nextPartitionID)+')'	
PRINT (@createPartitionFunction)

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES(@createPartitionFunction);

--EXEC (@createPartitionFunction)
END
IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
SET @createPartitionScheme = 'CREATE PARTITION SCHEME [PS_Dynamic_NU] AS PARTITION PF_Dynamic_NU ALL TO ([PRIMARY])'
PRINT (@createPartitionScheme)

INSERT DBO.PartitionAuditLog([ActionPerformed])
VALUES(@createPartitionScheme);

--EXEC (@createPartitionScheme)
END


