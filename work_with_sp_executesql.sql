DECLARE @Tablename NVARCHAR(255) = 'BPASessionLog_NonUnicodeOATest';
DECLARE @tableSchema varchar(10) = 'ARCH'
DECLARE @maxlogidout BIGINT;
DECLARE @params1 NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT'
DECLARE @SQL1 NVARCHAR(4000) = 'select top 1 @maxlogid = max(logid) from ' +@tableSchema +'.'+@tableName

declare @minlogid bigint, @copiedMaxlogid bigint, @watermarklogid bigint,
 @currentMaxlogid bigint, @targetCopymaxid bigint, @strcommand nvarchar(400),@rowamt bigint
 
 set @rowamt = 2 




 

select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
select @copiedMaxlogid
set @targetCopymaxid = @copiedMaxlogid + @rowamt

EXEC sp_executeSQL @SQL1, @params1, @maxlogid = @maxlogidout OUTPUT;
select @maxlogidout'currentMaxlogid',@copiedMaxlogid'copiedMaxlogid',
@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'