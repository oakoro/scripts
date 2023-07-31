DECLARE @cutoverSessionnumber INT, 	@daysToRetain TINYINT = 7,
		@LoggingType BIT, @sessionlogtable NVARCHAR(50),
		@cutoverLogidout BIGINT,@retainSessionLogCountout BIGINT, 
		@sessionLogCopiedout BIGINT,
		@retainSessionLogCount NVARCHAR(400),
		@strcutoverLogid NVARCHAR(400), @str@retainSessionLog NVARCHAR(400),
		@strsessionlogcopied NVARCHAR(200),
		@param1 NVARCHAR(255) = '@cutoverLogid BIGINT OUTPUT',
		@param2 NVARCHAR(255) = '@retainSessionLogCount BIGINT OUTPUT',
		@param3 NVARCHAR(255) = '@sessionLogCopied BIGINT OUTPUT',
		@ckamt BIGINT = 10000000,
		@logcopied BIGINT


SELECT @LoggingType = unicodeLogging FROM BPASysConfig

IF @LoggingType = 0
  SET @sessionlogtable = 'BPASessionLog_NonUnicode'
  ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SELECT TOP 1 @cutoverSessionnumber =
sessionnumber
FROM
dbo.bpasession WITH (NOLOCK)
WHERE DATEDIFF(dd,CONVERT(DATE,startdatetime),CONVERT(DATE,GETDATE())) = @daysToRetain
ORDER BY startdatetime

SET @strcutoverLogid = '
select top 1 @cutoverLogid = logid
from dbo.' +@sessionlogtable +' with (nolock) where sessionnumber = ' +CONVERT(NVARCHAR(20),@cutoverSessionnumber) +' order by logid;'

EXEC sp_executeSQL @strcutoverLogid, @param1, @cutoverLogid = @cutoverLogidout OUTPUT;

SET @cutoverLogidout = @cutoverLogidout - 1

SET @str@retainSessionLog = ' 
select @retainSessionLogCount = count(*) from dbo.'+@sessionlogtable +' with (nolock)
where logid > '+CONVERT(NVARCHAR(20),@cutoverLogidout) +';
'
EXEC sp_executeSQL @str@retainSessionLog, @param2, @retainSessionLogCount = @retainSessionLogCountout OUTPUT;

IF EXISTS (SELECT 1 FROM SYS.tables WHERE name = 'adf_watermark' AND SCHEMA_NAME(SCHEMA_ID) = 'BPC') 
BEGIN
	SET @strsessionlogcopied = 'SELECT @sessionlogcopied = logid FROM [BPC].[adf_watermark] WHERE tablename = '''+@sessionlogtable+''''
	EXEC sp_executeSQL @strsessionlogcopied,@param3,@sessionlogcopied = @sessionLogCopiedout OUTPUT;
	
END;


WITH cte_1
AS
(SELECT 
s.Name AS SchemaName,
t.name,
p.partition_number,
p.rows,
a.used_pages,
a.total_pages
FROM
sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name = @sessionlogtable
)
,cte_2
AS
(
SELECT DISTINCT SchemaName,name, partition_number,rows,
CAST(ROUND((SUM(used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(total_pages) - SUM(used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
 FROM cte_1
GROUP BY SchemaName,name,partition_number,rows
)
SELECT DISTINCT 
@@SERVERNAME AS [ServerName],
GETDATE() AS [Date_Run],
SchemaName, name AS [ObjectName], 
SUM(Used_MB) AS [ObjectSizeMB],
SUM(rows)  AS [TotalRowCount],
ISNULL(@sessionLogCopiedout,0) AS [SessionLogCopied],
ISNULL(SUM(Rows) / @ckamt,0) AS [OriginalDaysToCatchup],
(SUM(rows) - ISNULL(@sessionLogCopiedout,0))/@ckamt AS [CurrentDaysToCatchup],
ISNULL(@retainSessionLogCountout,0) AS [RetainedRowCount],
ISNULL(CONVERT(DECIMAL(19,2),CONVERT(DECIMAL(19,2),@retainSessionLogCountout)/SUM(rows)*SUM(Used_MB)),0) AS [RetainedSizeMB]
FROM cte_2
GROUP BY SchemaName, name
ORDER BY SUM(rows) desc
