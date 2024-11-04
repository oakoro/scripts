DECLARE @tablename VARCHAR(100),@deltacol VARCHAR(100),@lastDateCopied DATETIME,
		@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql NVARCHAR(400),
		@maxCount INT = 500, @sql2 NVARCHAR(400),@sql3 NVARCHAR(400)

DECLARE @hold TABLE (currCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)

SELECT @tablename = tablename, @deltacol = deltacolumn FROM BPC.adf_watermark WHERE tablename = 'BPAWorkQueueItem'
SELECT @tablename 'tablename',@deltacol 'deltacolumn'

SELECT @lastDateCopied = last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacol AND tablename = @tablename

SELECT @lastDateCopied 'last_processed_date'

SET @sql = 'SELECT COUNT(*),MIN('+@deltacol+'),MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol + ' IS NOT NULL;' 
PRINT (@sql)

INSERT @hold(currCount,minDate,maxDate)
EXEC (@sql)

SELECT @currCount = currCount , @minDate = minDate  ,@maxDate = maxDate FROM @hold 
SELECT @currCount 'currCount', @maxCount'maxCount'

