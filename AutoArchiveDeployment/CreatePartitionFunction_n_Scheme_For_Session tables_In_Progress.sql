DECLARE @maxlogidout BIGINT;
DECLARE @params1 NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT'
DECLARE @SQL1 NVARCHAR(4000) --= 'select top 1 @maxlogid = max(logid) from ' +@tableSchema +'.'+@tableName
DECLARE @LoggingType bit, @sessionlogtable nvarchar(50)
DECLARE @nextPartitionID bigint --Maximum logid or seed value in BPASessionLog Table
DECLARE @partitionseedValue bigint --Partition function seed value

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
if @LoggingType = 0 
set @sessionlogtable = 'dbo.BPASessionLog_NonUnicode'
else set @sessionlogtable = 'dbo.BPASessionLog_Unicode'

set @SQL1 = 'select top 1 @maxlogid = max(logid) from ' +@sessionlogtable
print (@SQL1)

EXEC sp_executeSQL @SQL1, @params1, @maxlogid = @maxlogidout OUTPUT;
select @maxlogidout
if @maxlogidout is null set @nextPartitionID = 0 else set @nextPartitionID =  @maxlogidout
select @nextPartitionID

--declare @minlogid bigint, @copiedMaxlogid bigint, @watermarklogid bigint,
-- @currentMaxlogid bigint, @targetCopymaxid bigint, @strcommand nvarchar(400),@rowamt bigint
 
-- set @rowamt = 2 




 

--select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
--select @copiedMaxlogid
--set @targetCopymaxid = @copiedMaxlogid + @rowamt

--EXEC sp_executeSQL @SQL1, @params1, @maxlogid = @maxlogidout OUTPUT;
--select @maxlogidout'currentMaxlogid',@copiedMaxlogid'copiedMaxlogid',
--@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'