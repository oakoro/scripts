
SET NOCOUNT ON

DECLARE @tbl TABLE (
partition_number TINYINT,
[PercentIncrease] DECIMAL(5,2)
)


;WITH cte_init
AS
(
SELECT p.partition_number, SUM(u.used_pages) * 8/1024 AS Used_Space_Mb,
	   LAG(SUM(u.used_pages) * 8/1024) over (order by p.partition_number) as previous_size
FROM sys.allocation_units AS u
JOIN sys.partitions AS p ON u.container_id = p.hobt_id
JOIN sys.tables AS t ON p.object_id = t.object_id
WHERE OBJECT_NAME(t.object_id) = 'BPASessionLog_NonUnicode'
GROUP BY p.partition_number      

),
cte_calc
AS
(
SELECT partition_number,Used_Space_Mb,previous_size, 
CONVERT(DECIMAL(10,2),(CONVERT(DECIMAL(10,2),Used_Space_Mb) - CONVERT(DECIMAL(10,2),previous_size))/CONVERT(DECIMAL(10,2),previous_size)*100) [PercentIncrease]
FROM cte_init 
WHERE previous_size != 0

)
INSERT @tbl(partition_number,PercentIncrease)
SELECT partition_number,PercentIncrease FROM cte_calc ORDER by partition_number


DECLARE @count TINYINT, @percentIncrease DECIMAL(10,2),@partition_number TINYINT

SELECT @count = COUNT(*) FROM @tbl

WHILE @count > 0
BEGIN
SELECT TOP 1 @partition_number = partition_number ,@percentIncrease = PercentIncrease FROM @tbl
	IF @percentIncrease > 25
	BEGIN
	

	DECLARE @startdate DATETIME = GETDATE()-14


	;
	WITH cte_process_log
	AS
	(
	SELECT l.logid, s.startdatetime, p.name,
	(ISNULL(DATALENGTH(l.[result]), 0) + ISNULL(DATALENGTH(l.[attributexml]), 0)) [data_size]
	FROM dbo.BPASessionLog_NonUnicode l WITH (NOLOCK)
	JOIN dbo.BPASession s WITH (NOLOCK) ON l.sessionnumber = s.sessionnumber
	JOIN dbo.BPAProcess p WITH (NOLOCK) ON p.processid = s.processid
	WHERE s.startdatetime > @startdate

	)
	SELECT top 1 [name] [ProcessName], 
	SUM([data_size])/1024/1024 [Data_size_MB]
	FROM cte_process_log
	GROUP BY [name]
	ORDER BY [Data_size_MB] desc

	BREAK
	END

DELETE @tbl WHERE partition_number = @partition_number	
SET @count -= 1

END