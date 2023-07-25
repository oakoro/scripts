
declare @sessionnumber bigint

with get_oldest_session_to_retain
as
(
select
sessionnumber,
startdatetime
from
dbo.bpasession with (nolock)
where datediff(dd,convert(date,startdatetime),convert(date,getdate())) = 7
)
select top 1 @sessionnumber = sessionnumber from get_oldest_session_to_retain
order by startdatetime 
 
select @sessionnumber

select top 1 logid
from
dbo.BPASessionLog_NonUnicode with (nolock)
where sessionnumber = @sessionnumber
order by logid

--select count(*) from dbo.BPASessionLog_NonUnicode with (nolock) where logid > 137126109

DECLARE @cutoverSessionnumber INT, 	@daysToRetain TINYINT = 7,
		@LoggingType BIT, @sessionlogtable NVARCHAR(50),
		@cutoverLogidout BIGINT,@retainSessionLogCountout BIGINT, 
		@retainSessionLogCount NVARCHAR(400),
		@strcutoverLogid NVARCHAR(400), @str@retainSessionLog NVARCHAR(400),
		@param1 NVARCHAR(255) = '@cutoverLogid BIGINT OUTPUT',
		@param2 NVARCHAR(255) = '@retainSessionLogCount BIGINT OUTPUT',
		@ckamt BIGINT = 10000000

SELECT @LoggingType = unicodeLogging FROM BPASysConfig

IF @LoggingType = 0
  SET @sessionlogtable = 'BPASessionLog_NonUnicode'
  ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SELECT TOP 1 @cutoverSessionnumber =
sessionnumber
FROM
dbo.bpasession WITH (NOLOCK)
WHERE DATEDIFF(dd,CONVERT(DATE,startdatetime),CONVERT(DATE,GETDATE())) = @daysToRetain
ORDER BY startdatetime --DESC
 select @cutoverSessionnumber

SET @strcutoverLogid = '
select top 1 @cutoverLogid = logid
from dbo.' +@sessionlogtable +' with (nolock) where sessionnumber = ' +CONVERT(NVARCHAR(20),@cutoverSessionnumber) +' order by logid;'

EXEC sp_executeSQL @strcutoverLogid, @param1, @cutoverLogid = @cutoverLogidout OUTPUT;
select @cutoverLogidout

SET @str@retainSessionLog = ' 
select @retainSessionLogCount = count(*) from dbo.'+@sessionlogtable +' with (nolock)
where logid > '+CONVERT(NVARCHAR(20),@cutoverLogidout) +';
'
EXEC sp_executeSQL @str@retainSessionLog, @param2, @retainSessionLogCount = @retainSessionLogCountout OUTPUT;
select @retainSessionLogCountout
SELECT
@@SERVERNAME AS [ServerName],
GETDATE() AS [Date_Run],
SCHEMA_NAME(o.Schema_ID) AS [SchemaName],
OBJECT_NAME(p.object_id) AS [ObjectName],
CAST(SUM(ps.reserved_page_count) * 8.0 / 1024 AS DECIMAL(19,2)) AS [ObjectSizeMB],
SUM(p.Rows) AS [TotalRowCount],
SUM(p.Rows) / @ckamt AS [DaysToCatchup],
@retainSessionLogCountout AS [RetainedRowCount],
CONVERT(DECIMAL(19,2),CONVERT(DECIMAL(19,2),@retainSessionLogCountout)/SUM(p.Rows)*CONVERT(DECIMAL(19,2),(SUM(ps.reserved_page_count) * 8.0 / 1024))) AS [RetainedSizeMB]
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.partitions AS p WITH (NOLOCK)
ON p.object_id = o.object_id
INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK)
ON p.object_id = ps.object_id
WHERE ps.index_id < 2 -- ignore the partitions from the non-clustered indexes if any
AND p.index_id < 2    -- ignore the partitions from the non-clustered indexes if any
AND o.type_desc = N'USER_TABLE'
AND SCHEMA_NAME(o.Schema_ID) = 'dbo'
AND OBJECT_NAME(p.object_id) = @sessionlogtable
GROUP BY  SCHEMA_NAME(o.Schema_ID), p.object_id--ps.reserved_page_count, p.data_compression_desc
ORDER BY SUM(ps.reserved_page_count) DESC, SUM(p.Rows) DESC OPTION (RECOMPILE);