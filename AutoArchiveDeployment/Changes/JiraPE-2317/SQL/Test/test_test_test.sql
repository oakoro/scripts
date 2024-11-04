declare @tablename varchar(100),@deltacol varchar(100),@lastDateCopied DATETIME,
		@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql nvarchar(400),
		@maxCount INT = 500, @sql2 nvarchar(400),@sql3 nvarchar(400)

DECLARE @hold TABLE (currCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)

set @lastDateCopied = '1900-01-01 00:00:00.000'
set @maxDate = getdate()--'2021-05-17 13:24:11.040'
select top 1 @tablename = tablename, @deltacol = deltacolumn from BPC.adf_watermark where tablename not in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')

select @tablename, @deltacol

--SET @sql3 = 'SELECT count(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE finished > ''' +convert(nvarchar(20),@lastDateCopied)+'''' --+' AND '+@deltacol +' <= '+@maxDate 
--SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +convert(nvarchar(20),@lastDateCopied)+'''' +' AND '+@deltacol +' <= '''+convert(nvarchar(20),@maxDate)+''''
SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +convert(nvarchar(20),@lastDateCopied)+'''' +' AND '+@deltacol +' <= '''+convert(nvarchar(20),@maxDate)+''''

print (@sql3)
--exec (@sql3)
INSERT @tblcurrCount
	EXEC (@sql3)

SELECT * FROM @tblcurrCount

IF (SELECT * FROM @tblcurrCount) > @maxCount
		BEGIN
		SET @sql2 = 'SELECT TOP('+convert(nvarchar(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '''+convert(nvarchar(20),@lastDateCopied) +''' ORDER BY '+@deltacol 
		PRINT (@sql2)
		END

--select top 10* from BPAWorkQueueItem
SELECT TOP(500) finished FROM dbo.BPAWorkQueueItem WITH (NOLOCK) WHERE finished > 'Jan  1 1900 12:00AM' ORDER BY finished